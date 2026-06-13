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
                  'Preview Hasil AI',

                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Poppins',
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Periksa hasil laporan sebelum disimpan',
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

  // card info siswa
  Widget _buildInfoSiswa() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Row(
        children: [
          // Avatar inisial siswa
          CircleAvatar(
            radius: 24,
            backgroundColor: AppColors.softPrimary,
            child: Text(
              _inisial(widget.namaSiswa),
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
                fontFamily: 'Poppins',
              ),
            ),
          ),

          const SizedBox(width: 12),

          // Data siswa
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Nama siswa
                Text(
                  widget.namaSiswa,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Poppins',
                    color: AppColors.textPrimary,
                  ),
                ),

                const SizedBox(height: 3),

                // Kelas + tanggal
                Text(
                  '${widget.namaKelas} · ${widget.tanggalDisplay}',
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

  // card foto
  Widget _buildFotoCard() {
    return Container(
      width: double.infinity,
      decoration: _cardDecoration(),
      child: ClipRRect(
        // Agar gambar ikut rounded
        borderRadius: BorderRadius.circular(16),
        child: Image.file(
          // File gambar
          widget.imageFile!,
          // Tinggi gambar
          height: 190,
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
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
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

              // Judul card
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
                height: 1.6,
                color: AppColors.textPrimary,
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
                backgroundColor: AppColors.card,
                foregroundColor: AppColors.textPrimary,
                side: BorderSide(
                  color: AppColors.accent.withValues(alpha: 0.45),
                  width: 1,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Text(
                'Batal',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
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
                foregroundColor: AppColors.buttonText,
                elevation: 3,
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
                          color: AppColors.buttonText,
                          strokeWidth: 2.5,
                        ),
                      )
                      // Jika tidak loading tampilkan text
                      : const Text(
                        'Simpan Laporan',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.buttonText,
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
