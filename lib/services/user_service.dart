import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';

class UserService {
  final String baseUrl;

  UserService({required this.baseUrl});

  /// Get all users
  Future<List<User>> getUsers() async {
    final res = await http.get(Uri.parse('$baseUrl/users'));

    if (res.statusCode == 200) {
      final List data = json.decode(res.body);
      return data.map((u) => User.fromJson(u)).toList();
    } else {
      throw Exception('Failed to load users');
    }
  }

  /// Get single user by ID
  Future<User> getUserById(String id) async {
    final res = await http.get(Uri.parse('$baseUrl/users/$id'));

    if (res.statusCode == 200) {
      return User.fromJson(json.decode(res.body));
    } else {
      throw Exception('User not found');
    }
  }

  /// Create a user
  Future<User> createUser(User user) async {
    final res = await http.post(
      Uri.parse('$baseUrl/users'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(user.toJson()),
    );

    if (res.statusCode == 201) {
      return User.fromJson(json.decode(res.body));
    } else {
      throw Exception('Failed to create user');
    }
  }

  /// Update a user
  Future<User> updateUser(String id, User user) async {
    final res = await http.put(
      Uri.parse('$baseUrl/users/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(user.toJson()),
    );

    if (res.statusCode == 200) {
      return User.fromJson(json.decode(res.body));
    } else {
      throw Exception('Failed to update user');
    }
  }

  /// Delete a user
  Future<void> deleteUser(String id) async {
    final res = await http.delete(Uri.parse('$baseUrl/users/$id'));

    if (res.statusCode != 204) {
      throw Exception('Failed to delete user');
    }
  }
}
