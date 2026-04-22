import 'package:flutter/material.dart';

// Halaman form untuk menambah atau mengedit data kelas
class KelasFormPage extends StatefulWidget {
  final String? namaKelas;
  final String? periodeAjaran;
  final bool? isActive;

  const KelasFormPage({
    super.key,
    this.namaKelas,
    this.periodeAjaran,
    this.isActive,
  });

  @override
  State<KelasFormPage> createState() => _KelasFormPageState();
}

// State dari halaman form kelas
class _KelasFormPageState extends State<KelasFormPage> {
  // Controller untuk input nama kelas
  final _namaKelasController = TextEditingController();

  // Menyimpan pilihan periode ajaran
  String? selectedPeriode;

  // Menyimpan status kelas, default aktif
  bool isActive = true;

  // Mengecek apakah halaman sedang dalam mode edit
  bool get isEdit => widget.namaKelas != null;

  @override
  void initState() {
    super.initState();

    // Jika mode edit, isi field form dengan data lama
    if (isEdit) {
      _namaKelasController.text = widget.namaKelas!;
      selectedPeriode = widget.periodeAjaran;
      isActive = widget.isActive ?? true;
    }
  }

  @override
  void dispose() {
    // bersihkan controller saat halaman ditutup
    _namaKelasController.dispose();
    super.dispose();
  }

  // Fungsi untuk membuat dekorasi input yang sama
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

  // Fungsi untuk membuat label di atas input
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

  // Fungsi untuk membuat tombol aksi seperti Simpan dan Batal
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
          textStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            fontFamily: 'Poppins',
          ),
        ),
        child: Text(title),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Judul halaman berubah sesuai mode form
    final title = isEdit ? 'Edit Kelas' : 'Tambah Kelas';

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
                  // Input nama kelas
                  buildLabel('Nama Kelas'),
                  TextField(
                    controller: _namaKelasController,
                    decoration: customInputDecoration('Contoh: Kelas A1'),
                  ),
                  const SizedBox(height: 12),

                  // Input pilihan periode ajaran
                  buildLabel('Periode Ajaran'),
                  DropdownButtonFormField<String>(
                    value: selectedPeriode,
                    decoration: customInputDecoration('Pilih Periode Ajaran'),
                    items: const [
                      DropdownMenuItem(
                        value: '2024/2025 - Semester 1',
                        child: Text('2024/2025 - Semester 1'),
                      ),
                      DropdownMenuItem(
                        value: '2024/2025 - Semester 2',
                        child: Text('2024/2025 - Semester 2'),
                      ),
                      DropdownMenuItem(
                        value: '2025/2026 - Semester 1',
                        child: Text('2025/2026 - Semester 1'),
                      ),
                    ],
                    onChanged: (value) {
                      // Mengubah nilai periode ajaran yang dipilih
                      setState(() => selectedPeriode = value);
                    },
                  ),
                  const SizedBox(height: 12),

                  // Pilihan status kelas
                  buildLabel('Status Kelas'),
                  Row(
                    children: [
                      Expanded(
                        child: RadioListTile<bool>(
                          contentPadding: EdgeInsets.zero,
                          value: true,
                          groupValue: isActive,
                          onChanged: (value) {
                            if (value != null) {
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
                              // Mengubah status kelas menjadi tidak aktif
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
                          Navigator.pop(context);
                        },
                      ),
                      const SizedBox(width: 18),
                      buildActionButton(
                        title: 'Batal',
                        onTap: () {
                          // Menutup halaman form tanpa menyimpan perubahan
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
