import 'package:flutter/material.dart';
import '../riwayat_perkembangan/riwayat_perkembangan_page.dart';
import '../riwayat_perkembangan/riwayat_ortu_model.dart';
import '../riwayat_perkembangan/riwayat_ortu_service.dart';
import '../profile/profile_ortu_page.dart';
import '../../../services/user_session.dart';
import '../../../core/theme/app_colors.dart';

// Halaman dashboard orang tua
class OrangTuaDashboardPage extends StatefulWidget {
  const OrangTuaDashboardPage({super.key});

  @override
  State<OrangTuaDashboardPage> createState() => _OrangTuaDashboardPageState();
}

class _OrangTuaDashboardPageState extends State<OrangTuaDashboardPage> {
  // object service digunakan untuk mengambil data dari database
  final _service = RiwayatLaporanOrtuService();

  // Getter untuk mengambil nama orang tua dari session
  String get _namaOrangTua => UserSession().nama ?? 'Orang Tua';

  // Menyimpan daftar anak milik orang tua, awalnya list kosong
  List<AnakOrtuModel> _anakList = [];

  // Menyimpan data anak yang sedang dipilih
  AnakOrtuModel? _selectedAnak;

  // Menyimpan daftar laporan perkembangan anak
  List<LaporanOrtuModel> _laporanList = [];

  // Status loading saat mengambil data anak
  bool _isLoadingAnak = true;

  // Status loading saat mengambil data laporan
  bool _isLoadingLaporan = false;

  @override
  void initState() {
    super.initState();
    _loadAnak();
  }

  Future<void> _loadAnak() async {
    // Aktifkan loading sebelum mulai ambil data anak
    setState(() => _isLoadingAnak = true);

    try {
      // Ambil id orang tua dari session untuk digunakan sebagai parameter query data anak
      final idOrangTua = UserSession().idOrangTua;
      // jika id orang tua tidak tersedia di session
      if (idOrangTua == null) {
        // Matikan loading
        setState(() => _isLoadingAnak = false);

        // Hentikan function karena tidak bisa ambil data anak tanpa id orang tua
        return;
      }

      // Ambil daftar anak berdasarkan id_orang_tua
      final list = await _service.getAnakList(idOrangTua);
      // Dashboard hanya menampilkan anak aktif
      final anakAktifList = list.where((anak) => anak.isActive).toList();

      setState(() {
        // Simpan hanya anak aktif ke state dashboard
        _anakList = anakAktifList;

        // Loading selesai
        _isLoadingAnak = false;

        // Jika ada anak aktif, pilih anak pertama
        if (anakAktifList.isNotEmpty) {
          _selectedAnak = anakAktifList.first;

          // Setelah anak aktif dipilih, ambil laporan anak tersebut
          _loadLaporan(_selectedAnak!.id);
        } else {
          // Jika tidak ada anak aktif, kosongkan pilihan dan laporan
          _selectedAnak = null;
          _laporanList = [];
        }
      });
    } catch (e) {
      // Kalau terjadi error, matikan loading
      setState(() => _isLoadingAnak = false);
    }
  }

  Future<void> _loadLaporan(String idSiswa) async {
    // Aktifkan loading laporan
    setState(() => _isLoadingLaporan = true);

    try {
      // Ambil daftar laporan berdasarkan id siswa
      final list = await _service.getLaporan(idSiswa);

      setState(() {
        // Simpan data laporan ke state
        _laporanList = list;

        // Loading laporan selesai
        _isLoadingLaporan = false;
      });
    } catch (e) {
      // Kalau terjadi error, matikan loading
      setState(() => _isLoadingLaporan = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Warna background utama halaman
      backgroundColor: AppColors.background,

      body: SafeArea(
        child: SingleChildScrollView(
          // Padding seluruh isi halaman
          padding: const EdgeInsets.all(20),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Label kecil di atas dashboard
              const Text(
                'Dashboard Orang Tua',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                  fontFamily: 'Poppins',
                ),
              ),

              const SizedBox(height: 4),

              const Text(
                'Pantau perkembangan literasi anak secara mudah',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                  fontFamily: 'Poppins',
                ),
              ),
              const SizedBox(height: 18),

              // Card header berisi sapaan dan dropdown pilih anak
              _buildHeaderCard(),
              const SizedBox(height: 16),

              // Card laporan perkembangan terbaru
              _buildLaporanTerbaru(),
              const SizedBox(height: 20),

              // Label menu cepat
              const Text(
                'Menu Cepat',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                  fontFamily: 'Poppins',
                ),
              ),
              const SizedBox(height: 12),

              // halaman riwayat perkembangan
              _buildMenuItem(
                icon: Icons.description_outlined,
                label: 'Riwayat Perkembangan',
                onTap:
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const RiwayatPerkembanganPage(),
                      ),
                    ),
              ),

              // halaman profile orang tua
              _buildMenuItem(
                icon: Icons.person_outline_rounded,
                label: 'Profile Saya',
                onTap:
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ProfileOrtuPage(),
                      ),
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // header card
  Widget _buildHeaderCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.softPrimary, width: 1),
        // Shadow card
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.10),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Judul card
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
                  Icons.family_restroom_outlined,
                  color: AppColors.primary,
                  size: 24,
                ),
              ),

              const SizedBox(width: 14),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Selamat Datang',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    // Sapaan orang tua
                    Text(
                      'Halo, $_namaOrangTua 👋',
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Subtitle
          const Text(
            'Pilih anak aktif untuk melihat laporan perkembangan terbaru.',
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
              height: 1.5,
              fontFamily: 'Poppins',
            ),
          ),
          const SizedBox(height: 14),

          // Dropdown pilih anak
          if (_isLoadingAnak)
            // Jika data anak masih dalam proses diambil dari database, tampilkan loading di tengah layar
            const Center(
              child: CircularProgressIndicator(color: AppColors.accent),
            )
          else if (_anakList.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.softCard,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'Tidak ada data anak aktif',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                  fontFamily: 'Poppins',
                ),
              ),
            )
          else
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),

              decoration: BoxDecoration(
                color: AppColors.softPrimary,
                borderRadius: BorderRadius.circular(12),
              ),

              child: DropdownButtonHideUnderline(
                child: DropdownButton<AnakOrtuModel>(
                  // Anak yang sedang dipilih
                  value: _selectedAnak,

                  isExpanded: true,
                  dropdownColor: AppColors.card,
                  icon: const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: AppColors.primary,
                  ),

                  // Generate item dropdown dari list anak
                  items:
                      _anakList.map((anak) {
                        return DropdownMenuItem<AnakOrtuModel>(
                          value: anak,

                          child: Row(
                            children: [
                              const Icon(
                                Icons.person_outline_rounded,
                                size: 18,
                                color: AppColors.primary,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                // Menampilkan nama anak dan status anak
                                child: Text(
                                  anak.nama,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textPrimary,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),

                  // Saat dropdown dipilih
                  onChanged: (val) {
                    if (val != null) {
                      // Update anak yang dipilih
                      setState(() => _selectedAnak = val);
                      _loadLaporan(val.id);
                    }
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }

  // daftar laporan terbaru
  Widget _buildLaporanTerbaru() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(18),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header laporan terbaru
          Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: AppColors.softPrimary,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.access_time_rounded,
                  size: 18,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 10),

              const Expanded(
                child: Text(
                  'Laporan Terbaru',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Poppins',
                    color: AppColors.textPrimary,
                  ),
                ),
              ),

              // Tombol lihat semua
              GestureDetector(
                onTap:
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const RiwayatPerkembanganPage(),
                      ),
                    ),
                child: const Text(
                  'Lihat semua',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          if (_isLoadingLaporan)
            // Jika data laporan masih diambil dari database, tampilkan loading spinner di tengah
            const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            )
          else if (_laporanList.isEmpty)
            // Jika loading selesai tetapi tidak ada laporan, tampilkan pesan bahwa laporan belum tersedia
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                color: AppColors.softCard,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: Text(
                  'Belum ada laporan',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
            )
          else
            // Jika loading selesai dan laporan ada, tampilkan maksimal 2 laporan terbaru
            ..._laporanList
                .take(3)
                .map(
                  (l) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),

                    child: Container(
                      padding: const EdgeInsets.all(12),

                      decoration: BoxDecoration(
                        color: AppColors.softCard,
                        borderRadius: BorderRadius.circular(12),
                      ),

                      child: Row(
                        children: [
                          // Isi laporan
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Tanggal laporan
                                Text(
                                  l.tanggal,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    fontFamily: 'Poppins',
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 4),

                                // Preview catatan laporan
                                Text(
                                  l.preview,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: AppColors.textSecondary,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(width: 8),

                          if (l.isNew)
                            // Badge status laporan
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 9,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.successBg,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Text(
                                'Baru',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Poppins',
                                  color: AppColors.successText,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  // Menu cepat
  Widget _buildMenuItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,

      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),

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

        child: Row(
          children: [
            // Icon menu
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

            // Label menu
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

            // Icon panah
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
