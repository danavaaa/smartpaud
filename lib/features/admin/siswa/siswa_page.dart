import 'package:flutter/material.dart';
import 'siswa_form_page.dart';
import 'siswa_model.dart';
import 'siswa_service.dart';
import '../../../core/theme/app_colors.dart';

// Halaman untuk menampilkan dan mengelola data siswa
class SiswaPage extends StatefulWidget {
  const SiswaPage({super.key});

  @override
  State<SiswaPage> createState() => _SiswaPageState();
}

// State untuk halaman SiswaPage
class _SiswaPageState extends State<SiswaPage> {
  final _service = SiswaService();

  // List untuk menyimpan seluruh data siswa
  List<SiswaModel> dataList = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    // Saat halaman pertama kali dibuka, langsung ambil data siswa dari database

    fetchData();
  }

  // Fungsi untuk mengambil seluruh data siswa
  Future<void> fetchData() async {
    try {
      // Mengaktifkan loading sebelum proses ambil data dimulai
      setState(() => isLoading = true);

      // Memanggil service untuk mengambil semua data siswa
      final result = await _service.getAllSiswa();

      if (!mounted) return;

      // Menyimpan data hasil query ke dalam dataList
      setState(() => dataList = result);
    } catch (e) {
      // Jika terjadi error saat mengambil data, tampilkan pesan gagal ke user
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal mengambil data siswa: $e')));
    } finally {
      // Setelah proses selesai, matikan loading
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  // Fungsi untuk pindah ke halaman form siswa
  Future<void> goToForm({SiswaModel? item}) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (_) => SiswaFormPage(
              id: item?.id,
              nama: item?.namaSiswa,
              idKelas: item?.idKelas,
              isActive: item?.isActive,
              idOrangTua: item?.idOrangTua,
              tempatLahir: item?.tempatLahir,
              tanggalLahir: item?.tanggalLahir,
              jenisKelamin: item?.jenisKelamin,
            ),
      ),
    );

    if (result == true) fetchData();
  }

  // Fungsi untuk membuat kartu data siswa
  Widget buildSiswaCard(SiswaModel item, BuildContext context) {
    return Container(
      // Memberi jarak antar kartu
      margin: const EdgeInsets.only(bottom: 18),

      // Memberi ruang di dalam kartu
      padding: const EdgeInsets.all(14),

      // Mengatur tampilan kartu seperti warna, sudut melengkung, dan bayangan
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
          // Menampilkan nama siswa sebagai judul utama kartu
          Text(
            item.namaSiswa,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              fontFamily: 'Poppins',
            ),
          ),

          const SizedBox(height: 6),

          // Menampilkan kelas siswa
          Text(
            'Kelas: ${item.namaKelas}',
            style: const TextStyle(fontFamily: 'Poppins'),
          ),

          // Menampilkan status siswa
          Text(
            'Status: ${item.isActive ? "Aktif" : "Tidak Aktif"}',
            style: const TextStyle(fontFamily: 'Poppins'),
          ),

          const SizedBox(height: 10),

          // Tombol edit
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(
                height: 30,
                child: ElevatedButton(
                  // aksi saat tombol edit di tekan
                  onPressed: () => goToForm(item: item),

                  // Mengatur tampilan tombol edit
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.softPrimary,
                    foregroundColor: AppColors.primaryDark,
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
          'Kelola Data Siswa',
          style: TextStyle(color: Colors.black),
        ),
      ),

      // Isi halaman
      body: Padding(
        // Memberi jarak isi dari tepi layar
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
        child: Column(
          children: [
            // Tombol tambah siswa
            Align(
              alignment: Alignment.centerRight,
              child: SizedBox(
                height: 38,
                child: ElevatedButton(
                  // aksi saat tombol tambah di tekan
                  onPressed: () => goToForm(),

                  // Mengatur tampilan tombol tambah
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.softPrimary,
                    foregroundColor: AppColors.primaryDark,
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),

                  child: const Text(
                    'Tambah Siswa',
                    style: TextStyle(fontFamily: 'Poppins'),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            Expanded(
              child:
                  isLoading // Jika sedang memuat data, tampilkan indikator loading
                      ? const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primary,
                        ),
                      )
                      : dataList
                          .isEmpty // Jika tidak ada data siswa, tampilkan pesan kosong
                      ? const Center(child: Text('Belum ada data siswa'))
                      : RefreshIndicator(
                        // Jika ada data siswa, tampilkan dalam bentuk list dengan fitur pull-to-refresh
                        onRefresh: fetchData,
                        child: ListView.builder(
                          itemCount: dataList.length,
                          itemBuilder: (context, index) {
                            return buildSiswaCard(dataList[index], context);
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
