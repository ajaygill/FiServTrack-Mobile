import 'package:flutter/services.dart';

class MaxAmountFormatter extends TextInputFormatter {
  final double max;
  MaxAmountFormatter(this.max);

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) return newValue;
    final cleaned = newValue.text.replaceAll(',', '');
    if (cleaned.contains('.')) {
      final parts = cleaned.split('.');
      if (parts.length > 2 || parts[1].length > 2) {
        return oldValue;
      }
    }
    final val = double.tryParse(cleaned);
    if (val == null) {
      if (cleaned.endsWith('.') && double.tryParse(cleaned.substring(0, cleaned.length - 1)) != null) {
        return newValue;
      }
      return oldValue;
    }
    if (val > max) return oldValue;
    return newValue;
  }
}
