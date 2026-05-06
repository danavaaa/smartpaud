// Model untuk merepresentasikan data orang tua
class OrangTuaModel {
  // ID unik user pada tabel users
  final String idUser;

  // ID auth dari sistem autentikasi
  final String? idAuth;

  // Nama lengkap orang tua
  final String nama;

  // Email orang tua
  final String email;

  // Nomor HP orang tua
  final String? noHp;

  // Status orang tua, aktif atau tidak
  final bool isActive;

  // Constructor untuk mengisi seluruh data orang tua
  OrangTuaModel({
    required this.idUser,
    required this.idAuth,
    required this.nama,
    required this.email,
    required this.noHp,
    required this.isActive,
  });

  // Factory constructor untuk mengubah data JSON menjadi object OrangTuaModel
  factory OrangTuaModel.fromJson(Map<String, dynamic> json) {
    return OrangTuaModel(
      // Mengambil id user dari JSON
      idUser: json['id_user'],

      // Mengambil id auth dari JSON
      idAuth: json['id_auth'],

      // Mengambil nama orang tua
      nama: json['nama'] ?? '-',

      // Mengambil email orang tua
      email: json['email'] ?? '-',

      // Mengambil nomor HP orang tua
      noHp: json['no_hp'],

      // Mengambil status aktif orang tua
      isActive: json['is_active'] ?? true,
    );
  }
}
