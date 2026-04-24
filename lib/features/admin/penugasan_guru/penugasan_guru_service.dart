import 'package:supabase_flutter/supabase_flutter.dart';
import 'penugasan_guru_model.dart';

// Service untuk mengelola data penugasan guru dari database Supabase
class PenugasanGuruService {
  final SupabaseClient client = Supabase.instance.client;

  // Fungsi untuk mengambil seluruh data penugasan guru
  Future<List<PenugasanGuruModel>> getAllPenugasanGuru() async {
    final response = await client
        .from('penugasan_guru')
        .select('''
          id,
          id_guru,
          id_kelas,
          peran_guru,
          is_active,
          users (
            id_user,
            nama,
            email
          ),
          kelas (
            id,
            nama_kelas
          )
        ''')
        // Mengurutkan data berdasarkan created_at terbaru
        .order('created_at', ascending: false);

    // Mengubah hasil response menjadi list object PenugasanGuruModel
    return (response as List)
        .map((item) => PenugasanGuruModel.fromJson(item))
        .toList();
  }

  // Fungsi untuk mengambil seluruh data guru
  Future<List<Map<String, dynamic>>> getAllGuru() async {
    // Mengambil data dari tabel 'users'
    // kemudian memfilter hanya user dengan role 'guru'
    final response = await client
        .from('users')
        .select('id_user, nama, email')
        .eq('role', 'guru')
        .order('nama', ascending: true);

    // Mengubah hasil response menjadi list map
    return List<Map<String, dynamic>>.from(response);
  }

  // Fungsi untuk mengambil seluruh data kelas
  Future<List<Map<String, dynamic>>> getAllKelas() async {
    // Mengambil data dari tabel 'kelas'
    final response = await client
        .from('kelas')
        .select('id, nama_kelas')
        .order('nama_kelas', ascending: true);

    // Mengubah hasil response menjadi list map
    return List<Map<String, dynamic>>.from(response);
  }

  // Fungsi untuk menambahkan data penugasan guru baru
  Future<void> addPenugasanGuru({
    required String idGuru,
    required String idKelas,
    required String peranGuru,
    required bool isActive,
  }) async {
    // Menyimpan data baru ke tabel 'penugasan_guru'
    await client.from('penugasan_guru').insert({
      'id_guru': idGuru,
      'id_kelas': idKelas,
      'peran_guru': peranGuru,
      'is_active': isActive,
    });
  }

  // Fungsi untuk mengupdate data penugasan guru yang sudah ada
  Future<void> updatePenugasanGuru({
    required String id,
    required String idGuru,
    required String idKelas,
    required String peranGuru,
    required bool isActive,
  }) async {
    // Memperbarui data penugasan guru berdasarkan id
    await client
        .from('penugasan_guru')
        .update({
          'id_guru': idGuru,
          'id_kelas': idKelas,
          'peran_guru': peranGuru,
          'is_active': isActive,
        })
        .eq(
          'id',
          id,
        ); // Memastikan hanya data dengan id yang sesuai yang diperbarui
  }
}
