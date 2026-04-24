// Model untuk merepresentasikan data guru
class GuruModel {
  // ID unik user pada tabel users
  final String idUser;

  // ID auth dari sistem autentikasi, bisa null
  final String? idAuth;

  // Nama lengkap guru
  final String nama;

  // Email guru
  final String email;

  // Nomor HP guru, bisa null jika belum diisi
  final String? noHp;

  // Status guru, aktif atau tidak
  final bool isActive;

  // Constructor untuk mengisi seluruh data guru
  GuruModel({
    required this.idUser,
    required this.idAuth,
    required this.nama,
    required this.email,
    required this.noHp,
    required this.isActive,
  });

  // Factory constructor untuk mengubah data JSON menjadi object GuruModel
  factory GuruModel.fromJson(Map<String, dynamic> json) {
    return GuruModel(
      // Mengambil id user dari JSON
      idUser: json['id_user'] ?? '',

      // Mengambil id auth dari JSON
      idAuth: json['id_auth'],

      // Mengambil nama guru
      nama: json['nama'] ?? '-',

      // Mengambil email guru
      email: json['email'] ?? '-',

      // Mengambil nomor HP guru
      noHp: json['no_hp'],

      // Mengambil status aktif guru
      // Jika null, default menjadi true
      isActive: json['is_active'] ?? true,
    );
  }
}
