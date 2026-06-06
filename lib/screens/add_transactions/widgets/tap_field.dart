import 'package:fiservtrack/themes/app_color.dart';
import 'package:flutter/material.dart';

class TapField extends StatelessWidget {
  final String label, value;
  final IconData icon;
  final VoidCallback onTap;
  final bool highlighted;

  const TapField({
    Key? key,
    required this.label,
    required this.value,
    required this.icon,
    required this.onTap,
    this.highlighted = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.fromLTRB(20, 0, 20, 11),
        padding: const EdgeInsets.fromLTRB(16, 13, 16, 13),
        decoration: BoxDecoration(
          color: highlighted ? AppColors.brandPale : AppColors.card,
          border: Border.all(
            color: highlighted ? AppColors.brandMid : AppColors.cardBorder,
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(15),
          boxShadow: highlighted
              ? [
                  BoxShadow(
                    color: AppColors.brand.withOpacity(0.07),
                    blurRadius: 0,
                    spreadRadius: 3,
                  )
                ]
              : const [
                  BoxShadow(
                    color: Color(0x0F0D2840),
                    blurRadius: 3,
                    offset: Offset(0, 1),
                  )
                ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label.toUpperCase(),
                    style: const TextStyle(
                      color: AppColors.inkMuted,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: TextStyle(
                      color: highlighted ? AppColors.brand : AppColors.ink,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              icon,
              size: icon == Icons.calendar_today_rounded ? 16 : 20,
              color: AppColors.inkMuted,
            ),
          ],
        ),
      ),
    );
  }
}
