// Model untuk merepresentasikan data penugasan guru
class PenugasanGuruModel {
  // ID unik untuk setiap data penugasan
  final String id;

  // ID guru yang ditugaskan
  final String idGuru;

  // ID kelas tempat guru ditugaskan
  final String idKelas;

  // Nama guru yang ditampilkan
  final String namaGuru;

  // Nama kelas yang ditampilkan
  final String namaKelas;

  // Peran guru dalam penugasan
  final String peran;

  // Status penugasan, aktif atau tidak
  final bool isActive;

  // Constructor untuk mengisi seluruh data penugasan guru
  PenugasanGuruModel({
    required this.id,
    required this.idGuru,
    required this.idKelas,
    required this.namaGuru,
    required this.namaKelas,
    required this.peran,
    required this.isActive,
  });

  // Factory constructor untuk mengubah data JSON menjadi object PenugasanGuruModel
  factory PenugasanGuruModel.fromJson(Map<String, dynamic> json) {
    // Mengambil data relasi guru dari tabel users
    final guru = json['users'];

    // Mengambil data relasi kelas dari tabel kelas
    final kelas = json['kelas'];

    // Mengembalikan object PenugasanGuruModel dari data JSON
    return PenugasanGuruModel(
      // Mengambil id penugasan
      id: json['id'],

      // Mengambil id guru
      idGuru: json['id_guru'],

      // Mengambil id kelas
      idKelas: json['id_kelas'],

      // Jika data guru tersedia, ambil nama guru
      // Jika nama null, pakai email
      // Jika semuanya null, gunakan tanda '-'
      namaGuru: guru != null ? guru['nama'] ?? guru['email'] ?? '-' : '-',

      // Jika data kelas tersedia, ambil nama kelas
      // Jika null, gunakan tanda '-'
      namaKelas: kelas != null ? kelas['nama_kelas'] ?? '-' : '-',

      // Mengambil peran guru dari JSON
      peran: json['peran_guru'],

      // Mengambil status aktif
      // Jika null, default menjadi false
      isActive: json['is_active'] ?? false,
    );
  }
}
