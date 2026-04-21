import 'package:supabase_flutter/supabase_flutter.dart';
import 'periode_ajaran_model.dart';

// Service untuk mengelola data periode ajaran
class PeriodeAjaranService {
  final SupabaseClient client = Supabase.instance.client;
  // Mendapatkan semua periode ajaran
  Future<List<PeriodeAjaranModel>> getAllPeriodeAjaran() async {
    // Mengambil data periode ajaran dari tabel 'periode_ajaran' dan mengurutkannya berdasarkan tanggal pembuatan terbaru
    final response = await client
        .from('periode_ajaran')
        .select()
        .order('created_at', ascending: false);
    // Mengubah data yang diterima menjadi list model PeriodeAjaranModel
    return (response as List)
        .map((item) => PeriodeAjaranModel.fromJson(item))
        .toList();
  }

  // Menambahkan periode ajaran baru
  Future<void> addPeriodeAjaran({
    required String tahunAjaran,
    required String semester,
    required String tanggalMulai,
    required String tanggalSelesai,
    required bool isActive,
  }) async {
    await client.from('periode_ajaran').insert({
      'tahun_ajaran': tahunAjaran,
      'semester': semester,
      'tanggal_mulai': tanggalMulai,
      'tanggal_selesai': tanggalSelesai,
      'is_active': isActive,
    });
  }

  // Mengedit periode ajaran yang sudah ada
  Future<void> updatePeriodeAjaran({
    required String id,
    required String tahunAjaran,
    required String semester,
    required String tanggalMulai,
    required String tanggalSelesai,
    required bool isActive,
  }) async {
    await client
        .from('periode_ajaran')
        .update({
          'tahun_ajaran': tahunAjaran,
          'semester': semester,
          'tanggal_mulai': tanggalMulai,
          'tanggal_selesai': tanggalSelesai,
          'is_active': isActive,
        })
        .eq('id', id);
  }
}
