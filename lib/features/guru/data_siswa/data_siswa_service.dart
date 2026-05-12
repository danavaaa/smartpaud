import 'package:supabase_flutter/supabase_flutter.dart';
import 'data_siswa_model.dart';

class SiswaService {
  final _db = Supabase.instance.client;

  Future<List<Siswa>> getSiswa() async {
    // Query ke tabel siswa untuk mengambil data siswa beserta relasi ke kelas dan orang tua
    final response = await _db
        // Memilih tabel siswa
        .from('siswa')
        // Select data + relasi tabel
        .select('''
          id,
          nama_siswa,
          tempat_lahir,
          tanggal_lahir,
          jenis_kelamin,
          is_active,

          kelas (
            id,
            nama_kelas,

            periode_ajaran (
              tahun_ajaran,
              semester
            )
          ),

          orang_tua (
            id,
            nama_ayah,
            nama_ibu,
            no_hp_wali
          )
        ''')
        // Hanya mengambil siswa aktif
        .eq('is_active', true)
        // Mengurutkan berdasarkan nama siswa
        .order('nama_siswa');

    return response.map<Siswa>((e) => Siswa.fromJson(e)).toList();
  }

  // Fungsi untuk mengambil daftar kelas dari tabel kelas
  Future<List<Map<String, dynamic>>> getKelasList() async {
    // Query ke tabel kelas
    final response = await _db
        // Mengambil tabel kelas
        .from('kelas')
        // Mengambil field tertentu
        .select('id, nama_kelas')
        // Hanya kelas aktif
        .eq('is_active', true)
        // Urut berdasarkan nama kelas
        .order('nama_kelas');

    // Set untuk menyimpan nama kelas yang sudah pernah muncul
    final seen = <String>{};

    // List hasil akhir tanpa duplikat
    final unique = <Map<String, dynamic>>[];

    // Loop semua data kelas
    for (final k in response) {
      // Ambil nama kelas
      final nama = k['nama_kelas'] as String;

      // Jika nama kelas belum pernah ada
      if (seen.add(nama)) {
        // Tambahkan ke list unique
        unique.add(k);
      }
    }

    // Mengembalikan list kelas tanpa duplikat
    return unique;
  }
}
