class UserSession {
  // Singleton pattern
  static final UserSession _instance = UserSession._internal();
  factory UserSession() => _instance;
  UserSession._internal();

  // Data user yang login
  String? idUser;
  String? idAuth;
  String? nama;
  String? email;
  String? noHp;
  String? role;
  bool isActive = false;

  // Khusus role orang tua
  String? idOrangTua; // dipaai untuk query data anak

  // Isi session dari data profil Supabase
  void setFromProfile(Map<String, dynamic> profile) {
    // Ambil data dari profile lalu simpan ke session
    idUser = profile['id_user'];
    idAuth = profile['id_auth'];
    nama = profile['nama'];
    email = profile['email'];
    noHp = profile['no_hp'];
    role = profile['role'];
    isActive = profile['is_active'] ?? false;
    idOrangTua = profile['id_orang_tua'];
  }

  // Hapus session saat logout
  void clear() {
    // semua data session dikosongkan
    idUser = null;
    idAuth = null;
    nama = null;
    email = null;
    noHp = null;
    role = null;
    isActive = false;
    idOrangTua = null;
  }

  // Cek apakah sudah login
  bool get isLoggedIn => idUser != null;
}
