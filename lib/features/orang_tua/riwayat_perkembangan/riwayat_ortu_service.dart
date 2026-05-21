import 'package:supabase_flutter/supabase_flutter.dart';
import 'riwayat_ortu_model.dart';

// Service untuk mengambil data riwayat laporan orang tua
class RiwayatLaporanOrtuService {
  // Instance Supabase client
  final _db = Supabase.instance.client;

  // fungsi untuk mengambil daftar anak berdasarkan id orang tua
  Future<List<AnakOrtuModel>> getAnakList(String idOrangTua) async {
    // Query ke tabel siswa
    final response = await _db
        .from('siswa')
        .select('''
          id,
          nama_siswa,
          is_active,
          kelas (
            nama_kelas
          )
        ''')
        // Filter berdasarkan id orang tua
        .eq('id_orang_tua', idOrangTua);

    // Mapping response menjadi list AnakOrtuModel
    return response.map<AnakOrtuModel>((e) {
      // Ambil data kelas dari relasi
      final kelas = e['kelas'] as Map<String, dynamic>? ?? {};

      return AnakOrtuModel(
        // ID siswa
        id: e['id'] ?? '',

        // Nama siswa
        nama: e['nama_siswa'] ?? '-',

        // Nama kelas
        namaKelas: kelas['nama_kelas'] as String? ?? '-',

        // Status aktif siswa
        isActive: e['is_active'] ?? false,
      );
    }).toList();
  }

  // Fungsi untuk mengambil semua laporan berdasarkan id siswa
  Future<List<LaporanOrtuModel>> getLaporan(String idSiswa) async {
    // Query ke tabel laporan_perkembangan
    final response = await _db
        .from('laporan_perkembangan')
        .select('''
          id,
          id_siswa,
          tanggal_laporan,
          foto_url,
          catatan_literasi,
          ringkasan_ai,
          rekomendasi_ai,
          created_at,
          siswa (
            nama_siswa,
            kelas (
              nama_kelas
            )
          )
        ''')
        // Filter berdasarkan id siswa
        .eq('id_siswa', idSiswa)
        // Urutkan dari laporan terbaru
        .order('created_at', ascending: false);

    // Jika tidak ada data, return list kosong
    if (response.isEmpty) return [];

    // Mengambil ID laporan terbaru
    final latestId = response.first['id'] as String;

    // Mapping response menjadi list LaporanOrtuModel
    return response
        .map<LaporanOrtuModel>(
          // Parse JSON ke model
          (e) => LaporanOrtuModel.fromJson(e, latestId: latestId),
        )
        .toList();
  }

  // Fungsi untuk mengambil id orang tua berdasarkan email user
  Future<String?> getIdOrangTua(String email) async {
    // Query ke tabel users
    final response =
        await _db
            .from('users')
            .select('id_orang_tua, nama')
            // Filter berdasarkan email
            .eq('email', email)
            // Ambil satu data saja
            .single();

    // Return id_orang_tua
    return response['id_orang_tua'] as String?;
  }
}
