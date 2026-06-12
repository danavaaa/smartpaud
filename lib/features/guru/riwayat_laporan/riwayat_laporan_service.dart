import 'package:supabase_flutter/supabase_flutter.dart';
import 'riwayat_laporan_model.dart';
import '../../../services/user_session.dart';

// Service untuk mengelola data laporan perkembangan siswa
class RiwayatLaporanService {
  final _db = Supabase.instance.client;
  // Method untuk mengambil data laporan perkembangan siswa
  Future<List<LaporanModel>> getLaporan() async {
    final idGuru = UserSession().idUser ?? '';

    if (idGuru.isEmpty) {
      return [];
    }

    final response = await _db
        // Nama tabel
        .from('laporan_perkembangan')
        // Select field + relasi
        .select('''
        id,
        id_siswa,
        id_guru,
        tanggal_laporan,
        foto_url,
        catatan_literasi,
        ringkasan_ai,
        rekomendasi_ai,

        siswa (
          id,
          nama_siswa,
          is_active,
          id_kelas,

          kelas (
            id,
            nama_kelas,
            is_active,

            periode_ajaran (
              id,
              tahun_ajaran,
              semester,
              is_active
            )
          )
        )
      ''')
        // hanya laporan milik guru yang sedang login
        .eq('id_guru', idGuru)
        // Urutkan berdasarkan waktu terbaru
        .order('tanggal_laporan', ascending: false);

    final data = List<Map<String, dynamic>>.from(response);

    final filtered =
        data.where((item) {
          // ambil data siswa dari relasi laporan
          final siswa = item['siswa'] as Map<String, dynamic>?;

          // ambil data kelas dari relasi siswa
          final kelas = siswa?['kelas'] as Map<String, dynamic>?;

          // ambil data periode dari relasi kelas
          final periode = kelas?['periode_ajaran'] as Map<String, dynamic>?;

          // cek status aktif siswa
          final siswaAktif = siswa?['is_active'] == true;

          // cek status aktif kelas
          final kelasAktif = kelas?['is_active'] == true;

          // cek status aktif periode ajaran
          final periodeAktif = periode?['is_active'] == true;

          // laporan hanya tampil jika siswa, kelas, dan periode sama-sama aktif
          return siswaAktif && kelasAktif && periodeAktif;
        }).toList();

    return filtered.map<LaporanModel>((e) => LaporanModel.fromJson(e)).toList();
  }

  // Fungsi untuk mengambil daftar periode ajaran aktif
  Future<List<Map<String, dynamic>>> getPeriodeList() async {
    // Mengambil data dari tabel periode_ajaran
    final response = await _db
        .from('periode_ajaran')
        // Memilih kolom yang diperlukan
        .select('id, tahun_ajaran, semester, is_active')
        // Hanya mengambil periode yang berstatus aktif
        .eq('is_active', true)
        // Mengurutkan data berdasarkan waktu pembuatan terbaru
        .order('created_at', ascending: false);

    return List<Map<String, dynamic>>.from(response);
  }
}
