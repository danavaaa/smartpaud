// Model data profil guru
class ProfileModel {
  final String id;
  final String nama;
  final String email;
  final String noHp;
  final bool isActive;

  ProfileModel({
    required this.id,
    required this.nama,
    required this.email,
    required this.noHp,
    required this.isActive,
  });

  // Parse dari JSON Supabase
  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id_user'] ?? '',
      nama: json['nama'] ?? '-',
      email: json['email'] ?? '-',
      noHp: json['no_hp'] ?? '-',
      isActive: json['is_active'] ?? true,
    );
  }

  // Konversi status aktif ke teks
  String get statusText => isActive ? 'Aktif' : 'Nonaktif';
}

// Model data kelas yang diampu
class KelasModel {
  final String namaKelas;
  final String peranGuru;
  final String periode;

  KelasModel({
    required this.namaKelas,
    required this.peranGuru,
    required this.periode,
  });

  // Parse dari JSON Supabase (relasi penugasan_guru → kelas → periode_ajaran)
  factory KelasModel.fromJson(Map<String, dynamic> json) {
    final kelas = json['kelas'] as Map<String, dynamic>? ?? {};
    final periodeData = kelas['periode_ajaran'] as Map<String, dynamic>? ?? {};

    final tahun = periodeData['tahun_ajaran'] as String? ?? '';
    final semester = periodeData['semester'] as String? ?? '';

    return KelasModel(
      namaKelas: kelas['nama_kelas'] as String? ?? '-',
      peranGuru: json['peran_guru'] as String? ?? '-',
      periode: '$tahun – $semester',
    );
  }
}
