import 'package:flutter/material.dart';
import 'periode_ajaran_model.dart';

// halaman form tambah/edit periode ajaran
class PeriodeAjaranFormPage extends StatefulWidget {
  final PeriodeAjaranModel? periode;

  const PeriodeAjaranFormPage({super.key, this.periode});

  @override
  State<PeriodeAjaranFormPage> createState() => _PeriodeAjaranFormPageState();
}

class _PeriodeAjaranFormPageState extends State<PeriodeAjaranFormPage> {
  // controllers untuk input form
  final _tahunAjaranController = TextEditingController();
  final _tanggalMulaiController = TextEditingController();
  final _tanggalSelesaiController = TextEditingController();

  String? selectedSemester; // menyimpan pilihan semester
  bool isActive = true; // menyimpan status  periode ajaran

  bool get isEdit => widget.periode != null;

  @override
  void initState() {
    super.initState();
    // jika mode edit, isi controller dengan data yang sudah ada
    if (isEdit) {
      final data = widget.periode!;
      _tahunAjaranController.text = data.tahunAjaran;
      selectedSemester = data.semester;
      _tanggalMulaiController.text = data.tanggalMulai;
      _tanggalSelesaiController.text = data.tanggalSelesai;
      isActive = data.isActive;
    }
  }

  @override
  void dispose() {
    _tahunAjaranController.dispose();
    _tanggalMulaiController.dispose();
    _tanggalSelesaiController.dispose();
    super.dispose();
  }

  // fungsi untuk membuat dekorasi input yang konsisten
  InputDecoration customInputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(fontSize: 12, color: Color(0xFFB8B1B1)),
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

  // widget untuk membuat label diatas input yang konsisten
  Widget buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          text,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  // widget untuk membuat tombol aksi yang konsisten
  Widget buildActionButton({
    required String title,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: 90,
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
          textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
        ),
        child: Text(title),
      ),
    );
  }

  // fungsi untuk memilih tanggal menggunakan date picker
  //dan mengisi controller dengan format yyyy-mm-dd
  Future<void> pickDate(TextEditingController controller) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
    );
    // jika user memilih tanggal, format dan isi controller dengan tanggal yang dipilih
    if (picked != null) {
      controller.text = picked.toIso8601String().split('T').first;
    }
  }

  // fungsi build utama untuk membangun tampilan halaman form tambah/edit periode ajaran
  @override
  Widget build(BuildContext context) {
    // menentukan judul halaman berdasarkan mode (tambah atau edit)
    final title = isEdit ? 'Edit Periode Ajaran' : 'Tambah Periode Ajaran';

    return Scaffold(
      backgroundColor: const Color(0xFFDCE5E8),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // tombol kembali ke halaman sebelumnya
              InkWell(
                onTap: () => Navigator.pop(context),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.chevron_left, color: Colors.black),
                    const SizedBox(width: 6),
                    // judul halaman yang berubah sesuai mode tambah atau edit
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // container utama yang berisi form input periode ajaran
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(14, 16, 14, 18),
                decoration: BoxDecoration(
                  color: const Color(0xFFEAF0F1),
                  borderRadius: BorderRadius.circular(2),
                ),
                child: Column(
                  children: [
                    buildLabel('Tahun Ajaran'),
                    TextField(
                      controller: _tahunAjaranController,
                      decoration: customInputDecoration('Contoh: 2024/2025'),
                    ),
                    const SizedBox(height: 10),

                    buildLabel('Semester'),
                    DropdownButtonFormField<String>(
                      value: selectedSemester,
                      decoration: customInputDecoration('Pilih Semester'),
                      items: const [
                        DropdownMenuItem(
                          value: 'Semester 1',
                          child: Text('Semester 1'),
                        ),
                        DropdownMenuItem(
                          value: 'Semester 2',
                          child: Text('Semester 2'),
                        ),
                      ],
                      // ketika user memilih semester, simpan pilihan di state
                      onChanged: (value) {
                        setState(() => selectedSemester = value);
                      },
                    ),
                    const SizedBox(height: 10),

                    buildLabel('Tanggal Mulai'),
                    TextField(
                      controller: _tanggalMulaiController,
                      readOnly: true,
                      onTap: () => pickDate(_tanggalMulaiController),
                      decoration: customInputDecoration('dd/mm/yy').copyWith(
                        suffixIcon: const Icon(Icons.keyboard_arrow_down),
                      ),
                    ),
                    const SizedBox(height: 10),

                    buildLabel('Tanggal Selesai'),
                    TextField(
                      controller: _tanggalSelesaiController,
                      readOnly: true,
                      onTap: () => pickDate(_tanggalSelesaiController),
                      decoration: customInputDecoration('dd/mm/yy').copyWith(
                        suffixIcon: const Icon(Icons.keyboard_arrow_down),
                      ),
                    ),
                    const SizedBox(height: 12),

                    buildLabel('Status Periode'),
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
                              style: TextStyle(fontSize: 12),
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
                              style: TextStyle(fontSize: 12),
                            ),
                            dense: true,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    // tombol aksi simpan dan batal
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
      ),
    );
  }
}
