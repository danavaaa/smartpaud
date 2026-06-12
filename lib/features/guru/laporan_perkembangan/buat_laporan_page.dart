import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'preview_laporan_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../services/user_session.dart';

class BuatLaporanPage extends StatefulWidget {
  const BuatLaporanPage({super.key});

  @override
  State<BuatLaporanPage> createState() => _BuatLaporanPageState();
}

// State dari halaman BuatLaporanPage
class _BuatLaporanPageState extends State<BuatLaporanPage> {
  final TextEditingController _catatanCtrl = TextEditingController();

  // menyimpan daftar siswa yang berhasil diambil dari database untuk dropdown
  List<Map<String, dynamic>> _siswaList = [];
  // menyimpan daftar kelas yang diampu guru untuk digunakan pada dropdown
  List<Map<String, dynamic>> _kelasList = [];
  String? _selectedKelasId;
  Map<String, dynamic>? _selectedSiswa;
  bool _isLoadingSiswa = true;

  // filter data siswa berdasarkan kelas yang dipilih
  List<Map<String, dynamic>> get _filteredSiswaList {
    // jika belum ada kelas yg dipilih, maka tampilkan seluruh data siswa
    if (_selectedKelasId == null || _selectedKelasId == 'Semua') {
      return _siswaList;
    }
    // Menyaring data siswa berdasarkan id_kelas yang sesuai dengan kelas yang dipilih
    return _siswaList.where((siswa) {
      // Hanya siswa yang memiliki id_kelas sama dengan kelas yang dipilih yang akan ditampilkan
      return siswa['id_kelas'] == _selectedKelasId;
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    _loadSiswa();
  }

  // Fungsi untuk memuat data siswa berdasarkan kelas yang diampu guru
  Future<void> _loadSiswa() async {
    try {
      // ambil id guru yang sedang login dari session
      final idGuru = UserSession().idUser ?? '';
      // jika id guru tidak ditemukan, maka kosongkan daftar siswa
      if (idGuru.isEmpty) {
        setState(() {
          _siswaList = [];
          _kelasList = [];
          _isLoadingSiswa = false;
        });
        return;
      }

      // Ambil kelas aktif yang diampu guru
      final penugasanResponse = await Supabase.instance.client
          .from('penugasan_guru')
          .select('''
          id_kelas,
          is_active,

          kelas (
            id,
            nama_kelas,
            is_active,

            periode_ajaran (
              id,
              is_active
            )
          )
        ''')
          // filter berdasarkan guru yang login
          .eq('id_guru', idGuru)
          // hanya mengambil penugasan aktif
          .eq('is_active', true);

      final penugasanList = List<Map<String, dynamic>>.from(penugasanResponse);

      // filter kelas aktif dan periode aktif
      final kelasAktif =
          penugasanList.where((item) {
            // mengambil data relasi kelas
            final kelas = item['kelas'] as Map<String, dynamic>?;
            // mengambil dta relasi periode ajaran
            final periode = kelas?['periode_ajaran'] as Map<String, dynamic>?;
            // periksa status aktif kelas
            final kelasAktif = kelas?['is_active'] == true;
            // periksa status aktif periode ajaran
            final periodeAktif = periode?['is_active'] == true;

            return kelasAktif && periodeAktif;
          }).toList();

      // ambil seluruh id_kelas dari hasil filter
      final kelasAktifIds =
          kelasAktif.map((item) => item['id_kelas'] as String).toSet().toList();

      // Jika guru tidak memiliki kelas aktif, kosongkan data dan hentikan proses.
      if (kelasAktifIds.isEmpty) {
        setState(() {
          _siswaList = [];
          _kelasList = [];
          _isLoadingSiswa = false;
        });
        return;
      }

      // ambil id dan nama kelas yang akan digunakan sebagai item pada dropdown pemilihan kelas.
      final kelasDropdownList =
          kelasAktif.map((item) {
            final kelas = item['kelas'] as Map<String, dynamic>;

            return {'id': kelas['id'], 'nama_kelas': kelas['nama_kelas']};
          }).toList();

      // Mengambil seluruh siswa aktif yang berada pada kelas aktif yang diampu guru.
      final siswaResponse = await Supabase.instance.client
          .from('siswa')
          .select('id, nama_siswa, id_kelas, kelas(nama_kelas)')
          // hanya siswa aktif
          .eq('is_active', true)
          // hanya siswa yang berada pada kelas aktif
          .inFilter('id_kelas', kelasAktifIds)
          // urutkan berdasarkan nama siswa
          .order('nama_siswa');
      // simpan data ke state
      setState(() {
        _kelasList = List<Map<String, dynamic>>.from(kelasDropdownList);
        _siswaList = List<Map<String, dynamic>>.from(siswaResponse);
        _isLoadingSiswa = false;
      });
    } catch (e) {
      setState(() => _isLoadingSiswa = false);
    }
  }

  DateTime? _tanggalLaporan;
  // Menyimpan file gambar yang dipilih
  File? _selectedImage;
  bool _isLoading = false;

  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    _catatanCtrl.dispose();
    super.dispose();
  }

  // Pilih foto dari galeri
  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() => _selectedImage = File(image.path));
    }
  }

  // Buka date picker
  Future<void> _pilihTanggal() async {
    // Menampilkan dialog kalender
    final picked = await showDatePicker(
      context: context,

      // Tanggal awal saat kalender dibuka
      initialDate: DateTime.now(),

      // Batas tanggal minimum
      firstDate: DateTime(2020),

      // Batas tanggal maksimum
      lastDate: DateTime.now(),

      // Menggunakan format lokal Indonesia
      locale: const Locale('id', 'ID'),
    );

    // Jika user memilih tanggal
    if (picked != null) {
      // Update state agar UI berubah
      setState(() => _tanggalLaporan = picked);
    }
  }

  // Fungsi untuk menghasilkan ringkasan dan rekomendasi AI berdasarkan catatan literasi
  Future<void> _generateAi() async {
    // Validasi (pastikan siswa sudah dipilih)
    if (_selectedSiswa == null) {
      _snackbar('Pilih siswa terlebih dahulu');
      return;
    }
    // validasi (pastikan tanggal sudah dipilih)
    if (_tanggalLaporan == null) {
      _snackbar('Pilih tanggal laporan');
      return;
    }
    // validasi (pastikan catatan literasi tidak kosong)
    if (_catatanCtrl.text.trim().isEmpty) {
      _snackbar('Isi catatan literasi membaca terlebih dahulu');
      return;
    }
    // tampilkan loading saat proses AI berjalan
    setState(() => _isLoading = true);

    // Ambil data siswa yang dipilih
    final namaSiswa = _selectedSiswa!['nama_siswa'] as String;
    final idSiswa = _selectedSiswa!['id'] as String;
    // ambil data kelas siswa
    final kelas = _selectedSiswa!['kelas'] as Map<String, dynamic>? ?? {};
    final namaKelas = kelas['nama_kelas'] as String? ?? '-';
    // ambil catatan literasi dari input user
    final catatan = _catatanCtrl.text.trim();

    try {
      const workerUrl = 'https://smartpaud-ai.danavaa-vaa.workers.dev';

      // kirim request POST ke AI
      final response = await http.post(
        Uri.parse(workerUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'catatan': catatan, 'nama_siswa': namaSiswa}),
      );
      // untuk melihat respon dari user
      debugPrint('STATUS: ${response.statusCode}');
      debugPrint('BODY: ${response.body}');
      // jika request berhasil
      if (response.statusCode == 200) {
        // ubah response JSON menjadi obejct dart
        final data = jsonDecode(response.body);
        // ambil hasil teks AI
        final text = data['result'] as String;

        String ringkasan = '';
        String rekomendasi = '';
        // pisahkan hasil AI menjadi bagian ringkasan dan rekomendasi
        if (text.contains('RINGKASAN:') && text.contains('REKOMENDASI:')) {
          final parts = text.split('REKOMENDASI:');
          // ambil isi ringkasan
          ringkasan = parts[0].replaceAll('RINGKASAN:', '').trim();
          // ambil isi rekomendasi
          rekomendasi = 'REKOMENDASI:\n${parts[1].trim()}';
        } else {
          // jika format AI tidak sesuai, simpan semua teks sebagai ringkasan
          ringkasan = text;
          rekomendasi = '';
        }

        if (!mounted) return;
        setState(() => _isLoading = false);
        // pindah ke halaman preview laporan
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (_) => PreviewLaporanPage(
                  idSiswa: idSiswa,
                  namaSiswa: namaSiswa,
                  namaKelas: namaKelas,
                  tanggalLaporan: DateFormat(
                    'yyyy-MM-dd',
                  ).format(_tanggalLaporan!),
                  tanggalDisplay: DateFormat(
                    'dd MMMM yyyy',
                    'id_ID',
                  ).format(_tanggalLaporan!),
                  catatanLiterasi: catatan,
                  ringkasanAi: ringkasan,
                  rekomendasiAi: rekomendasi,
                  imageFile: _selectedImage,
                ),
          ),
        );
      } else {
        final errorBody = jsonDecode(response.body);
        throw Exception('Error ${response.statusCode}: ${errorBody['error']}');
      }
    } catch (e) {
      // jika terjadi error saat request API
      if (!mounted) return;
      // matikan loading
      setState(() => _isLoading = false);
      // tampilkan pesan error
      _snackbar('Gagal generate AI: $e');
    }
  }

  // Menampilkan snackbar untuk pesan error atau informasi
  void _snackbar(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFDDE8EF),

      body: SafeArea(
        child: Column(
          children: [
            // Header halaman
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),

                child: Column(
                  children: [
                    // Card pilih kelas
                    _buildPilihKelasCard(),
                    const SizedBox(height: 12),

                    // Card pilih siswa
                    _buildPilihSiswaCard(),
                    const SizedBox(height: 12),

                    // Card pilih tanggal
                    _buildTanggalCard(),
                    const SizedBox(height: 12),

                    // Card upload foto
                    _buildFotoCard(),
                    const SizedBox(height: 12),

                    // Card catatan
                    _buildCatatanCard(),
                    const SizedBox(height: 20),

                    // Tombol aksi
                    _buildButtonRow(),
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
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),

      child: Row(
        children: [
          // Tombol kembali
          GestureDetector(
            onTap: () => Navigator.pop(context),

            child: const Icon(Icons.chevron_left_rounded, size: 30),
          ),

          const SizedBox(width: 8),

          // Judul halaman
          const Expanded(
            child: Text(
              'Buat Laporan Perkembangan',

              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                fontFamily: 'Poppins',
              ),
            ),
          ),
        ],
      ),
    );
  }

  // widget dropdown pilih kelas
  Widget _buildPilihKelasCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child:
          // indikator loading saat data kelas masih dimuat
          _isLoadingSiswa
              ? const Center(child: CircularProgressIndicator())
              // Menampilkan dropdown ketika data selesai dimuat
              : DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedKelasId,
                  // Placeholder ketika belum ada kelas dipilih
                  hint: const Text(
                    'Pilih Kelas',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  isExpanded: true,
                  icon: const Icon(Icons.keyboard_arrow_down_rounded),
                  // daftar item dropdown
                  items: [
                    // Opsi untuk menampilkan seluruh kelas
                    const DropdownMenuItem<String>(
                      value: 'Semua',
                      child: Text(
                        'Semua Kelas',
                        style: TextStyle(fontSize: 16, fontFamily: 'Poppins'),
                      ),
                    ),
                    // menambahkan daftar kelas yang diperoleh dari database
                    ..._kelasList.map((kelas) {
                      return DropdownMenuItem<String>(
                        value: kelas['id'] as String,
                        child: Text(
                          kelas['nama_kelas'] as String,
                          style: const TextStyle(
                            fontSize: 16,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      );
                    }),
                  ],
                  onChanged: (val) {
                    setState(() {
                      _selectedKelasId = val;
                      _selectedSiswa = null;
                    });
                  },
                ),
              ),
    );
  }

  // pilih siswa dengan dropdown
  Widget _buildPilihSiswaCard() {
    return Container(
      // Lebar full
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),

      decoration: BoxDecoration(
        // Warna card
        color: Colors.white,

        // Radius sudut card
        borderRadius: BorderRadius.circular(18),

        // Shadow card
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),

      child:
          _isLoadingSiswa
              ? const Center(child: CircularProgressIndicator())
              : DropdownButtonHideUnderline(
                child: DropdownButton<Map<String, dynamic>>(
                  value: _selectedSiswa,
                  hint: Text(
                    _filteredSiswaList.isEmpty
                        ? 'Tidak ada siswa aktif'
                        : 'Pilih Siswa',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                      fontFamily: 'Poppins',
                    ),
                  ),

                  isExpanded: true,

                  icon: const Icon(Icons.keyboard_arrow_down_rounded),

                  items:
                      _filteredSiswaList.map((siswa) {
                        return DropdownMenuItem<Map<String, dynamic>>(
                          value: siswa,

                          child: Text(
                            siswa['nama_siswa'] as String,
                            style: const TextStyle(
                              fontSize: 16,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        );
                      }).toList(),
                  onChanged: (val) => setState(() => _selectedSiswa = val),
                ),
              ),
    );
  }

  // tanggal dengan card yang bisa diklik untuk membuka date picker
  Widget _buildTanggalCard() {
    // GestureDetector agar card bisa diklik
    return GestureDetector(
      // Ketika card ditekan
      onTap: _pilihTanggal,

      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),

        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),

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
            // Icon kalender
            const Icon(Icons.calendar_today_outlined, color: Color(0xFF185FA5)),

            const SizedBox(width: 14),

            // Menampilkan tanggal
            Text(
              // Jika belum memilih tanggal
              _tanggalLaporan == null
                  ? 'Tanggal Laporan'
                  // Jika sudah memilih tanggal
                  : DateFormat(
                    'dd MMMM yyyy',
                    'id_ID',
                  ).format(_tanggalLaporan!),

              style: TextStyle(
                fontSize: 16,

                // Warna abu jika belum memilih
                color: _tanggalLaporan == null ? Colors.grey : Colors.black,

                fontFamily: 'Poppins',
              ),
            ),
          ],
        ),
      ),
    );
  }

  // card untuk upload foto kegiatan literasi membaca anak
  Widget _buildFotoCard() {
    // Card upload foto dengan GestureDetector agar bisa diklik untuk memilih gambar
    return GestureDetector(
      onTap: _pickImage,
      child: Container(
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
          children: [
            Row(
              children: [
                const Icon(Icons.camera_alt_outlined, color: Color(0xFF185FA5)),
                const SizedBox(width: 12),

                // Text placeholder upload foto
                Text(
                  _selectedImage == null
                      ? 'Unggah Foto Kegiatan'
                      : 'Foto berhasil dipilih',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 16,
                    color: _selectedImage == null ? Colors.grey : Colors.black,
                  ),
                ),
              ],
            ),

            if (_selectedImage != null) ...[
              const SizedBox(height: 12),
              // Menampilkan gambar yang sudah dipilih
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(
                  _selectedImage!,
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // catatan dengan textfield untuk input catatan perkembangan literasi membaca anak
  Widget _buildCatatanCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),

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
          // Judul catatan
          const Text(
            'Catatan Literasi Membaca',

            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              fontFamily: 'Poppins',
            ),
          ),

          const SizedBox(height: 14),

          // Input catatan
          TextField(
            // Controller textfield
            controller: _catatanCtrl,

            // Jumlah baris maksimal
            maxLines: 5,

            decoration: InputDecoration(
              // Placeholder
              hintText: 'catatan perkembangan literasi membaca anak',

              hintStyle: const TextStyle(
                color: Colors.grey,
                fontFamily: 'Poppins',
              ),

              // Border default
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
              ),

              // Border saat normal
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),

              // Border saat focus
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: Color(0xFF185FA5)),
              ),

              // Padding isi textfield
              contentPadding: const EdgeInsets.all(16),
            ),
          ),
        ],
      ),
    );
  }

  // button batal dan generate ai
  Widget _buildButtonRow() {
    return Row(
      children: [
        // Tombol batal
        Expanded(
          child: SizedBox(
            height: 52,

            child: OutlinedButton(
              // Aksi ketika tombol batal ditekan
              onPressed: () => Navigator.pop(context),
              style: OutlinedButton.styleFrom(
                backgroundColor: const Color(0xFFF1F1EB),

                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),

                side: BorderSide.none,
              ),

              child: const Text(
                'Batal',

                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black87,
                  fontFamily: 'Poppins',
                ),
              ),
            ),
          ),
        ),

        const SizedBox(width: 14),

        // Tombol Generate AI
        Expanded(
          child: SizedBox(
            height: 52,

            child: ElevatedButton(
              // Aksi ketika tombol generate ai ditekan
              onPressed: _isLoading ? null : _generateAi,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF185FA5),

                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),

              child:
                  _isLoading
                      ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2.5,
                        ),
                      )
                      : const Text(
                        'Generate AI',

                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
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
