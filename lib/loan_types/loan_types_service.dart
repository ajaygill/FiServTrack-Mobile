import 'dart:convert';

import 'package:fiservtrack/loan_types/loan_types_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoanTypesService {
  static const String loanTypesBaseUrl =
      "https://api.fiservtrack.com/api/masters/loan-types";

  Future<List<LoanTypesModel>> getLoanTypes() async {
    final prefs = await SharedPreferences.getInstance();

    final token = prefs.getString("access_token") ?? "";
    final getLoanTypesResponse = await http.get(
      Uri.parse(loanTypesBaseUrl),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );
    if (getLoanTypesResponse.statusCode == 200) {
      debugPrint("get loan types :$getLoanTypesResponse");
      final List data = jsonDecode(getLoanTypesResponse.body);

      return data.map((e) => LoanTypesModel.fromJson(e)).toList();
      // return LoanTypesModel.fromJson(jsonDecode(getLoanTypesResponse.body));
    }
    throw Exception("get loan types failed");
  }
}
