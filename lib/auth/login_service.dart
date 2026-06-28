import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../core/encryption/payload_encryption.dart';
import '../core/session/app_session.dart';
import 'login_response_model.dart';

class LoginService {
  static const String baseUrl = "https://api.fiservtrack.com/api/auth";

  Future<LoginResponseModel> login({
    required String username,
    required String password,
  }) async {
    final publicKey = AppSession.instance.publicKey;

    if (publicKey == null) {
      throw Exception("Public key not found");
    }

    final encryptedPayload = EncryptionHelper.encryptPayload(
      publicKey: publicKey,
      payload: {"username": username, "password": password},
    );

    final response = await http.post(
      Uri.parse("$baseUrl/login"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"payload": encryptedPayload}),
    );

    if (response.statusCode == 200) {
      debugPrint("${response}");
      return LoginResponseModel.fromJson(jsonDecode(response.body));
    }

    throw Exception("Login failed");
  }
}
