import 'package:flutter/material.dart';
import 'dart:io';
import 'laporan_service.dart';
import '../../../core/theme/app_colors.dart';

// HAlaman preview hasil AI
class PreviewLaporanPage extends StatefulWidget {
  final String idSiswa;
  final String namaSiswa;
  final String namaKelas;
  final String tanggalLaporan;
  final String tanggalDisplay;
  final String catatanLiterasi;
  final String ringkasanAi;
  final String rekomendasiAi;
  final File? imageFile;

  const PreviewLaporanPage({
    super.key,

    required this.idSiswa,
    required this.namaSiswa,
    required this.namaKelas,
    required this.tanggalLaporan,
    required this.tanggalDisplay,
    required this.catatanLiterasi,
    required this.ringkasanAi,
    required this.rekomendasiAi,

    this.imageFile,
  });

  @override
  State<PreviewLaporanPage> createState() => _PreviewLaporanPageState();
}

class _PreviewLaporanPageState extends State<PreviewLaporanPage> {
  // Status loading saat simpan
  bool _isSaving = false;

  // Simpan laporan
  Future<void> _simpanLaporan() async {
    // Aktifkan loading
    setState(() => _isSaving = true);
    // Simpan laporan ke database
    try {
      final service = LaporanService();

      // Upload foto jika ada
      String? fotoUrl;
      if (widget.imageFile != null) {
        fotoUrl = await service.uploadFoto(widget.imageFile!, widget.idSiswa);
      }

      // Simpan laporan dengan fotoUrl
      await service.simpanLaporan(
        idSiswa: widget.idSiswa,
        tanggalLaporan: widget.tanggalLaporan,
        catatanLiterasi: widget.catatanLiterasi,
        ringkasanAi: widget.ringkasanAi,
        rekomendasiAi: widget.rekomendasiAi,
        fotoUrl: fotoUrl,
      );

      if (!mounted) return;

      // Menampilkan snackbar sukses
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Laporan berhasil disimpan!'),

          backgroundColor: Color(0xFF3B6D11),
        ),
      );

      // Kembali ke halaman pertama/dashboard
      Navigator.popUntil(context, (route) => route.isFirst);
    } catch (e) {
      if (!mounted) return;
      setState(() => _isSaving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal menyimpan: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Inisial nama siswa untuk avatar
  String _inisial(String nama) {
    // Pisahkan nama berdasarkan spasi
    final parts = nama.trim().split(' ');

    // Jika nama lebih dari satu kata
    if (parts.length >= 2) {
      // Ambil huruf pertama tiap kata
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }

    // Jika hanya satu kata
    return parts[0][0].toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Background halaman
      backgroundColor: AppColors.background,

      body: SafeArea(
        child: Column(
          children: [
            // Header halaman
            _buildHeader(context),

            Expanded(
              child: SingleChildScrollView(
                // Padding konten
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),

                child: Column(
                  children: [
                    // Card info siswa
                    _buildInfoSiswa(),

                    const SizedBox(height: 12),

                    // foto

                    // Tampilkan foto jika ada
                    if (widget.imageFile != null) ...[
                      _buildFotoCard(),
                      const SizedBox(height: 12),
                    ],

                    // card AI

                    // Card ringkasan AI
                    _buildCard(
                      icon: Icons.auto_awesome_rounded,

                      title: 'Ringkasan Literasi Membaca',

                      content: widget.ringkasanAi,
                    ),

                    const SizedBox(height: 12),

                    // Card rekomendasi AI
                    _buildCard(
                      icon: Icons.lightbulb_outline_rounded,

                      title: 'Rekomendasi Stimulasi Lanjutan',

                      content: widget.rekomendasiAi,
                    ),

                    const SizedBox(height: 20),

                    // Tombol aksi
                    _buildButtons(context),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

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
            'Preview Hasil AI',

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

  // card info siswa

  Widget _buildInfoSiswa() {
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

      child: Row(
        children: [
          // Avatar inisial siswa
          CircleAvatar(
            radius: 22,

            backgroundColor: AppColors.background,

            child: Text(
              _inisial(widget.namaSiswa),

              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.secondary,
                fontFamily: 'Poppins',
              ),
            ),
          ),

          const SizedBox(width: 12),

          // Data siswa
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              // Nama siswa
              Text(
                widget.namaSiswa,

                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Poppins',
                ),
              ),

              // Kelas + tanggal
              Text(
                '${widget.namaKelas} · ${widget.tanggalDisplay}',

                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                  fontFamily: 'Poppins',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // card foto

  Widget _buildFotoCard() {
    return Container(
      width: double.infinity,

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

      child: ClipRRect(
        // Agar gambar ikut rounded
        borderRadius: BorderRadius.circular(14),

        child: Image.file(
          // File gambar
          widget.imageFile!,

          // Tinggi gambar
          height: 180,

          width: double.infinity,

          // Crop gambar
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  // card umum

  Widget _buildCard({
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
          Row(
            children: [
              // Icon card
              Icon(icon, size: 18, color: AppColors.primary),

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

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),

            decoration: BoxDecoration(
              color: AppColors.background,

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

  // tombol aksi

  Widget _buildButtons(BuildContext context) {
    return Row(
      children: [
        // batal
        Expanded(
          child: SizedBox(
            height: 52,

            child: OutlinedButton(
              // Kembali ke halaman sebelumnya
              onPressed: () => Navigator.pop(context),

              style: OutlinedButton.styleFrom(
                backgroundColor: const Color(0xFFF1F1EB),

                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),

                side: BorderSide.none,
              ),

              child: const Text(
                'Batal',

                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black87,
                  fontFamily: 'Poppins',
                ),
              ),
            ),
          ),
        ),

        const SizedBox(width: 14),

        // simpan
        Expanded(
          child: SizedBox(
            height: 52,

            child: ElevatedButton(
              // Disable tombol saat loading
              onPressed: _isSaving ? null : _simpanLaporan,

              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,

                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),

              child:
                  // Jika loading tampilkan spinner
                  _isSaving
                      ? const SizedBox(
                        width: 22,
                        height: 22,

                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2.5,
                        ),
                      )
                      // Jika tidak loading tampilkan text
                      : const Text(
                        'Simpan Laporan',

                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontFamily: 'Poppins',
                        ),
                      ),
            ),
          ),
        ),
      ],
    );
  }
}
