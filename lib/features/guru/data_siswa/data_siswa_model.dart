class Siswa {
  final String id;
  final String namaSiswa;
  final String tempatLahir;
  final String tanggalLahir;
  final String jenisKelamin;
  final bool isActive;
  final String idKelas;
  final String namaKelas;
  final String periode;
  final String namaAyah;
  final String namaIbu;
  final String noHpWali;

  Siswa({
    required this.id,
    required this.namaSiswa,
    required this.tempatLahir,
    required this.tanggalLahir,
    required this.jenisKelamin,
    required this.isActive,
    required this.idKelas,
    required this.namaKelas,
    required this.periode,
    required this.namaAyah,
    required this.namaIbu,
    required this.noHpWali,
  });

  // Factory digunakan untuk mengubah data JSON/API menjadi object Siswa
  factory Siswa.fromJson(Map<String, dynamic> json) {
    // Mengambil data kelas dari JSON
    // Jika null maka gunakan object kosong {}
    final kelas = json['kelas'] as Map<String, dynamic>? ?? {};

    // Mengambil data periode ajaran dari tabel kelas
    final periodeAjaran =
        kelas['periode_ajaran'] as Map<String, dynamic>? ?? {};

    // Mengambil data orang tua
    final orangTua = json['orang_tua'] as Map<String, dynamic>? ?? {};

    // format periode ajaran
    final tahun = periodeAjaran['tahun_ajaran'] ?? '';

    // ambil semester
    final semester = periodeAjaran['semester'] ?? '';

    // Gabungkan tahun ajaran + semester
    final periodeStr =
        (tahun.isNotEmpty && semester.isNotEmpty) ? '$tahun – $semester' : '-';

    return Siswa(
      id: json['id'] ?? '',
      namaSiswa: json['nama_siswa'] ?? '',
      tempatLahir: json['tempat_lahir'] ?? '-',
      tanggalLahir: json['tanggal_lahir'] ?? '-',
      jenisKelamin: json['jenis_kelamin'] ?? '-',
      isActive: json['is_active'] ?? true,
      idKelas: json['id_kelas'] ?? '',
      namaKelas: kelas['nama_kelas'] ?? '-',
      periode: periodeStr,
      namaAyah: orangTua['nama_ayah'] ?? '-',
      namaIbu: orangTua['nama_ibu'] ?? '-',
      noHpWali: orangTua['no_hp_wali'] ?? '-',
    );
  }

  // Digunakan untuk membuat avatar inisial siswa
  String get inisial {
    // Menghapus spasi di awal/akhir lalu memisahkan nama berdasarkan spasi
    final parts = namaSiswa.trim().split(' ');

    // Jika nama memiliki minimal 2 kata
    if (parts.length >= 2) {
      // Mengambil huruf pertama dari 2 kata pertama
      // lalu diubah menjadi huruf kapital
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }

    // Jika nama hanya 1 kata
    // maka ambil huruf pertama saja
    return parts[0][0].toUpperCase();
  }

  // Digunakan untuk menampilkan status aktif/nonaktif siswa
  String get status => isActive ? 'Aktif' : 'Nonaktif';
}
