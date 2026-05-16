class LaporanModel {
  // ID laporan
  final String id;

  // Nama siswa
  final String namaSiswa;

  // Nama kelas siswa
  final String namaKelas;

  // Tanggal laporan
  final String tanggal;

  // Catatan literasi dari guru
  final String catatanLiterasi;

  // Ringkasan hasil AI
  final String ringkasanAi;

  // Rekomendasi hasil AI
  final String rekomendasiAi;

  // Constructor model laporan
  LaporanModel({
    required this.id,
    required this.namaSiswa,
    required this.namaKelas,
    required this.tanggal,
    required this.catatanLiterasi,
    required this.ringkasanAi,
    required this.rekomendasiAi,
  });

  // Getter untuk mendapatkan inisial nama siswa
  String get inisial {
    // Menghapus spasi berlebih lalu memisahkan nama
    final parts = namaSiswa.trim().split(' ');

    // Jika nama terdiri dari 2 kata atau lebih
    if (parts.length >= 2) {
      // Ambil huruf pertama dari 2 kata pertama
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }

    // Jika hanya satu kata
    return parts[0][0].toUpperCase();
  }
}
