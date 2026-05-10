import 'package:flutter/material.dart';
import 'data_siswa_model.dart';

// halaman data siswa
class DataSiswaPage extends StatefulWidget {
  const DataSiswaPage({super.key});

  @override
  State<DataSiswaPage> createState() => _DataSiswaPageState();
}

// state untuk halaman data siswa
class _DataSiswaPageState extends State<DataSiswaPage> {
  final TextEditingController _searchController =
      TextEditingController(); // Controller untuk input pencarian
  String _selectedKelas = 'Semua'; // Default kelas terpilih
  String _selectedPeriode = 'Semua'; // Default periode terpilih

  // Variabel pencarian
  String _searchQuery = '';

  // data dummy siswa
  final List<Siswa> _dummySiswa = [
    Siswa(
      id: '1',
      nama: 'Aisyah Putri',
      kelas: 'A1',
      periode: '2024/2025',
      status: 'Aktif',
    ),

    Siswa(
      id: '2',
      nama: 'Berliana Sari',
      kelas: 'A1',
      periode: '2024/2025',
      status: 'Aktif',
    ),

    Siswa(
      id: '3',
      nama: 'Cahaya Nugraha',
      kelas: 'A1',
      periode: '2024/2025',
      status: 'Aktif',
    ),

    Siswa(
      id: '4',
      nama: 'Dian Rahmawati',
      kelas: 'A1',
      periode: '2024/2025',
      status: 'Aktif',
    ),

    Siswa(
      id: '5',
      nama: 'Eka Saputra',
      kelas: 'B1',
      periode: '2024/2025',
      status: 'Nonaktif',
    ),
  ];

  // Pilihan kelas
  final List<String> _kelasList = ['Semua', 'A1', 'B1'];

  // Pilihan periode
  final List<String> _periodeList = ['Semua', '2024/2025', '2023/2024'];

  // filter data siswa berdasarkan pencarian, kelas, dan periode
  List<Siswa> get _filteredSiswa {
    return _dummySiswa.where((s) {
      // Filter berdasarkan nama
      final matchNama = s.nama.toLowerCase().contains(
        _searchQuery.toLowerCase(),
      );

      // Filter berdasarkan kelas
      final matchKelas = _selectedKelas == 'Semua' || s.kelas == _selectedKelas;

      // Filter berdasarkan periode
      final matchPeriode =
          _selectedPeriode == 'Semua' || s.periode == _selectedPeriode;

      // Data ditampilkan jika semua kondisi terpenuhi
      return matchNama && matchKelas && matchPeriode;
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();

    super.dispose();
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
              child: SingleChildScrollView(
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
            color: Colors.black.withOpacity(0.04),
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
    return Row(
      children: [
        // Dropdown kelas
        Expanded(
          child: _buildDropdown(
            value: _selectedKelas,
            items: _kelasList,

            // Update kelas terpilih
            onChanged: (val) => setState(() => _selectedKelas = val!),
          ),
        ),

        const SizedBox(width: 10),

        // Dropdown periode
        Expanded(
          child: _buildDropdown(
            value: _selectedPeriode,
            items: _periodeList,

            // Update periode terpilih
            onChanged: (val) => setState(() => _selectedPeriode = val!),
          ),
        ),
      ],
    );
  }

  // widget dropdown yang digunakan untuk filter kelas dan periode
  Widget _buildDropdown({
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),

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

          // List item dropdown
          items:
              items.map((e) {
                return DropdownMenuItem(
                  value: e,

                  child: Text(
                    e,
                    style: const TextStyle(fontSize: 13, fontFamily: 'Poppins'),
                  ),
                );
              }).toList(),

          onChanged: onChanged,

          // Icon dropdown
          icon: const Icon(
            Icons.keyboard_arrow_down_rounded,
            color: Colors.grey,
          ),

          isExpanded: true,
        ),
      ),
    );
  }

  // widget card untuk menampilkan data siswa
  Widget _buildSiswaCard(Siswa siswa) {
    // Mengecek status aktif
    final bool isAktif = siswa.status == 'Aktif';

    return Container(
      margin: const EdgeInsets.only(bottom: 10),

      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),

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
              siswa.nama,

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
                    isAktif ? const Color(0xFF3B6D11) : const Color(0xFFA32D2D),
              ),
            ),
          ),
        ],
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
