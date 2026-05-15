import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'preview_laporan_page.dart';

class BuatLaporanPage extends StatefulWidget {
  const BuatLaporanPage({super.key});

  @override
  State<BuatLaporanPage> createState() => _BuatLaporanPageState();
}

// State dari halaman BuatLaporanPage
class _BuatLaporanPageState extends State<BuatLaporanPage> {
  final TextEditingController _catatanCtrl = TextEditingController();

  // Dummy data siswa
  final List<Map<String, String>> _siswaList = [
    {'id': '1', 'nama': 'Andi', 'kelas': 'Kelas A1'},
    {'id': '2', 'nama': 'Budi', 'kelas': 'Kelas A1'},
    {'id': '3', 'nama': 'Citra', 'kelas': 'Kelas A1'},
    {'id': '4', 'nama': 'Dina', 'kelas': 'Kelas A1'},
  ];

  Map<String, String>? _selectedSiswa;
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

  // Validasi lalu navigasi ke preview
  Future<void> _generateAi() async {
    if (_selectedSiswa == null) {
      _snackbar('Pilih siswa terlebih dahulu');
      return;
    }
    if (_tanggalLaporan == null) {
      _snackbar('Pilih tanggal laporan');
      return;
    }
    if (_catatanCtrl.text.trim().isEmpty) {
      _snackbar('Isi catatan literasi membaca terlebih dahulu');
      return;
    }

    setState(() => _isLoading = true);

    // Simulasi delay AI
    await Future.delayed(const Duration(seconds: 2));

    // Hasil simulasi AI
    final namaSiswa = _selectedSiswa!['nama']!;
    final ringkasan =
        'Berdasarkan catatan guru, $namaSiswa menunjukkan '
        'perkembangan literasi membaca yang positif. '
        '${_catatanCtrl.text.trim()}';

    const rekomendasi =
        '1. Bacakan buku cerita bergambar setiap hari minimal 15 menit.\n'
        '2. Ajak anak menunjuk dan menyebut huruf di lingkungan sekitar.\n'
        '3. Gunakan kartu huruf untuk mengenalkan bunyi huruf.\n'
        '4. Beri pujian ketika anak berhasil mengenali kata baru.\n'
        '5. Libatkan anak dalam kegiatan menulis sederhana.';

    if (!mounted) return;
    setState(() => _isLoading = false);
    // Navigasi ke halaman preview dengan membawa data yang diperlukan
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (_) => PreviewLaporanPage(
              idSiswa: _selectedSiswa!['id']!,
              namaSiswa: _selectedSiswa!['nama']!,
              namaKelas: _selectedSiswa!['kelas']!,
              tanggalLaporan: DateFormat('yyyy-MM-dd').format(_tanggalLaporan!),
              tanggalDisplay: DateFormat(
                'dd MMMM yyyy',
                'id_ID',
              ).format(_tanggalLaporan!),
              catatanLiterasi: _catatanCtrl.text.trim(),
              ringkasanAi: ringkasan,
              rekomendasiAi: rekomendasi,
              imageFile: _selectedImage,
            ),
      ),
    );
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

  // pilih siswa dengan dropdown
  Widget _buildPilihSiswaCard() {
    return Container(
      // Lebar full
      width: double.infinity,
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        // Warna card
        color: Colors.white,

        // Radius sudut card
        borderRadius: BorderRadius.circular(18),

        // Shadow card
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
          // Nama kelas
          const Text(
            'Kelas A1',

            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              fontFamily: 'Poppins',
            ),
          ),

          const SizedBox(height: 16),

          // Container dropdown
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),

            decoration: BoxDecoration(
              color: const Color(0xFFF1F1EB),
              borderRadius: BorderRadius.circular(14),
            ),

            child: DropdownButtonHideUnderline(
              // Menghilangkan underline bawaan dropdown
              child: DropdownButton<Map<String, String>>(
                // Value siswa yang dipilih
                value: _selectedSiswa,

                // Hint ketika belum memilih
                hint: const Text(
                  'Pilih Siswa',

                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                    fontFamily: 'Poppins',
                  ),
                ),

                // Dropdown memenuhi lebar container
                isExpanded: true,

                icon: const Icon(Icons.keyboard_arrow_down_rounded),

                // Generate item dropdown dari list siswa
                items:
                    _siswaList.map((siswa) {
                      return DropdownMenuItem<Map<String, String>>(
                        value: siswa,

                        child: Text(
                          siswa['nama']!,
                          style: const TextStyle(fontFamily: 'Poppins'),
                        ),
                      );
                    }).toList(),
                onChanged: (val) => setState(() => _selectedSiswa = val),
              ),
            ),
          ),
        ],
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
        padding: const EdgeInsets.all(20),

        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),

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
              color: Colors.black.withOpacity(0.04),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              children: const [
                Icon(Icons.camera_alt_outlined, color: Color(0xFF185FA5)),
                SizedBox(width: 12),

                // Text placeholder upload foto
                Text(
                  'Unggah Foto Kegiatan',
                  style: TextStyle(fontFamily: 'Poppins'),
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
            color: Colors.black.withOpacity(0.04),
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
