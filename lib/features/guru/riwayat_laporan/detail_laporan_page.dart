import 'package:flutter/material.dart';
import 'riwayat_laporan_model.dart';

// halaman detail laporan
class DetailLaporanPage extends StatelessWidget {
  final LaporanModel laporan;
  const DetailLaporanPage({super.key, required this.laporan});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Warna background halaman
      backgroundColor: const Color(0xFFDDE8EF),

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

  // header halaman dengan tombol kembali dan judul
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

  // info siswa
  Widget _buildInfoSiswa() {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(16),

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

      child: Row(
        children: [
          // avatar dengan inisial nama siswa
          CircleAvatar(
            radius: 22,

            backgroundColor: const Color(0xFFDDE8EF),

            child: Text(
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

          // data nama siswa, kelas, dan tanggal laporan
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

                // Kelas dan tanggal laporan
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

          // badge status laporan (selesai)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),

            decoration: BoxDecoration(
              color: const Color(0xFFEAF3DE),

              borderRadius: BorderRadius.circular(20),
            ),

            child: const Text(
              'Selesai',

              style: TextStyle(
                fontSize: 11,

                fontFamily: 'Poppins',

                color: Color(0xFF3B6D11),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // card foto kegiatan
  Widget _buildFotoCard() {
    return Container(
      width: double.infinity,

      height: 180,

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

      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            // Icon placeholder
            Icon(Icons.image_outlined, size: 48, color: Colors.grey.shade400),

            const SizedBox(height: 8),

            // Text utama
            Text(
              'Foto Kegiatan',

              style: TextStyle(
                fontSize: 13,

                color: Colors.grey.shade400,

                fontFamily: 'Poppins',
              ),
            ),

            const SizedBox(height: 4),
          ],
        ),
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

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          // header dengan icon dan judul
          Row(
            children: [
              // Icon section
              Icon(icon, size: 18, color: const Color(0xFF185FA5)),

              const SizedBox(width: 8),

              // Judul section
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

          // isi konten
          Container(
            width: double.infinity,

            padding: const EdgeInsets.all(12),

            decoration: BoxDecoration(
              color: const Color(0xFFDDE8EF),

              borderRadius: BorderRadius.circular(8),
            ),

            child: Text(
              content,

              style: const TextStyle(
                fontSize: 12,

                fontFamily: 'Poppins',

                // Jarak antar baris
                height: 1.6,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
