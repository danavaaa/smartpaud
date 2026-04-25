import 'package:flutter/material.dart';

// Halaman form untuk menambah atau mengedit data siswa
class SiswaFormPage extends StatefulWidget {
  final String? nama;
  final String? kelas;
  final bool? isActive;

  const SiswaFormPage({super.key, this.nama, this.kelas, this.isActive});

  @override
  State<SiswaFormPage> createState() => _SiswaFormPageState();
}

// State dari halaman form siswa
class _SiswaFormPageState extends State<SiswaFormPage> {
  // Controller untuk input nama siswa
  final _namaController = TextEditingController();

  // Menyimpan kelas yang dipilih
  String? selectedKelas;

  // Menyimpan status siswa
  bool isActive = true;

  // Mengecek apakah halaman sedang dalam mode edit
  bool get isEdit => widget.nama != null;

  @override
  void initState() {
    super.initState();

    _namaController.text = widget.nama ?? '';
    selectedKelas = widget.kelas;
    isActive = widget.isActive ?? true;
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
      body: Padding(
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
                  DropdownButtonFormField<String>(
                    value: selectedKelas,
                    decoration: customInputDecoration('Pilih Kelas'),
                    items: const [
                      DropdownMenuItem(
                        value: 'Kelas A1',
                        child: Text('Kelas A1'),
                      ),
                      DropdownMenuItem(
                        value: 'Kelas B1',
                        child: Text('Kelas B1'),
                      ),
                    ],
                    onChanged: (value) {
                      // Menyimpan kelas yang dipilih
                      setState(() => selectedKelas = value);
                    },
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
                            if (value != null) {
                              // Mengubah status siswa menjadi aktif
                              setState(() => isActive = value);
                            }
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
                            if (value != null) {
                              // Mengubah status siswa menjadi tidak aktif
                              setState(() => isActive = value);
                            }
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
                        title: 'Simpan',
                        onTap: () {
                          // aksi saat tombol simpan ditekan
                          Navigator.pop(context);
                        },
                      ),
                      const SizedBox(width: 18),
                      buildActionButton(
                        title: 'Batal',
                        onTap: () {
                          // aksi saat tombol batal ditekan
                          Navigator.pop(context);
                        },
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
