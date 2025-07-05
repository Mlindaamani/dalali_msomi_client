import 'package:fixy/models/auth_model.dart';
import 'package:fixy/services/token_storage_service.dart';
import 'package:flutter/material.dart';
import 'package:fixy/services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  final TokenStorageService _tokenStorage = TokenStorageService();

  AuthModel? _user;
  bool _loading = false;
  String? _error;

  AuthModel? get user => _user;
  bool get loading => _loading;
  String? get error => _error;

  Future<void> login(String email, String password) async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      _user = await _authService.login(email, password);
    } catch (e) {
      _error = e.toString().replaceFirst('Exception: ', '');
      notifyListeners();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> register(Map<String, dynamic> payload) async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      await _authService.register(payload);
    } catch (e) {
      _error = e.toString().replaceFirst('Exception: ', '');
      notifyListeners();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> verifyEmail(String email, String code) async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      await _authService.verifyEmail(email, code);
    } catch (e) {
      _error = e.toString().replaceFirst('Exception: ', '');
      notifyListeners();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  void logout() {
    _user = null;
    _tokenStorage.deleteToken();
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  Future<void> loadAuthState() async {
    final tokenExists = await _authService.isLoggedIn();
    if (!tokenExists) return;

    final storedUser = await _authService.getStoredUser();
    if (storedUser != null) {
      _user = storedUser;
      notifyListeners();
    }
  }
}
