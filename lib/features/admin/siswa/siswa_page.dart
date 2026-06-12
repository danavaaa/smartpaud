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

  // Widget untuk menampilkan badge status aktif atau tidak aktif
  Widget _buildStatusBadge(bool isActive) {
    return Container(
      // Memberikan jarak di dalam badge agar teks terlihat rapi
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),

      // Mengatur tampilan badge
      decoration: BoxDecoration(
        // Warna latar berbeda sesuai status
        color: isActive ? AppColors.successBg : AppColors.dangerBg,

        // Membuat sudut badge menjadi melengkung
        borderRadius: BorderRadius.circular(20),
      ),

      // Menampilkan teks status
      child: Text(
        // Jika aktif tampilkan "Aktif", jika tidak tampilkan "Tidak Aktif"
        isActive ? 'Aktif' : 'Tidak Aktif',

        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          fontFamily: 'Poppins',

          // Warna teks menyesuaikan status
          color: isActive ? AppColors.successText : AppColors.dangerText,
        ),
      ),
    );
  }

  // Fungsi untuk membuat kartu data siswa
  Widget buildSiswaCard(SiswaModel item, BuildContext context) {
    return Container(
      // Memberi jarak antar kartu
      margin: const EdgeInsets.only(bottom: 14),

      // Memberi ruang di dalam kartu
      padding: const EdgeInsets.all(16),

      // Mengatur tampilan kartu seperti warna, sudut melengkung, dan bayangan
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),

      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: AppColors.softPrimary,
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.menu_book_outlined,
              color: AppColors.primary,
              size: 24,
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.namaSiswa,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Poppins',
                    color: AppColors.textPrimary,
                  ),
                ),

                const SizedBox(height: 6),

                Row(
                  children: [
                    const Icon(
                      Icons.groups_2_outlined,
                      size: 14,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      child: Text(
                        item.namaKelas,
                        style: const TextStyle(
                          fontSize: 12,
                          fontFamily: 'Poppins',
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                _buildStatusBadge(item.isActive),
              ],
            ),
          ),

          const SizedBox(width: 8),

          SizedBox(
            height: 34,
            child: ElevatedButton(
              // aksi saat tombol edit di tekan
              onPressed: () => goToForm(item: item),

              // Mengatur tampilan tombol edit
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.softPrimary,
                foregroundColor: AppColors.primary,
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                textStyle: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
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
      // Warna latar belakang halaman
      backgroundColor: AppColors.background,

      // Isi halaman
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    borderRadius: BorderRadius.circular(20),
                    child: const Icon(
                      Icons.chevron_left_rounded,
                      color: AppColors.textPrimary,
                      size: 30,
                    ),
                  ),

                  const SizedBox(width: 8),

                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Kelola Data Siswa',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Poppins',
                            color: AppColors.textPrimary,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Atur data siswa, kelas, dan status keaktifannya',
                          style: TextStyle(
                            fontSize: 11,
                            fontFamily: 'Poppins',
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                height: 46,
                child: ElevatedButton.icon(
                  // aksi saat tombol tambah di tekan
                  onPressed: () => goToForm(),
                  icon: const Icon(Icons.add_rounded, size: 20),
                  label: const Text('Tambah Siswa'),
                  // Mengatur tampilan tombol tambah
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.buttonText,
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    textStyle: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 22),

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
                        ? const Center(
                          child: Text(
                            'Belum ada data siswa',
                            style: TextStyle(fontFamily: 'Poppins'),
                          ),
                        )
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
      ),
    );
  }
}
