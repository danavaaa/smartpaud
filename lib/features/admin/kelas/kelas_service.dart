import 'package:supabase_flutter/supabase_flutter.dart';
import 'kelas_model.dart';

// Service untuk mengelola data kelas dari database Supabase
class KelasService {
  final SupabaseClient client = Supabase.instance.client;

  // Fungsi untuk mengambil semua data kelas
  Future<List<KelasModel>> getAllKelas() async {
    // Mengambil data dari tabel 'kelas dan mengambil relasi data dari tabel 'periode_ajaran'
    final response = await client
        .from('kelas')
        .select('''
          id,
          nama_kelas,
          id_periode,
          is_active,
          periode_ajaran (
            id,
            tahun_ajaran,
            semester
          )
        ''')
        // Mengurutkan data berdasarkan created_at terbaru
        .order('created_at', ascending: false);

    // Mengubah hasil response menjadi list object KelasModel
    return (response as List).map((item) => KelasModel.fromJson(item)).toList();
  }

  // Fungsi untuk mengambil semua data periode ajaran
  Future<List<Map<String, dynamic>>> getAllPeriodeAjaran() async {
    // Mengambil data dari tabel 'periode_ajaran'
    final response = await client
        .from('periode_ajaran')
        .select('id, tahun_ajaran, semester')
        // Mengurutkan data berdasarkan created_at terbaru
        .order('created_at', ascending: false);

    // Mengubah response menjadi List<Map<String, dynamic>>
    return List<Map<String, dynamic>>.from(response);
  }

  // Fungsi untuk menambahkan data kelas baru
  Future<void> addKelas({
    required String namaKelas,
    required String idPeriode,
    required bool isActive,
  }) async {
    // Menyimpan data baru ke tabel 'kelas'
    await client.from('kelas').insert({
      'nama_kelas': namaKelas,
      'id_periode': idPeriode,
      'is_active': isActive,
    });
  }

  // Fungsi untuk mengupdate data kelas yang sudah ada
  Future<void> updateKelas({
    required String id,
    required String namaKelas,
    required String idPeriode,
    required bool isActive,
  }) async {
    // Memperbarui data kelas berdasarkan id
    await client
        .from('kelas')
        .update({
          'nama_kelas': namaKelas,
          'id_periode': idPeriode,
          'is_active': isActive,
        })
        .eq('id', id);
  }
}
