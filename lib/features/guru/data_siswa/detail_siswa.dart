import 'package:flutter/material.dart';
import 'data_siswa_model.dart';
import '../../../core/theme/app_colors.dart';

// halaman detail siswa
class DetailSiswaPage extends StatelessWidget {
  final Siswa siswa;

  const DetailSiswaPage({super.key, required this.siswa});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // header dengan tombol kembali dan judul
            _buildHeader(context),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),

                child: Column(
                  children: [
                    const SizedBox(height: 16),
                    // card profil siswa dengan nama, NIS, status, dan avatar
                    _buildProfileCard(),

                    const SizedBox(height: 14),

                    // informasi umum siswa
                    _buildInfoCard(
                      // Judul
                      title: 'Informasi Umum',

                      // list data informasi
                      rows: [
                        // kelas siswa
                        _InfoRow(label: 'Kelas', value: siswa.namaKelas),

                        // Periode ajaran
                        _InfoRow(label: 'Periode', value: siswa.periode),

                        // Tanggal lahir
                        _InfoRow(
                          label: 'Tanggal Lahir',
                          value: siswa.tanggalLahir,
                        ),

                        // Jenis kelamin
                        _InfoRow(
                          label: 'Jenis Kelamin',
                          value: siswa.jenisKelamin,
                        ),
                      ],
                    ),

                    const SizedBox(height: 14),

                    // informasi orang tua/wali siswa
                    _buildInfoCard(
                      title: 'Informasi Orang Tua / Wali',

                      rows: [
                        // Nama ayah
                        _InfoRow(label: 'Nama Ayah', value: siswa.namaAyah),

                        // Nama ibu
                        _InfoRow(label: 'Nama Ibu', value: siswa.namaIbu),

                        _InfoRow(
                          label: 'Pekerjaan',
                          value: siswa.pekerjaanWali,
                        ),
                        // Nomor HP wali
                        _InfoRow(
                          label: 'No. HP Wali',
                          value: siswa.noHpWali,

                          // Warna khusus untuk nomor HP
                          valueColor: AppColors.primary,
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // widget header dengan tombol kembali dan judul halaman
  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),

      child: Row(
        children: [
          // tombol kembali
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
                  'Detail Siswa',

                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Poppins',
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Informasi siswa dan data orang tua',
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

  //  Widget card profil siswa dengan nama, kelas, periode, status, dan avatar
  Widget _buildProfileCard() {
    // Mengecek apakah status siswa aktif
    final bool isAktif = siswa.status == 'Aktif';
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
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

      child: Row(
        children: [
          // avatar siswa
          CircleAvatar(
            radius: 34,

            backgroundColor: AppColors.softPrimary,

            child: Text(
              // Menampilkan inisial siswa
              siswa.inisial,

              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
                fontFamily: 'Poppins',
              ),
            ),
          ),

          const SizedBox(width: 16),

          // informasi siswa
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                // Nama siswa
                Text(
                  siswa.namaSiswa,

                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Poppins',
                    color: AppColors.textPrimary,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  '${siswa.namaKelas} · ${siswa.periode}',
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                    fontFamily: 'Poppins',
                  ),
                ),

                const SizedBox(height: 8),

                // badge status siswa
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),

                  decoration: BoxDecoration(
                    // Warna badge berdasarkan status
                    color: isAktif ? AppColors.successBg : AppColors.dangerBg,
                    borderRadius: BorderRadius.circular(20),
                  ),

                  child: Text(
                    siswa.status,

                    style: TextStyle(
                      fontSize: 11,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,

                      // Warna text berdasarkan status
                      color:
                          isAktif
                              ? AppColors.successText
                              : AppColors.dangerText,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // widget card informasi
  Widget _buildInfoCard({required String title, required List<_InfoRow> rows}) {
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
          Text(
            title,

            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              fontFamily: 'Poppins',
              color: AppColors.textPrimary,
            ),
          ),

          const SizedBox(height: 14),

          // list data informasi siswa
          ...rows.asMap().entries.map((entry) {
            final index = entry.key;
            final row = entry.value;

            return Column(
              children: [
                // Widget baris info
                _buildInfoRow(row),

                if (index < rows.length - 1)
                  const Divider(
                    height: 18,
                    thickness: 0.5,
                    color: Color(0xFFE2DDD3),
                  ),
              ],
            );
          }),
        ],
      ),
    );
  }

  // widget untuk membangun satu baris informasi
  Widget _buildInfoRow(_InfoRow row) {
    return Row(
      children: [
        Expanded(
          flex: 4,
          child: Text(
            row.label,

            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
              fontFamily: 'Poppins',
            ),
          ),
        ),

        const SizedBox(width: 10),

        Expanded(
          flex: 5,
          child: Text(
            row.value.isEmpty ? '-' : row.value,
            textAlign: TextAlign.right,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              fontFamily: 'Poppins',

              color: row.valueColor ?? AppColors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }
}

// Model untuk satu baris informasi pada card info
class _InfoRow {
  // Label kiri
  final String label;

  // Value kanan
  final String value;

  // Optional warna value
  final Color? valueColor;

  // Constructor
  const _InfoRow({required this.label, required this.value, this.valueColor});
}
