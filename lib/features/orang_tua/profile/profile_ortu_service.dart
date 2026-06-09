import 'package:supabase_flutter/supabase_flutter.dart';
import 'profile_ortu_model.dart';

class ProfileOrtuService {
  final _db = Supabase.instance.client;

  // Ambil profil orang tua berdasarkan id_user
  Future<ProfileOrtuModel> getProfile(String userId) async {
    final response =
        await _db
            .from('users') // ambil data dari tabel users
            .select('id_user, nama, email, no_hp, is_active')
            .eq('id_user', userId) // filter berdasarkan id_user yang login
            .maybeSingle(); // ambil 1 data saja atau null jika tidak ditemukan

    // Jika response null, berarti profil tidak ditemukan, lempar exception
    if (response == null) throw Exception('Profil tidak ditemukan');
    return ProfileOrtuModel.fromJson(response);
  }

  // Ambil id_orang_tua dari tabel users berdasarkan id_user
  Future<String?> getIdOrangTua(String userId) async {
    final response =
        await _db
            .from('users') // ambil dari tabel users
            .select('id_orang_tua')
            .eq('id_user', userId) // filter berdasarkan id_user yang login
            .maybeSingle(); // ambil 1 data saja atau null jika tidak ditemukan

    // Jika response null, berarti id_orang_tua tidak ditemukan, return null
    return response?['id_orang_tua'] as String?;
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
