// services/auth_service.dart
// import 'package:firebase_auth/firebase_auth.dart'; // Dihapus: Tidak lagi menggunakan Firebase Auth

class AuthService {
  // Data pengguna sementara (hardcoded)
  // Dalam aplikasi nyata, ini bisa berasal dari API, database lokal, atau shared_preferences
  static final Map<String, String> _users = {
    'user@example.com': 'password123',
    'test@example.com': 'test123',
  };

  // Status login sementara
  static String? _currentUserEmail;

  // Login method
  /// Melakukan login dengan email dan password menggunakan data sementara.
  /// Mengembalikan `true` jika berhasil, atau `false` jika gagal.
  Future<bool> login(String email, String password) async {
    // Simulasi penundaan jaringan
    await Future.delayed(const Duration(seconds: 1));

    if (_users.containsKey(email) && _users[email] == password) {
      _currentUserEmail = email;
      print('Login berhasil untuk: $email');
      return true;
    } else {
      print('Login gagal: Email atau password salah untuk $email');
      return false;
    }
  }

  // Check if user is logged in
  Future<bool> isLoggedIn() async {
    // Simulasi penundaan
    await Future.delayed(const Duration(milliseconds: 100));
    return _currentUserEmail != null;
  }

  // Logout method
  Future<void> logout() async {
    // Simulasi penundaan
    await Future.delayed(const Duration(milliseconds: 500));
    _currentUserEmail = null;
    print('User logged out.');
  }

  // Get current user email
  Future<String?> getCurrentUserEmail() async {
    // Simulasi penundaan
    await Future.delayed(const Duration(milliseconds: 50));
    return _currentUserEmail;
  }

  /// (Opsional) Mendaftarkan pengguna baru dengan email dan password.
  /// Untuk data sementara, ini bisa berarti menambahkan ke daftar _users.
  Future<bool> signUp(String email, String password) async {
    // Simulasi penundaan jaringan
    await Future.delayed(const Duration(seconds: 1));
    if (_users.containsKey(email)) {
      print('Signup gagal: Email $email sudah terdaftar.');
      return false; // Email sudah ada
    }
    _users[email] = password; // Tambahkan pengguna baru (hanya di memori untuk sesi ini)
    _currentUserEmail = email; // Langsung login setelah signup
    print('Signup berhasil untuk: $email. Pengguna otomatis login.');
    return true;
  }
}
