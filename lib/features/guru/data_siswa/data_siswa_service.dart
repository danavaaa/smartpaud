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
        id_kelas,
        is_active,

        kelas (
          id,
          nama_kelas,
          is_active,

          periode_ajaran (
            tahun_ajaran,
            semester,
            is_active
          )
        ),

        orang_tua (
          id,
          nama_ayah,
          nama_ibu,
          no_hp_wali,

          users (
            role,
            pekerjaan
          )
        )
      ''')
        // Hanya mengambil siswa aktif
        .eq('is_active', true)
        // Mengurutkan berdasarkan nama siswa
        .order('nama_siswa');

    final data = List<Map<String, dynamic>>.from(response);

    final filtered =
        // filter data siswa sehingga hanya siswa aktif yang berada pada kelas aktif dan periode ajaran aktif yang ditampilkan
        data.where((item) {
          // ambil data relasi kelas dari siswa
          final kelas = item['kelas'] as Map<String, dynamic>?;
          // ambil data relasi periode ajaran dari kelas
          final periode = kelas?['periode_ajaran'] as Map<String, dynamic>?;
          // cek apakah kelas siswa masih aktif
          final kelasAktif = kelas?['is_active'] == true;
          // cek apakah periode ajaran masih aktif
          final periodeAktif = periode?['is_active'] == true;
          // data siswa hanya ditampilkan apabila kelas dan periode ajaran sama sama aktif
          return kelasAktif && periodeAktif;
        }).toList();

    return filtered.map<Siswa>((e) => Siswa.fromJson(e)).toList();
  }

  // fungsi mengambil daftar kelas aktif yang berada pada periode ajaran aktif untuk dropdown
  Future<List<Map<String, dynamic>>> getKelasList() async {
    // ambil data kelas beserta relasi periode ajaran
    final response = await _db
        .from('kelas')
        .select('''
        id,
        nama_kelas,
        is_active,

        periode_ajaran (
          is_active
        )
      ''')
        // hanya mengambil kelas yang aktif
        .eq('is_active', true)
        // Urut berdasarkan nama kelas
        .order('nama_kelas');

    final data = List<Map<String, dynamic>>.from(response);
    // filter kelas berdasarkan periode ajaran aktif
    final filtered =
        data.where((item) {
          // ambil data periode ajaran yang berelasi
          final periode = item['periode_ajaran'] as Map<String, dynamic>?;
          // hanya menampilkan kelas yang berada ppada periode ajaran aktif
          return periode?['is_active'] == true;
        }).toList();

    final seen = <String>{};

    // menyimpan hasil akhir tanpa duplikat
    final unique = <Map<String, dynamic>>[];

    // menghapus data kelas duplikat
    for (final k in filtered) {
      // Ambil nama kelas
      final nama = k['nama_kelas'] as String;

      // Jika nama kelas belum pernah ada
      if (seen.add(nama)) {
        // tambahkan ke list hasil akhir
        unique.add({'id': k['id'], 'nama_kelas': k['nama_kelas']});
      }
    }
    // Mengembalikan daftar kelas yang siap digunakan pada dropdown
    return unique;
  }
}
