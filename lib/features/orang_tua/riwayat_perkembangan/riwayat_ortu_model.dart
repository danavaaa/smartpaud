// Model laporan perkembangan untuk tampilan orang tua
class LaporanOrtuModel {
  // ID laporan
  final String id;

  // ID siswa yang terkait dengan laporan
  final String idSiswa;

  // Nama siswa
  final String namaSiswa;

  // Nama kelas siswa
  final String namaKelas;

  // Tanggal laporan dibuat
  final String tanggal;

  // Catatan literasi dari guru
  final String catatanLiterasi;

  // Ringkasan hasil AI
  final String ringkasanAi;

  // Rekomendasi stimulasi dari AI
  final String rekomendasiAi;

  // URL foto kegiatan (nullable jika tidak ada foto)
  final String? fotoUrl;

  // Status apakah laporan masih baru
  final bool isNew;

  // Constructor model laporan
  LaporanOrtuModel({
    required this.id,
    required this.idSiswa,
    required this.namaSiswa,
    required this.namaKelas,
    required this.tanggal,
    required this.catatanLiterasi,
    required this.ringkasanAi,
    required this.rekomendasiAi,
    this.fotoUrl,
    required this.isNew,
  });

  // Factory constructor untuk parse data dari JSON Supabase
  factory LaporanOrtuModel.fromJson(
    Map<String, dynamic> json, {

    // ID laporan terbaru untuk menentukan badge "Baru"
    required String latestId,
  }) {
    // Mengambil data siswa dari relasi JSON
    final siswa = json['siswa'] as Map<String, dynamic>? ?? {};

    // Mengambil data kelas dari relasi siswa
    final kelas = siswa['kelas'] as Map<String, dynamic>? ?? {};

    return LaporanOrtuModel(
      // ID laporan
      id: json['id'] ?? '',

      // ID siswa
      idSiswa: json['id_siswa'] ?? '',

      // Nama siswa dari relasi siswa
      namaSiswa: siswa['nama_siswa'] ?? '-',

      // Nama kelas dari relasi kelas
      namaKelas: kelas['nama_kelas'] ?? '-',

      // Tanggal laporan
      tanggal: json['tanggal_laporan'] ?? '',

      // Catatan literasi guru
      catatanLiterasi: json['catatan_literasi'] ?? '',

      // Ringkasan AI
      ringkasanAi: json['ringkasan_ai'] ?? '',

      // Rekomendasi AI
      rekomendasiAi: json['rekomendasi_ai'] ?? '',

      // URL foto kegiatan
      fotoUrl: json['foto_url'],

      // Laporan dianggap "Baru" jika id sama dengan laporan terbaru
      isNew: json['id'] == latestId,
    );
  }

  // Getter untuk membuat inisial nama siswa (avatar)
  String get inisial {
    // Memisahkan nama berdasarkan spasi
    final parts = namaSiswa.trim().split(' ');

    // Jika nama lebih dari satu kata, ambil 2 huruf awal
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }

    // Jika hanya satu kata, ambil 1 huruf awal
    return parts[0][0].toUpperCase();
  }

  // Getter untuk preview singkat catatan
  String get preview {
    // Jika catatan lebih dari 50 karakter
    if (catatanLiterasi.length > 50) {
      // Potong teks dan tambahkan titik tiga
      return '${catatanLiterasi.substring(0, 50)}...';
    }

    // Jika pendek, tampilkan penuh
    return catatanLiterasi;
  }
}

// Model data anak untuk dropdown orang tua
class AnakOrtuModel {
  // ID anak
  final String id;

  // Nama anak
  final String nama;

  // Nama kelas anak
  final String namaKelas;

  // Status aktif / tidak aktif
  final bool isActive;

  // Constructor model anak
  AnakOrtuModel({
    required this.id,
    required this.nama,
    required this.namaKelas,
    required this.isActive,
  });

  // Getter untuk label dropdown
  String get label => '$nama (${isActive ? 'Aktif' : 'Tidak Aktif'})';
}
