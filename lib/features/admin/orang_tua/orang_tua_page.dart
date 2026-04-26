import 'package:flutter/material.dart';

// Halaman untuk menampilkan dan mengelola data orang tua
class OrangTuaPage extends StatelessWidget {
  const OrangTuaPage({super.key});

  // Fungsi untuk membuat kartu data orang tua
  Widget buildOrangTuaCard({
    required String nama,
    required String email,
    required String noHp,
    required String status,
  }) {
    return Container(
      // Memberi jarak antar kartu
      margin: const EdgeInsets.only(bottom: 18),

      // Memberi ruang di dalam kartu
      padding: const EdgeInsets.all(14),

      // Mengatur tampilan kartu seperti warna, sudut melengkung, dan bayangan
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
          // Menampilkan nama orang tua sebagai judul utama kartu
          Text(
            nama,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              fontFamily: 'Poppins',
            ),
          ),

          const SizedBox(height: 6),

          // Menampilkan email orang tua
          Text('Email: $email', style: const TextStyle(fontFamily: 'Poppins')),

          // Menampilkan nomor HP orang tua
          Text('No HP: $noHp', style: const TextStyle(fontFamily: 'Poppins')),

          // Menampilkan status orang tua
          Text(
            'Status: $status',
            style: const TextStyle(fontFamily: 'Poppins'),
          ),

          const SizedBox(height: 10),

          // Tombol edit diletakkan di kanan bawah kartu
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(
                height: 30,
                child: ElevatedButton(
                  // aksi saat tombol edit di tekan
                  onPressed: () {},

                  // Mengatur tampilan tombol edit
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD9D4D4),
                    foregroundColor: Colors.black,
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),

                  child: const Text(
                    'Edit',
                    style: TextStyle(fontSize: 12, fontFamily: 'Poppins'),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

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
          'Kelola Data Orang Tua',
          style: TextStyle(color: Colors.black),
        ),
      ),

      // Isi halaman
      body: Padding(
        // Memberi jarak isi dari tepi layar
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
        child: Column(
          children: [
            // Tombol tambah orang tua diletakkan di kanan atas
            Align(
              alignment: Alignment.centerRight,
              child: SizedBox(
                height: 38,
                child: ElevatedButton(
                  // aksi saat tombol tambah di tekan
                  onPressed: () {},

                  // Mengatur tampilan tombol tambah
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD9D4D4),
                    foregroundColor: Colors.black,
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),

                  child: const Text(
                    'Tambah Orang Tua',
                    style: TextStyle(fontFamily: 'Poppins'),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            Expanded(
              child: ListView(
                children: [
                  // Menampilkan data orang tua pertama
                  buildOrangTuaCard(
                    nama: 'Shofiyah',
                    email: 'shofiyah@gmail.com',
                    noHp: '081234567890',
                    status: 'Aktif',
                  ),

                  // Menampilkan data orang tua kedua
                  buildOrangTuaCard(
                    nama: 'Ahmad',
                    email: 'ahmad@gmail.com',
                    noHp: '081298765432',
                    status: 'Aktif',
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
