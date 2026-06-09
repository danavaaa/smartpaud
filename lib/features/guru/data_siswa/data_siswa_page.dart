import 'package:flutter/material.dart';
import 'data_siswa_model.dart';
import 'data_siswa_service.dart';
import 'detail_siswa.dart';

// halaman data siswa
class DataSiswaPage extends StatefulWidget {
  const DataSiswaPage({super.key});

  @override
  State<DataSiswaPage> createState() => _DataSiswaPageState();
}

// state untuk halaman data siswa
class _DataSiswaPageState extends State<DataSiswaPage> {
  final _service = SiswaService();
  final _searchController = TextEditingController();

  List<Siswa> _siswaList = [];
  List<Map<String, dynamic>> _kelasList = [];
  bool _isLoading = true;
  // Variabel pencarian
  String _searchQuery = '';
  // Variabel filter kelas
  String _selectedKelasId = 'Semua';
  // Variabel filter periode
  String _selectedPeriode = 'Semua';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Ambil data dari Supabase
  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final siswa = await _service.getSiswa();
      final kelas = await _service.getKelasList();
      setState(() {
        _siswaList = siswa;
        _kelasList = kelas;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Gagal memuat data: $e')));
      }
    }
  }

  // filter data siswa berdasarkan pencarian, kelas, dan periode
  List<Siswa> get _filteredSiswa {
    return _siswaList.where((s) {
      // Filter berdasarkan nama
      final matchNama = s.namaSiswa.toLowerCase().contains(
        _searchQuery.toLowerCase(),
      );

      // Filter berdasarkan kelas
      final matchKelas =
          _selectedKelasId == 'Semua' || s.namaKelas == _selectedKelasId;

      // Filter berdasarkan periode
      final matchPeriode =
          _selectedPeriode == 'Semua' || s.periode == _selectedPeriode;

      // Data ditampilkan jika semua kondisi terpenuhi
      return matchNama && matchKelas && matchPeriode;
    }).toList();
  }

  // widget utama halaman data siswa
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFDDE8EF),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            // header
            _buildHeader(context),
            Expanded(
              child:
                  _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),

                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,

                          children: [
                            const SizedBox(height: 16),
                            // search bar
                            _buildSearchBar(),

                            const SizedBox(height: 12),
                            // filter untuk kelas dan periode
                            _buildFilterRow(),

                            const SizedBox(height: 16),
                            // filter data siswa dan tampilkan dalam bentuk card
                            ..._filteredSiswa.map((s) => _buildSiswaCard(s)),
                            // Jika data kosong maka tampil empty state
                            if (_filteredSiswa.isEmpty) _buildEmptyState(),

                            const SizedBox(height: 16),
                            // catatan footer
                            _buildFooterNote(),
                          ],
                        ),
                      ),
            ),
          ],
        ),
      ),
    );
  }

  // widget header dengan tombol back dan judul
  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),

      child: Row(
        children: [
          // Tombol back
          GestureDetector(
            // Kembali ke halaman sebelumnya
            onTap: () => Navigator.pop(context),

            child: const Icon(Icons.chevron_left_rounded, size: 28),
          ),

          const SizedBox(width: 8),

          // Judul halaman
          const Text(
            'Data Siswa',
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

  // widget pencarian
  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),

      // Input pencarian
      child: TextField(
        controller: _searchController,
        onChanged: (val) => setState(() => _searchQuery = val),

        style: const TextStyle(fontSize: 13, fontFamily: 'Poppins'),

        decoration: InputDecoration(
          // Hint pencarian
          hintText: 'Cari Siswa',

          hintStyle: const TextStyle(
            color: Colors.grey,
            fontSize: 13,
            fontFamily: 'Poppins',
          ),

          // Icon search kiri
          prefixIcon: const Icon(
            Icons.search_rounded,
            color: Colors.grey,
            size: 20,
          ),

          // Tombol clear search
          suffixIcon:
              _searchQuery.isNotEmpty
                  ? GestureDetector(
                    onTap: () {
                      // Menghapus isi search
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

  // widget filter untuk kelas dan periode
  Widget _buildFilterRow() {
    // Buat list unik berdasarkan nama_kelas
    final seen = <String>{};
    final kelasItems = <Map<String, dynamic>>[
      {'nama_kelas': 'Semua'},
    ];
    for (final k in _kelasList) {
      final nama = k['nama_kelas'] as String;
      if (seen.add(nama)) {
        kelasItems.add({'nama_kelas': nama});
      }
    }

    // Buat list periode unik dari data siswa
    final periodeSet = <String>{'Semua'};
    for (final s in _siswaList) {
      if (s.periode != '-') periodeSet.add(s.periode);
    }
    final periodeItems = periodeSet.toList();

    return Row(
      children: [
        // Dropdown kelas
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedKelasId,
                isExpanded: true,
                icon: const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: Colors.grey,
                ),
                items:
                    kelasItems.map((k) {
                      return DropdownMenuItem<String>(
                        value: k['nama_kelas'] as String,
                        child: Text(
                          k['nama_kelas'] as String,
                          style: const TextStyle(
                            fontSize: 13,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      );
                    }).toList(),
                onChanged: (val) => setState(() => _selectedKelasId = val!),
              ),
            ),
          ),
        ),

        const SizedBox(width: 10),

        // Dropdown periode
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),

            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),

              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),

            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedPeriode,
                isExpanded: true,
                icon: const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: Colors.grey,
                ),
                items:
                    periodeItems.map((e) {
                      return DropdownMenuItem<String>(
                        value: e,

                        child: Text(
                          e,
                          style: const TextStyle(
                            fontSize: 13,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      );
                    }).toList(),
                onChanged: (val) => setState(() => _selectedPeriode = val!),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // widget card untuk menampilkan data siswa
  Widget _buildSiswaCard(Siswa siswa) {
    // Mengecek status aktif
    final bool isAktif = siswa.status == 'Aktif';

    return GestureDetector(
      // aksi ketika card siswa ditekan, menuju ke halaman detail siswa
      onTap:
          () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => DetailSiswaPage(siswa: siswa)),
          ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),

        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),

        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),

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
            // avatar inisial nama siswa
            CircleAvatar(
              radius: 18,

              backgroundColor: const Color(0xFFDDE8EF),

              child: Text(
                siswa.inisial,

                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF185FA5),
                  fontFamily: 'Poppins',
                ),
              ),
            ),

            const SizedBox(width: 12),

            // Nama siswa
            Expanded(
              child: Text(
                siswa.namaSiswa,

                style: const TextStyle(fontSize: 14, fontFamily: 'Poppins'),
              ),
            ),

            // Badge status aktif/nonaktif
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),

              decoration: BoxDecoration(
                // Warna badge berdasarkan status
                color:
                    isAktif ? const Color(0xFFEAF3DE) : const Color(0xFFFCEBEB),

                borderRadius: BorderRadius.circular(20),
              ),

              child: Text(
                siswa.status,

                style: TextStyle(
                  fontSize: 11,
                  fontFamily: 'Poppins',

                  // Warna text status
                  color:
                      isAktif
                          ? const Color(0xFF3B6D11)
                          : const Color(0xFFA32D2D),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // widget untuk menampilkan state kosong ketika tidak ada data siswa yang sesuai dengan filter atau pencarian
  Widget _buildEmptyState() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 40),

      child: Center(
        child: Column(
          children: [
            // Icon empty
            Icon(Icons.search_off_rounded, size: 48, color: Colors.grey),

            SizedBox(height: 8),

            // Text empty
            Text(
              'Siswa tidak ditemukan',

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

  // widget untuk menampilkan catatan di bagian bawah halaman
  Widget _buildFooterNote() {
    return Row(
      children: const [
        // Icon info
        Icon(Icons.info_outline_rounded, size: 13, color: Colors.grey),

        SizedBox(width: 6),

        // Informasi tambahan
        Expanded(
          child: Text(
            'Hanya menampilkan siswa berdasarkan kelas yang diampu',

            style: TextStyle(
              fontSize: 11,
              color: Colors.grey,
              fontFamily: 'Poppins',
            ),
          ),
        ),
      ],
    );
  }
}
