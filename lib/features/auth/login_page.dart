import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import '../admin/dashboard/admin_dashboard.dart';
import '../guru/dashboard/guru_dashboard.dart';
import '../orang_tua/dashboard/orang_tua_dashboard.dart';
import '../../services/user_session.dart';

// Halaman login yang menangani autentikasi dan navigasi berdasarkan peran user
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

// State untuk halaman login yang mengelola input, autentikasi, dan navigasi
class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final authService = AuthService();

  bool isLoading = false;
  // Fungsi untuk menangani proses login, autentikasi, dan navigasi berdasarkan peran user
  Future<void> login() async {
    try {
      setState(() => isLoading = true);
      // Panggil metode signIn dari AuthService untuk melakukan autentikasi
      await authService.signIn(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      final profile =
          await authService
              .getCurrentUserProfile(); // Ambil profil user setelah login

      if (!mounted) return;

      if (profile == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          // Tampilkan pesan jika profil user tidak ditemukan
          const SnackBar(content: Text('Profil user tidak ditemukan')),
        );
        return;
      }
      // Simpan ke session agar data user dapat dipakai dihalaman lain tanpa ambil ulang dari database
      UserSession().setFromProfile(profile);
      final role = profile['role'];

      if (role == 'admin') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const AdminDashboardPage()),
        );
      } else if (role == 'guru') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const GuruDashboardPage()),
        );
      } else if (role == 'orang_tua') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const OrangTuaDashboardPage()),
        );
      } else {
        // Tampilkan pesan jika peran user tidak valid
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Role tidak valid')));
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Login gagal: $e')));
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  // Fungsi untuk membuat dekorasi input yang konsisten di seluruh halaman login
  InputDecoration customInputDecoration(String hintText) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: const TextStyle(fontSize: 16, color: Colors.black87),
      filled: true,
      fillColor: const Color(0xFFF7F4F4),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: BorderSide.none,
      ),
    );
  }

  // tampilan halaman login
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  TextField(
                    controller: emailController,
                    decoration: customInputDecoration('Email'),
                  ),
                  const SizedBox(height: 24),
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: customInputDecoration('Password'),
                  ),
                  const SizedBox(height: 32),
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
                        child: Text(isLoading ? 'Loading...' : 'Login'),
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
