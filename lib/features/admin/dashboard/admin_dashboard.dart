import 'package:flutter/material.dart';
import 'package:smartpaud/services/auth_service.dart';
import '../periode_ajaran/periode_ajaran_page.dart';
import '../kelas/kelas_page.dart';
import '../penugasan_guru/penugasan_guru_page.dart';
import '../guru/guru_page.dart';
import '../siswa/siswa_page.dart';
import '../orang_tua/orang_tua_page.dart';
import '../../auth/login_page.dart';
import '../../../core/theme/app_colors.dart';

// halaman dashboard utama admin
class AdminDashboardPage extends StatelessWidget {
  const AdminDashboardPage({super.key});

  // instance service
  static final _authService = AuthService();

  // fungsi untuk membuat tombol menu dashboard
  Widget buildMenuButton({
    required BuildContext context,
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        // efek sentuh
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: AppColors.softPrimary,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(icon, color: AppColors.primary, size: 24),
                ),

                const SizedBox(width: 16),

                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15,
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ),
                // ikon panah kanan
                const Icon(
                  Icons.chevron_right_rounded,
                  size: 26,
                  color: AppColors.accent,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // fungsi tombol logout
  Widget _buildLogoutButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        // aksi saat tombol logout ditekan
        onPressed: () {
          // Tampilkan dialog konfirmasi sebelum logout
          showDialog(
            context: context,
            builder:
                (ctx) => AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  // Judul dialog
                  title: const Text(
                    'Konfirmasi Logout',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  // Isi dialog
                  content: const Text(
                    'Apakah kamu yakin ingin keluar?',
                    style: TextStyle(
                      fontSize: 13,
                      fontFamily: 'Poppins',
                      color: Colors.grey,
                    ),
                  ),
                  // Tombol aksi dialog
                  actions: [
                    // Tombol batal
                    TextButton(
                      // Tutup dialog tanpa melakukan logout
                      onPressed: () => Navigator.pop(ctx),
                      child: const Text(
                        'Batal',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    // Tombol logout
                    TextButton(
                      onPressed: () async {
                        // Tutup dialog konfirmasi
                        Navigator.pop(ctx);
                        // Proses logout, menghapus session pengguna dan keluar dari akun
                        await _authService.logout();

                        if (!context.mounted) return;
                        // Setelah logout berhasil, navigasi ke halaman login
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (_) => const LoginPage()),
                          // Hapus semua route sebelumnya
                          (route) => false,
                        );
                      },
                      child: const Text(
                        'Logout',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          color: Color(0xFFA32D2D),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
          );
        },
        // gaya tombol logout
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: AppColors.primary,
          shadowColor: Colors.transparent,
          elevation: 0, // bayangan
          side: const BorderSide(color: AppColors.accent, width: 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        // teks tombol logout
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.logout_rounded, size: 20),
            SizedBox(width: 10),
            Text(
              'LogOut',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                fontFamily: 'Poppins',
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(26, 30, 26, 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Dashboard Admin',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                  fontFamily: 'Poppins',
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                'Selamat Datang, Admin',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                  fontFamily: 'Poppins',
                ),
              ),

              const SizedBox(height: 4),

              const Text(
                'Kelola data sekolah secara terpusat dan terstruktur',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: AppColors.textSecondary,
                  fontFamily: 'Poppins',
                ),
              ),
              const SizedBox(height: 28),

              buildMenuButton(
                context: context,
                title: 'Kelola Periode Ajaran',
                icon: Icons.calendar_month_outlined,
                onTap:
                    // navigasi ke halaman periode ajaran
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const PeriodeAjaranPage(),
                      ),
                    ),
              ),
              // menu kelola kelas
              buildMenuButton(
                context: context,
                title: 'Kelola Kelas',
                icon: Icons.groups_2_outlined,
                onTap:
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const KelasPage()),
                    ),
              ),
              // menu kelola penugasan guru
              buildMenuButton(
                context: context,
                title: 'Penugasan Guru',
                icon: Icons.assignment_ind_outlined,
                onTap:
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const PenugasanGuruPage(),
                      ),
                    ),
              ),
              // menu kelola guru
              buildMenuButton(
                context: context,
                title: 'Kelola Data Guru',
                icon: Icons.school_outlined,
                onTap:
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const GuruPage()),
                    ),
              ),
              // menu kelola siswa
              buildMenuButton(
                context: context,
                title: 'Kelola Data Siswa',
                icon: Icons.menu_book_outlined,
                onTap:
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const SiswaPage()),
                    ),
              ),
              // menu kelola orang tua
              buildMenuButton(
                context: context,
                title: 'Kelola Data Orang Tua',
                icon: Icons.family_restroom_outlined,
                onTap:
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const OrangTuaPage()),
                    ),
              ),

              const SizedBox(height: 24),

              // tombol logout
              _buildLogoutButton(context),
            ],
          ),
        ),
      ),
    );
  }
}
