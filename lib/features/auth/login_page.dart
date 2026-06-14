import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import '../admin/dashboard/admin_dashboard.dart';
import '../guru/dashboard/guru_dashboard.dart';
import '../orang_tua/dashboard/orang_tua_dashboard.dart';
import '../../../core/theme/app_colors.dart';

// Halaman login yang menangani autentikasi dan navigasi berdasarkan peran user
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

// State untuk halaman login yang mengelola input, autentikasi, dan navigasi
class _LoginPageState extends State<LoginPage> {
  // controller untuk mengambil nilai input email
  final emailController = TextEditingController();
  // controller untuk mengambil nilai input password
  final passwordController = TextEditingController();
  final authService = AuthService();

  // State variabel
  // menyimpan status loading saat proses login berlangsung
  bool isLoading = false;
  // untuk toggle show/hide password
  bool obscurePassword = true;

  // variabel untuk menyimpan pesan error validasi input email
  String? emailError;
  // variabel untuk menyimpan pesan error validasi input password
  String? passwordError;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  // Validasi form login
  // memastikan email dan password telah diisi dengan benar
  bool _validate() {
    bool valid = true;
    setState(() {
      emailError = null;
      passwordError = null;

      // validasi jika email kosong
      if (emailController.text.trim().isEmpty) {
        emailError = 'Email tidak boleh kosong';
        valid = false;
      }
      // validasi format email (harus mengandung '@')
      else if (!emailController.text.trim().contains('@')) {
        emailError = 'Format email tidak valid';
        valid = false;
      }
      // validasi jika password kosong
      else if (passwordController.text.trim().isEmpty) {
        passwordError = 'Password tidak boleh kosong';
        valid = false;
      }
    });
    return valid;
  }

  // Proses login
  Future<void> login() async {
    if (!_validate()) return;

    try {
      // aktifkan loading saat proses login berlangsung
      setState(() => isLoading = true);
      //autentikasi ke database
      await authService.signIn(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      // mengambil profile user yang sedang login
      final profile = await authService.getCurrentUserProfile();

      if (!mounted) return;

      // jika profile user tidak ditemukan, tampilkan pesan error
      if (profile == null) {
        _showSnackbar('Profil pengguna tidak ditemukan', isError: true);
        return;
      }
      // Mengambil role user
      final role = profile['role'];

      // Navigasi berdasarkan role user yang berhasil login
      // Jika admin, arahkan ke AdminDashboardPage
      if (role == 'admin') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const AdminDashboardPage()),
        );
      }
      // Jika guru, arahkan ke GuruDashboardPage
      else if (role == 'guru') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const GuruDashboardPage()),
        );
      }
      // Jika orang tua, arahkan ke OrangTuaDashboardPage
      else if (role == 'orang_tua') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const OrangTuaDashboardPage()),
        );
      }
      // jika role tidak valid, tampilkan pesan error
      else {
        _showSnackbar('Role tidak valid', isError: true);
      }

      // Handling eror
    } catch (e) {
      if (!mounted) return;
      String pesan = 'Email atau password salah';
      if (e.toString().contains('network') ||
          e.toString().contains('socket') ||
          e.toString().contains('connection')) {
        pesan = 'Gagal terhubung ke server. Periksa koneksi internet Anda.';
      }
      _showSnackbar(pesan, isError: true);
    }
    // selesai login, matikan loading
    finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  // Snackbar notifikasi untuk menampilkan pesan sukses atau error dengan ikon dan warna yang sesuai
  void _showSnackbar(
    String pesan, {
    bool isError = false,
    IconData icon = Icons.error_outline_rounded,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            // icon notifikasi
            Icon(icon, color: Colors.white, size: 18),
            const SizedBox(width: 8),
            // pesan notifikasi
            Expanded(child: Text(pesan)),
          ],
        ),
        // warna background berdasarkan status
        backgroundColor:
            isError ? const Color(0xFFD32F2F) : const Color(0xFF388E3C),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  // Widget untuk menampilkan logo, nama aplikasi, dan deskripsi singkat
  Widget _buildLogoSection() {
    return Column(
      children: [
        // Container logo aplikasi
        Container(
          width: 82,
          height: 82,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.14),
                blurRadius: 14,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: const Icon(
            Icons.menu_book_rounded,
            color: AppColors.buttonText,
            size: 42,
          ),
        ),

        const SizedBox(height: 18),

        // Nama aplikasi
        const Text(
          'SmartPAUD',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
            fontFamily: 'Poppins',
          ),
        ),

        const SizedBox(height: 6),

        // Deskripsi singkat aplikasi
        const Text(
          'Monitoring Kegiatan Literasi Anak Usia Dini',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12,
            color: AppColors.textSecondary,
            fontFamily: 'Poppins',
          ),
        ),
      ],
    );
  }

  // Widget untuk menampilkan label pada field input
  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 7),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
            fontFamily: 'Poppins',
          ),
        ),
      ),
    );
  }

  // Widget field input yang digunakan untuk email dan password
  Widget _buildInputField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    required String? errorText,
    required ValueChanged<String> onChanged,
    bool isPassword = false,
  }) {
    return TextField(
      controller: controller,

      // Menentukan jenis keyboard sesuai tipe input
      keyboardType:
          isPassword ? TextInputType.text : TextInputType.emailAddress,

      // Menyembunyikan karakter jika field password
      obscureText: isPassword ? obscurePassword : false,

      onChanged: onChanged,

      style: const TextStyle(
        fontSize: 13,
        fontFamily: 'Poppins',
        color: AppColors.textPrimary,
      ),

      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(
          fontSize: 13,
          color: AppColors.textSecondary,
          fontFamily: 'Poppins',
        ),

        // Icon di bagian kiri field
        prefixIcon: Icon(icon, size: 20, color: AppColors.textSecondary),

        // Tombol show/hide password
        suffixIcon:
            isPassword
                ? IconButton(
                  icon: Icon(
                    obscurePassword
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: AppColors.textSecondary,
                    size: 20,
                  ),
                  onPressed: () {
                    setState(() => obscurePassword = !obscurePassword);
                  },
                )
                : null,

        // Warna field berubah ketika terjadi error
        filled: true,
        fillColor:
            errorText != null ? const Color(0xFFFFEBEE) : AppColors.softCard,

        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 15,
        ),

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide:
              errorText != null
                  ? const BorderSide(color: Color(0xFFD32F2F), width: 1.2)
                  : BorderSide.none,
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color:
                errorText != null ? const Color(0xFFD32F2F) : AppColors.primary,
            width: 1.2,
          ),
        ),

        // Menampilkan pesan error validasi
        errorText: errorText,
        errorStyle: const TextStyle(fontSize: 11, fontFamily: 'Poppins'),
      ),
    );
  }

  // Widget tombol login
  Widget _buildLoginButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        // Menjalankan fungsi login saat tombol ditekan
        onPressed: isLoading ? null : login,

        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.buttonText,
          disabledBackgroundColor: AppColors.primary.withValues(alpha: 0.55),
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            fontFamily: 'Poppins',
          ),
        ),

        // Menampilkan loading ketika proses login berlangsung
        child:
            isLoading
                ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.4,
                    color: AppColors.buttonText,
                  ),
                )
                : const Text('Login'),
      ),
    );
  }

  // Widget card yang berisi form login
  Widget _buildLoginCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 4),

          // Label email
          _buildLabel('Email'),

          // Input email
          _buildInputField(
            controller: emailController,
            hint: 'Masukkan email',
            icon: Icons.email_outlined,
            errorText: emailError,
            onChanged: (_) {
              if (emailError != null) {
                setState(() => emailError = null);
              }
            },
          ),

          const SizedBox(height: 16),

          // Label password
          _buildLabel('Password'),

          // Input password
          _buildInputField(
            controller: passwordController,
            hint: 'Masukkan password',
            icon: Icons.lock_outline_rounded,
            errorText: passwordError,
            isPassword: true,
            onChanged: (_) {
              if (passwordError != null) {
                setState(() => passwordError = null);
              }
            },
          ),

          const SizedBox(height: 24),

          // Tombol login
          _buildLoginButton(),
        ],
      ),
    );
  }

  // Method build untuk menampilkan halaman login
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),

            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 380),

              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 24),

                  // Menampilkan logo aplikasi
                  _buildLogoSection(),

                  const SizedBox(height: 34),

                  // Menampilkan form login
                  _buildLoginCard(),

                  const SizedBox(height: 24),

                  // Footer aplikasi
                  const Text(
                    'SmartPAUD • Sistem Monitoring Literasi PAUD',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 10,
                      fontFamily: 'Poppins',
                      color: AppColors.textSecondary,
                    ),
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
