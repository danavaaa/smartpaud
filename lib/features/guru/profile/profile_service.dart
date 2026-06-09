import 'package:supabase_flutter/supabase_flutter.dart';
import 'profile_model.dart';

class ProfileService {
  final _db = Supabase.instance.client;

  // ambil profile guru berdasarkan id user yang tersimpan di session
  Future<ProfileModel> getProfile(String userId) async {
    final response =
        await _db
            // Nama tabel
            .from('users')
            // Ambil field yang diperlukan
            .select('id_user, nama, email, no_hp, is_active')
            .eq('id_user', userId) // ambil berdasarkan id user
            .maybeSingle(); // ambil satu data atau null jika tidak ditemukan

    // jika response null, berarti profil tidak ditemukan, lempar exception
    if (response == null) throw Exception('Profil tidak ditemukan');
    return ProfileModel.fromJson(response);
  }

  // ambil daftar kelas yang diampu berdasarkan id user guru
  Future<List<KelasModel>> getKelasDiampu(String idUser) async {
    final response = await _db
        // Nama tabel
        .from('penugasan_guru')
        // Ambil relasi kelas dan periode ajaran
        .select('''
              peran_guru,
              is_active,

              kelas (
                nama_kelas,

                periode_ajaran!id_periode (
                  tahun_ajaran,
                  semester
                )
              )
              ''')
        // Filter berdasarkan id guru
        .eq('id_guru', idUser)
        // Hanya data aktif
        .eq('is_active', true);

    // Convert List JSON menjadi List<KelasModel>
    return response.map<KelasModel>((e) => KelasModel.fromJson(e)).toList();
  }
}
