import 'package:flutter/material.dart';

// Halaman profile guru
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Background utama halaman
      backgroundColor: const Color(0xFFDDE8EF),

      body: SafeArea(
        child: Column(
          children: [
            // header halaman
            _buildHeader(context),
            // Konten utama halaman
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),

                child: Column(
                  children: [
                    // card avatar, nama, dan badge role
                    _buildAvatarCard(),

                    const SizedBox(height: 12),
                    // card informasi akun
                    _buildInfoAkunCard(),

                    const SizedBox(height: 12),
                    // card daftar kelas yang diampu
                    _buildKelasDiampuCard(),

                    const SizedBox(height: 12),
                    // tombol logout
                    _buildLogoutButton(context),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // header halaman dengan tombol kembali dan judul
  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),

      child: Row(
        children: [
          // Tombol kembali
          GestureDetector(
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

  // Card avatar, nama, dan badge role guru
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
          // avatar guru
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
          // nama guru dummy
          const Text(
            'Siti Rahmawati, M.Pd',
            style: TextStyle(
              fontSize: 16,

              fontWeight: FontWeight.w600,

              fontFamily: 'Poppins',
            ),
          ),

          const SizedBox(height: 6),

          // badge role guru dummy
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),

            decoration: BoxDecoration(
              color: const Color(0xFFDDE8EF),

              borderRadius: BorderRadius.circular(20),
            ),

            child: const Text(
              'Guru Pendamping',
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

  // Card informasi akun guru
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
          // judul
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

          // nama guru
          _buildInfoRow(
            icon: Icons.person_outline_rounded,

            label: 'Nama',

            value: 'Siti Rahmawati',
          ),

          const Divider(height: 16, thickness: 0.5),

          // email guru
          _buildInfoRow(
            icon: Icons.email_outlined,

            label: 'Email',

            value: 'siti@smartpaud.com',
          ),

          const Divider(height: 16, thickness: 0.5),

          // no. hp guru
          _buildInfoRow(
            icon: Icons.phone_outlined,

            label: 'No. HP',

            value: '0812-3456-7890',
          ),

          const Divider(height: 16, thickness: 0.5),

          // status aktif guru
          _buildInfoRow(
            icon: Icons.work_outline_rounded,

            label: 'Status',

            value: 'Aktif',
          ),
        ],
      ),
    );
  }

  // Row informasi dengan icon, label, dan value
  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        // Icon informasi
        Icon(icon, size: 16, color: Colors.grey),

        const SizedBox(width: 8),

        // Label informasi
        Text(
          label,

          style: const TextStyle(
            fontSize: 12,

            color: Colors.grey,

            fontFamily: 'Poppins',
          ),
        ),

        const Spacer(),

        // Value informasi
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

  // card daftar kelas yang diampu oleh guru
  Widget _buildKelasDiampuCard() {
    final List<Map<String, String>> kelasList = [
      {
        'nama': 'Kelas A1',

        'peran': 'Wali Kelas',

        'periode': '2024/2025 – Smstr 1',
      },

      {
        'nama': 'Kelas B1',

        'peran': 'Guru Pendamping',

        'periode': '2024/2025 – Smstr 1',
      },
    ];

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
          // judul
          const Text(
            'Kelas yang Diampu',

            style: TextStyle(
              fontSize: 13,

              fontWeight: FontWeight.w600,

              fontFamily: 'Poppins',

              color: Color(0xFF444444),
            ),
          ),

          const SizedBox(height: 12),

          // kelas yang diampu guru
          ...kelasList.map(
            (kelas) => Padding(
              padding: const EdgeInsets.only(bottom: 8),

              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),

                decoration: BoxDecoration(
                  color: Colors.white,

                  border: Border.all(
                    color: Colors.grey.withOpacity(0.5),

                    width: 0.5,
                  ),
                ),

                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [
                          // Nama kelas
                          Text(
                            kelas['nama']!,

                            style: const TextStyle(
                              fontSize: 13,

                              fontWeight: FontWeight.w500,

                              fontFamily: 'Poppins',
                            ),
                          ),

                          const SizedBox(height: 2),

                          // Role dan periode
                          Text(
                            '${kelas['peran']} · ${kelas['periode']}',

                            style: const TextStyle(
                              fontSize: 11,

                              color: Colors.grey,

                              fontFamily: 'Poppins',
                            ),
                          ),
                        ],
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

  // Tombol logout akun
  Widget _buildLogoutButton(BuildContext context) {
    return GestureDetector(
      // aksi ketika tombol ditekan
      onTap: () {},

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
            // Text logout
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
