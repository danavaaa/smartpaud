import 'package:flutter/material.dart';
import 'data_siswa_model.dart';
import 'data_siswa_service.dart';
import 'detail_siswa.dart';
import '../../../core/theme/app_colors.dart';

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
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            // header
            _buildHeader(context),
            Expanded(
              child:
                  _isLoading
                      ? const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primary,
                        ),
                      )
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
          InkWell(
            // Kembali ke halaman sebelumnya
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
                  'Data Siswa',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Poppins',
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Daftar siswa berdasarkan kelas yang diampu',
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

  // widget pencarian
  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 9,
            offset: const Offset(0, 3),
          ),
        ],
      ),

      // Input pencarian
      child: TextField(
        controller: _searchController,
        onChanged: (val) => setState(() => _searchQuery = val),

        style: const TextStyle(
          fontSize: 13,
          fontFamily: 'Poppins',
          color: AppColors.textPrimary,
        ),
        decoration: InputDecoration(
          // Hint pencarian
          hintText: 'Cari nama siswa',

          hintStyle: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 13,
            fontFamily: 'Poppins',
          ),

          // Icon search kiri
          prefixIcon: const Icon(
            Icons.search_rounded,
            color: AppColors.textSecondary,
            size: 22,
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
                      color: AppColors.textSecondary,
                      size: 18,
                    ),
                  )
                  : null,

          border: InputBorder.none,

          contentPadding: const EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }

  // widget filter untuk kelas dan periode
  Widget _buildFilterRow() {
    // Set digunakan untuk memastikan nama kelas yang ditampilkan pada dropdown tidak memiliki data duplikat
    final seen = <String>{};

    // Menambahkan pilihan default "Semua" pada dropdown kelas
    final kelasItems = <Map<String, dynamic>>[
      {'nama_kelas': 'Semua'},
    ];

    // Mengambil daftar nama kelas unik dari _kelasList
    for (final k in _kelasList) {
      final nama = k['nama_kelas'] as String;

      // Menambahkan kelas hanya jika belum pernah dimasukkan sebelumnya
      if (seen.add(nama)) {
        kelasItems.add({'nama_kelas': nama});
      }
    }

    // Mengurutkan daftar kelas secara alfabbet
    final kelasSorted =
        kelasItems.skip(1).toList()..sort(
          (a, b) => (a['nama_kelas'] as String).toLowerCase().compareTo(
            (b['nama_kelas'] as String).toLowerCase(),
          ),
        );

    // Menggabungkan kembali item "Semua" di posisi pertama dengan daftar kelas yang sudah diurutkan
    final kelasDropdownItems = [
      {'nama_kelas': 'Semua'},
      ...kelasSorted,
    ];

    // Set digunakan untuk menyimpan daftar periode yang unik dan menambahkan pilihan default "Semua"
    final periodeSet = <String>{'Semua'};

    // Mengambil seluruh periode dari data siswa
    for (final s in _siswaList) {
      // Menambahkan periode hanya jika nilainya valid
      if (s.periode != '-') {
        periodeSet.add(s.periode);
      }
    }

    // Mengubah Set menjadi List kemudian mengurutkannya
    final periodeItems =
        periodeSet.toList()..sort((a, b) {
          // Memastikan opsi "Semua" selalu berada di urutan pertama
          if (a == 'Semua') return -1;
          if (b == 'Semua') return 1;

          // Mengurutkan periode secara alfabetis
          return a.compareTo(b);
        });

    return Row(
      children: [
        // Dropdown kelas
        Expanded(
          child: Container(
            height: 52,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedKelasId,
                isExpanded: true,
                icon: const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: AppColors.textSecondary,
                ),
                items:
                    kelasDropdownItems.map((k) {
                      return DropdownMenuItem<String>(
                        value: k['nama_kelas'] as String,
                        child: Text(
                          k['nama_kelas'] as String,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Poppins',
                            color: AppColors.textPrimary,
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
            height: 52,
            padding: const EdgeInsets.symmetric(horizontal: 12),

            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(16),

              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),

            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedPeriode,
                isExpanded: true,
                icon: const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: AppColors.textSecondary,
                ),
                items:
                    periodeItems.map((e) {
                      return DropdownMenuItem<String>(
                        value: e,

                        child: Text(
                          e,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Poppins',
                            color: AppColors.textPrimary,
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
        margin: const EdgeInsets.only(bottom: 12),

        padding: const EdgeInsets.all(14),

        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(16),

          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 9,
              offset: const Offset(0, 3),
            ),
          ],
        ),

        child: Row(
          children: [
            // avatar inisial nama siswa
            CircleAvatar(
              radius: 22,

              backgroundColor: AppColors.softPrimary,

              child: Text(
                siswa.inisial,

                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                  fontFamily: 'Poppins',
                ),
              ),
            ),

            const SizedBox(width: 12),

            // Nama siswa
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    siswa.namaSiswa,

                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                      fontFamily: 'Poppins',
                    ),
                  ),

                  const SizedBox(height: 3),

                  Text(
                    '${siswa.namaKelas} · ${siswa.periode}',
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.textSecondary,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ],
              ),
            ),
            // Badge status aktif/nonaktif
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),

              decoration: BoxDecoration(
                // Warna badge berdasarkan status
                color: isAktif ? AppColors.successBg : AppColors.dangerBg,

                borderRadius: BorderRadius.circular(20),
              ),

              child: Text(
                siswa.status,

                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Poppins',

                  // Warna text status
                  color: isAktif ? AppColors.successText : AppColors.dangerText,
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
            Icon(
              Icons.search_off_rounded,
              size: 48,
              color: AppColors.textSecondary,
            ),
            SizedBox(height: 8),

            // Text empty
            Text(
              'Siswa tidak ditemukan',

              style: TextStyle(
                color: AppColors.textSecondary,
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.softCard,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Row(
        children: [
          // Icon info
          Icon(
            Icons.info_outline_rounded,
            size: 14,
            color: AppColors.textSecondary,
          ),
          SizedBox(width: 8),

          // Informasi tambahan
          Expanded(
            child: Text(
              'Hanya menampilkan siswa aktif berdasarkan kelas yang diampu',

              style: TextStyle(
                fontSize: 11,
                color: AppColors.textSecondary,
                fontFamily: 'Poppins',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
