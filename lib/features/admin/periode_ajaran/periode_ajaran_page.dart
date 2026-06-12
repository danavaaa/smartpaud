import 'package:flutter/material.dart';
import 'periode_ajaran_form_page.dart';
import 'periode_ajaran_model.dart';
import 'periode_ajaran_service.dart';
import '../../../core/theme/app_colors.dart';

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
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
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
              Icons.calendar_month_outlined,
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
                  item.tahunAjaran,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Poppins',
                    color: AppColors.textPrimary,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  item.semester,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Poppins',
                    color: AppColors.textPrimary,
                  ),
                ),

                const SizedBox(height: 6),

                Row(
                  children: [
                    const Icon(
                      Icons.date_range_outlined,
                      size: 14,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      child: Text(
                        '${item.tanggalMulai} s/d ${item.tanggalSelesai}',
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
              onPressed: () => goToForm(item: item),
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

  Widget _buildStatusBadge(bool isActive) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isActive ? AppColors.successBg : AppColors.dangerBg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        isActive ? 'Aktif' : 'Tidak Aktif',
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          fontFamily: 'Poppins',
          color: isActive ? AppColors.successText : AppColors.dangerText,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // tombol kembali ke halaman sebelumnya
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
                        // judul halaman
                        Text(
                          'Kelola Periode Ajaran',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Poppins',
                            color: AppColors.textPrimary,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Atur tahun ajaran dan status periode aktif',
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
                  onPressed: () => goToForm(),
                  icon: const Icon(Icons.add_rounded, size: 20),
                  label: const Text('Tambah Periode'),
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
              // daftar periode ajaran
              Expanded(
                child:
                    // jika sedang loading, tampilkan indikator loading
                    isLoading
                        ? const Center(
                          child: CircularProgressIndicator(
                            color: AppColors.primary,
                          ),
                        )
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
