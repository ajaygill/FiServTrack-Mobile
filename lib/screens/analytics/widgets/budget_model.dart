import 'package:flutter/material.dart';

class Budget {
  final String emoji, label;
  final int spent, limit;
  final List<Color> colors;

  const Budget({
    required this.emoji,
    required this.label,
    required this.spent,
    required this.limit,
    required this.colors,
  });

  Budget copyWith({
    String? emoji,
    String? label,
    int? spent,
    int? limit,
    List<Color>? colors,
  }) {
    return Budget(
      emoji: emoji ?? this.emoji,
      label: label ?? this.label,
      spent: spent ?? this.spent,
      limit: limit ?? this.limit,
      colors: colors ?? this.colors,
    );
  }
}
