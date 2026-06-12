import 'package:flutter/material.dart';
import 'penugasan_guru_form_page.dart';
import 'penugasan_guru_model.dart';
import 'penugasan_guru_service.dart';
import '../../../core/theme/app_colors.dart';

// Halaman untuk menampilkan dan mengelola daftar penugasan guru
class PenugasanGuruPage extends StatefulWidget {
  const PenugasanGuruPage({super.key});

  @override
  State<PenugasanGuruPage> createState() => _PenugasanGuruPageState();
}

// State untuk halaman PenugasanGuruPage
class _PenugasanGuruPageState extends State<PenugasanGuruPage> {
  final _service = PenugasanGuruService();

  // List untuk menyimpan seluruh data penugasan guru
  List<PenugasanGuruModel> dataList = [];

  // Penanda apakah halaman sedang memuat data
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    fetchData();
  }

  // Fungsi untuk mengambil seluruh data penugasan guru
  Future<void> fetchData() async {
    try {
      // Mengaktifkan loading sebelum proses ambil data dimulai
      setState(() => isLoading = true);

      // Memanggil service untuk mengambil semua data penugasan guru
      final result = await _service.getAllPenugasanGuru();

      // Cek apakah widget masih aktif sebelum memanggil setState
      if (!mounted) return;

      // Menyimpan data hasil query ke dalam dataList
      setState(() => dataList = result);
    } catch (e) {
      // Jika terjadi error saat mengambil data,
      // tampilkan pesan gagal ke user
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mengambil data penugasan: $e')),
      );
    } finally {
      // Setelah proses selesai, matikan loading
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  // Fungsi untuk pindah ke halaman form penugasan guru
  // Jika item ada, form digunakan untuk edit
  // Jika item null, form digunakan untuk tambah data baru
  Future<void> goToForm({PenugasanGuruModel? item}) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (_) => PenugasanGuruFormPage(
              id: item?.id,
              idGuru: item?.idGuru,
              idKelas: item?.idKelas,
              peran: item?.peran,
              isActive: item?.isActive,
            ),
      ),
    );

    if (result == true) {
      fetchData();
    }
  }

  // Fungsi untuk membuat kartu data penugasan guru
  Widget buildPenugasanCard({
    required PenugasanGuruModel item,
    required BuildContext context,
  }) {
    return Container(
      // Memberi jarak antar kartu
      margin: const EdgeInsets.only(bottom: 18),

      // Memberi ruang di dalam kartu
      padding: const EdgeInsets.all(14),

      // Mengatur tampilan kartu seperti warna, sudut, dan bayangan
      decoration: BoxDecoration(
        color: AppColors.card,
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
            item.namaGuru,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
          ),

          const SizedBox(height: 6),

          // Menampilkan informasi kelas
          Text('Kelas: ${item.namaKelas}'),

          // Menampilkan peran guru
          Text('Peran: ${item.peran}'),

          // Menampilkan status penugasan
          Text('Status: ${item.isActive ? 'Aktif' : 'Tidak Aktif'}'),

          const SizedBox(height: 10),

          // Tombol edit diletakkan di kanan bawah kartu
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(
                height: 30,
                child: ElevatedButton(
                  // Fungsi tombol edit
                  onPressed: () => goToForm(item: item),

                  // Mengatur tampilan tombol edit
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.softPrimary,
                    foregroundColor: AppColors.primaryDark,
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
      backgroundColor: AppColors.background,

      // AppBar di bagian atas halaman
      appBar: AppBar(
        backgroundColor: AppColors.background,
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
                  onPressed: () => goToForm(),

                  // Mengatur tampilan tombol
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.softPrimary,
                    foregroundColor: AppColors.primaryDark,
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

            Expanded(
              child:
                  isLoading
                      ? const Center(
                        child: CircularProgressIndicator(),
                      ) // Menampilkan indikator loading saat data sedang dimuat
                      : dataList.isEmpty
                      ? const Center(
                        child: Text('Belum ada data penugasan'),
                      ) // Menampilkan pesan jika tidak ada data penugasan
                      : RefreshIndicator(
                        onRefresh: fetchData,
                        child: ListView.builder(
                          itemCount: dataList.length,
                          itemBuilder: (context, index) {
                            return buildPenugasanCard(
                              item: dataList[index],
                              context: context,
                            );
                          },
                        ),
                      ),
            ),
          ],
        ),
      ),
    );
  }
}
