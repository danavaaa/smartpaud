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
              nama_kelas
            )
          )
        ''')
        // Urutkan berdasarkan waktu terbaru
        .order('created_at', ascending: false);

    // Mapping hasil query ke dalam model LaporanModel
    // agar lebih mudah digunakan di UI
    return response.map<LaporanModel>((e) => LaporanModel.fromJson(e)).toList();
  }
}
