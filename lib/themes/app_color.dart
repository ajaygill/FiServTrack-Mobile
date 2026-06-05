import 'package:flutter/material.dart';

class AppColors {
  // Prevent instantiation
  AppColors._();

  // ── Brand Colors ───────────────────────────────────────────────────────────
  static const brand      = Color(0xFF134372); // Primary Brand Blue
  static const brandDeep  = Color(0xFF0C2E52); // Deep Brand Blue
  static const brandMid   = Color(0xFF1D5A9A); // Medium Brand Blue
  static const brandLight = Color(0xFF2471C8); // Light Brand Blue
  static const brandPale  = Color(0xFFEAF2FB); // Pale Brand Blue (Background highlight)
  static const brandTint  = Color(0xFFF0F6FF); // Tinted Brand Blue

  // ── Success Colors (Green) ─────────────────────────────────────────────────
  static const green      = Color(0xFF0F7B50); // Primary Success Green
  static const greenDeep  = Color(0xFF0A5438); // Deep Success Green
  static const greenLight = Color(0xFF34C88A); // Bright/Light Success Green
  static const greenBg    = Color(0xFFE8FAF3); // Light Green Background
  static const greenBorder= Color(0xFF8AECC4); // Light Green Border

  // ── Error/Alert Colors (Red) ───────────────────────────────────────────────
  static const red        = Color(0xFFC0392B); // Primary Error Red
  static const redLight   = Color(0xFFF46C60); // Bright/Light Red
  static const redLightAlt= Color(0xFFE74C3C); // Alternate Light Red (Analytics)
  static const redBg      = Color(0xFFFEF0EE); // Light Red Background

  // ── Warning/Promo Colors (Gold) ────────────────────────────────────────────
  static const gold       = Color(0xFFB8860B); // Primary Gold/Yellow
  static const goldLight  = Color(0xFFE8B84B); // Light Gold
  static const goldBg     = Color(0xFFFEF9ED); // Light Gold Background
  static const goldCard   = Color(0xFFE8C96A); // Warm gold card fill
  static const goldBorder = Color(0xFFF0D080); // Gold Border

  // ── Neutrals & Typography (Ink / Slate) ────────────────────────────────────
  static const ink        = Color(0xFF0D2840); // Primary Dark Text/Ink
  static const inkMid     = Color(0xFF2C4A65); // Medium Dark Text
  static const inkSoft    = Color(0xFF5C7A96); // Soft Text/Subtitles
  static const inkMuted   = Color(0xFF94AFC6); // Muted Text/Placeholders
  static const inkFaint   = Color(0xFFC8D8E8); // Faint line/Disabled indicator
  static const slate      = Color(0xFF7C8D9F); // Slate Gray used in Auth
  static const slateLight = Color(0xFFB0C0D0); // Light Slate Gray
  static const charcoal   = Color(0xFF4A5F75); // Dark Charcoal Text

  // ── Surface & Cards ────────────────────────────────────────────────────────
  static const surface    = Color(0xFFF2F7FC); // App Background Surface
  static const card       = Color(0xFFFFFFFF); // Card Background (White)
  static const cardBorder = Color(0xFFDDE8F2); // Card/Input Border
  static const divider    = Color(0xFFEBF2F9); // Divider Lines

  // ── Accent / Category Colors ───────────────────────────────────────────────
  static const purple      = Color(0xFF7C3AED); // Category/Icon Purple
  static const purpleBg    = Color(0xFFF3EFFF); // Purple Background
  static const sky         = Color(0xFF0284C7); // Category/Icon Sky Blue
  static const skyBg       = Color(0xFFF0F9FF); // Sky Blue Background
  static const orangeBg    = Color(0xFFFFF4E8); // Orange Background
  static const lightGreenBg= Color(0xFFF0FDF4); // Light Green Background (Alternative)
  static const lightGrayBg = Color(0xFFF8F9FA); // Light Neutral Gray Background

  // ── Gradients ──────────────────────────────────────────────────────────────
  static const brandGradient = LinearGradient(
    colors: [brandMid, brandDeep],
    begin: Alignment.topCenter,
    end: Alignment.bottomRight,
  );

  static const goldGradient = LinearGradient(
    colors: [goldCard, gold],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // ── Shadows ────────────────────────────────────────────────────────────────
  static const shadowSm = BoxShadow(
    color: Color(0x0F0D2840),
    blurRadius: 3,
    offset: Offset(0, 1),
  );

  static const shadowMd = BoxShadow(
    color: Color(0x1A0D2840),
    blurRadius: 8,
    offset: Offset(0, 4),
  );

  static const shadowGold = BoxShadow(
    color: Color(0x1AB8860B),
    blurRadius: 8,
    offset: Offset(0, 2),
  );
}