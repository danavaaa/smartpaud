class PeriodeAjaranModel {
  final String id;
  final String tahunAjaran;
  final String semester;
  final String tanggalMulai;
  final String tanggalSelesai;
  final bool isActive;

  PeriodeAjaranModel({
    required this.id,
    required this.tahunAjaran,
    required this.semester,
    required this.tanggalMulai,
    required this.tanggalSelesai,
    required this.isActive,
  });

  factory PeriodeAjaranModel.fromJson(Map<String, dynamic> json) {
    return PeriodeAjaranModel(
      id: json['id'],
      tahunAjaran: json['tahun_ajaran'],
      semester: json['semester'],
      tanggalMulai: json['tanggal_mulai'],
      tanggalSelesai: json['tanggal_selesai'],
      isActive: json['is_active'] ?? false,
    );
  }
}
