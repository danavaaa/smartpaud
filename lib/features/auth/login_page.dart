import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import '../admin/dashboard/admin_dashboard.dart';
import '../guru/dashboard/guru_dashboard.dart';
import '../orang_tua/dashboard/orang_tua_dashboard.dart';

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

  // tampilan halaman login
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // latar belakang
      backgroundColor: const Color(0xFFDCE5E8),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 360),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 40),
                  // Judul Aplikasi
                  const Text(
                    'SmartPAUD',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 12),
                  // deskripsi aplikasi
                  const Text(
                    'Aplikasi Monitoring Kegiatan\nAnak Usia Dini',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.6,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 48),
                  // Input Email
                  TextField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    // menghapus pesan eror saat user mengetik ulang
                    onChanged: (_) {
                      if (emailError != null) {
                        setState(() => emailError = null);
                      }
                    },
                    decoration: InputDecoration(
                      hintText: 'Email',
                      hintStyle: const TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                      ),
                      filled: true,
                      fillColor:
                          emailError != null
                              ? const Color(0xFFFFEBEE)
                              : const Color(0xFFF7F4F4),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 18,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide:
                            emailError != null
                                ? const BorderSide(
                                  color: Color(0xFFD32F2F),
                                  width: 1.5,
                                )
                                : BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide: BorderSide(
                          color:
                              emailError != null
                                  ? const Color(0xFFD32F2F)
                                  : const Color(0xFF185FA5),
                          width: 1.5,
                        ),
                      ),
                      // Pesan error validasi email
                      errorText: emailError,
                      errorStyle: const TextStyle(fontSize: 12),
                    ),
                  ),

                  const SizedBox(height: 16),
                  // Input Password
                  TextField(
                    controller: passwordController,
                    // sembunyikan teks password
                    obscureText: obscurePassword,
                    // menghapus pesan eror saat user mengetik ulang
                    onChanged: (_) {
                      if (passwordError != null) {
                        setState(() => passwordError = null);
                      }
                    },
                    decoration: InputDecoration(
                      hintText: 'Password',
                      hintStyle: const TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                      ),
                      filled: true,
                      fillColor:
                          passwordError != null
                              ? const Color(0xFFFFEBEE)
                              : const Color(0xFFF7F4F4),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 18,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide:
                            passwordError != null
                                ? const BorderSide(
                                  color: Color(0xFFD32F2F),
                                  width: 1.5,
                                )
                                : BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide: BorderSide(
                          color:
                              passwordError != null
                                  ? const Color(0xFFD32F2F)
                                  : const Color(0xFF185FA5),
                          width: 1.5,
                        ),
                      ),
                      // Toggle show/hide password
                      suffixIcon: IconButton(
                        icon: Icon(
                          obscurePassword
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: Colors.black45,
                          size: 20,
                        ),
                        onPressed: () {
                          setState(() => obscurePassword = !obscurePassword);
                        },
                      ),
                      // Pesan error validasi password
                      errorText: passwordError,
                      errorStyle: const TextStyle(fontSize: 12),
                    ),
                  ),

                  const SizedBox(height: 32),
                  // Tombol Login
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: const [
                        BoxShadow(
                          color: Color.fromRGBO(0, 0, 0, 0.18),
                          blurRadius: 6,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: SizedBox(
                      width: 132,
                      height: 42,
                      child: ElevatedButton(
                        // jika sedang loading, tombol tidak bisa ditekan
                        onPressed: isLoading ? null : login,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFD9D4D4),
                          foregroundColor: Colors.black,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          textStyle: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        // menampilkan indikator loading saat login sedang diproses, jika tidak tampilkan teks 'Login'
                        child:
                            isLoading
                                ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.black54,
                                  ),
                                )
                                : const Text('Login'),
                      ),
                    ),
                  ),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
