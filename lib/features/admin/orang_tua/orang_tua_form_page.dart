import 'package:flutter/material.dart';
import 'orang_tua_service.dart';

// Halaman form untuk menambah atau mengedit data orang tua
class OrangTuaFormPage extends StatefulWidget {
  final String? idUser;
  final String? nama;
  final String? email;
  final String? noHp;
  final bool? isActive;

  const OrangTuaFormPage({
    super.key,
    this.idUser,
    this.nama,
    this.email,
    this.noHp,
    this.isActive,
  });

  @override
  State<OrangTuaFormPage> createState() => _OrangTuaFormPageState();
}

// State dari halaman form orang tua
class _OrangTuaFormPageState extends State<OrangTuaFormPage> {
  // Controller untuk input nama orang tua
  final _namaController = TextEditingController();

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

    _namaController.text = widget.nama ?? '';
    _emailController.text = widget.email ?? '';
    _noHpController.text = widget.noHp ?? '';
    isActive = widget.isActive ?? true;
  }

  // Fungsi untuk menyimpan data orang tua (baik tambah maupun edit)
  Future<void> saveData() async {
    // Validasi: nama dan email tidak boleh kosong
    if (_namaController.text.trim().isEmpty ||
        _emailController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nama dan email wajib diisi')),
      );
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
          nama: _namaController.text.trim(),
          email: _emailController.text.trim(),
          noHp: _noHpController.text.trim(),
          isActive: isActive,
        );
      } else {
        // Jika bukan mode edit, tambahkan data orang tua baru
        await _service.addOrangTua(
          nama: _namaController.text.trim(),
          email: _emailController.text.trim(),
          noHp: _noHpController.text.trim(),
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
    // Membersihkan semua controller saat halaman ditutup
    _namaController.dispose();
    _emailController.dispose();
    _noHpController.dispose();
    _passwordController.dispose();
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
    final title = isEdit ? 'Edit Orang Tua' : 'Tambah Orang Tua';

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
      body: SingleChildScrollView(
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
                  // Input nama orang tua
                  buildLabel('Nama Orang Tua'),
                  TextField(
                    controller: _namaController,
                    decoration: customInputDecoration('Contoh: Shofiyah'),
                  ),
                  const SizedBox(height: 12),

                  // Input email orang tua
                  buildLabel('Email'),
                  TextField(
                    controller: _emailController,
                    enabled: !isEdit, // Email tidak bisa diedit saat mode edit
                    decoration: customInputDecoration('contoh@email.com'),
                  ),
                  const SizedBox(height: 12),

                  // Input nomor HP orang tua
                  buildLabel('No Hp'),
                  TextField(
                    controller: _noHpController,
                    decoration: customInputDecoration('08xxxxxxxxxx'),
                  ),
                  const SizedBox(height: 12),

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
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],

                  // Status
                  buildLabel('Status Orang Tua'),
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

                  // Tombol aksi simpan dan batal
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
    );
  }
}
