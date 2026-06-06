import 'dart:math' as math;
import 'package:fiservtrack/themes/app_color.dart';
import 'package:flutter/material.dart';
import 'utils.dart';

class GoalCard extends StatelessWidget {
  final String emoji, label, deadline;
  final int saved, target;
  final List<Color> colors;
  const GoalCard({
    Key? key,
    required this.emoji,
    required this.label,
    required this.deadline,
    required this.saved,
    required this.target,
    required this.colors,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final pct = math.min(saved / target, 1.0);
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.cardBorder, width: 1.5),
        boxShadow: const [BoxShadow(color: Color(0x060D2840), blurRadius: 4, offset: Offset(0, 1))],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text(emoji, style: const TextStyle(fontSize: 20)),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    color: AppColors.ink,
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.brandPale,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  deadline,
                  style: const TextStyle(
                    color: AppColors.brand,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '₹${fmt(saved)}',
                style: TextStyle(
                  color: colors.first,
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                '₹${fmt(target)}',
                style: const TextStyle(
                  color: AppColors.inkMuted,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: pct,
              minHeight: 6,
              backgroundColor: AppColors.divider,
              valueColor: AlwaysStoppedAnimation(colors.first),
            ),
          ),
          const SizedBox(height: 6),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              '${(pct * 100).round()}% saved',
              style: const TextStyle(
                color: AppColors.inkMuted,
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
