import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Register new account
  Future<AuthResponse?> register(
    String email,
    String password,
    String username,
    String gender,
    DateTime dob,
    double height_cm,
    double weight_kg,
  ) async {
    AuthResponse authResponse = AuthResponse();
    try {
      authResponse = await _supabase.auth.signUp(
        email: email,
        password: password,
      );

      if (authResponse.user != null) {
        await _supabase.from("Users").insert({
          "id": authResponse.user!.id,
          "username": username,
          "gender": gender,
          "dob": dob.toIso8601String().split("T")[0],
          "height_cm": height_cm,
          "weight_lg": weight_kg,
          // total_points and created_at fields handled by database
        });
      }
    } catch (e) {
      // Let caller handle this exception
      rethrow;
    }
  }

  // Sign in with email and password
  Future<AuthResponse> loginWithEmailAndPassword(
    String email,
    String password,
  ) async {
    return await _supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  // Sign out
  Future<void> logout() async {
    return await _supabase.auth.signOut();
  }

  // Get email
  String? getCurrentUserEmail() {
    final session = _supabase.auth.currentSession;
    final user = session?.user;
    return user?.email;
  }
}
