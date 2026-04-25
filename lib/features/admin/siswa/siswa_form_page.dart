import 'package:flutter/material.dart';
import 'siswa_service.dart';

// Halaman form untuk menambah atau mengedit data siswa
class SiswaFormPage extends StatefulWidget {
  final String? id;
  final String? nama;
  final String? kelas;
  final String? idKelas;
  final bool? isActive;

  const SiswaFormPage({
    super.key,
    this.id,
    this.nama,
    this.kelas,
    this.idKelas,
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
  String? selectedKelas;

  List<Map<String, dynamic>> kelasList = [];
  String? selectedKelasId;

  // Menyimpan status siswa
  bool isActive = true;

  bool isLoading = false;

  // Mengecek apakah halaman sedang dalam mode edit
  bool get isEdit => widget.id != null;

  @override
  void initState() {
    super.initState();

    _namaController.text = widget.nama ?? '';
    selectedKelasId = widget.idKelas;
    isActive = widget.isActive ?? true;

    fetchKelasList();
  }

  // Fungsi untuk mengambil daftar kelas
  Future<void> fetchKelasList() async {
    try {
      // Mengambil seluruh data kelas
      final result = await _service.getAllKelas();

      // agar aman sebelum memanggil setState
      if (!mounted) return;

      // Menyimpan hasil data kelas ke dalam state agar bisa digunakan untuk dropdown
      setState(() {
        kelasList = result;
      });
    } catch (e) {
      // Jika terjadi error saat mengambil data kelas,
      // tampilkan pesan gagal ke user
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal mengambil data kelas: $e')));
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
        );
      } else {
        // Jika bukan mode edit, tambahkan data siswa baru
        await _service.addSiswa(
          namaSiswa: _namaController.text.trim(),
          idKelas: selectedKelasId!,
          isActive: isActive,
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
      if (mounted) {
        setState(() => isLoading = false);
      }
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
                    value: selectedKelasId,
                    decoration: customInputDecoration('Pilih Kelas'),
                    items:
                        kelasList.map((kelas) {
                          return DropdownMenuItem<String>(
                            value: kelas['id'],
                            child: Text(kelas['nama_kelas']),
                          );
                        }).toList(),
                    onChanged: (value) {
                      setState(() => selectedKelasId = value);
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
                        title: isLoading ? 'Loading' : 'Simpan',
                        onTap: isLoading ? () {} : saveData,
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
