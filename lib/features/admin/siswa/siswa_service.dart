import 'package:supabase_flutter/supabase_flutter.dart';
import 'siswa_model.dart';

// Service untuk mengelola data siswa dari database
class SiswaService {
  final SupabaseClient client = Supabase.instance.client;

  // Fungsi untuk mengambil seluruh data siswa
  Future<List<SiswaModel>> getAllSiswa() async {
    final response = await client
        .from('siswa')
        .select('''
          id,
          nama_siswa,
          tempat_lahir,
          tanggal_lahir,
          jenis_kelamin,
          id_kelas,
          id_orang_tua,
          is_active,
          kelas (
            id,
            nama_kelas
          )
        ''')
        // Mengurutkan data berdasarkan created_at terbaru
        .order('created_at', ascending: false);

    // Mengubah hasil response menjadi list object SiswaModel
    return (response as List).map((item) => SiswaModel.fromJson(item)).toList();
  }

  // Fungsi untuk mengambil seluruh data kelas aktif untuk dropdown
  Future<List<Map<String, dynamic>>> getKelasAktifDropdown({
    String? selectedKelasId,
  }) async {
    // ambil data kelas yang aktif dari tabel kelas
    final response = await client
        .from('kelas')
        .select('id, nama_kelas, is_active')
        .eq('is_active', true)
        .order('nama_kelas', ascending: true);

    final list = List<Map<String, dynamic>>.from(response);

    if (selectedKelasId != null && selectedKelasId.isNotEmpty) {
      // periksa apakah kelas yang dipilih sudah ada dalam daftar kelas aktif
      final sudahAda = list.any((item) => item['id'] == selectedKelasId);
      // jika belum ada
      if (!sudahAda) {
        // ambil data kelas berdasarkan ID
        final selectedData =
            await client
                .from('kelas')
                .select('id, nama_kelas, is_active')
                .eq('id', selectedKelasId)
                .maybeSingle();
        // jika data ditemukan, maka tambahkan ke daftar agar tetap muncul pada dropdown saat edit data
        if (selectedData != null) {
          list.add(selectedData);
        }
      }
    }

    return list;
  }

  // fungsi untuk mengambil semua data orang tua untuk dropdown
  Future<List<Map<String, dynamic>>> getOrangTuaAktifDropdown({
    String? selectedOrangTuaId,
  }) async {
    // ambil data pengguna dengan role orang_tua yang masih aktif
    final response = await client
        .from('users')
        .select('id_user, id_orang_tua, nama, is_active')
        .eq('role', 'orang_tua')
        .eq('is_active', true)
        // pastikan hanya data yang memiliki relasi ke tabel orang_tua yang diambil
        .not('id_orang_tua', 'is', null)
        // mengurutkan nama berdasarkan nama
        .order('nama', ascending: true);

    final list = List<Map<String, dynamic>>.from(response);

    if (selectedOrangTuaId != null && selectedOrangTuaId.isNotEmpty) {
      // perikda apakah data orang tua yang dipilih sudah ada pada daftar orang tua aktif
      final sudahAda = list.any(
        (item) => item['id_orang_tua'] == selectedOrangTuaId,
      );
      // jika belum ada pada daftar
      if (!sudahAda) {
        // ambil data orang tua berdasarkan id_orang_tua meskipun statusnya sudah tidak aktif
        final selectedData =
            await client
                .from('users')
                .select('id_user, id_orang_tua, nama, is_active')
                .eq('role', 'orang_tua')
                .eq('id_orang_tua', selectedOrangTuaId)
                .maybeSingle();
        // jika data ditemukan, maka tambahkan ke daftar dropdown
        if (selectedData != null) {
          list.add(selectedData);
        }
      }
    }
    // mengembalikan daftar orang tua yang siap digunakan pada dropdown
    return list;
  }

  // Fungsi untuk menambahkan data siswa baru
  Future<void> addSiswa({
    required String namaSiswa,
    required String idKelas,
    required bool isActive,
    String? idOrangTua,
    String? tempatLahir,
    String? tanggalLahir,
    String? jenisKelamin,
  }) async {
    // Menyimpan data baru ke tabel 'siswa'
    await client.from('siswa').insert({
      'nama_siswa': namaSiswa,
      'id_kelas': idKelas,
      'is_active': isActive,
      'id_orang_tua': idOrangTua,
      'tempat_lahir': tempatLahir,
      'tanggal_lahir': tanggalLahir,
      'jenis_kelamin': jenisKelamin,
    });
  }

  // Fungsi untuk mengupdate data siswa yang sudah ada
  Future<void> updateSiswa({
    required String id,
    required String namaSiswa,
    required String idKelas,
    required bool isActive,
    String? idOrangTua,
    String? tempatLahir,
    String? tanggalLahir,
    String? jenisKelamin,
  }) async {
    // Memperbarui data siswa berdasarkan id
    await client
        .from('siswa')
        .update({
          'nama_siswa': namaSiswa,
          'id_kelas': idKelas,
          'is_active': isActive,
          'id_orang_tua': idOrangTua,
          'tempat_lahir': tempatLahir,
          'tanggal_lahir': tanggalLahir,
          'jenis_kelamin': jenisKelamin,
        })
        .eq('id', id);
  }
}
