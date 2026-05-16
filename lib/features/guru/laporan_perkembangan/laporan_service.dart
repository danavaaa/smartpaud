import 'package:supabase_flutter/supabase_flutter.dart';

class LaporanService {
  final _db = Supabase.instance.client;

  // simpan laporan perkembangan ke database
  Future<void> simpanLaporan({
    // ID siswa
    required String idSiswa,

    // Tanggal laporan
    required String tanggalLaporan,

    // Catatan asli dari guru
    required String catatanLiterasi,

    // Ringkasan hasil AI
    required String ringkasanAi,

    // Rekomendasi hasil AI
    required String rekomendasiAi,

    // URL foto opsional
    String? fotoUrl,
  }) async {
    // Insert data ke tabel "laporan_perkembangan"
    await _db.from('laporan_perkembangan').insert({
      // Kolom id_siswa
      'id_siswa': idSiswa,

      // Kolom tanggal laporan
      'tanggal_laporan': tanggalLaporan,

      // Kolom catatan literasi
      'catatan_literasi': catatanLiterasi,

      // Kolom hasil ringkasan AI
      'ringkasan_ai': ringkasanAi,

      // Kolom rekomendasi AI
      'rekomendasi_ai': rekomendasiAi,

      // Kolom URL foto
      'foto_url': fotoUrl,
    });
  }
}
