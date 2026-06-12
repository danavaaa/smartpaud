import 'package:supabase_flutter/supabase_flutter.dart';
import 'penugasan_guru_model.dart';

// Service untuk mengelola data penugasan guru dari database Supabase
class PenugasanGuruService {
  final SupabaseClient client = Supabase.instance.client;

  // Fungsi untuk mengambil seluruh data penugasan guru
  Future<List<PenugasanGuruModel>> getAllPenugasanGuru() async {
    final response = await client
        .from('penugasan_guru')
        .select('''
          id,
          id_guru,
          id_kelas,
          peran_guru,
          is_active,
          users (
            id_user,
            nama,
            email
          ),
          kelas (
            id,
            nama_kelas
          )
        ''')
        // Mengurutkan data berdasarkan created_at terbaru
        .order('created_at', ascending: false);

    // Mengubah hasil response menjadi list object PenugasanGuruModel
    return (response as List)
        .map((item) => PenugasanGuruModel.fromJson(item))
        .toList();
  }

  // Fungsi untuk mengambil seluruh data guru untuk dropdown
  Future<List<Map<String, dynamic>>> getGuruAktifDropdown({
    String? selectedGuruId,
  }) async {
    // ambil data guru aktif
    final response = await client
        .from('users')
        .select('id_user, nama, email, is_active')
        // hanya mengambil data dengan role guru
        .eq('role', 'guru')
        // hanya guru yang aktif
        .eq('is_active', true)
        // urutkan berdasarkan nama
        .order('nama', ascending: true);

    final list = List<Map<String, dynamic>>.from(response);

    if (selectedGuruId != null && selectedGuruId.isNotEmpty) {
      // periksa apakah guru sudah ada dalam daftar guru aktif
      final sudahAda = list.any((item) => item['id_user'] == selectedGuruId);
      // jika belum ada dalam list
      if (!sudahAda) {
        // ambil data guru berdasarkan ID
        final selectedData =
            await client
                .from('users')
                .select('id_user, nama, email, is_active')
                .eq('id_user', selectedGuruId)
                .maybeSingle();
        // jika data ditemukan, tambahkan ke daftar agar data tetap dapat ditampilkan pada form edit
        if (selectedData != null) {
          list.add(selectedData);
        }
      }
    }
    // kembalikan data
    return list;
  }

  // Fungsi untuk mengambil seluruh data kelas untuk dropdown
  Future<List<Map<String, dynamic>>> getKelasAktifDropdown({
    String? selectedKelasId,
  }) async {
    // ambil data kelas aktif
    final response = await client
        .from('kelas')
        .select('id, nama_kelas, is_active')
        // hanya mengambil kelas yang aktif
        .eq('is_active', true)
        // ururtkan berdasarkan nama kelas
        .order('nama_kelas', ascending: true);

    final list = List<Map<String, dynamic>>.from(response);

    if (selectedKelasId != null && selectedKelasId.isNotEmpty) {
      // periksa apakah kelas yang dipilih sudah ada dalam daftar kelas aktif
      final sudahAda = list.any((item) => item['id'] == selectedKelasId);
      // jika belum ada dalam list
      if (!sudahAda) {
        // ambil data kelas berdasarkan ID
        final selectedData =
            await client
                .from('kelas')
                .select('id, nama_kelas, is_active')
                .eq('id', selectedKelasId)
                .maybeSingle();
        // jika data ditemukan, tambahkan ke daftar agar tetap dapat ditampilkan saat proses edit
        if (selectedData != null) {
          list.add(selectedData);
        }
      }
    }

    return list;
  }

  // Fungsi untuk menambahkan data penugasan guru baru
  Future<void> addPenugasanGuru({
    required String idGuru,
    required String idKelas,
    required String peranGuru,
    required bool isActive,
  }) async {
    // Menyimpan data baru ke tabel 'penugasan_guru'
    await client.from('penugasan_guru').insert({
      'id_guru': idGuru,
      'id_kelas': idKelas,
      'peran_guru': peranGuru,
      'is_active': isActive,
    });
  }

  // Fungsi untuk mengupdate data penugasan guru yang sudah ada
  Future<void> updatePenugasanGuru({
    required String id,
    required String idGuru,
    required String idKelas,
    required String peranGuru,
    required bool isActive,
  }) async {
    // Memperbarui data penugasan guru berdasarkan id
    await client
        .from('penugasan_guru')
        .update({
          'id_guru': idGuru,
          'id_kelas': idKelas,
          'peran_guru': peranGuru,
          'is_active': isActive,
        })
        .eq(
          'id',
          id,
        ); // Memastikan hanya data dengan id yang sesuai yang diperbarui
  }
}
