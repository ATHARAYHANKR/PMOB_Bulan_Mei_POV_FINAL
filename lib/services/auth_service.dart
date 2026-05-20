import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import 'api_service.dart';

class AuthService {
  static const String _currentUserKey = 'current_user';
  static const String _isLoggedInKey = 'is_logged_in';

  late SharedPreferences _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<Map<String, dynamic>> register({
    required String username,
    required String email,
    required String password,
    required String confirmPassword,
    required String fullName,
    required String phoneNumber,
    String role = 'customer',
  }) async {
    try {
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

      if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
        return {
          'success': false,
          'message': 'Format email tidak valid',
        };
      }

      final response = await ApiService.post('/register', {
        'username': username,
        'email': email,
        'password': password,
        'full_name': fullName,
        'phone_number': phoneNumber,
        'role': role,
      });

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        final user = User.fromJson(data['user']);
        final token = data['token'];

        await ApiService.saveToken(token);
        await _saveUserData(user);

        return {
          'success': true,
          'message': 'Registrasi berhasil',
          'user': user,
        };
      }

      final error = jsonDecode(response.body);
      return {
        'success': false,
        'message': error['message'] ?? 'Registrasi gagal',
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Terjadi kesalahan: ${e.toString()}',
      };
    }
  }

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await ApiService.post('/login', {
        'email': email,
        'password': password,
      });

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final user = User.fromJson(data['user']);
        final token = data['token'];

        await ApiService.saveToken(token);
        await _saveUserData(user);

        return {
          'success': true,
          'message': 'Login berhasil',
          'user': user,
        };
      }

      String errorMessage = 'Email atau password salah';
      try {
        final body = jsonDecode(response.body);
        if (body is Map<String, dynamic>) {
          if (body['message'] != null) {
            errorMessage = body['message'].toString();
          } else if (body['errors'] != null &&
              body['errors'] is Map<String, dynamic>) {
            final errors = body['errors'] as Map<String, dynamic>;
            if (errors.isNotEmpty) {
              final firstError = errors.values.first;
              if (firstError is List && firstError.isNotEmpty) {
                errorMessage = firstError.first.toString();
              } else {
                errorMessage = firstError.toString();
              }
            }
          }
        }
      } catch (_) {
        // Keep default error message when body is not valid JSON
      }

      return {
        'success': false,
        'message': errorMessage,
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Terjadi kesalahan: ${e.toString()}',
      };
    }
  }

  Future<void> logout() async {
    try {
      await ApiService.post('/logout', {});
    } catch (_) {
      // ignore API logout failures
    }

    await ApiService.removeToken();
    await _prefs.remove(_currentUserKey);
    await _prefs.remove(_isLoggedInKey);
  }

  User? getCurrentUser() {
    final userJson = _prefs.getString(_currentUserKey);
    if (userJson == null) return null;
    return User.fromJson(jsonDecode(userJson));
  }

  bool isLoggedIn() {
    return _prefs.getBool(_isLoggedInKey) ?? false;
  }

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
      await _saveUserData(currentUser);

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

  Future<void> _saveUserData(User user) async {
    await _prefs.setString(_currentUserKey, jsonEncode(user.toJson()));
    await _prefs.setBool(_isLoggedInKey, true);
  }
}
