import 'package:flutter/material.dart';
import 'orang_tua_form_page.dart';
import 'orang_tua_model.dart';
import 'orang_tua_service.dart';

// Halaman untuk menampilkan dan mengelola data orang tua
class OrangTuaPage extends StatefulWidget {
  const OrangTuaPage({super.key});

  @override
  State<OrangTuaPage> createState() => _OrangTuaPageState();
}

// State untuk halaman OrangTuaPage
class _OrangTuaPageState extends State<OrangTuaPage> {
  // Instance service untuk mengambil dan mengelola data orang tua dari database
  final _service = OrangTuaService();

  // List untuk menyimpan seluruh data orang tua
  List<OrangTuaModel> dataList = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    // Saat halaman pertama kali dibuka, ambil data orang tua dari database
    fetchData();
  }

  // Fungsi untuk mengambil seluruh data orang tua
  Future<void> fetchData() async {
    try {
      // Mengaktifkan loading sebelum proses ambil data dimulai
      setState(() => isLoading = true);

      // Memanggil service untuk mengambil semua data orang tua
      final result = await _service.getAllOrangTua();

      if (!mounted) return;

      // Menyimpan data hasil query ke dalam dataList
      setState(() => dataList = result);
    } catch (e) {
      // Jika terjadi error saat mengambil data, tampilkan pesan gagal ke user
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mengambil data orang tua: $e')),
      );
    } finally {
      // Setelah proses selesai, matikan loading
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  // Fungsi untuk pindah ke halaman form orang tua (untuk tambah atau edit)
  Future<void> goToForm({OrangTuaModel? item}) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (_) => OrangTuaFormPage(
              idUser: item?.idUser,
              nama: item?.nama,
              email: item?.email,
              noHp: item?.noHp,
              isActive: item?.isActive,
            ),
      ),
    );

    if (result == true) {
      fetchData();
    }
  }

  // Fungsi untuk membuat kartu data orang tua
  Widget buildOrangTuaCard(OrangTuaModel item) {
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
            item.nama,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              fontFamily: 'Poppins',
            ),
          ),

          const SizedBox(height: 6),

          // Menampilkan email orang tua
          Text(
            'Email: ${item.email}',
            style: const TextStyle(fontFamily: 'Poppins'),
          ),

          // Menampilkan nomor HP orang tua
          Text(
            'No HP: ${item.noHp}',
            style: const TextStyle(fontFamily: 'Poppins'),
          ),

          // Menampilkan status orang tua
          Text(
            'Status: ${item.isActive ? 'Aktif' : 'Tidak Aktif'}',
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
                  onPressed: () => goToForm(item: item),

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

                  child: const Text(
                    'Tambah Orang Tua',
                    style: TextStyle(fontFamily: 'Poppins'),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            Expanded(
              child:
                  isLoading // Jika sedang memuat data, tampilkan indikator loading
                      ? const Center(child: CircularProgressIndicator())
                      : dataList.isEmpty
                      ? const Center(child: Text('Belum ada data orang tua'))
                      : RefreshIndicator(
                        onRefresh: fetchData,
                        child: ListView.builder(
                          itemCount: dataList.length,
                          itemBuilder: (context, index) {
                            return buildOrangTuaCard(dataList[index]);
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
