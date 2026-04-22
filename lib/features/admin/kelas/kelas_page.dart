import 'package:flutter/material.dart';
import 'kelas_form_page.dart';

// Halaman untuk menampilkan dan mengelola daftar kelas
class KelasPage extends StatelessWidget {
  const KelasPage({super.key});

  // Fungsi untuk membuat kartu data kelas
  Widget buildKelasCard({
    required String namaKelas,
    required String periodeAjaran,
    required String status,
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
          // Menampilkan nama kelas sebagai judul utama
          Text(
            namaKelas,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
          ),

          const SizedBox(height: 6),

          // Menampilkan informasi periode ajaran
          Text('Periode Ajaran: $periodeAjaran'),

          // Menampilkan status kelas
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
                            (_) => KelasFormPage(
                              namaKelas: namaKelas,
                              periodeAjaran: periodeAjaran,
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

  // tampilan utama halaman kelas
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
          'Kelola Kelas',
          style: TextStyle(color: Colors.black),
        ),
      ),

      // Isi halaman
      body: Padding(
        // Memberi jarak isi dari tepi layar
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),

        child: Column(
          children: [
            // Tombol tambah kelas diletakkan di kanan atas
            Align(
              alignment: Alignment.centerRight,
              child: SizedBox(
                height: 38,
                child: ElevatedButton(
                  // Fungsi tombol tambah kelas
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const KelasFormPage()),
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

                  child: const Text('Tambah Kelas'),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Expanded digunakan agar ListView mengisi sisa ruang
            Expanded(
              child: ListView(
                children: [
                  // Menampilkan data kelas pertama (data dummy)
                  buildKelasCard(
                    namaKelas: 'Kelas A1',
                    periodeAjaran: '2024/2025 - Semester 1',
                    status: 'Aktif',
                    context: context,
                  ),

                  // Menampilkan data kelas kedua (data dummy)
                  buildKelasCard(
                    namaKelas: 'Kelas A2',
                    periodeAjaran: '2024/2025 - Semester 2',
                    status: 'Aktif',
                    context: context,
                  ),

                  // Menampilkan data kelas ketiga
                  buildKelasCard(
                    namaKelas: 'Kelas B1',
                    periodeAjaran: '2025/2026 - Semester 1',
                    status: 'Tidak Aktif',
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
