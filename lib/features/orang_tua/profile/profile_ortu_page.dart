import 'package:flutter/material.dart';
import '../../auth/login_page.dart';

class ProfileOrtuPage extends StatelessWidget {
  const ProfileOrtuPage({super.key});

  // Dummy data
  final String _nama = 'Khadijah';
  final String _email = 'ortu@smartpaud.com';
  final String _noHp = '0812-3456-7890';
  final bool _isActive = true;

  // Dummy data anak
  static const List<Map<String, dynamic>> _anakList = [
    {
      'nama': 'Kirana Larasati',
      'namaKelas': 'Kelas A',
      'periode': '2024/2025 – Semester 1',
      'isActive': true,
    },
  ];

  // Inisial nama untuk avatar
  String _inisial(String nama) {
    final parts = nama.trim().split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    return parts[0][0].toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Warna background
      backgroundColor: const Color(0xFFDDE8EF),
      body: SafeArea(
        child: Column(
          children: [
            // header
            _buildHeader(context),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                child: Column(
                  children: [
                    // Avatar,nama dan badge
                    _buildAvatarCard(),
                    const SizedBox(height: 12),

                    // Informasi akun
                    _buildInfoAkunCard(),
                    const SizedBox(height: 12),

                    // Data anak
                    _buildDataAnakCard(),
                    const SizedBox(height: 32),

                    // Tombol logout
                    _buildLogoutButton(context),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // header halaman profile
  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Row(
        children: [
          GestureDetector(
            // kembali ke halaman sebelumnya
            onTap: () => Navigator.pop(context),
            child: const Icon(Icons.chevron_left_rounded, size: 28),
          ),
          const SizedBox(width: 8),
          // Judul halaman
          const Text(
            'Profile Saya',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              fontFamily: 'Poppins',
            ),
          ),
        ],
      ),
    );
  }

  // card avatar
  Widget _buildAvatarCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Avatar icon
          Container(
            width: 72,
            height: 72,
            decoration: const BoxDecoration(
              color: Color(0xFFDDE8EF),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.person_outline_rounded,
              size: 36,
              color: Color(0xFF185FA5),
            ),
          ),
          const SizedBox(height: 12),

          // Nama
          Text(
            _nama,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              fontFamily: 'Poppins',
            ),
          ),
          const SizedBox(height: 6),

          // Badge role
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFDDE8EF),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'Orang Tua',
              style: TextStyle(
                fontSize: 12,
                fontFamily: 'Poppins',
                color: Color(0xFF185FA5),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Card Informasi Akun
  Widget _buildInfoAkunCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Judul
          const Text(
            'Informasi Akun',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              fontFamily: 'Poppins',
              color: Color(0xFF444444),
            ),
          ),
          const SizedBox(height: 12),
          // Baris informasi nama
          _buildInfoRow(
            icon: Icons.person_outline_rounded,
            label: 'Nama',
            value: _nama,
          ),
          const Divider(height: 16, thickness: 0.5),
          // Baris informasi email
          _buildInfoRow(
            icon: Icons.email_outlined,
            label: 'Email',
            value: _email,
          ),
          const Divider(height: 16, thickness: 0.5),
          // // Baris informasi No Hp
          _buildInfoRow(
            icon: Icons.phone_outlined,
            label: 'No. HP',
            value: _noHp,
          ),
          const Divider(height: 16, thickness: 0.5),
          // Baris informasi status akun
          _buildInfoRow(
            icon: Icons.verified_outlined,
            label: 'Status',
            value: _isActive ? 'Aktif' : 'Nonaktif',
          ),
        ],
      ),
    );
  }

  // Widget untuk satu baris informasi akun
  Widget _buildInfoRow({
    required IconData icon, // icon kiri
    required String label, // label field
    required String value, // isi field
  }) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey), // icon informasi
        const SizedBox(width: 8),
        // Label field
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
            fontFamily: 'Poppins',
          ),
        ),
        const Spacer(),
        // Isi field
        Text(
          value,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            fontFamily: 'Poppins',
          ),
        ),
      ],
    );
  }

  // Card data anak
  Widget _buildDataAnakCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Judul
          const Text(
            'Data Anak',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              fontFamily: 'Poppins',
              color: Color(0xFF444444),
            ),
          ),
          const SizedBox(height: 12),

          // loop semua data anak dari _anakList
          ..._anakList.map(
            (anak) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: Colors.grey.withOpacity(0.2),
                    width: 0.5,
                  ),
                ),
                child: Row(
                  children: [
                    // Avatar inisial anak
                    CircleAvatar(
                      radius: 16,
                      backgroundColor: Colors.white,
                      child: Text(
                        _inisial(anak['nama']), // ambil inisial nama anak
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF185FA5),
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),

                    // Nama, kelas dan periode
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            anak['nama'],
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Poppins',
                            ),
                          ),
                          const SizedBox(height: 2),

                          // info kelas dan periode
                          Text(
                            '${anak['namaKelas']} · ${anak['periode']}',
                            style: const TextStyle(
                              fontSize: 11,
                              color: Colors.grey,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Badge status anak
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color:
                            anak['isActive']
                                ? const Color(0xFFEAF3DE)
                                : const Color(0xFFFCEBEB),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        anak['isActive'] ? 'Aktif' : 'Nonaktif',
                        style: TextStyle(
                          fontSize: 11,
                          fontFamily: 'Poppins',
                          color:
                              anak['isActive']
                                  ? const Color(0xFF3B6D11)
                                  : const Color(0xFFA32D2D),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Tombol Logout
  Widget _buildLogoutButton(BuildContext context) {
    return GestureDetector(
      // aksi saat tombol ditekan, tampilkan dialog konfirmasi
      onTap: () {
        showDialog(
          context: context,
          builder:
              (ctx) => AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                // Judul dialog
                title: const Text(
                  'Konfirmasi Logout',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Poppins',
                  ),
                ),
                // Isi dialog
                content: const Text(
                  'Apakah kamu yakin ingin keluar?',
                  style: TextStyle(
                    fontSize: 13,
                    fontFamily: 'Poppins',
                    color: Colors.grey,
                  ),
                ),
                actions: [
                  // Tombol batal
                  TextButton(
                    onPressed: () => Navigator.pop(ctx), // tutup dialog
                    child: const Text(
                      'Batal',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  // Tombol logout
                  TextButton(
                    onPressed: () {
                      Navigator.pop(ctx); // tutup dialog dulu
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (_) => const LoginPage()),
                        (route) => false,
                      ); // pindah ke halaman login dan hapus semua halaman sebelumny
                    },
                    child: const Text(
                      'Logout',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        color: Color(0xFFA32D2D),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
        );
      },
      // tampilan tombol logout
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF0F0),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFF7C1C1), width: 0.5),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(width: 10),
            Text(
              'Logout',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                fontFamily: 'Poppins',
                color: Color(0xFFA32D2D),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
