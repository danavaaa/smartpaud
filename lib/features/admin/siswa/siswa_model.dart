// Model untuk merepresentasikan data siswa
class SiswaModel {
  // ID unik untuk setiap siswa
  final String id;

  // Nama siswa
  final String namaSiswa;

  // ID kelas yang terhubung dengan siswa
  final String? idKelas;

  // Nama kelas untuk ditampilkan
  final String namaKelas;

  // Status siswa, aktif atau tidak
  final bool isActive;

  // ID orang tua
  final String? idOrangTua;

  // Tempat lahir siswa
  final String? tempatLahir;

  // Tanggal lahir siswa
  final String? tanggalLahir;

  // Jenis kelamin siswa
  final String? jenisKelamin;

  // Constructor untuk mengisi seluruh data siswa
  SiswaModel({
    required this.id,
    required this.namaSiswa,
    required this.idKelas,
    required this.namaKelas,
    required this.isActive,
    this.idOrangTua,
    this.tempatLahir,
    this.tanggalLahir,
    this.jenisKelamin,
  });

  // Factory constructor untuk mengubah data JSON menjadi object SiswaModel
  factory SiswaModel.fromJson(Map<String, dynamic> json) {
    // Mengambil data relasi kelas dari JSON
    final kelas = json['kelas'];

    return SiswaModel(
      // Mengambil id siswa dari JSON
      id: json['id'],

      // Mengambil nama siswa
      namaSiswa: json['nama_siswa'] ?? '-',

      // Mengambil id kelas dari field utama tabel siswa
      idKelas: json['id_kelas'],

      // Jika data relasi kelas tersedia, ambil nama kelas
      namaKelas: kelas != null ? kelas['nama_kelas'] ?? '-' : '-',

      // Mengambil status aktif siswa
      isActive: json['is_active'] ?? true,

      // Mengambil ID ortu dari tabel siswa
      idOrangTua: json['id_orang_tua'],

      // Mengambil data tempat lahir
      tempatLahir: json['tempat_lahir'],

      // Mengambil data tanggal lahir
      tanggalLahir: json['tanggal_lahir'],

      // Mengambil data jenis kelamin
      jenisKelamin: json['jenis_kelamin'],
    );
  }
}
