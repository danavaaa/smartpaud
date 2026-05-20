import 'package:flutter/material.dart';
import '../riwayat_perkembangan/riwayat_perkembangan_page.dart';

// Halaman dashboard orang tua
class OrangTuaDashboardPage extends StatefulWidget {
  const OrangTuaDashboardPage({super.key});

  @override
  State<OrangTuaDashboardPage> createState() => _OrangTuaDashboardPageState();
}

class _OrangTuaDashboardPageState extends State<OrangTuaDashboardPage> {
  // Dummy nama orang tua
  final String _namaOrangTua = 'Bapak ...';

  // Dummy list anak
  final List<Map<String, String>> _anakList = [
    {'id': '1', 'nama': 'Richa', 'status': 'Aktif'},
    {'id': '2', 'nama': 'Richie', 'status': 'Tidak Aktif'},
  ];

  // Menyimpan anak yang sedang dipilih di dropdown
  Map<String, String>? _selectedAnak;

  // Dummy laporan perkembangan terbaru
  final List<Map<String, String>> _laporanList = [
    {
      'tanggal': '16 Mei 2026',
      'catatan': 'Anak lancar membaca halaman 10 tanpa bantuan guru.',
    },
    {
      'tanggal': '14 Mei 2026',
      'catatan': 'Anak mulai mengenal huruf vokal dengan baik.',
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
                onTap: () {},
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
            color: Colors.black.withOpacity(0.05),
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
            'Halo, $_namaOrangTua',
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
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),

            decoration: BoxDecoration(
              color: const Color(0xFFEAF1F5),
              borderRadius: BorderRadius.circular(10),
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

                // Generate item dropdown dari list anak
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

                            // Menampilkan nama anak dan status anak
                            Text(
                              '${anak['nama']} (${anak['status']})',
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
            color: Colors.black.withOpacity(0.04),
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
                onTap: () {},
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

          // Generate list laporan dari _laporanList
          ..._laporanList.map((l) {
            // Ambil catatan laporan
            final catatan = l['catatan']!;

            // Potong teks jika terlalu panjang
            final preview =
                catatan.length > 45
                    ? '${catatan.substring(0, 45)}...'
                    : catatan;

            return Padding(
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
                            l['tanggal']!,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Poppins',
                            ),
                          ),
                          const SizedBox(height: 3),

                          // Preview catatan laporan
                          Text(
                            preview,
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
            );
          }),
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
              color: Colors.black.withOpacity(0.04),
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
