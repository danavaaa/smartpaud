import 'package:flutter/material.dart';
import 'siswa_service.dart';

// Halaman form untuk menambah atau mengedit data siswa
class SiswaFormPage extends StatefulWidget {
  final String? id;
  final String? nama;
  final String? kelas;
  final String? idKelas;
  final String? idOrangTua;
  final bool? isActive;

  const SiswaFormPage({
    super.key,
    this.id,
    this.nama,
    this.kelas,
    this.idKelas,
    this.idOrangTua,
    this.isActive,
  });

  @override
  State<SiswaFormPage> createState() => _SiswaFormPageState();
}

// State dari halaman form siswa
class _SiswaFormPageState extends State<SiswaFormPage> {
  // Controller untuk input nama siswa
  final _namaController = TextEditingController();
  final _service = SiswaService();

  // Menyimpan kelas yang dipilih
  String? selectedKelasId;
  // Menyimpan ID orang tua yang dipilih dari dropdown
  String? selectedOrangTuaId;
  // List data kelas untuk dropdown
  List<Map<String, dynamic>> kelasList = [];
  // list data orang tua untuk dropdown
  List<Map<String, dynamic>> orangTuaList = [];

  // Menyimpan status siswa
  bool isActive = true;

  bool isLoading = false;

  // menyimpan status loading dropdown (digunakan saat data kelas dan ortu masih diambil dari database)
  bool _isLoadingDropdown = true;

  // Mengecek apakah halaman sedang dalam mode edit
  bool get isEdit => widget.id != null;

  @override
  void initState() {
    super.initState();

    _namaController.text = widget.nama ?? '';
    selectedKelasId = widget.idKelas;
    selectedOrangTuaId = widget.idOrangTua;
    isActive = widget.isActive ?? true;

    fetchDropdownData();
  }

  // Fungsi untuk mengambil daftar kelas dan orang tua
  Future<void> fetchDropdownData() async {
    try {
      // Ambil semua data kelas dari service
      final kelasResult = await _service.getAllKelas();

      // Ambil semua data orang tua dari service
      final orangTuaResult = await _service.getAllOrangTua();

      if (!mounted) return;

      // Update state setelah data berhasil didapat
      setState(() {
        kelasList = kelasResult; // isi list dropdown kelas
        orangTuaList = orangTuaResult; // isi list dropdown orang tua

        // Matikan loading dropdown karena data sudah siap
        _isLoadingDropdown = false;
      });
    } catch (e) {
      // Cek lagi apakah widget masih aktif
      if (!mounted) return;

      // Jika error, matikan loading
      setState(() => _isLoadingDropdown = false);

      // Tampilkan pesan error ke user
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal mengambil data: $e')));
    }
  }

  // Fungsi untuk menyimpan data siswa (baik tambah maupun edit)
  Future<void> saveData() async {
    // Validasi: nama siswa dan kelas wajib diisi
    if (_namaController.text.trim().isEmpty || selectedKelasId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nama siswa dan kelas wajib diisi')),
      );
      return;
    }

    try {
      // Mengaktifkan loading agar UI menandakan proses sedang berjalan
      setState(() => isLoading = true);

      // Jika mode edit, update data siswa yang sudah ada
      if (isEdit) {
        await _service.updateSiswa(
          id: widget.id!,
          namaSiswa: _namaController.text.trim(),
          idKelas: selectedKelasId!,
          isActive: isActive,
          idOrangTua: selectedOrangTuaId,
        );
      } else {
        // Jika bukan mode edit, tambahkan data siswa baru
        await _service.addSiswa(
          namaSiswa: _namaController.text.trim(),
          idKelas: selectedKelasId!,
          isActive: isActive,
          idOrangTua: selectedOrangTuaId,
        );
      }

      // Jika proses berhasil, kembali ke halaman sebelumnya
      if (!mounted) return;
      Navigator.pop(context, true);
    } catch (e) {
      // Jika terjadi error saat menyimpan data, tampilkan pesan gagal ke user
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal menyimpan data: $e')));
    } finally {
      // Setelah proses selesai, matikan loading
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  void dispose() {
    _namaController.dispose();
    super.dispose();
  }

  // Fungsi untuk membuat dekorasi input yang seragam
  InputDecoration customInputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(
        fontSize: 12,
        color: Color(0xFFB8B1B1),
        fontFamily: 'Poppins',
      ),
      filled: true,
      fillColor: const Color(0xFFF7F4F4),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(3),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(3),
        borderSide: BorderSide.none,
      ),
    );
  }

  // Fungsi untuk membuat label di atas field input
  Widget buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            fontFamily: 'Poppins',
          ),
        ),
      ),
    );
  }

  // Fungsi untuk membuat tombol aksi simpan dan batal
  Widget buildActionButton({
    required String title,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: 95,
      height: 32,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFD9D4D4),
          foregroundColor: Colors.black,
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Text(
          title,
          style: const TextStyle(fontSize: 12, fontFamily: 'Poppins'),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Judul halaman berubah sesuai mode form
    final title = isEdit ? 'Edit Siswa' : 'Tambah Siswa';

    return Scaffold(
      // Warna latar belakang halaman
      backgroundColor: const Color(0xFFDCE5E8),

      // AppBar di bagian atas halaman
      appBar: AppBar(
        backgroundColor: const Color(0xFFDCE5E8),
        elevation: 0,
        scrolledUnderElevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),

        // Menampilkan judul halaman sesuai mode
        title: Text(title, style: const TextStyle(color: Colors.black)),
      ),

      // Isi halaman
      body: SingleChildScrollView(
        // Memberi jarak isi dari tepi layar
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
        child: Column(
          children: [
            // Container utama form input
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(14, 16, 14, 18),
              decoration: BoxDecoration(
                color: const Color(0xFFEAF0F1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Column(
                children: [
                  // Input nama siswa
                  buildLabel('Nama Siswa'),
                  TextField(
                    controller: _namaController,
                    decoration: customInputDecoration('Contoh: Budi Santoso'),
                  ),
                  const SizedBox(height: 12),

                  // Dropdown untuk memilih kelas siswa
                  buildLabel('Kelas'),
                  _isLoadingDropdown
                      ? const SizedBox()
                      : DropdownButtonFormField<String>(
                        value: selectedKelasId,
                        decoration: customInputDecoration('Pilih Kelas'),
                        items:
                            kelasList.map((kelas) {
                              return DropdownMenuItem<String>(
                                value: kelas['id'],
                                child: Text(kelas['nama_kelas']),
                              );
                            }).toList(),
                        onChanged:
                            (value) => setState(() => selectedKelasId = value),
                      ),
                  const SizedBox(height: 12),

                  // Dropdown untuk memilih orang tua
                  buildLabel('Orang Tua'),

                  _isLoadingDropdown
                      // Jika data dropdown masih loading,tampilkan spinner loading di tengah
                      ? const Center(child: CircularProgressIndicator())
                      // Jika data sudah selesai diambil,tampilkan dropdown orang tua
                      : DropdownButtonFormField<String>(
                        value: selectedOrangTuaId,
                        decoration: customInputDecoration('Pilih Orang Tua'),

                        // tampilan input dropdown
                        items: [
                          // Opsi jika siswa tidak memiliki orang tua yang dipilih
                          const DropdownMenuItem<String>(
                            value: null,
                            child: Text('-- Tidak Ada --'),
                          ),

                          // Tambahkan semua data orang tua dari list
                          ...orangTuaList.map((ot) {
                            return DropdownMenuItem<String>(
                              value: ot['id_orang_tua'] as String?,

                              // ID orang tua yang akan disimpan saat dipilih
                              child: Text(ot['nama'] ?? '-'),
                              // Nama orang tua yang ditampilkan di dropdown
                            );
                          }),
                        ],

                        // Saat user memilih item dropdown,simpan ID orang tua yang dipilih ke state
                        onChanged:
                            (value) =>
                                setState(() => selectedOrangTuaId = value),
                      ),
                  const SizedBox(height: 12),

                  // Pilihan status siswa
                  buildLabel('Status Siswa'),
                  Row(
                    children: [
                      Expanded(
                        child: RadioListTile<bool>(
                          contentPadding: EdgeInsets.zero,
                          value: true,
                          groupValue: isActive,
                          onChanged: (value) {
                            if (value != null) setState(() => isActive = value);
                          },
                          title: const Text(
                            'Aktif',
                            style: TextStyle(
                              fontSize: 12,
                              fontFamily: 'Poppins',
                            ),
                          ),
                          dense: true,
                        ),
                      ),
                      Expanded(
                        child: RadioListTile<bool>(
                          contentPadding: EdgeInsets.zero,
                          value: false,
                          groupValue: isActive,
                          onChanged: (value) {
                            if (value != null) setState(() => isActive = value);
                          },
                          title: const Text(
                            'Tidak Aktif',
                            style: TextStyle(
                              fontSize: 12,
                              fontFamily: 'Poppins',
                            ),
                          ),
                          dense: true,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // Tombol aksi Simpan dan Batal
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      buildActionButton(
                        title: isLoading ? 'Loading' : 'Simpan',
                        onTap: isLoading ? () {} : saveData,
                      ),
                      const SizedBox(width: 18),
                      buildActionButton(
                        title: 'Batal',
                        onTap: () => Navigator.pop(context),
                        // aksi saat tombol batal ditekan
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
