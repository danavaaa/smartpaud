import 'package:flutter/material.dart';
import 'profile_model.dart';
import 'profile_service.dart';
import '../../auth/login_page.dart';
import '../../../services/user_session.dart';
import '../../../services/auth_service.dart';
import '../../../core/theme/app_colors.dart';

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

  // Getter untuk menentukan peran utama guru berdasarkan daftar kelas yang dimiliki atau diampu
  String get _peranUtama {
    // Jika guru tidak memiliki data kelas, tampilkan tanda "-"
    if (_kelasList.isEmpty) return '-';

    // Memeriksa apakah guru memiliki peran sebagai wali kelas
    final punyaWaliKelas = _kelasList.any((k) {
      final peran = k.peranGuru.toLowerCase().replaceAll(' ', '');

      return peran == 'walikelas';
    });

    // Jika terdapat minimal satu kelas dengan peran wali kelas, maka peran utama ditetapkan sebagai Wali Kelas
    if (punyaWaliKelas) {
      return 'Wali Kelas';
    }

    // Mengambil peran dari data kelas pertama
    final peranPertama = _kelasList.first.peranGuru.toLowerCase().replaceAll(
      ' ',
      '',
    );

    // Jika peran pertama adalah guru pendamping, tampilkan label Guru Pendamping
    if (peranPertama == 'gurupendamping') {
      return 'Guru Pendamping';
    }

    // Jika tidak memenuhi kondisi di atas, kembalikan peran asli dari data pertama
    return _kelasList.first.peranGuru;
  }

  @override
  void initState() {
    super.initState();
    _loadProfile(); // memuat data profile saat halaman dibuka
  }

  // function untuk mengambil data profile dan kelas dari database
  Future<void> _loadProfile() async {
    setState(() => _isLoading = true); // tampilkan loading
    try {
      // ambil data profile berdasarkan id user yang tersimpan di session
      final userId = UserSession().idUser ?? '';
      final profile = await _service.getProfile(userId);
      // ambil data semua kelas yang pernah/masih diampu
      final kelas = List<KelasModel>.from(
        await _service.getSemuaKelasDiampu(userId),
      );

      // urutkan daftar kelas berdasarkan nama kelas secara alfabet
      kelas.sort(
        (a, b) =>
            a.namaKelas.toLowerCase().compareTo(b.namaKelas.toLowerCase()),
      );

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
      backgroundColor: AppColors.background,

      body: SafeArea(
        child: Column(
          children: [
            // header halaman
            _buildHeader(context),
            // Konten utama halaman
            Expanded(
              child:
                  _isLoading
                      ? const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primary,
                        ),
                      )
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

  // Fungsi untuk membuat dekorasi card yang dapat digunakan kembalidi beberapa widget dengan tampilan yang konsisten
  BoxDecoration _cardDecoration({double radius = 16}) {
    return BoxDecoration(
      // Menentukan warna latar belakang card
      color: AppColors.card,

      // Mengatur tingkat kelengkungan sudut card
      borderRadius: BorderRadius.circular(radius),

      // Menambahkan efek bayangan agar card terlihat lebih menonjol
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.06),
          blurRadius: 9,
          offset: const Offset(0, 3),
        ),
      ],
    );
  }

  // header halaman dengan tombol kembali dan judul
  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Row(
        children: [
          // Tombol kembali
          InkWell(
            onTap: () => Navigator.pop(context),
            borderRadius: BorderRadius.circular(20),
            child: const Icon(
              Icons.chevron_left_rounded,
              size: 30,
              color: AppColors.textPrimary,
            ),
          ),

          const SizedBox(width: 8),

          // Judul halaman
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Profile Saya',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Poppins',
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Informasi akun dan kelas yang diampu',
                  style: TextStyle(
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
    );
  }

  // Card avatar, nama, dan badge role guru
  Widget _buildAvatarCard() {
    final peran = _peranUtama;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 26, horizontal: 16),
      decoration: _cardDecoration(radius: 18),
      child: Column(
        children: [
          // avatar guru
          Container(
            width: 76,
            height: 76,
            decoration: const BoxDecoration(
              color: AppColors.softPrimary,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.person_outline_rounded,
              size: 38,
              color: AppColors.primary,
            ),
          ),

          const SizedBox(height: 12),
          // nama guru
          Text(
            _profile?.nama ?? '-',
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              fontFamily: 'Poppins',
              color: AppColors.textPrimary,
            ),
          ),

          const SizedBox(height: 8),

          // badge role guru
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
            decoration: BoxDecoration(
              color: AppColors.softPrimary,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              peran,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                fontFamily: 'Poppins',
                color: AppColors.primary,
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
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // judul
          const Text(
            'Informasi Akun',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              fontFamily: 'Poppins',
              color: AppColors.textPrimary,
            ),
          ),

          const SizedBox(height: 14),

          // nama guru
          _buildInfoRow(
            icon: Icons.person_outline_rounded,
            label: 'Nama',
            value: _profile?.nama ?? '-',
          ),

          const Divider(height: 18, thickness: 0.5, color: Color(0xFFE2DDD3)),

          // email guru
          _buildInfoRow(
            icon: Icons.email_outlined,
            label: 'Email',
            value: _profile?.email ?? '-',
          ),

          const Divider(height: 18, thickness: 0.5, color: Color(0xFFE2DDD3)),

          // no. hp guru
          _buildInfoRow(
            icon: Icons.phone_outlined,
            label: 'No. HP',
            value: _profile?.noHp ?? '-',
          ),

          const Divider(height: 18, thickness: 0.5, color: Color(0xFFE2DDD3)),

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
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: AppColors.softPrimary,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 17, color: AppColors.primary),
        ),

        const SizedBox(width: 12),

        // Label informasi
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.textSecondary,
            fontFamily: 'Poppins',
          ),
        ),

        const Spacer(),
        // Value informasi
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.right,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              fontFamily: 'Poppins',
              color: AppColors.textPrimary,
            ),
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
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // judul
          const Text(
            'Kelas yang Diampu',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              fontFamily: 'Poppins',
              color: AppColors.textPrimary,
            ),
          ),

          const SizedBox(height: 14),

          // kelas yang diampu guru
          if (_kelasList.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.softCard,
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Text(
                'Belum ada kelas yang diampu',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                  fontFamily: 'Poppins',
                ),
              ),
            )
          else
            ..._kelasList.map(
              (k) => Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.softCard,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.card,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.groups_2_outlined,
                        size: 21,
                        color: AppColors.primary,
                      ),
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Nama kelas
                          Text(
                            k.namaKelas,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'Poppins',
                              color: AppColors.textPrimary,
                            ),
                          ),

                          const SizedBox(height: 3),
                          // Role dan periode
                          Text(
                            '${k.peranGuru} · ${k.periode}',
                            style: const TextStyle(
                              fontSize: 11,
                              color: AppColors.textSecondary,
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
        ],
      ),
    );
  }

  // Tombol logout akun
  Widget _buildLogoutButton(BuildContext context) {
    return GestureDetector(
      // aksi ketika tombol ditekan
      onTap: () {
        // Tampilkan dialog konfirmasi sebelum logout
        showDialog(
          context: context,
          builder:
              (ctx) => AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                title: const Text(
                  'Konfirmasi Logout',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Poppins',
                  ),
                ),
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
                    onPressed: () => Navigator.pop(ctx),
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
                    onPressed: () async {
                      Navigator.pop(ctx);
                      await AuthService().logout();
                      if (!mounted) return;
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (_) => const LoginPage()),
                        (route) => false,
                      );
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
      child: Container(
        width: double.infinity,
        height: 52,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.accent, width: 1),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // icon dan text logout
            Icon(Icons.logout_rounded, size: 20, color: AppColors.primary),
            SizedBox(width: 10),
            Text(
              'Logout',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                fontFamily: 'Poppins',
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
