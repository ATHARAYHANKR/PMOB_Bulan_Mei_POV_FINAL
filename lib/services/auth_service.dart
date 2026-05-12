import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class AuthService {
  static const String _usersBoxName = 'users';
  static const String _currentUserKey = 'current_user';
  static const String _isLoggedInKey = 'is_logged_in';

  late Box<User> _usersBox;
  late SharedPreferences _prefs;

  Future<void> init() async {
    _usersBox = await Hive.openBox<User>(_usersBoxName);
    _prefs = await SharedPreferences.getInstance();

    // Clear stale login data if no users exist
    if (_usersBox.isEmpty) {
      await _prefs.remove(_isLoggedInKey);
      await _prefs.remove(_currentUserKey);

      // Tambah demo account untuk testing
      await _initializeDemoAccount();
    }
  }

  // Initialize demo account
  Future<void> _initializeDemoAccount() async {
    final demoUser = User(
      id: '1',
      username: 'demo',
      email: 'demo@trackly.com',
      password: 'demo123',
      fullName: 'Demo User',
      phoneNumber: '08123456789',
      createdAt: DateTime.now(),
    );
    await _usersBox.put(demoUser.id, demoUser);
  }

  // Registrasi akun baru
  Future<Map<String, dynamic>> register({
    required String username,
    required String email,
    required String password,
    required String confirmPassword,
    required String fullName,
    required String phoneNumber,
  }) async {
    try {
      // Validasi
      if (username.isEmpty || email.isEmpty || password.isEmpty) {
        return {
          'success': false,
          'message': 'Semua field harus diisi',
        };
      }

      if (password.length < 6) {
        return {
          'success': false,
          'message': 'Password minimal 6 karakter',
        };
      }

      if (password != confirmPassword) {
        return {
          'success': false,
          'message': 'Password dan konfirmasi tidak cocok',
        };
      }

      // Validasi email format
      if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
        return {
          'success': false,
          'message': 'Format email tidak valid',
        };
      }

      // Cek apakah username atau email sudah terdaftar
      for (var user in _usersBox.values) {
        if (user.username == username) {
          return {
            'success': false,
            'message': 'Username sudah terdaftar',
          };
        }
        if (user.email == email) {
          return {
            'success': false,
            'message': 'Email sudah terdaftar',
          };
        }
      }

      // Buat user baru
      final newUser = User(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        username: username,
        email: email,
        password: password, // Note: In production, hash the password!
        fullName: fullName,
        phoneNumber: phoneNumber,
        createdAt: DateTime.now(),
      );

      // Simpan ke Hive
      await _usersBox.put(newUser.id, newUser);

      return {
        'success': true,
        'message': 'Registrasi berhasil. Silakan login.',
        'user': newUser,
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Terjadi kesalahan: ${e.toString()}',
      };
    }
  }

  // Login
  Future<Map<String, dynamic>> login({
    required String username,
    required String password,
  }) async {
    try {
      if (username.isEmpty || password.isEmpty) {
        return {
          'success': false,
          'message': 'Username dan password harus diisi',
        };
      }

      // Cari user berdasarkan username atau email
      User? foundUser;
      for (var user in _usersBox.values) {
        if ((user.username == username || user.email == username) &&
            user.password == password) {
          foundUser = user;
          break;
        }
      }

      if (foundUser == null) {
        return {
          'success': false,
          'message': 'Username/Email atau password salah',
        };
      }

      // Simpan status login
      await _prefs.setBool(_isLoggedInKey, true);
      await _prefs.setString(_currentUserKey, foundUser.id);

      return {
        'success': true,
        'message': 'Login berhasil',
        'user': foundUser,
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Terjadi kesalahan: ${e.toString()}',
      };
    }
  }

  // Logout
  Future<void> logout() async {
    await _prefs.remove(_isLoggedInKey);
    await _prefs.remove(_currentUserKey);
  }

  // Cek status login
  bool isLoggedIn() {
    return _prefs.getBool(_isLoggedInKey) ?? false;
  }

  // Dapatkan user yang sedang login
  User? getCurrentUser() {
    final userId = _prefs.getString(_currentUserKey);
    if (userId != null && _usersBox.containsKey(userId)) {
      return _usersBox.get(userId);
    }
    return null;
  }

  // Update profile user
  Future<Map<String, dynamic>> updateProfile({
    required String fullName,
    required String phoneNumber,
  }) async {
    try {
      final currentUser = getCurrentUser();
      if (currentUser == null) {
        return {
          'success': false,
          'message': 'User tidak ditemukan',
        };
      }

      currentUser.fullName = fullName;
      currentUser.phoneNumber = phoneNumber;
      await currentUser.save();

      return {
        'success': true,
        'message': 'Profil berhasil diperbarui',
        'user': currentUser,
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Terjadi kesalahan: ${e.toString()}',
      };
    }
  }
}
