import 'package:flutter/material.dart';
import '../../auth/login_page.dart';
import 'profile_ortu_model.dart';
import 'profile_ortu_service.dart';
import '../../../services/user_session.dart';
import '../../../services/auth_service.dart';
import '../../../core/theme/app_colors.dart';

class ProfileOrtuPage extends StatefulWidget {
  const ProfileOrtuPage({super.key});

  @override
  State<ProfileOrtuPage> createState() => _ProfileOrtuPageState();
}

// State untuk halaman ProfileOrtuPage
class _ProfileOrtuPageState extends State<ProfileOrtuPage> {
  // Membuat object service untuk mengambil data dari Supabase
  final _service = ProfileOrtuService();

  // Menyimpan data profil orang tua (nullable karena awalnya belum ada data)
  ProfileOrtuModel? _profile;

  // Menyimpan daftar data anak (awal kosong)
  List<AnakProfileModel> _anakList = [];

  // Status loading, default true karena data belum dimuat
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    // Saat halaman pertama kali dibuka,otomatis panggil function untuk load data profil
    _loadProfile();
  }

  // Load data profil orang tua dan daftar anak dari database
  Future<void> _loadProfile() async {
    // Tampilkan loading sebelum mulai ambil data
    setState(() => _isLoading = true);

    try {
      // Ambil idUser yang sedang login dari UserSession
      final userId = UserSession().idUser ?? '';
      // Ambil data profilorang tua berdasarkan idUser
      final profile = await _service.getProfile(userId);

      // Ambil id_orang_tua dari UserSession
      final idOrangTua = UserSession().idOrangTua;

      // Siapkan list data anak
      List<AnakProfileModel> anak = [];

      // Kalau id_orang_tua ada, ambil daftar anak
      if (idOrangTua != null) {
        anak = await _service.getAnakList(idOrangTua);
      }

      // Update state setelah semua data berhasil diambil
      setState(() {
        _profile = profile; // simpan data profil ke state
        _anakList = anak; // simpan daftar anak ke state
        _isLoading = false; // matikan loading
      });
    } catch (e) {
      // Kalau error, matikan loading
      setState(() => _isLoading = false);

      // Cek apakah widget masih ada di tree sebelum show SnackBar
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Gagal memuat profil: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Warna background
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // header
            _buildHeader(context),
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
                            _buildLogoutButton(),
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

  // Widget header yang menampilkan tombol kembali, judul halaman,dan deskripsi singkat mengenai profil pengguna
  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Row(
        children: [
          // Tombol untuk kembali ke halaman sebelumnya
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

          // Menampilkan judul dan keterangan halaman profil
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Judul halaman
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

                // Deskripsi singkat mengenai isi halaman
                Text(
                  'Informasi akun dan data anak',
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

  // card avatar
  Widget _buildAvatarCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 26, horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          // Avatar icon
          Container(
            width: 78,
            height: 78,
            decoration: BoxDecoration(
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

          // Nama
          Text(
            _profile?.nama ?? '-',
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              fontFamily: 'Poppins',
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 7),

          // Badge role
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
            decoration: BoxDecoration(
              color: AppColors.softPrimary,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'Orang Tua',
              style: TextStyle(
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

  // Card Informasi Akun
  Widget _buildInfoAkunCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, 3),
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
              fontSize: 14,
              fontWeight: FontWeight.w700,
              fontFamily: 'Poppins',
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 14),
          // Baris informasi nama
          _buildInfoRow(
            icon: Icons.person_outline_rounded,
            label: 'Nama',
            value: _profile?.nama ?? '-',
          ),
          const Divider(height: 18, thickness: 0.5),
          // Baris informasi email
          _buildInfoRow(
            icon: Icons.email_outlined,
            label: 'Email',
            value: _profile?.email ?? '-',
          ),
          const Divider(height: 18, thickness: 0.5),
          // Baris informasi No Hp
          _buildInfoRow(
            icon: Icons.phone_outlined,
            label: 'No. HP',
            value: _profile?.noHp ?? '-',
          ),
          const Divider(height: 18, thickness: 0.5),
          // Baris informasi status akun
          _buildInfoRow(
            icon: Icons.verified_outlined,
            label: 'Status',
            value: _profile?.statusText ?? '-',
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
        Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: AppColors.softPrimary,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 16, color: AppColors.primary),
        ),

        const SizedBox(width: 10),
        // Label field
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.textSecondary,
            fontFamily: 'Poppins',
          ),
        ),
        const Spacer(),
        // Isi field
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.right,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
              fontFamily: 'Poppins',
            ),
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
        color: AppColors.card,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, 3),
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
              fontSize: 14,
              fontWeight: FontWeight.w700,
              fontFamily: 'Poppins',
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 14),
          // Cek apakah daftar anak kosong, jika kosong, tampilkan teks informasi ke user
          if (_anakList.isEmpty)
            const Text(
              'Belum ada data anak',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
                fontFamily: 'Poppins',
              ),
            )
          else
            ..._anakList.map(
              (anak) => Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.softCard,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    // Avatar inisial anak
                    CircleAvatar(
                      radius: 18,
                      backgroundColor: AppColors.card,
                      child: Text(
                        anak.inisial, // ambil inisial nama anak
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),

                    // Nama, kelas dan periode
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            anak.nama,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                              fontFamily: 'Poppins',
                            ),
                          ),
                          const SizedBox(height: 2),

                          // info kelas dan periode
                          Text(
                            '${anak.namaKelas} · ${anak.periode}',
                            style: const TextStyle(
                              fontSize: 11,
                              color: AppColors.textSecondary,
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
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color:
                            anak.isActive
                                ? AppColors.successBg
                                : AppColors.dangerBg,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        anak.statusText,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Poppins',
                          color:
                              anak.isActive
                                  ? AppColors.successText
                                  : AppColors.dangerText,
                        ),
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

  // Tombol Logout
  Widget _buildLogoutButton() {
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
                    color: AppColors.textSecondary,
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
                        color: AppColors.textSecondary,
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
                      ); // pindah ke halaman login dan hapus semua halaman sebelumny
                    },
                    child: const Text(
                      'Logout',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        color: AppColors.dangerText,
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
        padding: const EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.accent, width: 1),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.logout_rounded, size: 18, color: AppColors.textPrimary),
            SizedBox(width: 8),
            Text(
              'LogOut',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                fontFamily: 'Poppins',
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
