import 'package:flutter/material.dart';
import 'periode_ajaran_form_page.dart';
import 'periode_ajaran_model.dart';
import 'periode_ajaran_service.dart';

// halaman untuk menampilkan daftar periode ajaran
class PeriodeAjaranPage extends StatefulWidget {
  const PeriodeAjaranPage({super.key});

  @override
  State<PeriodeAjaranPage> createState() => _PeriodeAjaranPageState();
}

// state untuk halaman periode ajaran
// berisi data dummy dan fungsi navigasi ke form tambah/edit periode ajaran
class _PeriodeAjaranPageState extends State<PeriodeAjaranPage> {
  final _service = PeriodeAjaranService();
  // data dummy untuk menampilkan daftar periode ajaran
  List<PeriodeAjaranModel> dataList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  // fungsi untuk mengambil data periode ajaran dari service
  Future<void> fetchData() async {
    try {
      setState(() => isLoading = true);
      final result = await _service.getAllPeriodeAjaran();
      if (!mounted) return;
      setState(() => dataList = result);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal mengambil data: $e')));
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  // fungsi untuk navigasi ke halaman form tambah/edit periode ajaran
  Future<void> goToForm({PeriodeAjaranModel? item}) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => PeriodeAjaranFormPage(periode: item)),
    );
    // jika result true, berarti data berhasil disimpan dan perlu refresh data
    if (result == true) {
      fetchData();
    }
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
              style: const TextStyle(
                color: Colors.black,
                fontSize: 12,
                fontFamily: 'Poppins',
              ),
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
                  Text(item.semester),
                  Text(item.tanggalMulai),
                  Text(item.tanggalSelesai),
                  Text('Status: ${item.isActive ? 'Aktif' : 'Tidak Aktif'}'),
                ],
              ),
            ),
          ),
          // tombol edit
          const SizedBox(width: 8),
          Column(
            children: [
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
              // daftar periode ajaran
              Expanded(
                child:
                    // jika sedang loading, tampilkan indikator loading
                    isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : dataList.isEmpty
                        ? const Center(
                          // jika tidak ada data, tampilkan pesan kosong
                          child: Text(
                            'Tidak ada data periode ajaran',
                            style: TextStyle(fontFamily: 'Poppins'),
                          ),
                        )
                        : RefreshIndicator(
                          onRefresh: fetchData,
                          child: ListView.builder(
                            itemCount: dataList.length,
                            itemBuilder: (context, index) {
                              return buildPeriodCard(dataList[index]);
                            },
                          ),
                        ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
