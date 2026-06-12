import 'package:supabase_flutter/supabase_flutter.dart';
import 'riwayat_ortu_model.dart';

// Service untuk mengambil data riwayat laporan orang tua
class RiwayatLaporanOrtuService {
  // Instance Supabase client
  final _db = Supabase.instance.client;

  // fungsi untuk mengambil daftar anak berdasarkan id orang tua
  Future<List<AnakOrtuModel>> getAnakList(String idOrangTua) async {
    // ambil data siswa beserta relasi kelas dan periode ajaran
    final response = await _db
        .from('siswa')
        .select('''
        id,
        nama_siswa,
        is_active,
        kelas (
          id,
          nama_kelas,
          is_active,

          periode_ajaran!id_periode (
            id,
            tahun_ajaran,
            semester,
            is_active
          )
        )
      ''')
        // Filter berdasarkan id orang tua
        .eq('id_orang_tua', idOrangTua)
        // Hanya siswa yang aktif
        .eq('is_active', true)
        // Urutkan berdasarkan nama siswa
        .order('nama_siswa');

    // Konversi response menjadi List<Map>
    final data = List<Map<String, dynamic>>.from(response);

    final filtered =
        data.where((item) {
          // Ambil data kelas dari relasi siswa ke kelas
          final kelas = item['kelas'] as Map<String, dynamic>?;

          // Ambil data periode ajaran dari relasi kelas ke periode_ajaran
          final periode = kelas?['periode_ajaran'] as Map<String, dynamic>?;

          // Cek apakah siswa masih aktif
          final anakAktif = item['is_active'] == true;

          // Cek apakah kelas tempat siswa terdaftar masih aktif
          final kelasAktif = kelas?['is_active'] == true;

          // Cek apakah periode ajaran kelas masih aktif
          final periodeAktif = periode?['is_active'] == true;

          // Hanya menampilkan siswa yang aktif, berada pada kelas aktif, dan berada pada periode ajaran aktif
          return anakAktif && kelasAktif && periodeAktif;
        }).toList();

    // Konversi hasil filter menjadi objek AnakOrtuModel
    return filtered.map<AnakOrtuModel>((e) {
      final kelas = e['kelas'] as Map<String, dynamic>? ?? {};

      return AnakOrtuModel(
        // ID siswa
        id: e['id'] ?? '',

        // Nama siswa
        nama: e['nama_siswa'] ?? '-',

        // Nama kelas
        namaKelas: kelas['nama_kelas'] ?? '-',

        // Status aktif siswa
        isActive: e['is_active'] == true,
      );
    }).toList();
  }

  // Fungsi untuk mengambil semua laporan berdasarkan id siswa
  Future<List<LaporanOrtuModel>> getLaporan(String idSiswa) async {
    return getLaporanByPeriode(idSiswa);
  }

  // Fungsi untuk mengambil id orang tua berdasarkan userId
  Future<String?> getIdOrangTua(String userId) async {
    // Query ke tabel users
    final response =
        await _db
            .from('users')
            .select('id_orang_tua')
            .eq('id_user', userId) // filter berdasarkan id_user yang login
            .maybeSingle(); // ambil 1 data saja atau null jika tidak ditemukan

    // jika data ditemukan, kembalikan id_orang_tua, jika tidak kembalikan null
    return response?['id_orang_tua'] as String?;
  }

  // Fungsi untuk mengambil daftar periode ajaran yang aktif
  Future<List<Map<String, dynamic>>> getPeriodeList() async {
    final response = await _db
        .from('periode_ajaran')
        // Ambil field yang diperlukan dari tabel periode_ajaran
        .select('id, tahun_ajaran, semester, is_active')
        // Hanya tampilkan periode yang masih aktif
        .eq('is_active', true)
        // Urutkan berdasarkan tahun ajaran terbaru terlebih dahulu
        .order('tahun_ajaran', ascending: false);

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
          id,
          nama_siswa,
          is_active,
          kelas (
            id,
            nama_kelas,
            is_active,

            periode_ajaran!id_periode (
              id,
              tahun_ajaran,
              semester,
              is_active
            )
          )
        )
      ''')
        // Filter berdasarkan id siswa
        .eq('id_siswa', idSiswa)
        // Urutkan laporan terbaru
        .order('created_at', ascending: false);

    // Jika tidak ada data laporan return list kosong
    if (response.isEmpty) return [];

    final data = List<Map<String, dynamic>>.from(response);

    final filtered =
        data.where((item) {
          // Ambil data siswa dari relasi laporan ke siswa
          final siswa = item['siswa'] as Map<String, dynamic>?;

          // Ambil data kelas dari relasi siswa ke kelas
          final kelas = siswa?['kelas'] as Map<String, dynamic>?;

          // Ambil data periode ajaran dari relasi kelas ke periode_ajaran
          final periode = kelas?['periode_ajaran'] as Map<String, dynamic>?;

          // Cek apakah siswa masih aktif
          final anakAktif = siswa?['is_active'] == true;

          // Cek apakah kelas siswa masih aktif
          final kelasAktif = kelas?['is_active'] == true;

          // Cek apakah periode ajaran masih aktif
          final periodeAktif = periode?['is_active'] == true;

          // Jika idPeriode tidak dipilih (null), tampilkan semua laporan.
          // Jika dipilih, hanya tampilkan laporanyang memiliki id periode yang sama.
          final matchPeriode = idPeriode == null || periode?['id'] == idPeriode;

          // Hanya tampilkan laporan yang memenuhi seluruh kondisi
          return anakAktif && kelasAktif && periodeAktif && matchPeriode;
        }).toList();

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
