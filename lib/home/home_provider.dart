import 'package:fiservtrack/home/home_response_model.dart';
import 'package:fiservtrack/home/home_service.dart';
import 'package:flutter/cupertino.dart';

class HomeProvider extends ChangeNotifier {
  final HomeService _homeService = HomeService();

  bool _isHomeLoading = false;
  String? _error;
  bool get isHomeLoading => _isHomeLoading;
  String? get error => _error;

  Future<HomeResponseModel?> home() async {
    _isHomeLoading = true;
    _error = null;
    notifyListeners();
    try {
      final response = await _homeService.home();
      _isHomeLoading = false;
      notifyListeners();
      return response;
    } catch (e) {
      _error = e.toString();
      _isHomeLoading = false;
      notifyListeners();
      return null;
    }
  }
}
