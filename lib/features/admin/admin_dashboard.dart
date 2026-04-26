import 'package:flutter/material.dart';
import 'periode_ajaran/periode_ajaran_page.dart';
import 'kelas/kelas_page.dart';
import 'penugasan_guru/penugasan_guru_page.dart';
import 'guru/guru_page.dart';
import 'siswa/siswa_page.dart';
import 'orang_tua/orang_tua_page.dart';

// halaman dashboard utama admin
class AdminDashboardPage extends StatelessWidget {
  const AdminDashboardPage({super.key});

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFDCE5E8),
      body: SafeArea(
        child: Padding(
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
                onTap: () {
                  // navigasi ke halaman periode ajaran
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const PeriodeAjaranPage(),
                    ),
                  );
                },
              ),
              // menu kelola kelas
              buildMenuButton(
                context: context,
                title: 'Kelola Kelas',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const KelasPage()),
                  );
                },
              ),
              // menu kelola penugasan guru
              buildMenuButton(
                context: context,
                title: 'Penugasan Guru',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const PenugasanGuruPage(),
                    ),
                  );
                },
              ),
              // menu kelola guru
              buildMenuButton(
                context: context,
                title: 'Kelola Data Guru',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const GuruPage()),
                  );
                },
              ),
              // menu kelola siswa
              buildMenuButton(
                context: context,
                title: 'Kelola Data Siswa',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const SiswaPage()),
                  );
                },
              ),
              // menu kelola orang tua
              buildMenuButton(
                context: context,
                title: 'Kelola Data Orang Tua',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const OrangTuaPage()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
