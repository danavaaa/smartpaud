// Model untuk merepresentasikan data kelas
class KelasModel {
  final String id;
  final String namaKelas;
  final String idPeriode;
  final String periodeAjaran;
  final bool isActive;

  // Constructor untuk mengisi seluruh data kelas
  KelasModel({
    required this.id,
    required this.namaKelas,
    required this.idPeriode,
    required this.periodeAjaran,
    required this.isActive,
  });

  // factory constructor untuk mengubah data JSON menjadi object KelasModel
  factory KelasModel.fromJson(Map<String, dynamic> json) {
    // Mengambil data relasi periode_ajaran jika tersedia
    final periode = json['periode_ajaran'];

    // Ambil id_periode langsung dari field utama tabel kelas
    final String periodeId = json['id_periode'] ?? '';

    // Nilai default label periode jika data relasi tidak tersedia
    String periodeLabel = '-';

    // Jika data relasi periode ada, buat label gabungan tahun ajaran dan semester
    if (periode != null) {
      periodeLabel = '${periode['tahun_ajaran']} - ${periode['semester']}';
    }

    // Mengembalikan object KelasModel dari data JSON
    return KelasModel(
      id: json['id'],
      namaKelas: json['nama_kelas'],
      idPeriode: periodeId,
      periodeAjaran: periodeLabel,
      isActive: json['is_active'] ?? false,
    );
  }
}
