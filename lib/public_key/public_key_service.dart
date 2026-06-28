import 'dart:convert';

import 'package:fiservtrack/public_key/public_key_response_model.dart';
import 'package:http/http.dart' as http;

class PublicKeyService {
  static const String _baseUrl = "https://api.fiservtrack.com/api/auth";
  static const String _publicKeyEndpoint = "/public-key";

  Future<GeneratePublicKeyModel> fetchPublicKeyApi() async {
    final uri = Uri.parse("$_baseUrl$_publicKeyEndpoint");

    final response = await http.get(
      uri,
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);

      print(json); // Print the response

      return GeneratePublicKeyModel(publicKey: json["publicKey"] ?? "");
    } else {
      throw Exception("Failed to fetch public key");
    }
  }
}
