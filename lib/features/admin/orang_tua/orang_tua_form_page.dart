import 'package:flutter/material.dart';
import 'orang_tua_service.dart';
import '../../../core/theme/app_colors.dart';

// Halaman form untuk menambah atau mengedit data orang tua
class OrangTuaFormPage extends StatefulWidget {
  final String? idUser;
  final String? idOrangTua;
  final String? namaAyah;
  final String? namaIbu;
  final String? email;
  final String? noHpWali;
  final String? pekerjaan;
  final bool? isActive;

  const OrangTuaFormPage({
    super.key,
    this.idUser,
    this.idOrangTua,
    this.namaAyah,
    this.namaIbu,
    this.email,
    this.noHpWali,
    this.pekerjaan,
    this.isActive,
  });

  @override
  State<OrangTuaFormPage> createState() => _OrangTuaFormPageState();
}

// State dari halaman form orang tua
class _OrangTuaFormPageState extends State<OrangTuaFormPage> {
  // Controller untuk input nama orang tua
  final _namaController = TextEditingController();
  final _namaAyahController = TextEditingController();
  final _namaIbuController = TextEditingController();
  final _noHpWaliController = TextEditingController();
  final _pekerjaanController = TextEditingController();

  // Controller untuk input email
  final _emailController = TextEditingController();

  // Controller untuk input nomor HP
  final _noHpController = TextEditingController();
  final _passwordController = TextEditingController();

  final _service = OrangTuaService();

  // Menyimpan status orang tua, default aktif
  bool isActive = true;

  bool isLoading = false;
  bool _obscurePassword = true;

  // Mengecek apakah halaman sedang dalam mode edit
  bool get isEdit => widget.idUser != null && widget.idUser!.isNotEmpty;

  @override
  void initState() {
    super.initState();

    _namaController.text = widget.namaAyah ?? widget.namaIbu ?? '';
    _emailController.text = widget.email ?? '';
    _noHpController.text = widget.noHpWali ?? '';
    _namaAyahController.text = widget.namaAyah ?? '';
    _namaIbuController.text = widget.namaIbu ?? '';
    _noHpWaliController.text = widget.noHpWali ?? '';
    _pekerjaanController.text = widget.pekerjaan ?? '';
    isActive = widget.isActive ?? true;
  }

  // Fungsi untuk menyimpan data orang tua (baik tambah maupun edit)
  Future<void> saveData() async {
    // Validasi nama ayah dan ibu tidak boleh kosong
    if (_namaAyahController.text.trim().isEmpty &&
        _namaIbuController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nama ayah atau nama ibu wajib diisi')),
      );
      return;
    }
    // Validasi email tidak bole kosong
    if (_emailController.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Email wajib diisi')));
      return;
    }
    // Validasi password hanya saat tambah baru dan pstikan password minimal 6 karakter
    if (!isEdit && _passwordController.text.trim().length < 6) {
      // Jika kurang dari 6 karakter, tampilkan pesan eror ke user
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password minimal 6 karakter')),
      );
      return;
    }

    try {
      setState(() => isLoading = true);

      // Jika mode edit, update data orang tua yang sudah ada
      if (isEdit) {
        await _service.updateOrangTua(
          idUser: widget.idUser!,
          idOrangTua: widget.idOrangTua,
          namaAyah: _namaAyahController.text.trim(),
          namaIbu: _namaIbuController.text.trim(),
          email: _emailController.text.trim(),
          noHpWali: _noHpWaliController.text.trim(),
          pekerjaan: _pekerjaanController.text.trim(),
          isActive: isActive,
        );
      } else {
        // Jika bukan mode edit, tambahkan data orang tua baru
        await _service.addOrangTua(
          namaAyah: _namaAyahController.text.trim(),
          namaIbu: _namaIbuController.text.trim(),
          email: _emailController.text.trim(),
          noHpWali: _noHpWaliController.text.trim(),
          pekerjaan: _pekerjaanController.text.trim(),
          isActive: isActive,
          password: _passwordController.text.trim(),
        );
      }

      // Jika berhasil, kembali ke halaman sebelumnya
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
    _namaAyahController.dispose();
    _namaIbuController.dispose();
    _emailController.dispose();
    _noHpWaliController.dispose();
    _pekerjaanController.dispose();
    _passwordController.dispose();
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
    final title = isEdit ? 'Edit Orang Tua' : 'Tambah Orang Tua';

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
                              ? 'Perbarui data orang tua dan status keaktifannya'
                              : 'Tambahkan akun orang tua baru ke sistem',
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
                    // input nama ayah
                    buildLabel('Nama Ayah'),
                    TextField(
                      controller: _namaAyahController,
                      decoration: customInputDecoration('Contoh: Abdullah'),
                    ),
                    const SizedBox(height: 14),
                    // Input nama ibu
                    buildLabel('Nama Ibu'),
                    TextField(
                      controller: _namaIbuController,
                      decoration: customInputDecoration('Contoh: Fatimah'),
                    ),
                    const SizedBox(height: 14),

                    // Input email orang tua
                    buildLabel('Email'),
                    TextField(
                      controller: _emailController,
                      enabled:
                          !isEdit, // Email tidak bisa diedit saat mode edit
                      decoration: customInputDecoration('contoh@email.com'),
                    ),
                    const SizedBox(height: 14),

                    // Input nomor hp
                    buildLabel('No HP Wali'),
                    TextField(
                      controller: _noHpWaliController,
                      keyboardType: TextInputType.phone,
                      decoration: customInputDecoration('08xxxxxxxxxx'),
                    ),
                    const SizedBox(height: 14),
                    // Input pekerjaan orang tua
                    buildLabel('Pekerjaan'),
                    TextField(
                      controller: _pekerjaanController,
                      decoration: customInputDecoration('Contoh: Wiraswasta'),
                    ),
                    const SizedBox(height: 14),

                    // Password (hanya tampil saat tambah baru)
                    // jika bukan dalam mode edit maka tampilkan field password
                    if (!isEdit) ...[
                      // Label input password
                      buildLabel('Password'),
                      // Input field password
                      TextField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        decoration: customInputDecoration(
                          'Min. 6 karakter',
                        ).copyWith(
                          // icon sebelah kanan
                          suffixIcon: GestureDetector(
                            // saat icon ditekan, ubah show/hide password
                            onTap:
                                () => setState(
                                  () => _obscurePassword = !_obscurePassword,
                                ),
                            child: Icon(
                              // Jika password tersebumyi, tampilkan mata tertutup
                              _obscurePassword
                                  ? Icons.visibility_off_outlined
                                  // Jika password terlihat, tampilkan mata terbuka
                                  : Icons.visibility_outlined,
                              size: 18,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 14),
                    ],

                    // Status
                    buildLabel('Status Orang Tua'),
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

                    // Tombol aksi simpan dan batal
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
