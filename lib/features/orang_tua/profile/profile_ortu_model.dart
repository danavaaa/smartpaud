// Model profil orang tua
class ProfileOrtuModel {
  final String id; // ID user/orang tua
  final String nama; // Nama orang tua
  final String email; // Email orang tua
  final String noHp; // Nomor HP orang tua
  final bool isActive; // Status akun aktif / nonaktif

  // Constructor untuk membuat object ProfileOrtuModel
  ProfileOrtuModel({
    required this.id,
    required this.nama,
    required this.email,
    required this.noHp,
    required this.isActive,
  });

  // Factory constructor untuk convert JSON dari database/API menjadi object ProfileOrtuModel
  factory ProfileOrtuModel.fromJson(Map<String, dynamic> json) {
    return ProfileOrtuModel(
      id: json['id_user'] ?? '', // ambil id_user, kalau null jadi string kosong
      nama: json['nama'] ?? '-', // ambil nama, kalau null tampil '-'
      email: json['email'] ?? '-', // ambil email, kalau null tampil '-'
      noHp: json['no_hp'] ?? '-', // ambil nomor HP, kalau null tampil '-'
      isActive: json['is_active'] ?? true, // default true kalau data kosong
    );
  }

  // Getter untuk ubah boolean status jadi text
  String get statusText => isActive ? 'Aktif' : 'Nonaktif';
}

// Model data anak
class AnakProfileModel {
  final String id; // ID siswa
  final String nama; // Nama siswa
  final String namaKelas; // Nama kelas siswa
  final String periode; // Periode ajaran (tahun ajaran + semester)
  final bool isActive; // Status siswa aktif / nonaktif

  // Constructor untuk membuat object AnakProfileModel
  AnakProfileModel({
    required this.id,
    required this.nama,
    required this.namaKelas,
    required this.periode,
    required this.isActive,
  });

  // Factory constructor untuk convert JSON dari database/API menjadi object AnakProfileModel
  factory AnakProfileModel.fromJson(Map<String, dynamic> json) {
    // Ambil data kelas dari JSON (nested object)
    final kelas = json['kelas'] as Map<String, dynamic>? ?? {};

    // Ambil data periode ajaran dari object kelas
    final periodeData = kelas['periode_ajaran'] as Map<String, dynamic>? ?? {};

    // Ambil tahun ajaran
    final tahun = periodeData['tahun_ajaran'] as String? ?? '';

    // Ambil semester
    final semester = periodeData['semester'] as String? ?? '';

    return AnakProfileModel(
      id: json['id'] ?? '', // ID siswa
      nama: json['nama_siswa'] ?? '-', // Nama siswa
      namaKelas: kelas['nama_kelas'] as String? ?? '-', // Nama kelas
      periode: tahun.isNotEmpty ? '$tahun – $semester' : '-',

      // Kalau tahun ada maka gabung jadi "2024/2025 – Semester 1"
      // Kalau kosong maka tampil "-"
      isActive: json['is_active'] ?? false, // Status siswa
    );
  }

  // Getter inisial untuk avatar
  String get inisial {
    final parts = nama.trim().split(' '); // Pisahkan nama berdasarkan spasi
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    return parts[0][0].toUpperCase(); // Kalau cuma 1 kata, ambil huruf pertama
  }

  // Getter untuk ubah boolean status jadi text
  String get statusText => isActive ? 'Aktif' : 'Nonaktif';
}
