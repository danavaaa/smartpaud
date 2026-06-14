import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

// Halaman Splash Screen yang ditampilkan saat aplikasi pertama kali dibuka
class SplashPage extends StatefulWidget {
  // Halaman tujuan setelah splash screen selesai
  final Widget nextPage;

  const SplashPage({super.key, required this.nextPage});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  // Controller untuk mengatur animasi
  late final AnimationController _controller;

  // Animasi fade (transparansi)
  late final Animation<double> _fadeAnimation;

  // Animasi scale (pembesaran)
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    // Inisialisasi animation controller
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    // Animasi fade in saat splash muncul
    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );

    // Animasi scale dari ukuran 92% menjadi 100%
    _scaleAnimation = Tween<double>(
      begin: 0.92,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    // Menjalankan animasi
    _controller.forward();

    // Menunggu selama 2 detik sebelum berpindah halaman
    Future.delayed(const Duration(seconds: 2), () {
      // Pastikan widget masih aktif
      if (!mounted) return;

      // Navigasi ke halaman berikutnya dan menghapus splash screen dari stack
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => widget.nextPage),
      );
    });
  }

  @override
  void dispose() {
    // Membersihkan controller ketika widget dihancurkan
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Warna latar belakang halaman splash
      backgroundColor: AppColors.background,

      body: SafeArea(
        child: Center(
          child: FadeTransition(
            // Efek fade saat muncul
            opacity: _fadeAnimation,

            child: ScaleTransition(
              // Efek zoom saat muncul
              scale: _scaleAnimation,

              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo aplikasi
                  Container(
                    width: 96,
                    height: 96,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.14),
                          blurRadius: 14,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),

                    // Ikon utama aplikasi
                    child: const Icon(
                      Icons.menu_book_rounded,
                      color: AppColors.buttonText,
                      size: 46,
                    ),
                  ),

                  const SizedBox(height: 22),

                  // Nama aplikasi
                  const Text(
                    'SmartPAUD',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      fontFamily: 'Poppins',
                      color: AppColors.textPrimary,
                      letterSpacing: 0.3,
                    ),
                  ),

                  const SizedBox(height: 6),

                  // Deskripsi aplikasi
                  const Text(
                    'Pemantauan Literasi Anak Usia Dini',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      fontFamily: 'Poppins',
                      color: AppColors.textSecondary,
                    ),
                  ),

                  const SizedBox(height: 34),

                  // Loading indicator selama proses perpindahan halaman
                  const SizedBox(
                    width: 28,
                    height: 28,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
