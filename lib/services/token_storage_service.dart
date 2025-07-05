import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fixy/models/auth_model.dart';

class TokenStorageService {
  final _storage = const FlutterSecureStorage();
  final _tokenKey = 'auth_token';
  final _userKey = 'auth_user';

  Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  Future<bool> hasToken() async {
    final token = await _storage.read(key: _tokenKey);
    return token != null;
  }

  Future<void> deleteToken() async {
    await _storage.delete(key: _tokenKey);
    await _storage.delete(key: _userKey);
  }

  Future<void> saveUser(AuthModel user) async {
    final jsonStr = json.encode(user.toJson());
    await _storage.write(key: _userKey, value: jsonStr);
  }

  Future<AuthModel?> getUser() async {
    final jsonStr = await _storage.read(key: _userKey);
    if (jsonStr == null) return null;
    final jsonMap = json.decode(jsonStr);
    return AuthModel.fromJson(jsonMap);
  }
}
