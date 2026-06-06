import 'dart:math' as math;
import 'package:fiservtrack/themes/app_color.dart';
import 'package:flutter/material.dart';
import 'budget_model.dart';
import 'utils.dart';

class BudgetDetailCard extends StatelessWidget {
  final Budget budget;
  final VoidCallback onEdit;
  const BudgetDetailCard({
    Key? key,
    required this.budget,
    required this.onEdit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isOver = budget.spent > budget.limit;
    final progress = math.min(budget.spent / budget.limit, 1.0);
    final remaining = budget.limit - budget.spent;

    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isOver ? const Color(0xFFFEF5F4) : AppColors.card,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isOver ? AppColors.redLight.withOpacity(0.3) : AppColors.cardBorder,
          width: 1.5,
        ),
        boxShadow: const [BoxShadow(color: Color(0x070D2840), blurRadius: 6, offset: Offset(0, 2))],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text(budget.emoji, style: const TextStyle(fontSize: 20)),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      budget.label,
                      style: const TextStyle(
                        color: AppColors.ink,
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      '₹${fmt(budget.spent)} spent of ₹${fmt(budget.limit)}',
                      style: const TextStyle(
                        color: AppColors.inkSoft,
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(8),
                  onTap: onEdit,
                  child: Ink(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: AppColors.brandPale,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'Edit',
                      style: TextStyle(
                        color: AppColors.brand,
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 6,
              backgroundColor: AppColors.divider,
              valueColor: AlwaysStoppedAnimation(budget.colors.first),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${(progress * 100).round()}% used',
                style: const TextStyle(
                  color: AppColors.inkMuted,
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
              ),
              isOver
                  ? Row(
                      children: [
                        const Icon(Icons.warning_amber_rounded, color: AppColors.red, size: 12),
                        const SizedBox(width: 3),
                        Text(
                          'Over by ₹${fmt(-remaining)}',
                          style: const TextStyle(
                            color: AppColors.red,
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    )
                  : Text(
                      '₹${fmt(remaining)} remaining',
                      style: const TextStyle(
                        color: AppColors.inkSoft,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ],
          ),
        ],
      ),
    );
  }
}
