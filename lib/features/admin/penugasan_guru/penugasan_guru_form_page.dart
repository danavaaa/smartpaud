import 'package:flutter/material.dart';
import 'penugasan_guru_service.dart';
import '../../../core/theme/app_colors.dart';

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
      // Mengambil data guru aktif untuk dropdown
      final guruResult = await _service.getGuruAktifDropdown(
        selectedGuruId: widget.idGuru,
      );
      // Mengambil data kelas aktif untuk dropdown
      final kelasResult = await _service.getKelasAktifDropdown(
        selectedKelasId: widget.idKelas,
      );
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

  // Fungsi untuk membuat label di atas field input
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

  // Fungsi untuk membuat tombol aksi Simpan dan Batal
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
    final title = isEdit ? 'Edit Penugasan' : 'Tambah Penugasan';

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
                              ? 'Perbarui guru, kelas, dan peran penugasan'
                              : 'Tambahkan penugasan guru pada kelas aktif',
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
                        setState(() => selectedGuruId = value);
                      },
                    ),
                    const SizedBox(height: 14),

                    // Dropdown untuk memilih kelas
                    buildLabel('Kelas'),
                    DropdownButtonFormField<String>(
                      value: selectedKelasId,
                      decoration: customInputDecoration('Pilih Kelas'),
                      items:
                          kelasList.map((kelas) {
                            return DropdownMenuItem<String>(
                              value: kelas['id'],
                              child: Text(
                                kelas['nama_kelas'],
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                            );
                          }).toList(),
                      onChanged: (value) {
                        setState(() => selectedKelasId = value);
                      },
                    ),
                    const SizedBox(height: 14),

                    // Dropdown untuk memilih peran guru
                    buildLabel('Peran Guru'),
                    DropdownButtonFormField<String>(
                      value: selectedPeran,
                      decoration: customInputDecoration('Pilih Peran'),
                      items: const [
                        DropdownMenuItem(
                          value: 'Wali Kelas',
                          child: Text(
                            'Wali Kelas',
                            style: TextStyle(
                              fontSize: 13,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ),
                        DropdownMenuItem(
                          value: 'Guru Pendamping',
                          child: Text(
                            'Guru Pendamping',
                            style: TextStyle(
                              fontSize: 13,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ),
                      ],
                      onChanged: (value) {
                        // Menyimpan peran yang dipilih
                        setState(() => selectedPeran = value);
                      },
                    ),
                    const SizedBox(height: 14),

                    // Pilihan status penugasan
                    buildLabel('Status Penugasan'),
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
                              activeColor: AppColors.primary,
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
