import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/user_session.dart';

// service untuk autentikasi menggunakan Supabase
class AuthService {
  final SupabaseClient client = Supabase.instance.client;
  // method untuk sign in dengan email dan password
  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    return await client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  // method untuk mendapatkan user yang sedang login
  User? get currentUser => client.auth.currentUser;
  //  method untuk mendapatkan profil user yang sedang login
  Future<Map<String, dynamic>?> getCurrentUserProfile() async {
    final user = currentUser; // mendapatkan user yang sedang login
    if (user == null) return null;
    final data =
        await client // mengakses tabel 'users' di database Supabase
            .from('users')
            .select()
            .eq(
              'id_auth',
              user.id,
            ) // mencari data yang memiliki id_auth yang sama dengan id user yang sedang login
            .maybeSingle(); // mengambil satu data saja, jika tidak ada data yang ditemukan, kembalikan null

    return data;
  }

  // logout dan clear session
  Future<void> logout() async {
    UserSession().clear(); // hapus data session
    await client.auth.signOut();
  }
}
