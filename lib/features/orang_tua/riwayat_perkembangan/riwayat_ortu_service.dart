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

  // fungsi untuk mengambil daftar periode ajaran dari tabel periode_ajaran
  Future<List<Map<String, dynamic>>> getPeriodeList() async {
    final response = await _db
        .from('periode_ajaran')
        // Ambil field yang dibutuhkan
        .select('id, tahun_ajaran, semester')
        // Urutkan berdasarkan tahun ajaran terbaru
        .order('tahun_ajaran', ascending: false);

    // Convert response menjadi List<Map>
    return List<Map<String, dynamic>>.from(response);
  }

  // fungsi untuk mengambil laporan perkembangan siswa berdasarkan id siswa dan filter periode
  Future<List<LaporanOrtuModel>> getLaporanByPeriode(
    String idSiswa, {
    String? idPeriode,
  }) async {
    final response = await _db
        .from('laporan_perkembangan')
        // Ambil field laporan dan relasi siswa dan kelas
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
        // Filter berdasarkan id siswa
        .eq('id_siswa', idSiswa)
        // Urutkan laporan terbaru
        .order('created_at', ascending: false);

    // Jika tidak ada data laporan return list kosong
    if (response.isEmpty) return [];

    // Simpan response ke variable filtered nanti akan difilter lagi berdasarkan periode
    List filtered = response;

    // Jika user memilih periode tertentu
    if (idPeriode != null) {
      // Filter hanya laporan yang memiliki id_periode sesuai
      filtered =
          response.where((e) {
            // Ambil data siswa dari relasi
            final siswa = e['siswa'] as Map<String, dynamic>? ?? {};

            // Ambil data kelas dari relasi siswa
            final kelas = siswa['kelas'] as Map<String, dynamic>? ?? {};

            // Cocokkan id_periode
            return kelas['id_periode'] == idPeriode;
          }).toList();
    }

    // Jika setelah filter data kosong
    if (filtered.isEmpty) return [];

    // Ambil id laporan terbaru digunakan untuk menandai laporan terbaru
    final latestId = filtered.first['id'] as String;

    // Convert hasil filter menjadi object model
    return filtered
        .map<LaporanOrtuModel>(
          // Kirim latestId ke model agar model bisa menentukan badge "baru"
          (e) => LaporanOrtuModel.fromJson(e, latestId: latestId),
        )
        // Ubah hasil map menjadi List
        .toList();
  }
}
