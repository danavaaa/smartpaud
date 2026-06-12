import 'package:flutter/material.dart';
import '../riwayat_perkembangan/riwayat_perkembangan_page.dart';
import '../riwayat_perkembangan/riwayat_ortu_model.dart';
import '../riwayat_perkembangan/riwayat_ortu_service.dart';
import '../profile/profile_ortu_page.dart';
import '../../../services/user_session.dart';

// Halaman dashboard orang tua
class OrangTuaDashboardPage extends StatefulWidget {
  const OrangTuaDashboardPage({super.key});

  @override
  State<OrangTuaDashboardPage> createState() => _OrangTuaDashboardPageState();
}

class _OrangTuaDashboardPageState extends State<OrangTuaDashboardPage> {
  // object service digunakan untuk mengambil data dari database
  final _service = RiwayatLaporanOrtuService();

  // Getter untuk mengambil nama orang tua dari session
  String get _namaOrangTua => UserSession().nama ?? 'Orang Tua';

  // Menyimpan daftar anak milik orang tua, awalnya list kosong
  List<AnakOrtuModel> _anakList = [];

  // Menyimpan data anak yang sedang dipilih
  AnakOrtuModel? _selectedAnak;

  // Menyimpan daftar laporan perkembangan anak
  List<LaporanOrtuModel> _laporanList = [];

  // Status loading saat mengambil data anak
  bool _isLoadingAnak = true;

  // Status loading saat mengambil data laporan
  bool _isLoadingLaporan = false;

  @override
  void initState() {
    super.initState();
    _loadAnak();
  }

  Future<void> _loadAnak() async {
    // Aktifkan loading sebelum mulai ambil data anak
    setState(() => _isLoadingAnak = true);

    try {
      // Ambil id orang tua dari session untuk digunakan sebagai parameter query data anak
      final idOrangTua = UserSession().idOrangTua;
      // jika id orang tua tidak tersedia di session
      if (idOrangTua == null) {
        // Matikan loading
        setState(() => _isLoadingAnak = false);

        // Hentikan function karena tidak bisa ambil data anak tanpa id orang tua
        return;
      }

      // Ambil daftar anak berdasarkan id_orang_tua
      final list = await _service.getAnakList(idOrangTua);
      // Dashboard hanya menampilkan anak aktif
      final anakAktifList = list.where((anak) => anak.isActive).toList();

      setState(() {
        // Simpan hanya anak aktif ke state dashboard
        _anakList = anakAktifList;

        // Loading selesai
        _isLoadingAnak = false;

        // Jika ada anak aktif, pilih anak pertama
        if (anakAktifList.isNotEmpty) {
          _selectedAnak = anakAktifList.first;

          // Setelah anak aktif dipilih, ambil laporan anak tersebut
          _loadLaporan(_selectedAnak!.id);
        } else {
          // Jika tidak ada anak aktif, kosongkan pilihan dan laporan
          _selectedAnak = null;
          _laporanList = [];
        }
      });
    } catch (e) {
      // Kalau terjadi error, matikan loading
      setState(() => _isLoadingAnak = false);
    }
  }

  Future<void> _loadLaporan(String idSiswa) async {
    // Aktifkan loading laporan
    setState(() => _isLoadingLaporan = true);

    try {
      // Ambil daftar laporan berdasarkan id siswa
      final list = await _service.getLaporan(idSiswa);

      setState(() {
        // Simpan data laporan ke state
        _laporanList = list;

        // Loading laporan selesai
        _isLoadingLaporan = false;
      });
    } catch (e) {
      // Kalau terjadi error, matikan loading
      setState(() => _isLoadingLaporan = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Warna background utama halaman
      backgroundColor: const Color(0xFFDDE8EF),

      body: SafeArea(
        child: SingleChildScrollView(
          // Padding seluruh isi halaman
          padding: const EdgeInsets.all(20),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Label kecil di atas dashboard
              const Text(
                'Dashboard Orang Tua',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                  fontFamily: 'Poppins',
                ),
              ),
              const SizedBox(height: 12),

              // Card header berisi sapaan dan dropdown pilih anak
              _buildHeaderCard(),
              const SizedBox(height: 16),

              // Card laporan perkembangan terbaru
              _buildLaporanTerbaru(),
              const SizedBox(height: 20),

              // Label menu cepat
              const Text(
                'Menu Cepat',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Poppins',
                ),
              ),
              const SizedBox(height: 12),

              // halaman riwayat perkembangan
              _buildMenuItem(
                icon: Icons.description_outlined,
                label: 'Riwayat Perkembangan',
                onTap:
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const RiwayatPerkembanganPage(),
                      ),
                    ),
              ),

              // halaman profile orang tua
              _buildMenuItem(
                icon: Icons.person_outline_rounded,
                label: 'Profile Saya',
                onTap:
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ProfileOrtuPage(),
                      ),
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // header card
  Widget _buildHeaderCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),

        // Shadow card
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Judul card
          const Text(
            'Dashboard',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              fontFamily: 'Poppins',
            ),
          ),
          const SizedBox(height: 4),

          // Sapaan orang tua
          Text(
            'Halo, $_namaOrangTua 👋',
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              fontFamily: 'Poppins',
            ),
          ),

          // Subtitle
          const Text(
            'Pantau perkembangan anak anda dengan mudah',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey,
              fontFamily: 'Poppins',
            ),
          ),
          const SizedBox(height: 12),

          // Dropdown pilih anak
          if (_isLoadingAnak)
            // Jika data anak masih dalam proses diambil dari database, tampilkan loading di tengah layar
            const Center(child: CircularProgressIndicator())
          else if (_anakList.isEmpty)
            // Jika loading selesai tetapi daftar anak kosong, tampilkan pesan informasi
            const Text(
              'Tidak ada data anak',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
                fontFamily: 'Poppins',
              ),
            )
          else
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),

              decoration: BoxDecoration(
                color: const Color(0xFFEAF1F5),
                borderRadius: BorderRadius.circular(10),
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

                  // Generate item dropdown dari list anak
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

                              // Menampilkan nama anak dan status anak
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

                  // Saat dropdown dipilih
                  onChanged: (val) {
                    if (val != null) {
                      // Update anak yang dipilih
                      setState(() => _selectedAnak = val);
                      _loadLaporan(val.id);
                    }
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }

  // daftar laporan terbaru
  Widget _buildLaporanTerbaru() {
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
          // Header laporan terbaru
          Row(
            children: [
              const Icon(
                Icons.access_time_rounded,
                size: 16,
                color: Color(0xFF185FA5),
              ),
              const SizedBox(width: 8),

              const Expanded(
                child: Text(
                  'Laporan Terbaru',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Poppins',
                    color: Color(0xFF444444),
                  ),
                ),
              ),

              // Tombol lihat semua
              GestureDetector(
                onTap:
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const RiwayatPerkembanganPage(),
                      ),
                    ),
                child: const Text(
                  'Lihat semua',
                  style: TextStyle(
                    fontSize: 11,
                    color: Color(0xFF185FA5),
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          if (_isLoadingLaporan)
            // Jika data laporan masih diambil dari database, tampilkan loading spinner di tengah
            const Center(child: CircularProgressIndicator())
          else if (_laporanList.isEmpty)
            // Jika loading selesai tetapi tidak ada laporan, tampilkan pesan bahwa laporan belum tersedia
            const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Text(
                  'Belum ada laporan',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
            )
          else
            // Jika loading selesai dan laporan ada, tampilkan maksimal 2 laporan terbaru
            ..._laporanList
                .take(2) // mengambil hanya 2 data pertama dari list
                .map(
                  (l) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),

                    child: Container(
                      padding: const EdgeInsets.all(12),

                      decoration: BoxDecoration(
                        color: const Color(0xFFEAF1F5),
                        borderRadius: BorderRadius.circular(10),
                      ),

                      child: Row(
                        children: [
                          // Isi laporan
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Tanggal laporan
                                Text(
                                  l.tanggal,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                                const SizedBox(height: 3),

                                // Preview catatan laporan
                                Text(
                                  l.preview,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(width: 8),

                          if (l.isNew)
                            // Badge status laporan
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
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
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  // Menu cepat
  Widget _buildMenuItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,

      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),

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
            // Icon menu
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: const Color(0xFFDDE8EF),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, size: 20, color: const Color(0xFF185FA5)),
            ),

            const SizedBox(width: 14),

            // Label menu
            Expanded(
              child: Text(
                label,
                style: const TextStyle(fontSize: 14, fontFamily: 'Poppins'),
              ),
            ),

            // Icon panah
            const Icon(
              Icons.chevron_right_rounded,
              color: Colors.grey,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
