class Siswa {
  // ID unik siswa
  final String id;

  // Nama lengkap siswa
  final String nama;

  // Nomor Induk Siswa (NIS)
  final String nis;

  // Kelas siswa
  final String kelas;

  // Periode ajaran siswa
  final String periode;

  // Tanggal lahir siswa
  final String tanggalLahir;

  // Jenis kelamin siswa (L/P)
  final String jenisKelamin;

  // Informasi orang tua/wali
  final String namaAyah;

  // Informasi orang tua/wali
  final String namaIbu;

  // Informasi orang tua/wali
  final String noHpWali;

  // Status siswa (aktif/nonaktif)
  final String status;

  // Konstruktor untuk membuat objek Siswa
  Siswa({
    required this.id,
    required this.nama,
    required this.nis,
    required this.kelas,
    required this.periode,
    required this.status,
    required this.tanggalLahir,
    required this.jenisKelamin,
    required this.namaAyah,
    required this.namaIbu,
    required this.noHpWali,
  });

  // Getter untuk mendapatkan inisial nama siswa
  String get inisial {
    // Menghapus spasi di awal/akhir lalu memisahkan nama berdasarkan spasi
    final parts = nama.trim().split(' ');

    // Jika nama memiliki minimal 2 kata
    if (parts.length >= 2) {
      // Mengambil huruf pertama dari kata pertama & kedua
      // lalu diubah menjadi huruf kapital
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }

    // Jika nama hanya 1 kata
    // maka ambil huruf pertama saja
    return parts[0][0].toUpperCase();
  }
}
