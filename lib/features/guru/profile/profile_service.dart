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

  // ambil daftar kelas aktif  yang diampu berdasarkan id user guru
  Future<List<KelasModel>> getKelasDiampuAktif(String idUser) async {
    final response = await _db
        // Nama tabel
        .from('penugasan_guru')
        // Ambil relasi kelas dan periode ajaran
        .select('''
        peran_guru,
        is_active,

        kelas (
          nama_kelas,
          is_active,

          periode_ajaran!id_periode (
            tahun_ajaran,
            semester,
            is_active
          )
        )
      ''')
        // Filter berdasarkan id guru
        .eq('id_guru', idUser)
        // Hanya data aktif
        .eq('is_active', true);

    final data = List<Map<String, dynamic>>.from(response);

    // filter data agar hanya kelas dan periode ajaran aktif yang ditampilkan
    final filtered =
        data.where((item) {
          // mengambil data relasi kelas
          final kelas = item['kelas'] as Map<String, dynamic>?;
          // mengambil data relasi periode ajaran dari kelas
          final periode = kelas?['periode_ajaran'] as Map<String, dynamic>?;
          // cek apakah kelas masih aktif
          final kelasAktif = kelas?['is_active'] == true;
          // cek apakah periode ajaran masih aktif
          final periodeAktif = periode?['is_active'] == true;

          return kelasAktif && periodeAktif;
        }).toList();

    return filtered.map<KelasModel>((e) => KelasModel.fromJson(e)).toList();
  }

  // fungsi untuk mengambil seluruh kelas yang diampu
  Future<List<KelasModel>> getSemuaKelasDiampu(String idUser) async {
    // ambil data penugasan guru beserta relasi kelas dan periode ajaran
    final response = await _db
        .from('penugasan_guru')
        .select('''
        peran_guru,
        is_active,

        kelas (
          nama_kelas,
          is_active,

          periode_ajaran!id_periode (
            tahun_ajaran,
            semester,
            is_active
          )
        )
      ''')
        // filter berdasarkan ID guru yang sedang login
        .eq('id_guru', idUser);

    return response.map<KelasModel>((e) => KelasModel.fromJson(e)).toList();
  }
}
