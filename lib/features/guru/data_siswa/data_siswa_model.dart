class Siswa {
  // ID unik siswa
  final String id;

  // Nama lengkap siswa
  final String nama;

  // Kelas siswa
  final String kelas;

  // Periode ajaran siswa
  final String periode;

  // Status siswa (aktif/nonaktif)
  final String status;

  // Konstruktor untuk membuat objek Siswa
  Siswa({
    required this.id,
    required this.nama,
    required this.kelas,
    required this.periode,
    required this.status,
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
