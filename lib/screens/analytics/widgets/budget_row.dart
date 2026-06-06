import 'dart:math' as math;
import 'package:fiservtrack/themes/app_color.dart';
import 'package:flutter/material.dart';
import 'utils.dart';

class BudgetRow extends StatelessWidget {
  final String emoji, label;
  final int spent, limit;
  final List<Color> barColor;
  final bool isOver;
  const BudgetRow({
    Key? key,
    required this.emoji,
    required this.label,
    required this.spent,
    required this.limit,
    required this.barColor,
    this.isOver = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final progress = math.min(spent / limit, 1.0);
    final remaining = limit - spent;

    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, bottom: 9),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isOver ? const Color(0xFFFEF5F4) : AppColors.card,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isOver ? AppColors.redLight.withOpacity(0.3) : AppColors.cardBorder,
          width: 1.5,
        ),
        boxShadow: const [BoxShadow(color: Color(0x060D2840), blurRadius: 4, offset: Offset(0, 1))],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text(emoji, style: const TextStyle(fontSize: 18)),
              const SizedBox(width: 9),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    color: AppColors.ink,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Text(
                '₹${fmt(spent)}',
                style: TextStyle(
                  color: isOver ? AppColors.red : AppColors.ink,
                  fontSize: 13,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                '/ ₹${fmt(limit)}',
                style: const TextStyle(
                  color: AppColors.inkMuted,
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 5,
              backgroundColor: AppColors.divider,
              valueColor: AlwaysStoppedAnimation(barColor.first),
            ),
          ),
          const SizedBox(height: 6),
          Align(
            alignment: Alignment.centerRight,
            child: isOver
                ? Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.redBg,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '↑ Over ₹${fmt(-remaining)}',
                      style: const TextStyle(
                        color: AppColors.red,
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  )
                : Text(
                    '₹${fmt(remaining)} left',
                    style: const TextStyle(
                      color: AppColors.inkSoft,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
