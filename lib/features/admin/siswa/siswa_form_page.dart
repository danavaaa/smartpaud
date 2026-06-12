import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'siswa_service.dart';
import '../../../core/theme/app_colors.dart';

// Halaman form untuk menambah atau mengedit data siswa
class SiswaFormPage extends StatefulWidget {
  final String? id;
  final String? nama;
  final String? idKelas;
  final String? idOrangTua;
  final String? tempatLahir;
  final String? tanggalLahir;
  final String? jenisKelamin;
  final bool? isActive;

  const SiswaFormPage({
    super.key,
    this.id,
    this.nama,
    this.idKelas,
    this.idOrangTua,
    this.tempatLahir,
    this.tanggalLahir,
    this.jenisKelamin,
    this.isActive,
  });

  @override
  State<SiswaFormPage> createState() => _SiswaFormPageState();
}

// State dari halaman form siswa
class _SiswaFormPageState extends State<SiswaFormPage> {
  // Controller untuk input nama siswa
  final _namaController = TextEditingController();
  // Controller untuk input tempat lahir siswa
  final _tempatLahirController = TextEditingController();
  // Controller untuk input tanggal lahir siswa
  final _tanggalLahirController = TextEditingController();
  final _service = SiswaService();

  // Menyimpan kelas yang dipilih
  String? selectedKelasId;
  // Menyimpan ID orang tua yang dipilih dari dropdown
  String? selectedOrangTuaId;
  // Menyimpan jenis kelamin yang dipilih
  String? selectedJenisKelamin;
  List<Map<String, dynamic>> kelasList = [];
  // list data orang tua untuk dropdown
  List<Map<String, dynamic>> orangTuaList = [];

  // Menyimpan status siswa
  bool isActive = true;

  bool isLoading = false;

  // menyimpan status loading dropdown (digunakan saat data kelas dan ortu masih diambil dari database)
  bool _isLoadingDropdown = true;

  // Mengecek apakah halaman sedang dalam mode edit
  bool get isEdit => widget.id != null;

  @override
  void initState() {
    super.initState();

    _namaController.text = widget.nama ?? '';
    _tempatLahirController.text = widget.tempatLahir ?? '';
    _tanggalLahirController.text = widget.tanggalLahir ?? '';
    selectedKelasId = widget.idKelas;
    selectedOrangTuaId = widget.idOrangTua;
    selectedJenisKelamin = widget.jenisKelamin;
    isActive = widget.isActive ?? true;

    fetchDropdownData();
  }

  // Fungsi untuk mengambil daftar kelas dan orang tua
  Future<void> fetchDropdownData() async {
    try {
      // Mengambil data kelas aktif untuk dropdown
      final kelasResult = await _service.getKelasAktifDropdown(
        selectedKelasId: widget.idKelas,
      );
      // Mengambil data ortu aktif untuk dropdown
      final orangTuaResult = await _service.getOrangTuaAktifDropdown(
        selectedOrangTuaId: widget.idOrangTua,
      );

      if (!mounted) return;

      // Update state setelah data berhasil didapat
      setState(() {
        kelasList = kelasResult; // isi list dropdown kelas
        orangTuaList = orangTuaResult; // isi list dropdown orang tua

        // Matikan loading dropdown karena data sudah siap
        _isLoadingDropdown = false;
      });
    } catch (e) {
      // Cek lagi apakah widget masih aktif
      if (!mounted) return;

      // Jika error, matikan loading
      setState(() => _isLoadingDropdown = false);

      // Tampilkan pesan error ke user
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal mengambil data: $e')));
    }
  }

  // Fungsi untuk memilih tanggal lahir menggunakan date picker
  Future<void> _pilihTanggalLahir() async {
    // tampilkan dialog kalender untuk memilih tanggal lahir
    final picked = await showDatePicker(
      context: context,
      // Tanggal awal yang ditampilkan saat dialog muncul
      initialDate: DateTime(2018),
      // Batas tanggal yang bisa dipilih
      firstDate: DateTime(2010),
      // Batas tanggal terakhir yang bisa dipilih
      lastDate: DateTime.now(),
      locale: const Locale('id', 'ID'),
    );
    // Jika user memilih tanggal (tidak membatalkan dialog), simpan tanggal yang dipilih ke controller dengan format yyyy-MM-dd
    if (picked != null) {
      setState(() {
        _tanggalLahirController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

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
          idOrangTua: selectedOrangTuaId,
          tempatLahir:
              _tempatLahirController.text.trim().isEmpty
                  ? null
                  : _tempatLahirController.text.trim(),
          tanggalLahir:
              _tanggalLahirController.text.trim().isEmpty
                  ? null
                  : _tanggalLahirController.text.trim(),
          jenisKelamin: selectedJenisKelamin,
        );
      } else {
        // Jika bukan mode edit, tambahkan data siswa baru
        await _service.addSiswa(
          namaSiswa: _namaController.text.trim(),
          idKelas: selectedKelasId!,
          isActive: isActive,
          idOrangTua: selectedOrangTuaId,
          tempatLahir:
              _tempatLahirController.text.trim().isEmpty
                  ? null
                  : _tempatLahirController.text.trim(),
          tanggalLahir:
              _tanggalLahirController.text.trim().isEmpty
                  ? null
                  : _tanggalLahirController.text.trim(),
          jenisKelamin: selectedJenisKelamin,
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
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  void dispose() {
    _namaController.dispose();
    _tempatLahirController.dispose();
    _tanggalLahirController.dispose();
    super.dispose();
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

  // Fungsi untuk membuat tombol aksi simpan dan batal
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
    final title = isEdit ? 'Edit Siswa' : 'Tambah Siswa';

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
                              ? 'Perbarui data siswa dan status keaktifannya'
                              : 'Tambahkan data siswa baru ke kelas aktif',
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
                    // Input nama siswa
                    buildLabel('Nama Siswa'),
                    TextField(
                      controller: _namaController,
                      decoration: customInputDecoration('Contoh: Richa'),
                    ),
                    const SizedBox(height: 14),

                    // Input tempat lahir
                    buildLabel('Tempat Lahir'),
                    TextField(
                      controller: _tempatLahirController,
                      decoration: customInputDecoration('Contoh: Surabaya'),
                    ),
                    const SizedBox(height: 14),

                    // Tanggal Lahir
                    buildLabel('Tanggal Lahir'),
                    GestureDetector(
                      onTap: _pilihTanggalLahir,
                      child: AbsorbPointer(
                        child: TextField(
                          controller: _tanggalLahirController,
                          decoration: customInputDecoration(
                            'Pilih tanggal lahir',
                          ).copyWith(
                            suffixIcon: const Icon(
                              Icons.keyboard_arrow_down,
                              color: AppColors.primaryDark,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Jenis Kelamin
                    buildLabel('Jenis Kelamin'),
                    DropdownButtonFormField<String>(
                      value: selectedJenisKelamin,
                      decoration: customInputDecoration('Pilih Jenis Kelamin'),
                      items: const [
                        DropdownMenuItem(
                          value: 'Laki-laki',
                          child: Text(
                            'Laki-laki',
                            style: TextStyle(
                              fontSize: 13,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ),
                        DropdownMenuItem(
                          value: 'Perempuan',
                          child: Text(
                            'Perempuan',
                            style: TextStyle(
                              fontSize: 13,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() => selectedJenisKelamin = value);
                      },
                    ),

                    const SizedBox(height: 14),

                    // Kelas
                    buildLabel('Kelas'),
                    _isLoadingDropdown
                        ? const Center(
                          child: CircularProgressIndicator(
                            color: AppColors.primary,
                          ),
                        )
                        : DropdownButtonFormField<String>(
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

                    // Dropdown untuk memilih orang tua
                    buildLabel('Orang Tua'),
                    // Jika data kelas dan orang tua masih dimuat, tampilkan indikator loading
                    _isLoadingDropdown
                        ? const SizedBox()
                        : DropdownButtonFormField<String>(
                          value: selectedOrangTuaId,
                          decoration: customInputDecoration('Pilih Orang Tua'),

                          // tampilan input dropdown
                          items: [
                            // Opsi jika siswa tidak memiliki orang tua yang dipilih
                            const DropdownMenuItem<String>(
                              value: null,
                              child: Text(
                                '-- Tidak Ada --',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                            ),
                            // Tambahkan semua data orang tua dari list
                            ...orangTuaList.map((ot) {
                              return DropdownMenuItem<String>(
                                value: ot['id_orang_tua'] as String?,
                                child: Text(
                                  ot['nama'] ?? '-',
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                              );
                            }),
                          ],

                          // Saat user memilih item dropdown,simpan ID orang tua yang dipilih ke state
                          onChanged: (value) {
                            setState(() => selectedOrangTuaId = value);
                          },
                        ),
                    const SizedBox(height: 14),

                    // Pilihan status siswa
                    buildLabel('Status Siswa'),
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
                          onTap: () => Navigator.pop(context),
                          // aksi saat tombol batal ditekan
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
