import 'package:fiservtrack/themes/app_color.dart';
import 'package:flutter/material.dart';

InputDecoration inputDeco(String label, String hint) {
  return InputDecoration(
    labelText: label,
    hintText: hint,
    labelStyle: const TextStyle(
      color: AppColors.inkSoft,
      fontSize: 10,
      fontWeight: FontWeight.w800,
      letterSpacing: 0.5,
    ),
    hintStyle: const TextStyle(
      color: AppColors.inkMuted,
      fontSize: 12,
    ),
    filled: true,
    fillColor: AppColors.surface,
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppColors.cardBorder, width: 1.5),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppColors.brandMid, width: 1.8),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Colors.redAccent, width: 1.8),
    ),
  );
}

String fmt(int v) {
  if (v >= 100000) return '${(v / 100000).toStringAsFixed(v % 100000 == 0 ? 0 : 1)}L';
  if (v >= 1000) {
    final thousands = v ~/ 1000;
    final remainder = v % 1000;
    return remainder == 0
        ? '$thousands,000'
        : '$thousands,${remainder.toString().padLeft(3, '0')}';
  }
  return v.toString();
}

String fmtK(int v) {
  if (v >= 1000) return '₹${(v / 1000).toStringAsFixed(0)}K';
  return '₹$v';
}
