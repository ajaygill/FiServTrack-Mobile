import 'dart:convert';

import 'package:fiservtrack/home/home_response_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class HomeService {
  static const String baseUrl =
      "https://api.fiservtrack.com/api/dashboard/analytics";
  Future<HomeResponseModel> home() async {
    final prefs = await SharedPreferences.getInstance();

    final token = prefs.getString("access_token") ?? "";
    final response = await http.get(
      Uri.parse(baseUrl),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );
    if (response.statusCode == 200) {
      debugPrint("home res:$response");
      return HomeResponseModel.fromJson(jsonDecode(response.body));
    }
    throw Exception("Home request failed");
  }
}
