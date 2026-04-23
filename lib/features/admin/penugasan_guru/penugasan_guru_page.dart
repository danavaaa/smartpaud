import 'package:flutter/material.dart';
import 'penugasan_guru_form_page.dart';

// Halaman untuk menampilkan dan mengelola daftar penugasan guru
class PenugasanGuruPage extends StatelessWidget {
  const PenugasanGuruPage({super.key});

  // Fungsi untuk membuat kartu data penugasan guru
  Widget buildPenugasanCard({
    required String namaGuru,
    required String kelas,
    required String peran,
    required String status,
    required String periode,
    required BuildContext context,
  }) {
    return Container(
      // Memberi jarak antar kartu
      margin: const EdgeInsets.only(bottom: 18),

      // Memberi ruang di dalam kartu
      padding: const EdgeInsets.all(14),

      // Mengatur tampilan kartu seperti warna, sudut, dan bayangan
      decoration: BoxDecoration(
        color: const Color(0xFFF7F4F4),
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.14),
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Menampilkan nama guru sebagai judul utama
          Text(
            namaGuru,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
          ),

          const SizedBox(height: 6),

          // Menampilkan informasi kelas
          Text('Kelas: $kelas'),

          // Menampilkan peran guru
          Text('Peran: $peran'),

          // Menampilkan status penugasan
          Text('Status: $status'),

          const SizedBox(height: 10),

          // Tombol edit diletakkan di kanan bawah kartu
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(
                height: 30,
                child: ElevatedButton(
                  // Fungsi tombol edit
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (_) => PenugasanGuruFormPage(
                              namaGuru: namaGuru,
                              namaKelas: kelas,
                              periode: periode,
                              peran: peran,
                              isActive: status == 'Aktif',
                            ),
                      ),
                    );
                  },

                  // Mengatur tampilan tombol edit
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD9D4D4),
                    foregroundColor: Colors.black,
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    textStyle: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  child: const Text('Edit'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Tampilan utama halaman penugasan guru
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Warna latar belakang halaman
      backgroundColor: const Color(0xFFDCE5E8),

      // AppBar di bagian atas halaman
      appBar: AppBar(
        backgroundColor: const Color(0xFFDCE5E8),
        elevation: 0,
        scrolledUnderElevation: 0,

        // Mengatur warna ikon menjadi hitam
        iconTheme: const IconThemeData(color: Colors.black),

        // Judul halaman
        title: const Text(
          'Penugasan Guru',
          style: TextStyle(color: Colors.black),
        ),
      ),

      // Isi halaman
      body: Padding(
        // Memberi jarak isi dari tepi layar
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),

        child: Column(
          children: [
            // Tombol tambah penugasan diletakkan di kanan atas
            Align(
              alignment: Alignment.centerRight,
              child: SizedBox(
                height: 38,
                child: ElevatedButton(
                  // Fungsi tombol tambah penugasan
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const PenugasanGuruFormPage(),
                      ),
                    );
                  },

                  // Mengatur tampilan tombol
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD9D4D4),
                    foregroundColor: Colors.black,
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),

                  child: const Text('Tambah Penugasan'),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Expanded digunakan agar ListView mengisi sisa ruang
            Expanded(
              child: ListView(
                children: [
                  // Data dummy penugasan guru pertama
                  buildPenugasanCard(
                    namaGuru: 'Sri Rahmawati',
                    kelas: 'Kelas A1',
                    peran: 'Wali Kelas',
                    status: 'Aktif',
                    periode: '2024-2025',
                    context: context,
                  ),

                  // Data dummy penugasan guru kedua
                  buildPenugasanCard(
                    namaGuru: 'Endang Purwati',
                    kelas: 'Kelas A2',
                    peran: 'Guru Pendamping',
                    status: 'Aktif',
                    periode: '2024-2025',
                    context: context,
                  ),

                  // Data dummy penugasan guru ketiga
                  buildPenugasanCard(
                    namaGuru: 'Santi Wulandari',
                    kelas: 'Kelas B1',
                    peran: 'Wali Kelas',
                    status: 'Tidak Aktif',
                    periode: '2024-2025',
                    context: context,
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
