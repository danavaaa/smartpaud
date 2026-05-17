class LaporanModel {
  // ID laporan
  final String id;

  // ID siswa yang dilaporkan
  final String idSiswa;
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

  // URL foto siswa
  final String? fotoUrl;

  LaporanModel({
    required this.id,
    required this.idSiswa,
    required this.namaSiswa,
    required this.namaKelas,
    required this.tanggal,
    required this.catatanLiterasi,
    required this.ringkasanAi,
    required this.rekomendasiAi,
    this.fotoUrl,
  });

  // Parse dari JSON dari API Supabase
  factory LaporanModel.fromJson(Map<String, dynamic> json) {
    final siswa = json['siswa'] as Map<String, dynamic>? ?? {};
    final kelas = siswa['kelas'] as Map<String, dynamic>? ?? {};

    return LaporanModel(
      id: json['id'] ?? '',
      idSiswa: json['id_siswa'] ?? '',
      namaSiswa: siswa['nama_siswa'] ?? '-',
      namaKelas: kelas['nama_kelas'] ?? '-',
      tanggal: json['tanggal_laporan'] ?? '',
      catatanLiterasi: json['catatan_literasi'] ?? '',
      ringkasanAi: json['ringkasan_ai'] ?? '',
      rekomendasiAi: json['rekomendasi_ai'] ?? '',
      fotoUrl: json['foto_url'],
    );
  }

  // Getter untuk mendapatkan inisial nama siswa
  String get inisial {
    // Menghapus spasi berlebih lalu memisahkan nama
    final parts = namaSiswa.trim().split(' ');

    // Jika nama terdiri dari 2 kata atau lebih, ambil inisial dari dua kata pertama
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    // Jika hanya satu kata atau nama kosong, ambil inisial dari kata pertama saja
    return parts[0][0].toUpperCase();
  }
}
