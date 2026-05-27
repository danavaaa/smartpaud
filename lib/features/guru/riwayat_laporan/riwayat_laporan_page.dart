import 'package:flutter/material.dart';
import '../riwayat_laporan/riwayat_laporan_model.dart';
import 'detail_laporan_page.dart';
import 'riwayat_laporan_service.dart';

// halaman riwayat laporan guru
class RiwayatLaporanPage extends StatefulWidget {
  const RiwayatLaporanPage({super.key});

  @override
  State<RiwayatLaporanPage> createState() => _RiwayatLaporanPageState();
}

class _RiwayatLaporanPageState extends State<RiwayatLaporanPage> {
  final _searchController = TextEditingController();
  // service untuk mengambil data laporan dari database
  final _service = RiwayatLaporanService();

  // Menyimpan teks pencarian dari search bar
  String _searchQuery = '';

  // Filter kelas default
  String _selectedKelas = 'Semua';

  // menyimpan daftar periode yang dipilih dari dropdown
  String? _selectedPeriodeId;

  // menyimpan seluruh data laporan
  List<LaporanModel> _laporanList = [];
  // menyimpan daftar periode ajaran
  List<Map<String, dynamic>> _periodeListData = [];
  // status loading halaman
  bool _isLoading = true;

  // list kelas unik dari data laporan untuk dropdown filter
  List<String> get _kelasItems {
    // ambil semua nama kelas dari laporan
    final kelas = _laporanList.map((e) => e.namaKelas).toSet().toList();

    // Tambahkan pilihan "Semua"
    return ['Semua', ...kelas];
  }

  // filter data riwayat laporan berdasarkan search query, kelas, dan periode
  List<LaporanModel> get _filtered {
    return _laporanList.where((l) {
      // Filter berdasarkan nama siswa
      final matchSearch = l.namaSiswa.toLowerCase().contains(
        _searchQuery.toLowerCase(),
      );

      // Filter berdasarkan kelas
      final matchKelas =
          _selectedKelas == 'Semua' || l.namaKelas == _selectedKelas;
      // cek apakah data laporan sesuai dengan periode yang dipilih
      final matchPeriode =
          // jika periode belum dipilih (null) maka semua data dianggap sesuai
          _selectedPeriodeId == null ||
          // jika ada periode dipilih, ceka apakah periode laporan sama dengan filter
          l.periodeId == _selectedPeriodeId;
      // return hasil akhir, data yang ditampilkan jika sesuai pencarian, kelas dan periode
      return matchSearch && matchKelas && matchPeriode;
      // ubah hasil filter menjadi list
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    // ambil data periode ajaran
    _loadPeriode();
    // ambil seluruh data laporan
    _loadData();
  }

  // fungsi untuk mengambil daftar periode ajaran
  Future<void> _loadPeriode() async {
    try {
      // request data periode dari service
      final list = await _service.getPeriodeList();
      setState(() => _periodeListData = list);
    } catch (_) {}
  }

  // fungsi untuk mengambil data laporan perkembangan
  Future<void> _loadData() async {
    // aktifkan loading sebelum request data
    setState(() => _isLoading = true);
    try {
      // ambil seluruh data laporan dari service
      final data = await _service.getLaporan();
      // simpan data laporan ke state
      setState(() {
        _laporanList = data;
        // matikan loading saat data berhasil diambil
        _isLoading = false;
      });
    } catch (e) {
      // matikan loading saat terjadi eror
      setState(() => _isLoading = false);
      if (mounted) {
        // tampilkan pesan eror ke user
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Gagal memuat data: $e')));
      }
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Background halaman
      backgroundColor: const Color(0xFFDDE8EF),

      body: SafeArea(
        child: Column(
          children: [
            // Header halaman
            _buildHeader(context),

            Expanded(
              child:
                  _isLoading // Tampilkan loading indicator saat data sedang dimuat
                      ? const Center(child: CircularProgressIndicator())
                      : SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),

                        child: Column(
                          children: [
                            // Search bar
                            _buildSearchBar(),

                            const SizedBox(height: 10),

                            // Filter dropdown
                            _buildFilterRow(),

                            const SizedBox(height: 14),

                            // Generate card laporan
                            ..._filtered.map((l) => _buildLaporanCard(l)),

                            // Empty state jika data kosong
                            if (_filtered.isEmpty) _buildEmptyState(),
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
            'Riwayat Laporan',

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

  // search bar untuk mencari laporan berdasarkan nama siswa
  Widget _buildSearchBar() {
    return Container(
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

      child: TextField(
        // Controller input
        controller: _searchController,

        // saat input berubah, update search query
        onChanged: (val) => setState(() => _searchQuery = val),

        style: const TextStyle(fontSize: 13, fontFamily: 'Poppins'),

        decoration: InputDecoration(
          // Placeholder
          hintText: 'Cari laporan siswa...',

          hintStyle: const TextStyle(
            color: Colors.grey,
            fontSize: 13,
            fontFamily: 'Poppins',
          ),

          // Icon search
          prefixIcon: const Icon(
            Icons.search_rounded,
            color: Colors.grey,
            size: 20,
          ),

          // Tombol clear muncul jika ada input
          suffixIcon:
              _searchQuery.isNotEmpty
                  ? GestureDetector(
                    onTap: () {
                      // Hapus isi search
                      _searchController.clear();

                      // Reset query
                      setState(() => _searchQuery = '');
                    },

                    child: const Icon(
                      Icons.close_rounded,
                      color: Colors.grey,
                      size: 18,
                    ),
                  )
                  : null,

          border: InputBorder.none,

          contentPadding: const EdgeInsets.symmetric(vertical: 12),
        ),
      ),
    );
  }

  // filter row dengan dropdown untuk memilih kelas dan periode laporan
  Widget _buildFilterRow() {
    return Row(
      children: [
        // dropdown kelas
        Expanded(
          child: _buildDropdown(
            value: _selectedKelas,

            items: _kelasItems,

            onChanged: (val) => setState(() => _selectedKelas = val!),
          ),
        ),

        const SizedBox(width: 8),

        // dropdown periode
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            // Dekorasi container dropdown
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              // Shadow agar terlihat seperti card
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),

            child: DropdownButtonHideUnderline(
              // Menghilangkan garis bawah default dropdown
              child: DropdownButton<String?>(
                value: _selectedPeriodeId,
                isExpanded: true,
                // Icon panah dropdown
                icon: const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: Colors.grey,
                  size: 18,
                ),
                // List item dropdown
                items: [
                  // Opsi default untuk menampilkan semua data
                  const DropdownMenuItem<String?>(
                    value: null,
                    child: Text(
                      'Semua',
                      style: TextStyle(fontSize: 12, fontFamily: 'Poppins'),
                    ),
                  ),

                  // Generate item dropdown dari data periode
                  ..._periodeListData.map((p) {
                    return DropdownMenuItem<String?>(
                      // Value yang disimpan saat item dipilih
                      value: p['id'] as String,

                      // Text yang ditampilkan di dropdown
                      child: Text(
                        '${p['tahun_ajaran']} – ${p['semester']}',
                        style: const TextStyle(
                          fontSize: 12,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    );
                  }),
                ],

                // Saat user memilih periode
                onChanged: (val) {
                  // Simpan id periode yang dipilih
                  setState(() => _selectedPeriodeId = val);
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  // widget dropdown umum untuk filter kelas dan periode
  Widget _buildDropdown({
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),

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
          value: value,

          isExpanded: true,

          icon: const Icon(
            Icons.keyboard_arrow_down_rounded,
            color: Colors.grey,
            size: 18,
          ),

          // Generate item dropdown
          items:
              items
                  .map(
                    (e) => DropdownMenuItem(
                      value: e,

                      child: Text(
                        e,

                        style: const TextStyle(
                          fontSize: 12,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ),
                  )
                  .toList(),

          onChanged: onChanged,
        ),
      ),
    );
  }

  // card laporan
  Widget _buildLaporanCard(LaporanModel laporan) {
    return GestureDetector(
      // aksi saat card ditekan
      onTap:
          () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => DetailLaporanPage(laporan: laporan),
            ),
          ),

      child: Container(
        margin: const EdgeInsets.only(bottom: 10),

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
            // Avatar inisial siswa
            CircleAvatar(
              radius: 20,

              backgroundColor: const Color(0xFFDDE8EF),

              child: Text(
                laporan.inisial,

                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,

                  color: Color(0xFF185FA5),

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
                    laporan.namaSiswa,

                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,

                      fontFamily: 'Poppins',
                    ),
                  ),

                  const SizedBox(height: 2),

                  // Kelas dan tanggal
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

            // Status laporan
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
      ),
    );
  }

  // empty state jika tidak ada laporan yang cocok dengan filter pencarian
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
