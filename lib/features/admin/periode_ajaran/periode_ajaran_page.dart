import 'package:flutter/material.dart';
import 'periode_ajaran_form_page.dart';
import 'periode_ajaran_model.dart';

// halaman untuk menampilkan daftar periode ajaran
class PeriodeAjaranPage extends StatefulWidget {
  const PeriodeAjaranPage({super.key});

  @override
  State<PeriodeAjaranPage> createState() => _PeriodeAjaranPageState();
}

// state untuk halaman periode ajaran
// berisi data dummy dan fungsi navigasi ke form tambah/edit periode ajaran
class _PeriodeAjaranPageState extends State<PeriodeAjaranPage> {
  final List<PeriodeAjaranModel> dataList = [
    PeriodeAjaranModel(
      id: '1',
      tahunAjaran: '2024/2025',
      semester: 'Semester 1',
      tanggalMulai: '15 Juli 2024',
      tanggalSelesai: '20 Desember 2024',
      isActive: true,
    ),
    PeriodeAjaranModel(
      id: '2',
      tahunAjaran: '2024/2025',
      semester: 'Semester 2',
      tanggalMulai: '8 Januari 2025',
      tanggalSelesai: '21 Juni 2025',
      isActive: true,
    ),
  ];
  // fungsi untuk navigasi ke halaman form tambah/edit periode ajaran
  Future<void> goToForm({PeriodeAjaranModel? item}) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => PeriodeAjaranFormPage(periode: item)),
    );
  }

  // widget untuk menampilkan card periode ajaran
  Widget buildPeriodCard(PeriodeAjaranModel item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F4F4),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: DefaultTextStyle(
              style: const TextStyle(color: Colors.black, fontSize: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.tahunAjaran,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    item.semester,
                    style: const TextStyle(fontFamily: 'Poppins'),
                  ),
                  Text(
                    item.tanggalMulai,
                    style: const TextStyle(fontFamily: 'Poppins'),
                  ),
                  Text(item.tanggalSelesai),
                  Text('Status: ${item.isActive ? 'Aktif' : 'Tidak Aktif'}'),
                ],
              ),
            ),
          ),
          // tombol edit
          const SizedBox(width: 8),
          SizedBox(
            height: 28,
            child: ElevatedButton(
              onPressed: () => goToForm(item: item),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFD9D4D4),
                foregroundColor: Colors.black,
                elevation: 3,
                padding: const EdgeInsets.symmetric(horizontal: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                textStyle: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Poppins',
                ),
              ),
              child: const Text('Edit'),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFDCE5E8),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // tombol kembali ke halaman sebelumnya
              InkWell(
                onTap: () => Navigator.pop(context),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.chevron_left, color: Colors.black),
                    SizedBox(width: 6),
                    // judul halaman
                    Text(
                      'Kelola Periode Ajaran',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              // tombol untuk menambah periode ajaran baru
              Align(
                alignment: Alignment.centerRight,
                child: SizedBox(
                  height: 34,
                  child: ElevatedButton(
                    onPressed: () => goToForm(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFD9D4D4),
                      foregroundColor: Colors.black,
                      elevation: 4,
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      textStyle: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    child: const Text('Tambah Periode'),
                  ),
                ),
              ),
              const SizedBox(height: 22),
              Expanded(
                child: ListView.builder(
                  itemCount: dataList.length,
                  itemBuilder: (context, index) {
                    return buildPeriodCard(dataList[index]);
                    // menampilkan kartu periode ajaran untuk setiap item dalam dataList
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
