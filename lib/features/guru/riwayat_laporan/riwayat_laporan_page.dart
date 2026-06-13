import 'package:flutter/material.dart';
import '../riwayat_laporan/riwayat_laporan_model.dart';
import 'detail_laporan_page.dart';
import 'riwayat_laporan_service.dart';
import '../../../core/theme/app_colors.dart';

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
      backgroundColor: AppColors.background,

      body: SafeArea(
        child: Column(
          children: [
            // Header halaman
            _buildHeader(context),

            Expanded(
              child:
                  _isLoading // Tampilkan loading indicator saat data sedang dimuat
                      ? const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primary,
                        ),
                      )
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

  // Fungsi untuk membuat dekorasi card yang dapat digunakan di beberapa widget dengan tampilan yang konsisten
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

  // header halaman dengan tombol kembali dan judul
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
                  'Riwayat Laporan',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Poppins',
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Daftar laporan perkembangan siswa',
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

  // search bar untuk mencari laporan berdasarkan nama siswa
  Widget _buildSearchBar() {
    return Container(
      decoration: _cardDecoration(),
      child: TextField(
        // Controller input
        controller: _searchController,
        // saat input berubah, update search query
        onChanged: (val) => setState(() => _searchQuery = val),
        style: const TextStyle(
          fontSize: 13,
          fontFamily: 'Poppins',
          color: AppColors.textPrimary,
        ),
        decoration: InputDecoration(
          // Placeholder
          hintText: 'Cari laporan siswa...',
          hintStyle: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 13,
            fontFamily: 'Poppins',
          ),

          // Icon search
          prefixIcon: const Icon(
            Icons.search_rounded,
            color: AppColors.textSecondary,
            size: 22,
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

  // filter row dengan dropdown untuk memilih kelas dan periode laporan
  Widget _buildFilterRow() {
    // Mengurutkan daftar kelas yang akan ditampilkan pada dropdown
    final kelasItems =
        _kelasItems.toList()..sort((a, b) {
          if (a == 'Semua') return -1;
          if (b == 'Semua') return 1;

          // Mengurutkan nama kelas secara alfabet
          return a.toLowerCase().compareTo(b.toLowerCase());
        });

    // Mengurutkan daftar periode ajaran berdasarkan kombinasi tahun ajaran dan semester
    final periodeItems =
        _periodeListData.toList()..sort((a, b) {
          final textA = '${a['tahun_ajaran']} ${a['semester']}';
          final textB = '${b['tahun_ajaran']} ${b['semester']}';

          // Mengurutkan periode secara berurutan
          return textA.compareTo(textB);
        });

    return Row(
      children: [
        // dropdown kelas
        Expanded(
          child: _buildDropdown(
            value: _selectedKelas,
            items: kelasItems,
            onChanged: (val) => setState(() => _selectedKelas = val!),
          ),
        ),

        const SizedBox(width: 10),

        // dropdown periode
        Expanded(
          child: Container(
            height: 52,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: _cardDecoration(),
            child: DropdownButtonHideUnderline(
              // Menghilangkan garis bawah default dropdown
              child: DropdownButton<String?>(
                value: _selectedPeriodeId,
                isExpanded: true,
                // Icon panah dropdown
                icon: const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: AppColors.textSecondary,
                ),
                // List item dropdown
                items: [
                  // Opsi default untuk menampilkan semua data
                  const DropdownMenuItem<String?>(
                    value: null,
                    child: Text(
                      'Semua',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Poppins',
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  // Generate item dropdown dari data periode
                  ...periodeItems.map((p) {
                    return DropdownMenuItem<String?>(
                      // Value yang disimpan saat item dipilih
                      value: p['id'] as String,

                      // Text yang ditampilkan di dropdown
                      child: Text(
                        '${p['tahun_ajaran']} – ${p['semester']}',
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Poppins',
                          color: AppColors.textPrimary,
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
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: _cardDecoration(),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          icon: const Icon(
            Icons.keyboard_arrow_down_rounded,
            color: AppColors.textSecondary,
          ),
          // Generate item dropdown
          items:
              items.map((e) {
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
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: _cardDecoration(),
        child: Row(
          children: [
            // Avatar inisial siswa
            CircleAvatar(
              radius: 22,
              backgroundColor: AppColors.softPrimary,
              child: Text(
                laporan.inisial,
                style: const TextStyle(
                  fontSize: 12,
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
                    laporan.namaSiswa,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Poppins',
                      color: AppColors.textPrimary,
                    ),
                  ),

                  const SizedBox(height: 3),

                  // Kelas dan tanggal
                  Text(
                    '${laporan.namaKelas} · ${laporan.tanggal}',
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.textSecondary,
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
                color: AppColors.successBg,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'Selesai',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Poppins',
                  color: AppColors.successText,
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
            Icon(
              Icons.article_outlined,
              size: 48,
              color: AppColors.textSecondary,
            ),
            SizedBox(height: 8),
            // Text empty
            Text(
              'Belum ada laporan',
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
}
