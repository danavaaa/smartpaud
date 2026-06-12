import 'package:flutter/material.dart';
import 'kelas_form_page.dart';
import 'kelas_model.dart';
import 'kelas_service.dart';
import '../../../core/theme/app_colors.dart';

// Halaman untuk menampilkan dan mengelola daftar kelas
class KelasPage extends StatefulWidget {
  const KelasPage({super.key});

  @override
  State<KelasPage> createState() => _KelasPageState();
}

// State untuk halaman KelasPage
class _KelasPageState extends State<KelasPage> {
  final _service = KelasService();
  // List untuk menyimpan data kelas yang diambil dari server
  List<KelasModel> dataList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  // Fungsi untuk mengambil data kelas dari server
  Future<void> fetchData() async {
    try {
      setState(() => isLoading = true);
      final result = await _service.getAllKelas();
      if (!mounted) return;
      setState(() => dataList = result);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
        // Menampilkan pesan error jika gagal mengambil data kelas
      ).showSnackBar(SnackBar(content: Text('Gagal mengambil data kelas: $e')));
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  // Fungsi untuk membuka halaman form kelas, baik untuk tambah maupun edit
  Future<void> goToForm({KelasModel? item}) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        // Membuka halaman form kelas, mengirim data kelas jika untuk edit
        builder:
            (_) => KelasFormPage(
              id: item?.id,
              // Mengirim data kelas yang akan diedit, jika ada
              namaKelas: item?.namaKelas,
              idPeriode: item?.idPeriode,
              isActive: item?.isActive,
            ),
      ),
    );
    // jika hasil dari halaman form adalah true, maka refresh data kelas untuk menampilkan perubahan terbaru
    if (result == true) {
      fetchData();
    }
  }

  // Fungsi untuk membuat kartu data kelas
  Widget buildKelasCard(KelasModel item) {
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
          // Menampilkan nama kelas sebagai judul utama
          Text(
            item.namaKelas,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
          ),

          const SizedBox(height: 6),

          // Menampilkan informasi periode ajaran
          Text('Periode Ajaran: ${item.periodeAjaran}'),

          // Menampilkan status kelas
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

  // tampilan utama halaman kelas
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

                  child: const Text('Tambah Kelas'),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Expanded digunakan agar ListView mengisi sisa ruang
            Expanded(
              child:
                  isLoading
                      ? const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primary,
                        ),
                      )
                      : dataList.isEmpty
                      // Menampilkan pesan jika tidak ada data kelas
                      ? const Center(child: Text('Belum ada data kelas'))
                      : RefreshIndicator(
                        onRefresh: fetchData,
                        child: ListView.builder(
                          itemCount: dataList.length,
                          itemBuilder: (context, index) {
                            return buildKelasCard(dataList[index]);
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
