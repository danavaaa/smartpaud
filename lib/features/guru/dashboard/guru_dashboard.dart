import 'package:flutter/material.dart';
import '../data_siswa/data_siswa_page.dart';
import '../laporan_perkembangan/buat_laporan_page.dart';
import '../riwayat_laporan/riwayat_laporan_page.dart';
import '../profile/profile_page.dart';
import '../profile/profile_service.dart';
import '../profile/profile_model.dart';
import '../../../services/user_session.dart';
import '../../../core/theme/app_colors.dart';

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
        setState(() {
          _kelasList = [];
          _isLoadingKelas = false;
        });
        return;
      }

      // Ambil daftar kelas aktif yang diampu  guru berdasarkan idUser yang sedang login
      final kelas = List<KelasModel>.from(
        await _service.getKelasDiampuAktif(idUser),
      );
      // Mengurutkan daftar kelas berdasarkan nama kelas secara alfabet
      kelas.sort(
        (a, b) =>
            a.namaKelas.toLowerCase().compareTo(b.namaKelas.toLowerCase()),
      );

      setState(() {
        _kelasList = kelas; // isi daftar kelas
        _isLoadingKelas = false; // loading selesai
      });
    } catch (e) {
      // Kalau terjadi error, matikan loading
      setState(() {
        _kelasList = [];
        _isLoadingKelas = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              // card dashboard utama
              const Text(
                'Dashboard Guru',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Poppins',
                  color: AppColors.textPrimary,
                ),
              ),

              const SizedBox(height: 4),

              const Text(
                'Kelola data siswa dan laporan perkembangan',
                style: TextStyle(
                  fontSize: 12,
                  fontFamily: 'Poppins',
                  color: AppColors.textSecondary,
                ),
              ),

              const SizedBox(height: 20),

              _buildDashboardCard(),

              // jarak bawah card
              const SizedBox(height: 26),
              // label menu cepat
              const Text(
                'Menu Cepat',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Poppins',
                  color: AppColors.textPrimary,
                ),
              ),

              // jarak bawah label
              const SizedBox(height: 14),

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
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),

      // isi card disusun vertikal
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: AppColors.softPrimary,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.school_outlined,
                  color: AppColors.primary,
                  size: 24,
                ),
              ),

              const SizedBox(width: 14),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // sapaan guru
                    Text(
                      'Halo, $_namaGuru 👋',
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Poppins',
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    // keterangan kelas yang diampu
                    const Text(
                      'Kelas aktif yang sedang diampu',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Tampil loading atau data kelas yang diampu
          if (_isLoadingKelas)
            // jika data kelas masih loading, tampilkan indikator loading di tengah
            const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            )
          else if (_kelasList.isEmpty)
            // Kalau loading selesai tapi data kelas kosong, tampilkan pesan bahwa guru belum punya kelas
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.softCard,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'Belum ada kelas aktif yang diampu',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                  fontFamily: 'Poppins',
                ),
              ),
            )
          else
            ..._kelasList.map((k) => _buildKelasItem(k)),
        ],
      ),
    );
  }

  Widget _buildKelasItem(KelasModel k) {
    return Container(
      width: double.infinity,

      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.softCard,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.groups_2_outlined,
              size: 18,
              color: AppColors.primary,
            ),
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                // nama kelas
                Text(
                  k.namaKelas,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Poppins',
                    color: AppColors.textPrimary,
                  ),
                ),

                // jarak kecil
                const SizedBox(height: 2),

                // informasi kelas dan periode
                Text(
                  '${k.peranGuru} · ${k.periode}',
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondary,
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
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 9,
              offset: const Offset(0, 3),
            ),
          ],
        ),

        // isi menu horizontal
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,

              decoration: BoxDecoration(
                color: AppColors.softPrimary,
                borderRadius: BorderRadius.circular(13),
              ),

              child: Icon(icon, size: 22, color: AppColors.primary),
            ),

            const SizedBox(width: 14),
            // label menu
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                  fontFamily: 'Poppins',
                ),
              ),
            ),

            // ikon panah
            const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.accent,
              size: 22,
            ),
          ],
        ),
      ),
    );
  }
}
