import 'package:flutter/material.dart';
import '../models/user_model.dart';
import 'auth_service.dart';

enum AuthState { initial, loading, authenticated, unauthenticated, error }

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  AuthState _state = AuthState.initial;
  User? _currentUser;
  String _errorMessage = '';

  AuthState get state => _state;
  User? get currentUser => _currentUser;
  String get errorMessage => _errorMessage;
  bool get isAuthenticated => _state == AuthState.authenticated;

  // Initialize auth service dan check login status
  Future<void> init() async {
    await _authService.init();
    
    if (_authService.isLoggedIn()) {
      _currentUser = _authService.getCurrentUser();
      _state = AuthState.authenticated;
    } else {
      _state = AuthState.unauthenticated;
    }
    notifyListeners();
  }

  // Register
  Future<bool> register({
    required String username,
    required String email,
    required String password,
    required String confirmPassword,
    required String fullName,
    required String phoneNumber,
  }) async {
    _state = AuthState.loading;
    _errorMessage = '';
    notifyListeners();

    final result = await _authService.register(
      username: username,
      email: email,
      password: password,
      confirmPassword: confirmPassword,
      fullName: fullName,
      phoneNumber: phoneNumber,
    );

    if (result['success']) {
      _state = AuthState.unauthenticated;
      notifyListeners();
      return true;
    } else {
      _state = AuthState.error;
      _errorMessage = result['message'] ?? 'Registrasi gagal';
      notifyListeners();
      return false;
    }
  }

  // Login
  Future<bool> login({
    required String username,
    required String password,
  }) async {
    _state = AuthState.loading;
    _errorMessage = '';
    notifyListeners();

    final result = await _authService.login(
      username: username,
      password: password,
    );

    if (result['success']) {
      _currentUser = result['user'] as User;
      _state = AuthState.authenticated;
      notifyListeners();
      return true;
    } else {
      _state = AuthState.error;
      _errorMessage = result['message'] ?? 'Login gagal';
      _currentUser = null;
      notifyListeners();
      return false;
    }
  }

  // Logout
  Future<void> logout() async {
    await _authService.logout();
    _currentUser = null;
    _state = AuthState.unauthenticated;
    _errorMessage = '';
    notifyListeners();
  }

  // Update profile
  Future<bool> updateProfile({
    required String fullName,
    required String phoneNumber,
  }) async {
    _state = AuthState.loading;
    notifyListeners();

    final result = await _authService.updateProfile(
      fullName: fullName,
      phoneNumber: phoneNumber,
    );

    if (result['success']) {
      _currentUser = result['user'] as User;
      _state = AuthState.authenticated;
      notifyListeners();
      return true;
    } else {
      _state = AuthState.error;
      _errorMessage = result['message'] ?? 'Update gagal';
      notifyListeners();
      return false;
    }
  }
}
