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

  // Fungsi untuk mengambil seluruh data kelas
  Future<List<Map<String, dynamic>>> getAllKelas() async {
    // Mengambil data dari tabel 'kelas'
    final response = await client
        .from('kelas')
        .select('id, nama_kelas')
        .order('nama_kelas', ascending: true);

    return List<Map<String, dynamic>>.from(response);
  }

  // ambil semua orang tua
  Future<List<Map<String, dynamic>>> getAllOrangTua() async {
    final response = await client
        .from('users')
        .select('id_user, id_orang_tua, nama')
        .eq('role', 'orang_tua')
        .order('nama', ascending: true);
    // Mengubah hasil response menjadi list map
    return List<Map<String, dynamic>>.from(response);
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
