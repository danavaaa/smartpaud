import 'package:flutter/material.dart';
import 'penugasan_guru_service.dart';

// Halaman form untuk menambah atau mengedit data penugasan guru
class PenugasanGuruFormPage extends StatefulWidget {
  final String? id;
  final String? idGuru;
  final String? idKelas;
  final String? peran;
  final bool? isActive;

  const PenugasanGuruFormPage({
    super.key,
    this.id,
    this.idGuru,
    this.idKelas,
    this.peran,
    this.isActive,
  });

  @override
  State<PenugasanGuruFormPage> createState() => _PenugasanGuruFormPageState();
}

// State dari halaman form penugasan guru
class _PenugasanGuruFormPageState extends State<PenugasanGuruFormPage> {
  final PenugasanGuruService _service = PenugasanGuruService();
  // Menyimpan pilihan guru
  String? selectedGuruId;

  // Menyimpan pilihan kelas
  String? selectedKelasId;

  // Menyimpan pilihan periode
  String? selectedPeriode;

  // Menyimpan pilihan peran guru
  String? selectedPeran;

  // Menyimpan status penugasan, default aktif
  bool isActive = true;

  // Menyimpan status loading saat menyimpan data
  bool isLoading = false;

  // Mengecek apakah halaman sedang dalam mode edit
  bool get isEdit => widget.id != null;

  // Menyimpan data dropdown guru dan kelas
  List<dynamic> guruList = [];
  List<dynamic> kelasList = [];

  @override
  void initState() {
    super.initState();

    // Jika dalam mode edit, isi field dengan data yang sudah ada
    selectedGuruId = widget.idGuru;
    selectedKelasId = widget.idKelas;
    selectedPeran = widget.peran;
    isActive = widget.isActive ?? true;
    // Ambil data dropdown guru dan kelas saat halaman pertama kali dibuka
    fetchDropdownData();
  }

  // Fungsi untuk mengambil data guru dan kelas yang akan digunakan pada dropdown form
  Future<void> fetchDropdownData() async {
    try {
      // Mengambil seluruh data guru dari service
      final guruResult = await _service.getAllGuru();

      // Mengambil seluruh data kelas dari service
      final kelasResult = await _service.getAllKelas();

      if (!mounted) return;

      // Menyimpan hasil data guru dan kelas ke state agar dropdown bisa menampilkan pilihan
      setState(() {
        guruList = guruResult;
        kelasList = kelasResult;
      });
    } catch (e) {
      // Jika terjadi error, tampilkan pesan gagal ke user
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mengambil data dropdown: $e')),
      );
    }
  }

  // Fungsi untuk menyimpan data penugasan guru (tambah data baru maupun edit data lama)
  Future<void> saveData() async {
    // Validasi: pastikan semua field penting sudah dipilih
    if (selectedGuruId == null ||
        selectedKelasId == null ||
        selectedPeran == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Semua field wajib diisi')));
      return;
    }

    try {
      // Mengaktifkan loading agar tombol/input bisa dinonaktifkan
      setState(() => isLoading = true);

      // Jika mode edit, update data yang sudah ada
      if (isEdit) {
        await _service.updatePenugasanGuru(
          id: widget.id!,
          idGuru: selectedGuruId!,
          idKelas: selectedKelasId!,
          peranGuru: selectedPeran!,
          isActive: isActive,
        );
      } else {
        // Jika bukan mode edit, tambahkan data baru
        await _service.addPenugasanGuru(
          idGuru: selectedGuruId!,
          idKelas: selectedKelasId!,
          peranGuru: selectedPeran!,
          isActive: isActive,
        );
      }

      // Setelah berhasil simpan, kembali ke halaman sebelumnya
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

  // Fungsi untuk membuat tombol aksi Simpan dan Batal
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
    final title = isEdit ? 'Edit Penugasan' : 'Tambah Penugasan';

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
                  // Dropdown untuk memilih guru
                  buildLabel('Guru'),
                  DropdownButtonFormField<String>(
                    value: selectedGuruId,
                    decoration: customInputDecoration('Pilih Guru'),
                    items:
                        guruList.map((guru) {
                          final label = guru['nama'] ?? guru['email'] ?? '-';
                          return DropdownMenuItem<String>(
                            value: guru['id_user'],
                            child: Text(label),
                          );
                        }).toList(),
                    onChanged: (value) {
                      setState(() => selectedGuruId = value);
                    },
                  ),
                  const SizedBox(height: 12),

                  // Dropdown untuk memilih kelas
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

                  // Dropdown untuk memilih peran guru
                  buildLabel('Peran Guru'),
                  DropdownButtonFormField<String>(
                    value: selectedPeran,
                    decoration: customInputDecoration('Pilih Peran'),
                    items: const [
                      DropdownMenuItem(
                        value: 'Wali Kelas',
                        child: Text('Wali Kelas'),
                      ),
                      DropdownMenuItem(
                        value: 'Guru Pendamping',
                        child: Text('Guru Pendamping'),
                      ),
                    ],
                    onChanged: (value) {
                      // Menyimpan peran yang dipilih
                      setState(() => selectedPeran = value);
                    },
                  ),
                  const SizedBox(height: 12),

                  // Pilihan status penugasan
                  buildLabel('Status Penugasan'),
                  Row(
                    children: [
                      Expanded(
                        child: RadioListTile<bool>(
                          contentPadding: EdgeInsets.zero,
                          value: true,
                          groupValue: isActive,
                          onChanged: (value) {
                            if (value != null) {
                              // Mengubah status menjadi aktif
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
                              // Mengubah status menjadi tidak aktif
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
