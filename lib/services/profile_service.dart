import 'dart:convert';
import 'dart:typed_data';
import 'package:fixy/constants/base_urls.dart';
import 'package:fixy/services/token_storage_service.dart';
import 'package:http/http.dart' as http;

class ProfileService {
  final TokenStorageService _tokenStorage = TokenStorageService();

  Future<void> uploadProfileImage(Uint8List imageBytes, {String? token}) async {
    final token = await _tokenStorage.getToken();

    final request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl/api/auth/upload-profile'),
    );

    if (token != null) {
      request.headers['Authorization'] = 'JWT ${token}';
    }

    request.files.add(
      http.MultipartFile.fromBytes(
        'profilePicture',
        imageBytes,
        filename: 'profile.jpg',
      ),
    );

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode != 200) {
      final body = json.decode(response.body);
      throw Exception(body['message'] ?? 'Upload failed');
    }
  }

  Future<void> removeProfileImage() async {
    final uri = Uri.parse('$baseUrl/api/auth/remove-profile');
    final response = await http.delete(uri);

    if (response.statusCode != 200) {
      final data = jsonDecode(response.body);
      throw Exception(data['message'] ?? 'Removal failed');
    }
  }
}
