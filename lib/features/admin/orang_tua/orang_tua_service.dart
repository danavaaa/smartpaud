import 'package:supabase_flutter/supabase_flutter.dart';
import 'orang_tua_model.dart';

// Service untuk mengelola data orang tua di databse
class OrangTuaService {
  final SupabaseClient client = Supabase.instance.client;

  // fungsi untuk mengambil semua data orang tua dari tabel 'users' dengan role 'orang_tua'
  Future<List<OrangTuaModel>> getAllOrangTua() async {
    final response = await client
        .from('users')
        .select('id_user, id_auth, nama, email, no_hp, is_active')
        .eq('role', 'orang_tua')
        .order('nama', ascending: true);

    // mengubah hasil response menjadi list objek OrangTuaModel
    return (response as List)
        .map((item) => OrangTuaModel.fromJson(item))
        .toList();
  }

  // fungsi untuk menambahkan data orang tua baru
  Future<void> addOrangTua({
    required String nama,
    required String email,
    required String noHp,
    required bool isActive,
    required String password,
  }) async {
    // Simpan session admin sebelum signUp
    final adminSession = client.auth.currentSession;

    // 1. Buat akun Auth Supabase
    final authResponse = await client.auth.signUp(
      email: email,
      password: password,
    );
    // ambil ID user dari auth.users
    final idAuth = authResponse.user?.id;
    // jika gagal membuat akun auth, hentikan proses
    if (idAuth == null) throw Exception('Gagal membuat akun auth');

    // 2. Insert ke tabel users dengan id_auth
    await client.from('users').insert({
      'id_auth': idAuth,
      'nama': nama,
      'email': email,
      'no_hp': noHp,
      'role': 'orang_tua',
      'is_active': isActive,
    });

    // 3. Kembalikan session admin
    if (adminSession?.refreshToken != null) {
      await client.auth.setSession(adminSession!.refreshToken!);
    }
  }

  // fungsi untuk mengupdate data orang tua yang sudah ada
  Future<void> updateOrangTua({
    required String idUser,
    required String nama,
    required String email,
    required String noHp,
    required bool isActive,
  }) async {
    // Memperbarui data orang tua berdasarkan id_user
    await client
        .from('users')
        .update({'nama': nama, 'no_hp': noHp, 'is_active': isActive})
        .eq('id_user', idUser);
  }
}
