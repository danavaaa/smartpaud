import 'package:flutter/material.dart';

// Halaman dashboard untuk guru
class GuruDashboardPage extends StatelessWidget {
  const GuruDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFDDE8EF),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              // card dashboard utama
              _buildDashboardCard(),

              // jarak bawah card
              const SizedBox(height: 24),
              // label menu cepat
              const Text(
                'Menu Cepat',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Poppins',
                ),
              ),

              // jarak bawah label
              const SizedBox(height: 12),

              // menu data siswa
              _buildMenuItem(
                context,
                icon: Icons.people_outline_rounded,
                label: 'Data Siswa',
                onTap: () {},
              ),

              // menu laporan perkembangan
              _buildMenuItem(
                context,
                icon: Icons.description_outlined,
                label: 'Laporan Perkembangan',
                onTap: () {},
              ),

              // menu riwayat laporan
              _buildMenuItem(
                context,
                icon: Icons.history_rounded,
                label: 'Riwayat Laporan',
                onTap: () {},
              ),

              // menu profile
              _buildMenuItem(
                context,
                icon: Icons.person_outline_rounded,
                label: 'Profile Saya',
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }

  // widget untuk card dashboard utama
  Widget _buildDashboardCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),

      // isi card disusun vertikal
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          // judul dashboard
          const Text(
            'Dashboard',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              fontFamily: 'Poppins',
            ),
          ),
          const SizedBox(height: 8),

          // sapaan guru
          const Text(
            'Halo, Bu ......',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              fontFamily: 'Poppins',
            ),
          ),

          // keterangan kelas yang diampu
          const Text(
            'Kelas yang diampu',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey,
              fontFamily: 'Poppins',
            ),
          ),

          const SizedBox(height: 10),
          // sub-card untuk kelas yang diampu
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 255, 255, 255),
              borderRadius: BorderRadius.circular(10),
            ),

            // isi sub-card
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                // nama kelas
                Text(
                  'Kelas A1',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Poppins',
                  ),
                ),

                // jarak kecil
                SizedBox(height: 2),

                // informasi kelas dan periode
                Text(
                  'Guru Kelas  ·  Periode 2024/2025 – smstr 1',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey,
                    fontFamily: 'Poppins',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // widget untuk item menu cepat
  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    // GestureDetector digunakan agar widget bisa ditekan
    return GestureDetector(
      onTap: onTap, // aksi ketika menu di tekan
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),

        // isi menu horizontal
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,

              decoration: BoxDecoration(
                color: const Color(0xFFDDE8EF),
                borderRadius: BorderRadius.circular(10),
              ),

              child: Icon(icon, size: 20, color: const Color(0xFF185FA5)),
            ),

            const SizedBox(width: 14),
            // label menu
            Expanded(
              child: Text(
                label,
                style: const TextStyle(fontSize: 14, fontFamily: 'Poppins'),
              ),
            ),

            // ikon panah
            const Icon(
              Icons.chevron_right_rounded,
              color: Colors.grey,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
