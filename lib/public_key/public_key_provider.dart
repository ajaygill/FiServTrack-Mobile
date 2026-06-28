import 'package:fiservtrack/public_key/public_key_response_model.dart';
import 'package:flutter/material.dart';

import '../core/session/app_session.dart';
import 'public_key_service.dart';

class PublicKeyProvider extends ChangeNotifier {
  final PublicKeyService _service = PublicKeyService();

  bool _isLoading = false;
  String? _error;

  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<bool> fetchPublicKey() async {
    _isLoading = true;
    _error = null;

    notifyListeners();

    try {
      GeneratePublicKeyModel response = await _service.fetchPublicKeyApi();

      AppSession.instance.setPublicKey(response.publicKey);
      debugPrint("Public key: ${response.publicKey}");
      _isLoading = false;

      notifyListeners();

      return true;
    } catch (e) {
      _isLoading = false;
      _error = e.toString();

      notifyListeners();

      return false;
    }
  }
}
