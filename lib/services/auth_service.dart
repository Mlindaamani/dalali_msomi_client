import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:fixy/constants/base_urls.dart';
import 'package:fixy/models/auth_model.dart';
import 'package:fixy/services/token_storage_service.dart';

class AuthService {
  final TokenStorageService _tokenStorage = TokenStorageService();

  Future<AuthModel> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'email': email, 'password': password}),
    );

    final decoded = jsonDecode(response.body);

    if (response.statusCode == 200) {
      await _tokenStorage.saveToken(decoded['accessToken']);
      final user = AuthModel.fromJson(decoded);
      await _tokenStorage.saveUser(user);
      return user;
    } else {
      throw Exception(decoded['message'] ?? 'Login failed');
    }
  }

  Future<String> register(Map<String, dynamic> payload) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(payload),
    );

    final data = json.decode(response.body);

    if (response.statusCode == 201) {
      return data['message'] ?? 'Registration successful';
    } else {
      throw Exception(data['message'] ?? 'Registration failed');
    }
  }

  Future<void> verifyEmail(String email, String code) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/auth/verify-email'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'email': email, 'code': code}),
    );

    final data = json.decode(response.body);
    if (response.statusCode != 200) {
      throw Exception(data['message'] ?? 'Email verification failed');
    }
  }

  Future<void> logout() async {
    await _tokenStorage.deleteToken();
  }

  Future<String?> getToken() async {
    return await _tokenStorage.getToken();
  }

  Future<bool> isLoggedIn() async {
    return await _tokenStorage.hasToken();
  }

  Future<AuthModel?> getStoredUser() async {
    return await _tokenStorage.getUser();
  }
}
