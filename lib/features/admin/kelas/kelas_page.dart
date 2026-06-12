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
    final periodeText = item.periodeAjaran;

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
              Icons.groups_2_outlined,
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
                  item.namaKelas,
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
                      Icons.calendar_month_outlined,
                      size: 14,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      child: Text(
                        periodeText,
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

  // tampilan utama halaman kelas
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
                          'Kelola Kelas',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Poppins',
                            color: AppColors.textPrimary,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Atur kelas berdasarkan periode ajaran aktif',
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
                  // Fungsi tombol tambah kelas
                  onPressed: () => goToForm(),
                  icon: const Icon(Icons.add_rounded, size: 20),
                  label: const Text('Tambah Kelas'),
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
                        ? const Center(
                          child: Text(
                            'Belum ada data kelas',
                            style: TextStyle(fontFamily: 'Poppins'),
                          ),
                        )
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
      ),
    );
  }
}
