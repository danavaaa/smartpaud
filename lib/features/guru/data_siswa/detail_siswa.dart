import 'package:flutter/material.dart';
import 'data_siswa_model.dart';

// halaman detail siswa
class DetailSiswaPage extends StatelessWidget {
  final Siswa siswa;

  const DetailSiswaPage({super.key, required this.siswa});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFDDE8EF),
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

                        // Nomor HP wali
                        _InfoRow(
                          label: 'No. HP Wali',
                          value: siswa.noHpWali,

                          // Warna khusus untuk nomor HP
                          valueColor: const Color(0xFF185FA5),
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
          GestureDetector(
            onTap: () => Navigator.pop(context),

            child: const Icon(Icons.chevron_left_rounded, size: 28),
          ),

          const SizedBox(width: 8),

          // Judul halaman
          const Text(
            'Detail Siswa',

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

  // widget card profil siswa dengan nama, NIS, status, dan avatar
  Widget _buildProfileCard() {
    // Mengecek apakah status siswa aktif
    final bool isAktif = siswa.status == 'Aktif';
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(16),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),

      child: Row(
        children: [
          // avatar siswa
          CircleAvatar(
            radius: 28,

            backgroundColor: const Color(0xFFDDE8EF),

            child: Text(
              // Menampilkan inisial siswa
              siswa.inisial,

              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Color(0xFF185FA5),
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
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Poppins',
                  ),
                ),

                const SizedBox(height: 2),

                // Nomor induk siswa
                Text(
                  'NIS · -',

                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                    fontFamily: 'Poppins',
                  ),
                ),

                const SizedBox(height: 6),

                // badge status siswa
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 3,
                  ),

                  decoration: BoxDecoration(
                    // Warna badge berdasarkan status
                    color:
                        isAktif
                            ? const Color(0xFFEAF3DE)
                            : const Color(0xFFFCEBEB),

                    borderRadius: BorderRadius.circular(20),
                  ),

                  child: Text(
                    siswa.status,

                    style: TextStyle(
                      fontSize: 11,
                      fontFamily: 'Poppins',

                      // Warna text berdasarkan status
                      color:
                          isAktif
                              ? const Color(0xFF3B6D11)
                              : const Color(0xFFA32D2D),
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
          Text(
            title,

            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              fontFamily: 'Poppins',
              color: Color(0xFF444444),
            ),
          ),

          const SizedBox(height: 12),

          // list data informasi siswa
          ...rows.asMap().entries.map((entry) {
            final index = entry.key;
            final row = entry.value;

            return Column(
              children: [
                // Widget baris info
                _buildInfoRow(row),

                if (index < rows.length - 1)
                  const Divider(height: 16, thickness: 0.5),
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
      // Label kiri & value kanan
      mainAxisAlignment: MainAxisAlignment.spaceBetween,

      children: [
        // Label informasi
        Text(
          row.label,

          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
            fontFamily: 'Poppins',
          ),
        ),

        // value informasi
        Text(
          row.value,

          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            fontFamily: 'Poppins',

            // Jika ada warna custom maka gunakan
            color: row.valueColor ?? const Color(0xFF222222),
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
