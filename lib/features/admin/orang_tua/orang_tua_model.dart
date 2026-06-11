// Model untuk merepresentasikan data orang tua
class OrangTuaModel {
  // ID unik user pada tabel users
  final String idUser;

  // ID auth dari sistem autentikasi
  final String? idAuth;

  // ID orang tua
  final String? idOrangTua;

  // Nama lengkap orang tua
  final String nama;

  // Email orang tua
  final String email;

  // Nomor HP orang tua
  final String? noHp;

  // Status orang tua, aktif atau tidak
  final bool isActive;

  // Constructor untuk mengisi seluruh data orang tua
  final String? namaAyah;
  final String? namaIbu;
  final String? noHpWali;
  final String? pekerjaan;

  OrangTuaModel({
    required this.idUser,
    required this.idAuth,
    required this.idOrangTua,
    required this.nama,
    required this.email,
    required this.noHp,
    required this.isActive,
    required this.namaAyah,
    required this.namaIbu,
    required this.noHpWali,
    required this.pekerjaan,
  });

  // Factory constructor untuk mengubah data JSON menjadi object OrangTuaModel
  factory OrangTuaModel.fromJson(Map<String, dynamic> json) {
    final orangTua = json['orang_tua'] as Map<String, dynamic>?;
    return OrangTuaModel(
      // Mengambil id user dari JSON
      idUser: json['id_user'],

      // Mengambil id auth dari JSON
      idAuth: json['id_auth'],

      // mengambil id ortu
      idOrangTua: json['id_orang_tua'],

      // Mengambil nama orang tua
      nama: json['nama'] ?? '-',

      // Mengambil email orang tua
      email: json['email'] ?? '-',

      // Mengambil nomor HP orang tua
      noHp: json['no_hp'],

      // Mengambil status aktif orang tua
      isActive: json['is_active'] ?? true,

      // Mengambil pekerjaan ortu
      pekerjaan: json['pekerjaan'],

      // mengambil nama ayah
      namaAyah: orangTua?['nama_ayah'],

      // mengambil nama ibu
      namaIbu: orangTua?['nama_ibu'],

      // mengambil no hp wali
      noHpWali: orangTua?['no_hp_wali'],
    );
  }
}
