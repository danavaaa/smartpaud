import 'package:flutter/material.dart';
import 'guru_service.dart';

// Halaman form untuk menambah atau mengedit data guru
class GuruFormPage extends StatefulWidget {
  final String? idUser;
  final String? namaGuru;
  final String? email;
  final String? noHp;
  final bool? isActive;

  const GuruFormPage({
    super.key,
    this.idUser,
    this.namaGuru,
    this.email,
    this.noHp,
    this.isActive,
  });

  @override
  State<GuruFormPage> createState() => _GuruFormPageState();
}

// State dari halaman form guru
class _GuruFormPageState extends State<GuruFormPage> {
  final _namaGuruController = TextEditingController();
  final _emailController = TextEditingController();
  final _noHpController = TextEditingController();

  final _service = GuruService();

  bool isActive = true;
  bool isLoading = false;

  // Mengecek apakah halaman sedang dalam mode edit
  // Jika idUser tidak null dan tidak kosong, berarti dalam mode edit
  bool get isEdit => widget.idUser != null && widget.idUser!.isNotEmpty;

  @override
  void initState() {
    super.initState();

    // Mengisi controller dengan data yang diterima jika dalam mode edit
    _namaGuruController.text = widget.namaGuru ?? '';
    _emailController.text = widget.email ?? '';
    _noHpController.text = widget.noHp ?? '';
    isActive = widget.isActive ?? true;
  }

  // Fungsi untuk menyimpan data guru (baik tambah maupun edit)
  Future<void> saveData() async {
    // Validasi: nama guru dan email tidak boleh kosong
    if (_namaGuruController.text.trim().isEmpty ||
        _emailController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nama dan email wajib diisi')),
      );
      return;
    }

    try {
      setState(() => isLoading = true);

      // Jika mode edit, update data guru yang sudah ada
      if (isEdit) {
        await _service.updateGuru(
          idUser: widget.idUser!,
          nama: _namaGuruController.text.trim(),
          email: _emailController.text.trim(),
          noHp: _noHpController.text.trim(),
          isActive: isActive,
        );
      } else {
        // Jika bukan mode edit, tambahkan data guru baru
        await _service.addGuru(
          nama: _namaGuruController.text.trim(),
          email: _emailController.text.trim(),
          noHp: _noHpController.text.trim(),
          isActive: isActive,
        );
      }

      // Jika berhasil, kembali ke halaman sebelumnya
      // sambil mengirim nilai true sebagai tanda sukses
      if (!mounted) return;
      Navigator.pop(context, true);
    } catch (e) {
      // Jika terjadi error saat menyimpan data,
      // tampilkan pesan gagal ke user
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal menyimpan data: $e')));
    } finally {
      // Setelah proses selesai, matikan loading
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  @override
  void dispose() {
    _namaGuruController.dispose();
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

  // Fungsi untuk membuat tombol aksi  Simpan dan Batal
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
    final title = isEdit ? 'Edit Guru' : 'Tambah Guru';

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
                  // Input nama lengkap guru
                  buildLabel('Nama Lengkap'),
                  TextField(
                    controller: _namaGuruController,
                    decoration: customInputDecoration('Contoh: Andini Ray'),
                  ),
                  const SizedBox(height: 12),

                  // Input email guru
                  buildLabel('Email'),
                  TextField(
                    controller: _emailController,
                    enabled:
                        !isEdit, // Email bisa diisi saat tambah, tidak bisa diubah saat edit
                    decoration: customInputDecoration('contoh@email.com'),
                  ),
                  const SizedBox(height: 12),

                  // Input nomor HP guru
                  buildLabel('No Hp'),
                  TextField(
                    controller: _noHpController,
                    decoration: customInputDecoration('08xxxxxxxxxx'),
                  ),
                  const SizedBox(height: 12),

                  // Pilihan status guru
                  buildLabel('Status Guru'),
                  Row(
                    children: [
                      Expanded(
                        child: RadioListTile<bool>(
                          contentPadding: EdgeInsets.zero,
                          value: true,
                          groupValue: isActive,
                          onChanged: (value) {
                            if (value != null) {
                              // Mengubah status guru menjadi aktif
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
                              // Mengubah status guru menjadi tidak aktif
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
                        title: isLoading ? 'Loading' : 'Simpan',
                        onTap: isLoading ? () {} : saveData,
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
