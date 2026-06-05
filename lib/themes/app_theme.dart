import 'package:flutter/material.dart';
import 'app_color.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: AppColors.brand,
      scaffoldBackgroundColor: AppColors.surface,
      dividerColor: AppColors.divider,

      colorScheme: const ColorScheme.light(
        primary: AppColors.brand,
        secondary: AppColors.brandMid,
        surface: AppColors.card,
        error: AppColors.red,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: AppColors.ink,
        onError: Colors.white,
      ),

      // ── Card Theme ──────────────────────────────────────────────────────────
      cardTheme: CardThemeData(
        color: AppColors.card,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.cardBorder, width: 1),
        ),
      ),

      // ── AppBar Theme ────────────────────────────────────────────────────────
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: AppColors.ink),
        titleTextStyle: TextStyle(
          color: AppColors.ink,
          fontSize: 18,
          fontWeight: FontWeight.w800,
        ),
      ),

// No global inputDecorationTheme because the app uses custom Containers to wrap input fields and style borders/fills locally.

      // ── Button Themes ───────────────────────────────────────────────────────
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.brand,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.2,
          ),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.brand,
          side: const BorderSide(color: AppColors.brand, width: 1.5),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.2,
          ),
        ),
      ),

      // ── Text Theme ──────────────────────────────────────────────────────────
      textTheme: const TextTheme(
        headlineLarge: TextStyle(color: AppColors.ink, fontSize: 32, fontWeight: FontWeight.w900),
        headlineMedium: TextStyle(color: AppColors.ink, fontSize: 24, fontWeight: FontWeight.w800),
        titleLarge: TextStyle(color: AppColors.ink, fontSize: 20, fontWeight: FontWeight.w800),
        titleMedium: TextStyle(color: AppColors.ink, fontSize: 16, fontWeight: FontWeight.w700),
        titleSmall: TextStyle(color: AppColors.inkMid, fontSize: 14, fontWeight: FontWeight.w600),
        bodyLarge: TextStyle(color: AppColors.inkMid, fontSize: 16, fontWeight: FontWeight.normal),
        bodyMedium: TextStyle(color: AppColors.inkSoft, fontSize: 14, fontWeight: FontWeight.normal),
        bodySmall: TextStyle(color: AppColors.inkMuted, fontSize: 12, fontWeight: FontWeight.normal),
      ),
    );
  }
}