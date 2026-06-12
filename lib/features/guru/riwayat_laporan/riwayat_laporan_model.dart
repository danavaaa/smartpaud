class LaporanModel {
  // ID laporan
  final String id;

  // ID siswa yang dilaporkan
  final String idSiswa;
  // Nama siswa
  final String namaSiswa;

  // Nama kelas siswa
  final String namaKelas;

  // ID periode ajaran
  final String periodeId;

  // Label periode ajaran
  final String periode;

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
    required this.periodeId,
    required this.periode,
    required this.tanggal,
    required this.catatanLiterasi,
    required this.ringkasanAi,
    required this.rekomendasiAi,
    this.fotoUrl,
  });

  // Factory method untuk mengubah data JSON dari Supabase
  factory LaporanModel.fromJson(Map<String, dynamic> json) {
    // Ambil data relasi siswa
    final siswa = json['siswa'] as Map<String, dynamic>? ?? {};
    // Ambil data relasi kelas dari siswa
    final kelas = siswa['kelas'] as Map<String, dynamic>? ?? {};
    // Ambil data relasi periode ajaran dari kelas
    final periodeAjaran =
        kelas['periode_ajaran'] as Map<String, dynamic>? ?? {};
    // Ambil tahun ajaran
    final tahun = periodeAjaran['tahun_ajaran'] ?? '';
    // Ambil semester
    final semester = periodeAjaran['semester'] ?? '';
    // Gabungkan tahun ajaran dan semester menjadi format periode
    final periodeStr =
        (tahun.isNotEmpty && semester.isNotEmpty) ? '$tahun – $semester' : '-';
    // Membuat objek LaporanModel dari data JSON
    return LaporanModel(
      id: json['id'] ?? '',
      idSiswa: json['id_siswa'] ?? '',

      // Data siswa
      namaSiswa: siswa['nama_siswa'] ?? '-',

      // Data kelas
      namaKelas: kelas['nama_kelas'] ?? '-',

      // Data periode ajaran
      periodeId: periodeAjaran['id'] ?? '',
      periode: periodeStr,

      // Data laporan
      tanggal: json['tanggal_laporan'] ?? '',
      catatanLiterasi: json['catatan_literasi'] ?? '',

      // Hasil analisis AI
      ringkasanAi: json['ringkasan_ai'] ?? '',
      rekomendasiAi: json['rekomendasi_ai'] ?? '',

      // URL foto dokumentasi laporan
      fotoUrl: json['foto_url'],
    );
  }

  // Getter untuk mendapatkan inisial nama siswa
  String get inisial {
    // Menghapus spasi lalu memisahkan nama menjadi beberapa kata
    final parts = namaSiswa.trim().split(' ');

    // Jika nama terdiri dari 2 kata atau lebih, ambil inisial dari dua kata pertama
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }

    // Jika hanya terdiri dari satu kata, ambil huruf pertama sebagai inisial
    return parts[0][0].toUpperCase();
  }
}
