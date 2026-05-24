import 'package:flutter/material.dart';
import 'features/auth/login_page.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'features/guru/dashboard/guru_dashboard.dart';
import 'features/admin/dashboard/admin_dashboard.dart';
import 'features/orang_tua/dashboard/orang_tua_dashboard.dart';
import 'services/user_session.dart';
import 'services/auth_service.dart';

// Widget utama aplikasi
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Menghilangkan banner DEBUG di pojok kanan atas
      debugShowCheckedModeBanner: false,

      // Theme aplikasi
      theme: ThemeData(
        // Mengatur font default aplikasi menjadi Poppins
        fontFamily: 'Poppins',
      ),

      // Delegates untuk mendukung lokalizasi (multibahasa)
      localizationsDelegates: const [
        // Localization untuk Material widget
        GlobalMaterialLocalizations.delegate,

        // Localization widget umum Flutter
        GlobalWidgetsLocalizations.delegate,

        // Localization untuk Cupertino widget (iOS style)
        GlobalCupertinoLocalizations.delegate,
      ],

      // Daftar bahasa yang didukung aplikasi
      supportedLocales: const [Locale('id', 'ID'), Locale('en', 'US')],
      home: const AuthWrapper(),
    );
  }
}

// Widget yang cek session saat app dibuka
class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  // Status untuk menandakan apakah pengecekan session masih berjalan
  bool _isChecking = true;

  @override
  void initState() {
    super.initState();

    // Saat widget pertama kali dibuka,
    // langsung cek apakah user masih punya session login
    _checkSession();
  }

  Future<void> _checkSession() async {
    try {
      // Membuat object AuthService
      final authService = AuthService();

      // Ambil user yang sedang login dari Supabase
      final user = authService.currentUser;

      if (user != null) {
        // Jika user masih punya session Supabase,
        // ambil data profil lengkap user
        final profile = await authService.getCurrentUserProfile();

        if (profile != null) {
          // Simpan data profil ke UserSession
          // agar bisa dipakai di seluruh aplikasi
          UserSession().setFromProfile(profile);
        }
      }
    } catch (_) {
      // Kalau terjadi error, abaikan (tidak tampilkan pesan)
    }

    // Setelah pengecekan selesai, matikan loading
    setState(() => _isChecking = false);
  }

  @override
  Widget build(BuildContext context) {
    // Kalau masih cek session, tampilkan loading spinner
    if (_isChecking) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    // Ambil data session user yang tersimpan
    final session = UserSession();

    // Kalau belum login, arahkan ke halaman login
    if (!session.isLoggedIn) return const LoginPage();

    // Cek role user dan arahkan ke dashboard sesuai role
    switch (session.role) {
      case 'admin':
        return const AdminDashboardPage();

      case 'guru':
        return const GuruDashboardPage();

      case 'orang_tua':
        return const OrangTuaDashboardPage();

      default:
        // Jika role tidak dikenali, kembali ke login
        return const LoginPage();
    }
  }
}
