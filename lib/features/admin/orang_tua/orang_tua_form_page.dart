import 'package:flutter/material.dart';

// Halaman form untuk menambah atau mengedit data orang tua
class OrangTuaFormPage extends StatefulWidget {
  final String? nama;
  final String? email;
  final String? noHp;
  final bool? isActive;

  const OrangTuaFormPage({
    super.key,
    this.nama,
    this.email,
    this.noHp,
    this.isActive,
  });

  @override
  State<OrangTuaFormPage> createState() => _OrangTuaFormPageState();
}

// State dari halaman form orang tua
class _OrangTuaFormPageState extends State<OrangTuaFormPage> {
  // Controller untuk input nama orang tua
  final _namaController = TextEditingController();

  // Controller untuk input email
  final _emailController = TextEditingController();

  // Controller untuk input nomor HP
  final _noHpController = TextEditingController();

  // Menyimpan status orang tua, default aktif
  bool isActive = true;

  // Mengecek apakah halaman sedang dalam mode edit
  bool get isEdit => widget.email != null;

  @override
  void initState() {
    super.initState();

    _namaController.text = widget.nama ?? '';
    _emailController.text = widget.email ?? '';
    _noHpController.text = widget.noHp ?? '';
    isActive = widget.isActive ?? true;
  }

  @override
  void dispose() {
    // Membersihkan semua controller saat halaman ditutup
    _namaController.dispose();
    _emailController.dispose();
    _noHpController.dispose();
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
    final title = isEdit ? 'Edit Orang Tua' : 'Tambah Orang Tua';

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
                  // Input nama orang tua
                  buildLabel('Nama Orang Tua'),
                  TextField(
                    controller: _namaController,
                    decoration: customInputDecoration('Contoh: Shofiyah'),
                  ),
                  const SizedBox(height: 12),

                  // Input email orang tua
                  buildLabel('Email'),
                  TextField(
                    controller: _emailController,
                    decoration: customInputDecoration('contoh@email.com'),
                  ),
                  const SizedBox(height: 12),

                  // Input nomor HP orang tua
                  buildLabel('No Hp'),
                  TextField(
                    controller: _noHpController,
                    decoration: customInputDecoration('08xxxxxxxxxx'),
                  ),
                  const SizedBox(height: 12),

                  // Pilihan status orang tua
                  buildLabel('Status Orang Tua'),
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
                          // menutup halaman form dan menyimpan perubahan
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
