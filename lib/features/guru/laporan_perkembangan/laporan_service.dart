import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:io';
import '../../../services/user_session.dart';

class LaporanService {
  final _db = Supabase.instance.client;

  // Upload foto ke database, return URL-nya
  Future<String?> uploadFoto(File imageFile, String idSiswa) async {
    try {
      final fileName = '$idSiswa-${DateTime.now().millisecondsSinceEpoch}.jpg';

      await _db.storage.from('laporan-foto').upload(fileName, imageFile);

      // Ambil public URL
      final url = _db.storage.from('laporan-foto').getPublicUrl(fileName);

      return url;
    } catch (e) {
      return null;
    }
  }

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

    // URL foto
    String? fotoUrl,
  }) async {
    // Insert data ke tabel "laporan_perkembangan"
    await _db.from('laporan_perkembangan').insert({
      // Kolom id_siswa
      'id_siswa': idSiswa,

      // Kolom Id guru
      'id_guru': UserSession().idUser,

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
