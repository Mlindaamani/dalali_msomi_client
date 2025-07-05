import 'dart:convert';
import 'dart:typed_data';
import 'package:fixy/constants/base_urls.dart';
import 'package:fixy/models/property_model.dart';
import 'package:fixy/services/token_storage_service.dart';
import 'package:http/http.dart' as http;

class PropertyService {
  final TokenStorageService _token_storage_service = TokenStorageService();

  static Future<List<Property>> getAllProperties() async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/properties'),
      headers: {'ngrok-skip-browser-warning': 'true'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((item) => Property.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load properties');
    }
  }

  Future<void> sellDalaliMsomiProperty(
    Map<String, dynamic> propertyData,
    List<Uint8List> imageBytesList,
    List<Uint8List> contractBytesList, {
    String? token,
  }) async {
    final token = await _token_storage_service.getToken();

    final request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl/api/properties'),
    );

    if (token != null) {
      request.headers['Authorization'] = 'JWT $token';
    }

    for (final imageBytes in imageBytesList) {
      request.files.add(
        http.MultipartFile.fromBytes(
          'propertyImages',
          imageBytes,
          filename: 'property_image_${imageBytesList.indexOf(imageBytes)}.jpg',
        ),
      );
    }

    for (final contractBytes in contractBytesList) {
      request.files.add(
        http.MultipartFile.fromBytes(
          'contracts',
          contractBytes,
          filename: 'contract_${contractBytesList.indexOf(contractBytes)}.pdf',
        ),
      );
    }

    propertyData.forEach((key, value) {
      request.fields[key] = value.toString();
    });

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);
    final responseBody = json.decode(response.body);

    if (response.statusCode != 200) {
      throw Exception(responseBody['message'] ?? 'Failed to sell property');
    }
  }
}
