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

  // Fungsi untuk menambahkan data guru baru (buat akun Auth dulu, lalu insert ke users)
  Future<void> addGuru({
    required String nama,
    required String email,
    required String noHp,
    required bool isActive,
    required String password,
  }) async {
    // Simpan session admin yang sedang login, agar nanti setelah membuat akun guru, admin bisa login kembali
    final adminSession = client.auth.currentSession;

    // Buat akun Auth Supabase (akun login guru)
    final authResponse = await client.auth.signUp(
      email: email,
      password: password,
    );

    // ambil id user dari database
    final idAuth = authResponse.user?.id;
    // jika id tidak ada, maka pembuatan akun gagal
    if (idAuth == null) throw Exception('Gagal membuat akun auth');

    // simpan data tambahan ke tabel users
    // id_auth dihubungkan dengan akun auth supabase yang baru dibuat
    await client.from('users').insert({
      'id_auth': idAuth, // id dari auth.users
      'nama': nama,
      'email': email,
      'no_hp': noHp,
      'role': 'guru',
      'is_active': isActive,
    });

    // Kembalikan session admin agar admin tetap login
    if (adminSession?.refreshToken != null) {
      await client.auth.setSession(adminSession!.refreshToken!);
    }
  }

  // Fungsi untuk mengupdate data guru yang sudah ada
  Future<void> updateGuru({
    required String idUser,
    required String nama,
    required String email,
    required String noHp,
    required bool isActive,
  }) async {
    // Update data guru di tabel users
    await client
        .from('users')
        .update({
          'nama': nama,
          'email': email,
          'no_hp': noHp.isEmpty ? null : noHp,
          'is_active': isActive,
        })
        .eq('id_user', idUser)
        .eq('role', 'guru');

    // Jika guru dinonaktifkan, maka semua penugasan guru tersebut ikut dinonaktifkan
    if (!isActive) {
      await client
          .from('penugasan_guru')
          .update({'is_active': false})
          .eq('id_guru', idUser);
    }
  }
}
