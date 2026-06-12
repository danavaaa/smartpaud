import 'package:flutter/material.dart';
import 'kelas_service.dart';
import '../../../core/theme/app_colors.dart';

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
      final result = await _service.getPeriodeAktifDropdown(
        selectedPeriodeId: widget.idPeriode,
      );
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
        color: AppColors.textSecondary,
        fontFamily: 'Poppins',
      ),
      filled: true,
      fillColor: AppColors.softCard,
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

  // Fungsi untuk membuat label di atas input
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

  // Fungsi untuk membuat tombol aksi seperti Simpan dan Batal
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

  @override
  Widget build(BuildContext context) {
    // Judul halaman berubah sesuai mode form
    final title = isEdit ? 'Edit Kelas' : 'Tambah Kelas';

    return Scaffold(
      // Warna latar belakang halaman
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                              ? 'Perbarui nama kelas dan periode ajaran'
                              : 'Tambahkan kelas baru pada periode ajaran aktif',
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
                    // Input nama kelas
                    buildLabel('Nama Kelas'),
                    TextField(
                      controller: _namaKelasController,
                      decoration: customInputDecoration('Contoh: Kelas A1'),
                    ),
                    const SizedBox(height: 14),

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
                              child: Text(
                                label,
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                            );
                          }).toList(),
                      onChanged: (value) {
                        // Mengubah nilai periode ajaran yang dipilih
                        setState(() => selectedPeriodeId = value);
                      },
                    ),
                    const SizedBox(height: 14),

                    // Pilihan status kelas
                    buildLabel('Status Kelas'),
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

                    const SizedBox(height: 18),

                    // Tombol aksi Simpan dan Batal
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
                          // Menutup halaman form tanpa menyimpan perubahan
                          onTap: () => Navigator.pop(context),
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
