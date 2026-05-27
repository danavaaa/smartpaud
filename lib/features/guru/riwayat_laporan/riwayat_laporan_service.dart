import 'package:supabase_flutter/supabase_flutter.dart';
import 'riwayat_laporan_model.dart';

// Service untuk mengelola data laporan perkembangan siswa
class RiwayatLaporanService {
  final _db = Supabase.instance.client;
  // Method untuk mengambil data laporan perkembangan siswa
  Future<List<LaporanModel>> getLaporan() async {
    final response = await _db
        // Nama tabel
        .from('laporan_perkembangan')
        // Select field + relasi
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
              nama_kelas,
              id_periode
            )
          )
        ''')
        // Urutkan berdasarkan waktu terbaru
        .order('created_at', ascending: false);

    // Mapping hasil query ke dalam model LaporanModel
    // agar lebih mudah digunakan di UI
    return response.map<LaporanModel>((e) => LaporanModel.fromJson(e)).toList();
  }

  // Ambil daftar periode dari database
  Future<List<Map<String, dynamic>>> getPeriodeList() async {
    final response = await _db
        .from('periode_ajaran')
        .select('id, tahun_ajaran, semester')
        .order('tahun_ajaran', ascending: false);

    return List<Map<String, dynamic>>.from(response);
  }
}
