import 'package:fiservtrack/themes/app_color.dart';
import 'package:flutter/material.dart';

class LegendItem extends StatelessWidget {
  final Color color;
  final String label, value;
  const LegendItem({
    Key? key,
    required this.color,
    required this.label,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(color: AppColors.inkSoft, fontSize: 11)),
        const SizedBox(width: 4),
        Text(
          value,
          style: const TextStyle(
            color: AppColors.ink,
            fontSize: 11,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}
