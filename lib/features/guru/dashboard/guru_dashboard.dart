import 'package:flutter/material.dart';
import '../data_siswa/data_siswa_page.dart';
import '../laporan_perkembangan/buat_laporan_page.dart';
import '../riwayat_laporan/riwayat_laporan_page.dart';
import '../profile/profile_page.dart';
import '../profile/profile_service.dart';
import '../profile/profile_model.dart';
import '../../../services/user_session.dart';

// Halaman dashboard untuk guru
class GuruDashboardPage extends StatefulWidget {
  const GuruDashboardPage({super.key});

  @override
  State<GuruDashboardPage> createState() => _GuruDashboardPageState();
}

class _GuruDashboardPageState extends State<GuruDashboardPage> {
  // object service digunakan untuk mengambil data dari database
  final _service = ProfileService();

  // Getter untuk mengambil nama guru dari session
  String get _namaGuru => UserSession().nama ?? 'Guru';

  // Menyimpan daftar kelas yang diampu guru, awalnya list kosong
  List<KelasModel> _kelasList = [];

  // Status loading saat mengambil data kelas
  bool _isLoadingKelas = true;

  @override
  void initState() {
    super.initState();

    // Saat halaman pertama dibuka, otomatis ambil data kelas yang diampu guru
    _loadKelas();
  }

  Future<void> _loadKelas() async {
    try {
      // Ambil id user guru dari session
      final idUser = UserSession().idUser ?? '';

      // Kalau idUser kosong, berarti user belum login / session tidak ada
      if (idUser.isEmpty) {
        // Matikan loading
        setState(() => _isLoadingKelas = false);

        // Hentikan function
        return;
      }

      // Ambil data kelas yang diampu guru berdasarkan idUser
      final kelas = await _service.getKelasDiampu(idUser);

      // Simpan hasil data ke state
      setState(() {
        _kelasList = kelas; // isi daftar kelas
        _isLoadingKelas = false; // loading selesai
      });
    } catch (e) {
      // Kalau terjadi error, matikan loading
      setState(() => _isLoadingKelas = false);
    }
  }

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
                onTap:
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const DataSiswaPage()),
                    ),
              ),

              // menu laporan perkembangan
              _buildMenuItem(
                context,
                icon: Icons.description_outlined,
                label: 'Laporan Perkembangan',
                onTap:
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const BuatLaporanPage(),
                      ),
                    ),
              ),

              // menu riwayat laporan
              _buildMenuItem(
                context,
                icon: Icons.history_rounded,
                label: 'Riwayat Laporan',
                onTap:
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const RiwayatLaporanPage(),
                      ),
                    ),
              ),

              // menu profile
              _buildMenuItem(
                context,
                icon: Icons.person_outline_rounded,
                label: 'Profile Saya',
                onTap:
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ProfilePage()),
                    ),
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
            color: Colors.black.withValues(alpha: 0.05),
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
          Text(
            'Halo, $_namaGuru 👋',
            style: const TextStyle(
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

          // Tampil loading atau data kelas yang diampu
          if (_isLoadingKelas)
            // jika data kelas masih loading, tampilkan indikator loading di tengah
            const Center(child: CircularProgressIndicator())
          else if (_kelasList.isEmpty)
            // Kalau loading selesai tapi data kelas kosong, tampilkan pesan bahwa guru belum punya kelas
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFFDDE8EF),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                'Belum ada kelas yang diampu',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                  fontFamily: 'Poppins',
                ),
              ),
            )
          else
            // Kalau data kelas ada, tampilkan semua data dari _kelasList
            ..._kelasList.map(
              (k) => Container(
                width: double.infinity,

                margin: const EdgeInsets.only(bottom: 8), // jarak antar item

                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),

                decoration: BoxDecoration(
                  color: const Color(0xFFDDE8EF),
                  borderRadius: BorderRadius.circular(10),
                ),

                // isi sub-card
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    // nama kelas
                    Text(
                      k.namaKelas,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Poppins',
                      ),
                    ),

                    // jarak kecil
                    const SizedBox(height: 2),

                    // informasi kelas dan periode
                    Text(
                      '${k.peranGuru} · ${k.periode}',
                      style: const TextStyle(
                        fontSize: 11,
                        color: Colors.grey,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ],
                ),
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
              color: Colors.black.withValues(alpha: 0.04),
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
