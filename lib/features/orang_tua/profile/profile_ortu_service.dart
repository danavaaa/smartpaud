import 'package:supabase_flutter/supabase_flutter.dart';
import 'profile_ortu_model.dart';

class ProfileOrtuService {
  final _db = Supabase.instance.client;

  // Ambil profil orang tua berdasarkan email
  Future<ProfileOrtuModel> getProfile(String email) async {
    final response =
        await _db
            .from('users') // ambil data dari tabel users
            .select(
              'id_user, nama, email, no_hp, is_active',
            ) // kolom yang diambil
            .eq('email', email)
            // filter berdasarkan email yang login
            .single();
    // ambil 1 data saja (karena email harus unik)

    // Convert response JSON menjadi object ProfileOrtuModel
    return ProfileOrtuModel.fromJson(response);
  }

  // Ambil id_orang_tua dari tabel users
  Future<String?> getIdOrangTua(String email) async {
    final response =
        await _db
            .from('users') // ambil dari tabel users
            .select('id_orang_tua')
            // hanya ambil kolom id_orang_tua
            .eq('email', email)
            // cari berdasarkan email
            .single();
    // ambil 1 row saja

    // Return id_orang_tua sebagai String
    return response['id_orang_tua'] as String?;
  }

  // Ambil daftar anak berdasarkan id_orang_tua
  Future<List<AnakProfileModel>> getAnakList(String idOrangTua) async {
    final response = await _db
        .from('siswa') // ambil data dari tabel siswa
        .select('''
          id,
          nama_siswa,
          is_active,
          kelas (
            nama_kelas,
            periode_ajaran!id_periode (
              tahun_ajaran,
              semester
            )
          )
        ''')
        .eq('id_orang_tua', idOrangTua);
    // Filter hanya anak yang punya id_orang_tua ini

    // Convert setiap row JSON menjadi object AnakProfileModel
    return response
        .map<AnakProfileModel>((e) => AnakProfileModel.fromJson(e))
        .toList();
  }
}
