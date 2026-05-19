import 'package:flutter/material.dart';
import 'profile_model.dart';
import 'profile_service.dart';

// Halaman profile guru
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  // state utama halaman profile
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _service = ProfileService();
  // menyimpan data profile guru
  ProfileModel? _profile;
  // menyimpan dftar kelas yang diampu
  List<KelasModel> _kelasList = [];
  // status loading
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfile(); // memuat data profile saat halaman dibuka
  }

  // function untuk mengambil data profile dan kelas dari database
  Future<void> _loadProfile() async {
    setState(() => _isLoading = true); // tampilkan loading
    try {
      // ambil data profile berdasarkan email
      final profile = await _service.getProfile('guru@smartpaud.com');
      // ambil data kelas berdasarkan id_guru
      final kelas = await _service.getKelasDiampu(profile.id);

      setState(() {
        _profile = profile; // simpan profile
        _kelasList = kelas; // simpan daftar kelas
        _isLoading = false; // selesai loading
      });
    } catch (e) {
      // handle eror
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
          // tampilkan snackbar eror
        ).showSnackBar(SnackBar(content: Text('Gagal memuat profil: $e')));
      }
    }
  }

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
              child:
                  _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : SingleChildScrollView(
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
    final peran = _kelasList.isNotEmpty ? _kelasList.first.peranGuru : '-';
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
          // nama guru
          Text(
            _profile?.nama ?? '-',
            style: const TextStyle(
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

            child: Text(
              peran,
              style: const TextStyle(
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

            value: _profile?.nama ?? '-',
          ),

          const Divider(height: 16, thickness: 0.5),

          // email guru
          _buildInfoRow(
            icon: Icons.email_outlined,

            label: 'Email',

            value: _profile?.email ?? '-',
          ),

          const Divider(height: 16, thickness: 0.5),

          // no. hp guru
          _buildInfoRow(
            icon: Icons.phone_outlined,

            label: 'No. HP',

            value: _profile?.noHp ?? '-',
          ),

          const Divider(height: 16, thickness: 0.5),

          // status aktif guru
          _buildInfoRow(
            icon: Icons.verified_outlined,

            label: 'Status',

            value: _profile?.statusText ?? '-',
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
          if (_kelasList.isEmpty)
            const Text(
              'Belum ada kelas yang diampu',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
                fontFamily: 'Poppins',
              ),
            )
          else
            ..._kelasList.map(
              (k) => Padding(
                padding: const EdgeInsets.only(bottom: 8),

                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),

                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
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
                              k.namaKelas,

                              style: const TextStyle(
                                fontSize: 13,

                                fontWeight: FontWeight.w500,

                                fontFamily: 'Poppins',
                              ),
                            ),

                            const SizedBox(height: 2),

                            // Role dan periode
                            Text(
                              '${k.peranGuru} · ${k.periode}',

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
