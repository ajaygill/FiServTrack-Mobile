import 'package:fiservtrack/loan_types/loan_types_model.dart';
import 'package:fiservtrack/loan_types/loan_types_service.dart';
import 'package:flutter/cupertino.dart';

class LoanTypesProvider extends ChangeNotifier {
  final LoanTypesService _loanTypesService = LoanTypesService();

  bool _isLoanTypesLoading = false;
  String? _error;
  bool get isLoanTypesLoading => _isLoanTypesLoading;
  String? get error => _error;
  List<LoanTypesModel> _loanTypes = [];
  List<LoanTypesModel> get loanTypes => _loanTypes;

  Future<void> getLoanTypes() async {
    _isLoanTypesLoading = true;
    _error = null;
    notifyListeners();

    try {
      _loanTypes = await _loanTypesService.getLoanTypes();

      _isLoanTypesLoading = false;
      notifyListeners();
      // return response;
    } catch (e) {
      _error = e.toString();
      _isLoanTypesLoading = false;
      notifyListeners();
      return null;
    }
  }
}
