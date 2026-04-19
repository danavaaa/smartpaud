import 'package:flutter/material.dart';

class PeriodeAjaranPage extends StatelessWidget {
  const PeriodeAjaranPage({super.key});
  // fungsi untuk menampilkan dan mengelola daftar periode ajaran
  Widget buildPeriodCard({
    required String tahunAjaran,
    required String semester,
    required String tanggalMulai,
    required String tanggalSelesai,
    required String status,
  }) {
    // jarak antar kartu
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(14),
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
      // isi card periode ajaran
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            tahunAjaran,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 6),
          Text('Semester: $semester'),
          Text('Mulai: $tanggalMulai'),
          Text('Selesai: $tanggalSelesai'),
          Text('Status: $status'),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFDCE5E8),
      appBar: AppBar(
        backgroundColor: const Color(0xFFDCE5E8),
        elevation: 0,
        scrolledUnderElevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          'Kelola Periode Ajaran',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: SizedBox(
                height: 38,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD9D4D4),
                    foregroundColor: Colors.black,
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text('Tambah Periode'),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: [
                  buildPeriodCard(
                    tahunAjaran: '2024/2025',
                    semester: 'Ganjil',
                    tanggalMulai: '15 Juli 2024',
                    tanggalSelesai: '20 Des 2024',
                    status: 'Aktif',
                  ),
                  buildPeriodCard(
                    tahunAjaran: '2024/2025',
                    semester: 'Genap',
                    tanggalMulai: '6 Jan 2025',
                    tanggalSelesai: '20 Juni 2025',
                    status: 'Tidak Aktif',
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
