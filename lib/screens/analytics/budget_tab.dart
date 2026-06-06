import 'dart:math' as math;
import 'package:fiservtrack/themes/app_color.dart';
import 'package:flutter/material.dart';
import 'widgets/budget_model.dart';
import 'widgets/budget_detail_card.dart';
import 'widgets/add_budget_bottom_sheet.dart';
import 'widgets/edit_budget_bottom_sheet.dart';
import 'widgets/utils.dart';

class BudgetTab extends StatefulWidget {
  final Animation<double> anim;
  const BudgetTab({Key? key, required this.anim}) : super(key: key);

  @override
  State<BudgetTab> createState() => _BudgetTabState();
}

class _BudgetTabState extends State<BudgetTab> {
  final List<Budget> _budgets = [
    const Budget(
      emoji: '🛒',
      label: 'Food & Dining',
      spent: 16800,
      limit: 20000,
      colors: [AppColors.gold, AppColors.goldLight],
    ),
    const Budget(
      emoji: '⛽',
      label: 'Transport',
      spent: 9200,
      limit: 8000,
      colors: [AppColors.red, AppColors.redLight],
    ),
    const Budget(
      emoji: '🎬',
      label: 'Entertainment',
      spent: 2400,
      limit: 5000,
      colors: [AppColors.green, AppColors.greenLight],
    ),
    const Budget(
      emoji: '🛍️',
      label: 'Shopping',
      spent: 6100,
      limit: 10000,
      colors: [AppColors.brand, AppColors.brandLight],
    ),
    const Budget(
      emoji: '💊',
      label: 'Healthcare',
      spent: 1200,
      limit: 3000,
      colors: [Color(0xFF9D7AE4), Color(0xFF7A4EE2)],
    ),
    const Budget(
      emoji: '✈️',
      label: 'Travel',
      spent: 0,
      limit: 15000,
      colors: [AppColors.inkMuted, AppColors.inkFaint],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final total = _budgets.fold(0.0, (s, b) => s + b.spent);
    final overCount = _budgets.where((b) => b.spent > b.limit).length;

    return FadeTransition(
      opacity: widget.anim,
      child: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.only(top: 16, bottom: 100),
        children: [
          // Summary Card
          Container(
            margin: const EdgeInsets.fromLTRB(20, 0, 20, 14),
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [AppColors.brandMid, AppColors.brandDeep]),
              borderRadius: BorderRadius.circular(22),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x2A134372),
                  blurRadius: 16,
                  offset: Offset(0, 6),
                )
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'TOTAL SPENT',
                          style: TextStyle(
                            color: Color(0x80FFFFFF),
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.5,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '₹${fmt(total.toInt())}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.w900,
                            letterSpacing: -1,
                          ),
                        ),
                      ],
                    ),
                    if (overCount > 0)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: AppColors.redBg,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '$overCount over budget',
                          style: const TextStyle(
                            color: AppColors.red,
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 12),
                // overall bar
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: math.min(
                      total / math.max(1.0, _budgets.fold(0.0, (s, b) => s + b.limit)),
                      1.0,
                    ),
                    minHeight: 6,
                    backgroundColor: Colors.white.withOpacity(0.15),
                    valueColor: const AlwaysStoppedAnimation(Color(0xFF34C88A)),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '₹${fmt(total.toInt())} of ₹${fmt(_budgets.fold(0, (s, b) => s + b.limit))} total budget',
                  style: const TextStyle(
                    color: Color(0x80FFFFFF),
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          // Budget List Header
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 2, 20, 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Budget Limits',
                  style: TextStyle(
                    color: AppColors.ink,
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.3,
                  ),
                ),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(10),
                    onTap: _showAddBudgetSheet,
                    child: Ink(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.brandPale,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppColors.brandMid.withOpacity(0.3)),
                      ),
                      child: const Text(
                        '+ Add',
                        style: TextStyle(
                          color: AppColors.brand,
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          if (_budgets.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 40),
              child: Center(
                child: Text(
                  "No budgets defined yet.\nTap '+ Add' to create one.",
                  style: TextStyle(color: AppColors.inkSoft, fontSize: 13, height: 1.4),
                  textAlign: TextAlign.center,
                ),
              ),
            )
          else
            ..._budgets.map(
              (b) => BudgetDetailCard(
                budget: b,
                onEdit: () => _showEditBudgetSheet(b),
              ),
            ),
        ],
      ),
    );
  }

  void _showAddBudgetSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AddBudgetBottomSheet(
        onAdded: (emoji, label, limit, colors) {
          setState(() {
            _budgets.add(
              Budget(
                emoji: emoji,
                label: label,
                spent: 0,
                limit: limit,
                colors: colors,
              ),
            );
          });
        },
      ),
    );
  }

  void _showEditBudgetSheet(Budget b) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => EditBudgetBottomSheet(
        budget: b,
        onSaved: (newLimit) {
          setState(() {
            final index = _budgets.indexOf(b);
            if (index != -1) {
              _budgets[index] = b.copyWith(limit: newLimit);
            }
          });
        },
        onDelete: () {
          setState(() {
            _budgets.remove(b);
          });
        },
      ),
    );
  }
}
