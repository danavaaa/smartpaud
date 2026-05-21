import 'package:flutter/material.dart';
import 'riwayat_ortu_model.dart';
import 'riwayat_ortu_service.dart';
import 'detail_laporan_ortu_page.dart';

// Halaman riwayat perkembangan orang tua
class RiwayatPerkembanganPage extends StatefulWidget {
  const RiwayatPerkembanganPage({super.key});

  @override
  State<RiwayatPerkembanganPage> createState() =>
      _RiwayatPerkembanganPageState();
}

class _RiwayatPerkembanganPageState extends State<RiwayatPerkembanganPage> {
  // Instance service untuk mengambil data dari database
  final _service = RiwayatLaporanOrtuService();

  // Menyimpan daftar anak milik orang tua
  List<AnakOrtuModel> _anakList = [];
  // Menyimpan anak yang sedang dipilih pada dropdown
  AnakOrtuModel? _selectedAnak;

  // Menyimpan daftar laporan perkembangan siswa
  List<LaporanOrtuModel> _laporanList = [];

  // Status loading saat data anak sedang diambil
  bool _isLoadingAnak = true;

  // Status loading saat data laporan sedang diambil
  bool _isLoadingLaporan = false;
  // Filter periode yang sedang dipilih
  String _selectedPeriode = 'Semua Periode';

  // List pilihan periode nanti diambil dari tabel periode ajaran
  final List<String> _periodeList = [
    'Semua Periode',
    '2024/2025 – Semester 1',
    '2024/2025 – Semester 2',
  ];

  final String _emailOrangTua = 'ortu@smartpaud.com';

  @override
  void initState() {
    super.initState();
    _loadAnak();
  }

  // Fungsi untuk mengambil daftar anak berdasarkan akun orang tua
  Future<void> _loadAnak() async {
    // Set loading anak menjadi true
    setState(() => _isLoadingAnak = true);

    try {
      // Ambil id_orang_tua berdasarkan email login
      final idOrangTua = await _service.getIdOrangTua(_emailOrangTua);

      // Jika id_orang_tua tidak ditemukan
      if (idOrangTua == null) {
        // Matikan loading
        setState(() => _isLoadingAnak = false);
        return;
      }

      // Ambil daftar anak dari database
      final list = await _service.getAnakList(idOrangTua);

      // Update state setelah data berhasil didapat
      setState(() {
        _anakList = list;
        _isLoadingAnak = false;

        // Jika daftar anak tidak kosong
        if (list.isNotEmpty) {
          // Otomatis pilih anak aktif pertama
          _selectedAnak = list.firstWhere(
            (a) => a.isActive,

            // Jika tidak ada yang aktif, pilih data pertama
            orElse: () => list.first,
          );

          // Load laporan berdasarkan anak yang dipilih
          _loadLaporan(_selectedAnak!.id);
        }
      });
    } catch (e) {
      // Jika error, matikan loading
      setState(() => _isLoadingAnak = false);

      // Cek apakah widget masih aktif
      if (mounted) {
        // Tampilkan pesan error
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Gagal memuat data: $e')));
      }
    }
  }

  // Function untuk mengambil daftar laporan berdasarkan id siswa
  Future<void> _loadLaporan(String idSiswa) async {
    // Set loading laporan menjadi true
    setState(() => _isLoadingLaporan = true);

    try {
      // Ambil data laporan dari database
      final list = await _service.getLaporan(idSiswa);

      // Update state setelah data berhasil didapat
      setState(() {
        _laporanList = list;
        _isLoadingLaporan = false;
      });
    } catch (e) {
      // Jika error, matikan loading
      setState(() => _isLoadingLaporan = false);
    }
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
              child:
                  _isLoadingAnak
                      ? const Center(child: CircularProgressIndicator())
                      : SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),

                        child: Column(
                          children: [
                            // Dropdown untuk memilih anak
                            _buildDropdownAnak(),
                            const SizedBox(height: 10),

                            // Dropdown filter periode ajaran
                            _buildFilterPeriode(),
                            const SizedBox(height: 14),
                            if (_isLoadingLaporan)
                              const Center(child: CircularProgressIndicator())
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

  // Dropdown untuk memilih anak
  Widget _buildDropdownAnak() {
    // Jika daftar anak kosong
    if (_anakList.isEmpty) {
      // Tampilkan pesan
      return const Text(
        'Tidak ada data anak',
        style: TextStyle(
          fontSize: 12,
          color: Colors.grey,
          fontFamily: 'Poppins',
        ),
      );
    }
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
        child: DropdownButton<AnakOrtuModel>(
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
                return DropdownMenuItem<AnakOrtuModel>(
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
                        anak.nama,
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
              _loadLaporan(val.id);
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
            if (val != null) setState(() => _selectedPeriode = val);
          },
        ),
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
