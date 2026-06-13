import 'package:flutter/material.dart';
import 'riwayat_laporan_model.dart';
import '../../../core/theme/app_colors.dart';

// halaman detail laporan
class DetailLaporanPage extends StatelessWidget {
  final LaporanModel laporan;
  const DetailLaporanPage({super.key, required this.laporan});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Warna background halaman
      backgroundColor: AppColors.background,

      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),

                child: Column(
                  children: [
                    // info siswa
                    _buildInfoSiswa(),

                    const SizedBox(height: 12),

                    // foto kegiatan
                    _buildFotoCard(),

                    const SizedBox(height: 12),

                    // ringkasan AI
                    _buildContentCard(
                      icon: Icons.auto_awesome_rounded,

                      title: 'Ringkasan Literasi Membaca',

                      content: laporan.ringkasanAi,
                    ),

                    const SizedBox(height: 12),

                    // rekomendasi stimulasi
                    _buildContentCard(
                      icon: Icons.lightbulb_outline_rounded,

                      title: 'Rekomendasi Stimulasi Lanjutan',

                      content: laporan.rekomendasiAi,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Fungsi untuk membuat dekorasi card yang dapat digunakan di berbagai widget dengan tampilan yang konsisten
  BoxDecoration _cardDecoration({double radius = 16}) {
    return BoxDecoration(
      // Menentukan warna latar belakang card
      color: AppColors.card,

      // Mengatur tingkat kelengkungan sudut card
      borderRadius: BorderRadius.circular(radius),

      // Menambahkan efek bayangan agar card terlihat lebih menonjol
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.06),
          blurRadius: 9,
          offset: const Offset(0, 3),
        ),
      ],
    );
  }

  // header halaman dengan tombol kembali dan judul
  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Row(
        children: [
          // Tombol kembali
          InkWell(
            onTap: () => Navigator.pop(context),
            borderRadius: BorderRadius.circular(20),
            child: const Icon(
              Icons.chevron_left_rounded,
              size: 30,
              color: AppColors.textPrimary,
            ),
          ),

          const SizedBox(width: 8),

          // Judul halaman
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Detail Laporan',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Poppins',
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Hasil laporan perkembangan literasi siswa',
                  style: TextStyle(
                    fontSize: 11,
                    fontFamily: 'Poppins',
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // info siswa
  Widget _buildInfoSiswa() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Row(
        children: [
          // avatar dengan inisial nama siswa
          CircleAvatar(
            radius: 24,
            backgroundColor: AppColors.softPrimary,
            child: Text(
              laporan.inisial,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
                fontFamily: 'Poppins',
              ),
            ),
          ),

          const SizedBox(width: 12),

          // data nama siswa, kelas, dan tanggal laporan
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Nama siswa
                Text(
                  laporan.namaSiswa,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Poppins',
                    color: AppColors.textPrimary,
                  ),
                ),

                const SizedBox(height: 3),

                // Kelas dan tanggal laporan
                Text(
                  '${laporan.namaKelas} · ${laporan.tanggal}',
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                    fontFamily: 'Poppins',
                  ),
                ),
              ],
            ),
          ),

          // badge status laporan (selesai)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.successBg,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'Selesai',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                fontFamily: 'Poppins',
                color: AppColors.successText,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // card foto kegiatan
  Widget _buildFotoCard() {
    if (laporan.fotoUrl != null && laporan.fotoUrl!.isNotEmpty) {
      // Jika ada URL foto yang valid, coba tampilkan gambarnya
      return Container(
        width: double.infinity,
        height: 180,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          // Pastikan foto juga memiliki border radius yang sama
          borderRadius: BorderRadius.circular(14),
          child: Image.network(
            laporan.fotoUrl!,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => _buildFotoPlaceholder(),
            // Tampilkan placeholder jika gambar gagal dimuat
          ),
        ),
      );
    }

    // Jika tidak ada foto, tampilkan placeholder
    return _buildFotoPlaceholder();
  }

  Widget _buildFotoPlaceholder() {
    return Container(
      width: double.infinity,
      height: 190,
      decoration: _cardDecoration(),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon placeholder
          Icon(Icons.image_outlined, size: 48, color: AppColors.textSecondary),

          SizedBox(height: 8),

          // Text utama
          Text(
            'Foto kegiatan tidak tersedia',
            style: TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
              fontFamily: 'Poppins',
            ),
          ),
        ],
      ),
    );
  }

  // card untuk ringkasan AI dan rekomendasi stimulasi
  Widget _buildContentCard({
    required IconData icon,
    required String title,
    required String content,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // header dengan icon dan judul
          Row(
            children: [
              // Icon section
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: AppColors.softPrimary,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, size: 18, color: AppColors.primary),
              ),

              const SizedBox(width: 10),

              // Judul section
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Poppins',
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // isi konten
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.softCard,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              content,
              style: const TextStyle(
                fontSize: 12,
                fontFamily: 'Poppins',
                // Jarak antar baris
                height: 1.6,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
