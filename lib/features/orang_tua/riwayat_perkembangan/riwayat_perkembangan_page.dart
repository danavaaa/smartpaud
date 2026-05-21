import 'package:flutter/material.dart';
import 'detail_laporan_ortu_page.dart';

// Halaman riwayat perkembangan orang tua
class RiwayatPerkembanganPage extends StatefulWidget {
  const RiwayatPerkembanganPage({super.key});

  @override
  State<RiwayatPerkembanganPage> createState() =>
      _RiwayatPerkembanganPageState();
}

class _RiwayatPerkembanganPageState extends State<RiwayatPerkembanganPage> {
  // Dummy list anak
  final List<Map<String, String>> _anakList = [
    {'id': '1', 'nama': 'Richa'},
    {'id': '2', 'nama': 'Richie'},
  ];

  // Menyimpan anak yang sedang dipilih
  Map<String, String>? _selectedAnak;

  // Dummy filter periode yang sedang dipilih
  String _selectedPeriode = 'Semua Periode';

  // List pilihan periode nanti diambil dari tabel periode ajaran
  final List<String> _periodeList = [
    'Semua Periode',
    '2024/2025 – Semester 1',
    '2024/2025 – Semester 2',
  ];

  // Dummy data laporan perkembangan
  final List<Map<String, dynamic>> _laporanList = [
    {
      'id': '1',
      'nama_siswa': 'Richa',
      'nama_kelas': 'Kelas A',
      // Tanggal laporan dibuat
      'tanggal': '20 Mei 2025',

      // Preview singkat isi laporan
      'preview': 'Anak dapat menggunting sesuai pola gambar dengan baik.',

      // Ringkasan hasil analisis
      'ringkasan':
          'Berdasarkan catatan guru, anak menunjukkan perkembangan literasi membaca yang positif.',

      // Rekomendasi tindak lanjut
      'rekomendasi':
          '1. Bacakan buku cerita bergambar setiap hari minimal 15 menit.\n2. Ajak anak menunjuk dan menyebut huruf di lingkungan sekitar.',

      // Penanda laporan terbaru
      'isNew': true,
    },
    {
      'id': '2',
      'nama_siswa': 'Richa',
      'nama_kelas': 'Kelas A',
      'tanggal': '19 Mei 2025',
      'preview': 'Anak dapat menyebutkan angka 1 sampai 10 dengan urut.',
      'ringkasan': 'Anak menunjukkan kemampuan literasi membaca yang baik.',
      'rekomendasi':
          '1. Latih membaca buku bergambar sederhana.\n2. Libatkan anak dalam kegiatan menulis sederhana.',
      'isNew': false,
    },
    {
      'id': '3',
      'nama_siswa': 'Richa',
      'nama_kelas': 'Kelas A',
      'tanggal': '15 Mei 2025',
      'preview': 'Anak mulai mengenal huruf vokal A, I, U, E, O.',
      'ringkasan': 'Anak mulai mengenal huruf vokal dengan baik dan konsisten.',
      'rekomendasi':
          '1. Gunakan kartu huruf untuk mengenalkan bunyi huruf.\n2. Beri pujian ketika anak berhasil mengenali kata baru.',
      'isNew': false,
    },
  ];

  @override
  void initState() {
    super.initState();

    // Otomatis pilih anak pertama saat halaman dibuka
    _selectedAnak = _anakList.first;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Warna background utama halaman
      backgroundColor: const Color(0xFFDDE8EF),

      body: SafeArea(
        child: Column(
          children: [
            // Header halaman
            _buildHeader(context),

            Expanded(
              child: SingleChildScrollView(
                // Padding isi halaman
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),

                child: Column(
                  children: [
                    // Dropdown untuk memilih anak
                    _buildDropdownAnak(),
                    const SizedBox(height: 10),

                    // Dropdown filter periode ajaran
                    _buildFilterPeriode(),
                    const SizedBox(height: 14),

                    // Generate list laporan
                    ..._laporanList.map((l) => _buildLaporanCard(l)),

                    // Empty state jika tidak ada laporan
                    if (_laporanList.isEmpty) _buildEmptyState(),
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

  // Dropdown untuk memilih anak
  Widget _buildDropdownAnak() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),

      child: DropdownButtonHideUnderline(
        child: DropdownButton<Map<String, String>>(
          // Anak yang sedang dipilih
          value: _selectedAnak,

          isExpanded: true,

          icon: const Icon(
            Icons.keyboard_arrow_down_rounded,
            color: Colors.grey,
          ),

          // Generate item dropdown dari _anakList
          items:
              _anakList.map((anak) {
                return DropdownMenuItem<Map<String, String>>(
                  value: anak,

                  child: Row(
                    children: [
                      const Icon(
                        Icons.person_outline_rounded,
                        size: 16,
                        color: Color(0xFF185FA5),
                      ),
                      const SizedBox(width: 8),

                      // Nama anak
                      Text(
                        anak['nama']!,
                        style: const TextStyle(
                          fontSize: 13,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),

          // Saat anak dipilih
          onChanged: (val) {
            if (val != null) {
              // Update state anak yang dipilih
              setState(() => _selectedAnak = val);
            }
          },
        ),
      ),
    );
  }

  // Dropdown untuk filter laporan berdasarkan periode ajaran
  Widget _buildFilterPeriode() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),

      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          // Periode yang sedang dipilih
          value: _selectedPeriode,

          isExpanded: true,

          icon: const Icon(
            Icons.keyboard_arrow_down_rounded,
            color: Colors.grey,
          ),

          // Generate pilihan periode
          items:
              _periodeList.map((p) {
                return DropdownMenuItem<String>(
                  value: p,
                  child: Text(
                    p,
                    style: const TextStyle(fontSize: 13, fontFamily: 'Poppins'),
                  ),
                );
              }).toList(),

          // Saat periode dipilih
          onChanged: (val) {
            if (val != null) {
              // Update filter periode
              setState(() => _selectedPeriode = val);
            }
          },
        ),
      ),
    );
  }

  // card laporan
  Widget _buildLaporanCard(Map<String, dynamic> laporan) {
    // Cek apakah laporan baru
    final bool isNew = laporan['isNew'] as bool;

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
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),

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
            Row(
              children: [
                // Tanggal laporan
                Expanded(
                  child: Text(
                    laporan['tanggal'],
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ),

                // Badge "Baru" jika laporan terbaru
                if (isNew)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEAF3DE),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'Baru',
                      style: TextStyle(
                        fontSize: 10,
                        fontFamily: 'Poppins',
                        color: Color(0xFF3B6D11),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 6),

            // Preview isi laporan
            Text(
              laporan['preview'],
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
