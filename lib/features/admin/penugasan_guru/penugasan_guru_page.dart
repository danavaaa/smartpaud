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

  // Fungsi untuk membuat kartu data penugasan guru
  Widget buildPenugasanCard({
    required PenugasanGuruModel item,
    required BuildContext context,
  }) {
    return Container(
      // Memberi jarak antar kartu
      margin: const EdgeInsets.only(bottom: 14),

      // Memberi ruang di dalam kartu
      padding: const EdgeInsets.all(16),

      // Mengatur tampilan kartu seperti warna, sudut, dan bayangan
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
              Icons.assignment_ind_outlined,
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
                  item.namaGuru,
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

                const SizedBox(height: 4),

                Row(
                  children: [
                    const Icon(
                      Icons.badge_outlined,
                      size: 14,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      child: Text(
                        item.peran,
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
              // Fungsi tombol edit
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

  // Tampilan utama halaman penugasan guru
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Warna latar belakang halaman
      backgroundColor: AppColors.background,

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
                          'Penugasan Guru',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Poppins',
                            color: AppColors.textPrimary,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Atur guru, kelas, dan peran penugasan',
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
                  // Fungsi tombol tambah penugasan
                  onPressed: () => goToForm(),
                  icon: const Icon(Icons.add_rounded, size: 20),
                  label: const Text('Tambah Penugasan'),

                  // Mengatur tampilan tombol
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
                    isLoading
                        ? const Center(
                          child: CircularProgressIndicator(
                            color: AppColors.primary,
                          ),
                        )
                        : dataList.isEmpty
                        ? const Center(
                          child: Text(
                            'Belum ada data penugasan',
                            style: TextStyle(fontFamily: 'Poppins'),
                          ),
                        )
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
      ),
    );
  }
}
