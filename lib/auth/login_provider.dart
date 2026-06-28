import 'package:flutter/material.dart';

import 'login_response_model.dart';
import 'login_service.dart';

class LoginProvider extends ChangeNotifier {
  final LoginService _service = LoginService();

  bool _isLoading = false;

  String? _error;

  bool get isLoading => _isLoading;

  String? get error => _error;

  Future<LoginResponseModel?> login({
    required String username,
    required String password,
  }) async {
    _isLoading = true;
    _error = null;

    notifyListeners();

    try {
      final response = await _service.login(
        username: username,
        password: password,
      );

      _isLoading = false;

      notifyListeners();

      return response;
    } catch (e) {
      _error = e.toString();

      _isLoading = false;

      notifyListeners();

      return null;
    }
  }
}
