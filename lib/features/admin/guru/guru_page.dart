import 'package:flutter/material.dart';
import 'guru_form_page.dart';
import 'guru_model.dart';
import 'guru_service.dart';

// Halaman untuk menampilkan dan mengelola data guru
class GuruPage extends StatefulWidget {
  const GuruPage({super.key});

  @override
  State<GuruPage> createState() => _GuruPageState();
}

class _GuruPageState extends State<GuruPage> {
  final _service = GuruService();

  // List untuk menyimpan seluruh data guru
  List<GuruModel> dataList = [];

  // Penanda apakah halaman sedang memuat data
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    // Saat halaman pertama kali dibuka, ambil data guru dari database
    fetchData();
  }

  // Fungsi untuk mengambil seluruh data guru
  Future<void> fetchData() async {
    try {
      // Mengaktifkan loading sebelum proses ambil data dimulai
      setState(() => isLoading = true);

      // Memanggil service untuk mengambil semua data guru
      final result = await _service.getAllGuru();

      if (!mounted) return;

      // Menyimpan data hasil query ke dalam dataList
      setState(() => dataList = result);
    } catch (e) {
      // Jika terjadi error saat mengambil data, tampilkan pesan gagal ke user
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal mengambil data guru: $e')));
    } finally {
      // Setelah proses selesai, matikan loading
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  // Fungsi untuk pindah ke halaman form guru (baik untuk tambah maupun edit)
  Future<void> goToForm({GuruModel? item}) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (_) => GuruFormPage(
              idUser: item?.idUser,
              namaGuru: item?.nama,
              email: item?.email,
              noHp: item?.noHp,
              isActive: item?.isActive ?? false,
            ),
      ),
    );

    if (result == true) {
      fetchData();
    }
  }

  // Fungsi untuk membuat kartu data guru
  Widget buildGuruCard(GuruModel item) {
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
          // Menampilkan nama guru sebagai judul utama kartu
          Text(
            item.nama,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
          ),

          const SizedBox(height: 6),

          // Menampilkan email guru
          Text('Email: ${item.email}'),

          // Menampilkan nomor HP guru
          Text('No HP: ${item.noHp}'),

          // Menampilkan status guru
          Text('Status: ${item.isActive ? "Aktif" : "Tidak Aktif"}'),

          const SizedBox(height: 10),

          // Tombol edit diletakkan di kanan bawah kartu
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(
                height: 30,
                child: ElevatedButton(
                  // tombol edit
                  onPressed: () => goToForm(item: item),

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
          'Kelola Data Guru',
          style: TextStyle(color: Colors.black),
        ),
      ),

      // Isi halaman
      body: Padding(
        // Memberi jarak isi dari tepi layar
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: SizedBox(
                height: 38,
                child: ElevatedButton(
                  // tombol tambah
                  onPressed: () => goToForm(),

                  // Mengatur tampilan tombol tambah
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD9D4D4),
                    foregroundColor: Colors.black,
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),

                  child: const Text('Tambah Guru'),
                ),
              ),
            ),

            const SizedBox(height: 20),
            // Bagian untuk menampilkan daftar guru atau indikator loading
            Expanded(
              child:
                  isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : dataList.isEmpty
                      ? const Center(child: Text('Belum ada data guru'))
                      : RefreshIndicator(
                        onRefresh: fetchData,
                        child: ListView.builder(
                          itemCount: dataList.length,
                          itemBuilder: (context, index) {
                            return buildGuruCard(dataList[index]);
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
