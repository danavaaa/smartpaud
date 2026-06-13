import 'package:flutter/material.dart';
import 'riwayat_ortu_model.dart';
import 'riwayat_ortu_service.dart';
import 'detail_laporan_ortu_page.dart';
import '../../../core/theme/app_colors.dart';

// Halaman riwayat perkembangan orang tua
class RiwayatPerkembanganPage extends StatefulWidget {
  final String idSiswa;
  final String namaSiswa;

  const RiwayatPerkembanganPage({
    super.key,
    required this.idSiswa,
    required this.namaSiswa,
  });

  @override
  State<RiwayatPerkembanganPage> createState() =>
      _RiwayatPerkembanganPageState();
}

class _RiwayatPerkembanganPageState extends State<RiwayatPerkembanganPage> {
  // Instance service untuk mengambil data dari database
  final _service = RiwayatLaporanOrtuService();

  // Menyimpan daftar laporan perkembangan siswa
  List<LaporanOrtuModel> _laporanList = [];
  bool _isLoadingLaporan = true;

  @override
  void initState() {
    super.initState();
    _loadLaporan();
  }

  // Function untuk mengambil daftar laporan berdasarkan id siswa, yang dikirim dari halaman sebelumnya
  Future<void> _loadLaporan() async {
    // Menampilkan indikator loading selama proses pengambilan data
    setState(() => _isLoadingLaporan = true);

    try {
      // Memanggil service untuk mengambil daftar laporan siswa
      final list = await _service.getLaporanByPeriode(widget.idSiswa);

      // hentikan proses jika widget sudah tidak berada di dalam tree
      if (!mounted) return;

      // Menyimpan hasil data laporan ke state dan mematikan loading
      setState(() {
        _laporanList = list;
        _isLoadingLaporan = false;
      });
    } catch (e) {
      // hentikan proses jika widget sudah tidak aktif
      if (!mounted) return;

      // matikan loading ketika terjadi error
      setState(() => _isLoadingLaporan = false);

      // tampilkan pesan kesalahan kepada user
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal mengambil laporan: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Warna background utama halaman
      backgroundColor: AppColors.background,

      body: SafeArea(
        child: Column(
          children: [
            // Header halaman
            _buildHeader(context),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),

                child: Column(
                  children: [
                    _buildInfoAnakCard(),

                    const SizedBox(height: 14),
                    if (_isLoadingLaporan)
                      const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primary,
                        ),
                      )
                    else ...[
                      ..._laporanList.map((l) => _buildLaporanCard(l)),

                      // Empty state jika tidak ada laporan
                      if (_laporanList.isEmpty) _buildEmptyState(),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // header menampilkan tombol kembali dan judul halaman
  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),

      child: Row(
        children: [
          // Tombol back
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(Icons.chevron_left_rounded, size: 28),
          ),

          const SizedBox(width: 8),

          // Judul halaman
          const Text(
            'Riwayat Perkembangan',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              fontFamily: 'Poppins',
            ),
          ),
        ],
      ),
    );
  }

  // Widget card yang menampilkan informasi siswa yang sedang dipilih
  Widget _buildInfoAnakCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),

      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),

        boxShadow: [
          BoxShadow(
            // Memberikan efek bayangan agar card terlihat lebih menonjol
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          // Icon siswa sebagai identitas visual card
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.softPrimary,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.person_outline_rounded,
              color: AppColors.primary,
              size: 22,
            ),
          ),

          const SizedBox(width: 12),

          // Menampilkan informasi nama siswa
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Teks keterangan
                const Text(
                  'Riwayat laporan untuk',
                  style: TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                    fontFamily: 'Poppins',
                  ),
                ),

                const SizedBox(height: 2),

                // Menampilkan nama siswa yang diterima dari halaman sebelumnya
                Text(
                  widget.namaSiswa,
                  style: const TextStyle(
                    fontSize: 15,
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
    );
  }

  // card laporan
  Widget _buildLaporanCard(LaporanOrtuModel laporan) {
    return GestureDetector(
      // aksi ketika card di klik
      onTap:
          () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => DetailLaporanOrtuPage(laporan: laporan),
            ),
          ),

      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),

        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(12),

          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Tanggal laporan
                Expanded(
                  child: Text(
                    laporan.tanggal,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ),

                // Badge "Baru" jika laporan terbaru
                if (laporan.isNew)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.successBg,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'Baru',
                      style: TextStyle(
                        fontSize: 10,
                        fontFamily: 'Poppins',
                        color: AppColors.successText,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 6),

            // Preview isi laporan
            Text(
              laporan.preview,
              style: const TextStyle(
                fontSize: 11,
                color: Colors.grey,
                fontFamily: 'Poppins',
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Tampilan jika tidak ada laporan
  Widget _buildEmptyState() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 40),

      child: Center(
        child: Column(
          children: [
            // Icon empty
            Icon(Icons.article_outlined, size: 48, color: Colors.grey),

            SizedBox(height: 8),

            // Text empty
            Text(
              'Belum ada laporan',
              style: TextStyle(
                color: Colors.grey,
                fontFamily: 'Poppins',
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
