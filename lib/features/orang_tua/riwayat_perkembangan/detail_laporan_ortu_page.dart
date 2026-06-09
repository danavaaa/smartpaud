import 'package:flutter/material.dart';
import 'riwayat_ortu_model.dart';

class DetailLaporanOrtuPage extends StatelessWidget {
  // Data laporan yang dikirim dari halaman sebelumnya
  final LaporanOrtuModel laporan;

  // Constructor menerima data laporan
  const DetailLaporanOrtuPage({super.key, required this.laporan});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Warna background halaman
      backgroundColor: const Color(0xFFDDE8EF),

      body: SafeArea(
        child: Column(
          children: [
            // Header halaman
            _buildHeader(context),
            Expanded(
              child: SingleChildScrollView(
                // Padding untuk seluruh isi halaman
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),

                child: Column(
                  children: [
                    // Card informasi siswa
                    _buildInfoSiswa(),
                    const SizedBox(height: 12),

                    // Card foto kegiatan
                    _buildFotoCard(),
                    const SizedBox(height: 12),

                    // Card ringkasan AI
                    _buildContentCard(
                      icon: Icons.auto_awesome_rounded,
                      title: 'Ringkasan Literasi Membaca',

                      // Mengambil data ringkasan dari laporan
                      content: laporan.ringkasanAi,
                    ),
                    const SizedBox(height: 12),

                    // Card rekomendasi stimulasi
                    _buildContentCard(
                      icon: Icons.lightbulb_outline_rounded,
                      title: 'Rekomendasi Stimulasi Lanjutan',

                      // Mengambil data rekomendasi dari laporan
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

  // Widget untuk header halaman
  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),

      child: Row(
        children: [
          // Tombol kembali
          GestureDetector(
            onTap: () => Navigator.pop(context),

            child: const Icon(Icons.chevron_left_rounded, size: 28),
          ),

          const SizedBox(width: 8),

          // Judul halaman
          const Text(
            'Detail Laporan',

            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              fontFamily: 'Poppins',
            ),
          ),
        ],
      ),
    );
  }

  // Widget card informasi siswa
  Widget _buildInfoSiswa() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        // Warna card
        color: Colors.white,

        // Radius sudut card
        borderRadius: BorderRadius.circular(14),

        // Shadow card
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),

      child: Row(
        children: [
          // Avatar berisi inisial siswa
          CircleAvatar(
            radius: 22,
            backgroundColor: const Color(0xFFDDE8EF),

            child: Text(
              // Mengambil inisial dari nama siswa
              laporan.inisial,

              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF185FA5),
                fontFamily: 'Poppins',
              ),
            ),
          ),

          const SizedBox(width: 12),

          // Nama siswa, kelas, dan tanggal
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Nama siswa
                Text(
                  laporan.namaSiswa,

                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Poppins',
                  ),
                ),

                const SizedBox(height: 2),

                // Menampilkan nama kelas dan tanggal laporan
                Text(
                  '${laporan.namaKelas} · ${laporan.tanggal}',

                  style: const TextStyle(
                    fontSize: 11,
                    color: Colors.grey,
                    fontFamily: 'Poppins',
                  ),
                ),
              ],
            ),
          ),

          // Badge "Baru" jika laporan masih baru
          if (laporan.isNew)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),

              decoration: BoxDecoration(
                color: const Color(0xFFEAF3DE),
                borderRadius: BorderRadius.circular(20),
              ),

              child: const Text(
                'Baru',

                style: TextStyle(
                  fontSize: 11,
                  fontFamily: 'Poppins',
                  color: Color(0xFF3B6D11),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
        ],
      ),
    );
  }

  // Widget card foto kegiatan
  Widget _buildFotoCard() {
    // Jika foto tersedia
    if (laporan.fotoUrl != null && laporan.fotoUrl!.isNotEmpty) {
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
          borderRadius: BorderRadius.circular(14),

          child: Image.network(
            // Menampilkan gambar dari URL
            laporan.fotoUrl!,

            fit: BoxFit.cover,

            // Jika gagal load gambar
            errorBuilder: (_, __, ___) => _buildFotoPlaceholder(),
          ),
        ),
      );
    }

    // Jika foto tidak ada
    return _buildFotoPlaceholder();
  }

  // Placeholder jika foto belum ada
  Widget _buildFotoPlaceholder() {
    return Container(
      width: double.infinity,
      height: 180,

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

      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon placeholder gambar
          Icon(Icons.image_outlined, size: 48, color: Colors.grey.shade400),

          const SizedBox(height: 8),

          // Judul placeholder
          Text(
            'Foto Kegiatan',

            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade400,
              fontFamily: 'Poppins',
            ),
          ),

          const SizedBox(height: 4),

          // Informasi belum ada foto
          Text(
            'Belum ada foto kegiatan',

            style: TextStyle(
              fontSize: 10,
              color: Colors.grey.shade400,
              fontFamily: 'Poppins',
            ),
          ),
        ],
      ),
    );
  }

  // Widget ringkasan dan rekomendasi
  Widget _buildContentCard({
    required IconData icon,
    required String title,
    required String content,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),

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

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header card (icon dan judul)
          Row(
            children: [
              // Icon card
              Icon(icon, size: 18, color: const Color(0xFF185FA5)),

              const SizedBox(width: 8),

              // Judul card
              Expanded(
                child: Text(
                  title,

                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Poppins',
                    color: Color(0xFF444444),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // Container isi konten
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),

            decoration: BoxDecoration(
              color: const Color(0xFFDDE8EF),
              borderRadius: BorderRadius.circular(8),
            ),

            child: Text(
              // Isi teks dari parameter
              content,

              style: const TextStyle(
                fontSize: 12,
                fontFamily: 'Poppins',
                height: 1.6,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
