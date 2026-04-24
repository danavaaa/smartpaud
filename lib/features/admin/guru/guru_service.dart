import 'package:supabase_flutter/supabase_flutter.dart';
import 'guru_model.dart';

// Service untuk mengelola data guru dari database Supabase
class GuruService {
  // Mengambil instance client Supabase
  final SupabaseClient client = Supabase.instance.client;

  // Fungsi untuk mengambil seluruh data guru
  Future<List<GuruModel>> getAllGuru() async {
    // Mengambil data dari tabel 'users'
    // lalu memfilter hanya user dengan role 'guru'
    final response = await client
        .from('users')
        .select('id_user, id_auth, nama, email, no_hp, is_active')
        .eq('role', 'guru')
        .order('nama', ascending: true);

    // Mengubah hasil response menjadi list object GuruModel
    return (response as List).map((item) => GuruModel.fromJson(item)).toList();
  }

  // Fungsi untuk menambahkan data guru baru
  Future<void> addGuru({
    required String nama,
    required String email,
    required String noHp,
    required bool isActive,
  }) async {
    // Menyimpan data baru ke tabel 'users'
    // role otomatis diisi 'guru'
    await client.from('users').insert({
      'nama': nama,
      'email': email,
      'no_hp': noHp,
      'role': 'guru',
      'is_active': isActive,
    });
  }

  // Fungsi untuk mengupdate data guru yang sudah ada
  Future<void> updateGuru({
    required String idUser,
    required String nama,
    required String email,
    required String noHp,
    required bool isActive,
  }) async {
    // Memperbarui data guru berdasarkan id_user
    await client
        .from('users')
        .update({
          'nama': nama,
          'email': email,
          'no_hp': noHp,
          'is_active': isActive,
        })
        .eq('id_user', idUser);
  }
}
