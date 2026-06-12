import 'package:flutter/material.dart';
import 'periode_ajaran_model.dart';
import 'periode_ajaran_service.dart';
import '../../../core/theme/app_colors.dart';

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

  // instance service untuk mengelola data periode ajaran
  final _service = PeriodeAjaranService();
  // variabel untuk menyimpan pilihan semester dan status aktif periode ajaran
  String? selectedSemester;
  bool isActive = true;
  bool isLoading = false;

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
      hintStyle: const TextStyle(
        fontSize: 12,
        color: AppColors.textSecondary,
        fontFamily: 'Poppins',
      ),
      filled: true,
      fillColor: AppColors.cardWhite,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.primary),
      ),
    );
  }

  // widget untuk membuat label diatas input yang konsisten
  Widget buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 7),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
            fontFamily: 'Poppins',
          ),
        ),
      ),
    );
  }

  // widget untuk membuat tombol aksi yang konsisten
  Widget buildActionButton({
    required String title,
    required VoidCallback onTap,
    bool isPrimary = false,
  }) {
    return Expanded(
      child: SizedBox(
        height: 44,
        child: ElevatedButton(
          onPressed: onTap,
          style: ElevatedButton.styleFrom(
            backgroundColor:
                isPrimary ? AppColors.primary : AppColors.softPrimary,
            foregroundColor:
                isPrimary ? AppColors.buttonText : AppColors.primaryDark,
            elevation: isPrimary ? 3 : 1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            textStyle: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              fontFamily: 'Poppins',
            ),
          ),
          child: Text(title),
        ),
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

  // fungsi untuk menyimpan data periode ajaran, baik untuk tambah maupun edit
  Future<void> saveData() async {
    // validasi sederhana untuk memastikan semua field wajib diisi
    if (_tahunAjaranController.text.trim().isEmpty ||
        selectedSemester == null ||
        _tanggalMulaiController.text.trim().isEmpty ||
        _tanggalSelesaiController.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Semua field wajib diisi')));
      return;
    }

    try {
      setState(() => isLoading = true);
      if (isEdit) {
        // jika mode edit, panggil fungsi update dengan id periode yang sudah ada
        await _service.updatePeriodeAjaran(
          id: widget.periode!.id,
          tahunAjaran: _tahunAjaranController.text.trim(),
          semester: selectedSemester!,
          tanggalMulai: _tanggalMulaiController.text.trim(),
          tanggalSelesai: _tanggalSelesaiController.text.trim(),
          isActive: isActive,
        );
      } else {
        // jika mode tambah, panggil fungsi add tanpa id
        await _service.addPeriodeAjaran(
          tahunAjaran: _tahunAjaranController.text.trim(),
          semester: selectedSemester!,
          tanggalMulai: _tanggalMulaiController.text.trim(),
          tanggalSelesai: _tanggalSelesaiController.text.trim(),
          isActive: isActive,
        );
      }
      // setelah berhasil menyimpan data, kembali ke halaman sebelumnya dengan hasil true
      if (!mounted) return;
      Navigator.pop(context, true);
    } catch (e) {
      // jika terjadi error saat menyimpan data, tampilkan pesan error menggunakan SnackBar
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal menyimpan data: $e')));
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  // fungsi build utama untuk membangun tampilan halaman form tambah/edit periode ajaran
  @override
  Widget build(BuildContext context) {
    // menentukan judul halaman berdasarkan mode (tambah atau edit)
    final title = isEdit ? 'Edit Periode Ajaran' : 'Tambah Periode Ajaran';

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // tombol kembali ke halaman sebelumnya
              Row(
                children: [
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    borderRadius: BorderRadius.circular(20),
                    child: const Icon(
                      Icons.chevron_left_rounded,
                      color: AppColors.textPrimary,
                      size: 30,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // judul halaman yang berubah sesuai mode tambah atau edit
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Poppins',
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          isEdit
                              ? 'Perbarui data periode ajaran'
                              : 'Tambahkan tahun ajaran dan semester baru',
                          style: const TextStyle(
                            fontSize: 11,
                            fontFamily: 'Poppins',
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // container utama yang berisi form input periode ajaran
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(18, 20, 18, 20),
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
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
                        suffixIcon: const Icon(
                          Icons.keyboard_arrow_down,
                          color: AppColors.primaryDark,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),

                    buildLabel('Tanggal Selesai'),
                    TextField(
                      controller: _tanggalSelesaiController,
                      readOnly: true,
                      onTap: () => pickDate(_tanggalSelesaiController),
                      decoration: customInputDecoration('dd/mm/yy').copyWith(
                        suffixIcon: const Icon(
                          Icons.keyboard_arrow_down,
                          color: AppColors.primaryDark,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    buildLabel('Status Periode'),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.softCard,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: RadioListTile<bool>(
                              activeColor: AppColors.primary,
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
                              activeColor: AppColors.primary,
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
                    ),
                    const SizedBox(height: 14),
                    // tombol aksi simpan dan batal
                    Row(
                      children: [
                        buildActionButton(
                          title: isLoading ? 'Loading...' : 'Simpan',
                          isPrimary: true,
                          onTap: isLoading ? () {} : saveData,
                        ),
                        const SizedBox(width: 12),
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
