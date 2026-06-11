import 'package:supabase_flutter/supabase_flutter.dart';
import 'orang_tua_model.dart';

// Service untuk mengelola data orang tua di databse
class OrangTuaService {
  final SupabaseClient client = Supabase.instance.client;

  // ambil semua data orang tua
  // Mengambil seluruh data pengguna dengan role orang_tua, beserta data relasi dari tabel orang_tua
  Future<List<OrangTuaModel>> getAllOrangTua() async {
    final response = await client
        .from('users')
        .select('''
        id_user,
        id_auth,
        id_orang_tua,
        nama,
        email,
        no_hp,
        pekerjaan,
        is_active,
        orang_tua (
          id,
          nama_ayah,
          nama_ibu,
          no_hp_wali
        )
      ''')
        // Filter hanya akun dengan role orang tua
        .eq('role', 'orang_tua')
        // Urutkan berdasarkan nama
        .order('nama', ascending: true);

    // Konversi response JSON menjadi List<OrangTuaModel>
    return (response as List)
        .map((item) => OrangTuaModel.fromJson(item))
        .toList();
  }

  // Tambah data orang tua
  Future<void> addOrangTua({
    required String namaAyah,
    required String namaIbu,
    required String email,
    required String noHpWali,
    required String pekerjaan,
    required bool isActive,
    required String password,
  }) async {
    // Simpan refresh token admin yang sedang login
    final adminRefreshToken = client.auth.currentSession?.refreshToken;

    // Buat akun Auth Supabase
    final authResponse = await client.auth.signUp(
      email: email,
      password: password,
    );
    // ambil ID user dari auth.users
    final idAuth = authResponse.user?.id;
    // jika gagal membuat akun auth, hentikan proses
    if (idAuth == null) {
      throw Exception('Gagal membuat akun auth');
    }

    // kembalikan session admin
    if (adminRefreshToken != null) {
      await client.auth.setSession(adminRefreshToken);
    }

    // simpan data orang tua
    final orangTuaData =
        await client
            .from('orang_tua')
            .insert({
              'nama_ayah': namaAyah.isEmpty ? null : namaAyah,

              'nama_ibu': namaIbu.isEmpty ? null : namaIbu,

              'no_hp_wali': noHpWali.isEmpty ? null : noHpWali,
            })
            // Ambil id hasil insert
            .select('id')
            .single();

    // Simpan ID orang tua yang baru dibuat
    final idOrangTua = orangTuaData['id'];

    // Tentukan nama akun
    final namaAkun = namaIbu.isNotEmpty ? namaIbu : namaAyah;

    // simpan data user
    await client.from('users').insert({
      // Relasi ke auth.users
      'id_auth': idAuth,

      // Relasi ke tabel orang_tua
      'id_orang_tua': idOrangTua,

      // Data akun
      'nama': namaAkun,
      'email': email,
      'no_hp': noHpWali.isEmpty ? null : noHpWali,
      'pekerjaan': pekerjaan.isEmpty ? null : pekerjaan,

      'role': 'orang_tua',
      'is_active': isActive,
    });
  }

  // update data orang tua
  Future<void> updateOrangTua({
    required String idUser,
    required String? idOrangTua,
    required String namaAyah,
    required String namaIbu,
    required String email,
    required String noHpWali,
    required String pekerjaan,
    required bool isActive,
  }) async {
    // Simpan id orang tua sementara
    String? idWali = idOrangTua;

    // update tabel orang tua
    if (idWali != null && idWali.isNotEmpty) {
      await client
          .from('orang_tua')
          .update({
            'nama_ayah': namaAyah.isEmpty ? null : namaAyah,

            'nama_ibu': namaIbu.isEmpty ? null : namaIbu,

            'no_hp_wali': noHpWali.isEmpty ? null : noHpWali,
          })
          // Cari berdasarkan ID orang tua
          .eq('id', idWali);
    }

    // Tentukan nama akun yang akan ditampilkan
    final namaAkun = namaIbu.isNotEmpty ? namaIbu : namaAyah;

    //update tabel users
    await client
        .from('users')
        .update({
          // Update data akun
          'nama': namaAkun,

          'no_hp': noHpWali.isEmpty ? null : noHpWali,

          'pekerjaan': pekerjaan.isEmpty ? null : pekerjaan,

          'is_active': isActive,
        })
        // Cari berdasarkan id user
        .eq('id_user', idUser)
        // Pastikan hanya role orang_tua
        .eq('role', 'orang_tua');
  }
}
