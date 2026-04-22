import 'package:flutter/material.dart';
import 'kelas_service.dart';

// Halaman form untuk menambah atau mengedit data kelas
class KelasFormPage extends StatefulWidget {
  final String? id;
  final String? namaKelas;
  final String? idPeriode;
  final bool? isActive;

  const KelasFormPage({
    super.key,
    this.id,
    this.namaKelas,
    this.idPeriode,
    this.isActive,
  });

  @override
  State<KelasFormPage> createState() => _KelasFormPageState();
}

// State dari halaman form kelas
class _KelasFormPageState extends State<KelasFormPage> {
  final _namaKelasController = TextEditingController();

  final _service = KelasService();

  List<Map<String, dynamic>> periodeList = [];
  // Menyimpan pilihan periode ajaran
  String? selectedPeriodeId;
  // Menyimpan status kelas, default aktif
  bool isActive = true;
  bool isLoading = false;

  // Mengecek apakah halaman sedang dalam mode edit
  bool get isEdit => widget.id != null;

  @override
  void initState() {
    super.initState();
    _namaKelasController.text = widget.namaKelas ?? '';
    selectedPeriodeId = widget.idPeriode;
    isActive = widget.isActive ?? true;
    fetchPeriodeList();
  }

  // Fungsi untuk mengambil daftar periode ajaran dari server
  Future<void> fetchPeriodeList() async {
    try {
      final result = await _service.getAllPeriodeAjaran();
      if (!mounted) return;
      setState(() {
        periodeList = result;
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mengambil periode ajaran: $e')),
      );
    }
  }

  // Fungsi untuk menyimpan data kelas, baik untuk tambah maupun edit
  Future<void> saveData() async {
    if (_namaKelasController.text.trim().isEmpty || selectedPeriodeId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nama kelas dan periode wajib diisi')),
      );
      return;
    }
    // Menampilkan loading saat proses penyimpanan data
    try {
      setState(() => isLoading = true);
      // jika dalam mode edit, panggil fungsi update kelas
      if (isEdit) {
        await _service.updateKelas(
          id: widget.id!,
          namaKelas: _namaKelasController.text.trim(),
          idPeriode: selectedPeriodeId!,
          isActive: isActive,
        );
      }
      // Jika tidak dalam mode edit, maka tambahkan data kelas baru dengan memanggil fungsi addKelas
      else {
        await _service.addKelas(
          namaKelas: _namaKelasController.text.trim(),
          idPeriode: selectedPeriodeId!,
          isActive: isActive,
        );
      }
      // jika berhasil menyimpan data, maka kembali ke halaman sebelumnya dengan mengirim nilai true untuk menandakan bahwa data telah berubah dan perlu direfresh
      if (!mounted) return;
      Navigator.pop(context, true);
    } catch (e) {
      // Menampilkan pesan error jika gagal menyimpan data kelas
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal menyimpan data: $e')));
    } finally {
      // Menghentikan loading setelah proses selesai, baik berhasil maupun gagal
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  @override
  void dispose() {
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
                    // Menampilkan nilai periode ajaran yang dipilih
                    value: selectedPeriodeId,
                    // Membuat daftar pilihan periode ajaran dari data yang diambil dari server
                    decoration: customInputDecoration('Pilih Periode Ajaran'),
                    // Membuat daftar pilihan periode ajaran dari data yang diambil dari server
                    items:
                        periodeList.map((periode) {
                          // Membuat label untuk setiap pilihan periode ajaran dengan format "tahun ajaran - semester"
                          final label =
                              '${periode['tahun_ajaran']} - ${periode['semester']}';
                          return DropdownMenuItem<String>(
                            // Membuat item dropdown untuk setiap periode ajaran dengan nilai id periode ajaran
                            value: periode['id'],
                            child: Text(label),
                          );
                        }).toList(),
                    onChanged: (value) {
                      // Mengubah nilai periode ajaran yang dipilih
                      setState(() => selectedPeriodeId = value);
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
