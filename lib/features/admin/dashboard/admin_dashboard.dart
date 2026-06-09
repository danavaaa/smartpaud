import 'package:flutter/material.dart';
import 'package:smartpaud/services/auth_service.dart';
import '../periode_ajaran/periode_ajaran_page.dart';
import '../kelas/kelas_page.dart';
import '../penugasan_guru/penugasan_guru_page.dart';
import '../guru/guru_page.dart';
import '../siswa/siswa_page.dart';
import '../orang_tua/orang_tua_page.dart';
import '../../auth/login_page.dart';

// halaman dashboard utama admin
class AdminDashboardPage extends StatelessWidget {
  const AdminDashboardPage({super.key});

  // instance service
  static final _authService = AuthService();

  // fungsi untuk membuat tombol menu dashboard
  Widget buildMenuButton({
    required BuildContext context,
    required String title,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.16),
            blurRadius: 6,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: const Color(0xFFF7F4F4),
        borderRadius: BorderRadius.circular(12),
        // efek sentuh
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                // ikon panah kanan
                const Icon(Icons.chevron_right, size: 24, color: Colors.black),
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
          backgroundColor: const Color(0xFFD9D4D4),
          foregroundColor: Colors.black,
          elevation: 2, // Bayangan
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20), // Sudut tombol membulat
          ),
        ),
        // teks tombol logout
        child: const Text(
          'LogOut',
          style: TextStyle(fontSize: 15, fontFamily: 'Poppins'),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFDCE5E8),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(26, 30, 26, 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Dashboard',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 32),
              const Text(
                'Selamat Datang, Admin',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 28),

              buildMenuButton(
                context: context,
                title: 'Kelola Periode Ajaran',
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
