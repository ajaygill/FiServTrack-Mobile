import 'package:fiservtrack/themes/app_color.dart';
import 'package:flutter/material.dart';
import 'widgets/chart_card.dart';
import 'widgets/trend_chart.dart';
import 'widgets/legend_item.dart';
import 'widgets/donut_chart.dart';
import 'widgets/donut_legend_row.dart';
import 'widgets/budget_row.dart';
import 'widgets/insight_box.dart';

class OverviewTab extends StatelessWidget {
  final Animation<double> anim;
  const OverviewTab({Key? key, required this.anim}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: anim,
      child: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.only(top: 16, bottom: 100),
        children: [
          // ── Spending Trend Chart ──
          ChartCard(
            title: 'Spending Trend',
            subtitle: 'Daily spend · March',
            child: Column(
              children: [
                const SizedBox(height: 4),
                const TrendChart(),
                const SizedBox(height: 12),
                Row(
                  children: const [
                    LegendItem(color: AppColors.green, label: 'Income', value: '₹1.2L'),
                    SizedBox(width: 16),
                    LegendItem(color: AppColors.red, label: 'Expenses', value: '₹68.2K'),
                  ],
                ),
              ],
            ),
          ),

          // ── Spend Breakdown Donut ──
          const SpendBreakdownSection(),

          // ── Quick Budget Preview ──
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 6, 20, 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  '🎯 Budgets',
                  style: TextStyle(
                    color: AppColors.ink,
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.3,
                  ),
                ),
              ],
            ),
          ),
          const BudgetRow(
            emoji: '🛒',
            label: 'Food & Dining',
            spent: 16800,
            limit: 20000,
            barColor: [AppColors.gold, AppColors.goldLight],
          ),
          const BudgetRow(
            emoji: '⛽',
            label: 'Transport',
            spent: 9200,
            limit: 8000,
            barColor: [AppColors.red, AppColors.redLight],
            isOver: true,
          ),
          const BudgetRow(
            emoji: '🎬',
            label: 'Entertainment',
            spent: 2400,
            limit: 5000,
            barColor: [AppColors.green, AppColors.greenLight],
          ),

          // ── AI Insight ──
          const InsightBox(),
        ],
      ),
    );
  }
}

class SpendBreakdownSection extends StatefulWidget {
  const SpendBreakdownSection({Key? key}) : super(key: key);

  @override
  State<SpendBreakdownSection> createState() => _SpendBreakdownSectionState();
}

class _SpendBreakdownSectionState extends State<SpendBreakdownSection> {
  int _selectedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return ChartCard(
      title: 'Spend Breakdown',
      subtitle: 'Category split · March',
      child: Row(
        children: [
          DonutChart(
            selectedIndex: _selectedIndex,
            onSelected: (idx) {
              setState(() {
                _selectedIndex = idx;
              });
            },
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DonutLegendRow(
                  color: AppColors.red,
                  label: 'EMI / Loans',
                  value: '33%',
                  isSelected: _selectedIndex == 0,
                  isDimmed: _selectedIndex != -1 && _selectedIndex != 0,
                  onTap: () {
                    setState(() {
                      _selectedIndex = _selectedIndex == 0 ? -1 : 0;
                    });
                  },
                ),
                const SizedBox(height: 8),
                DonutLegendRow(
                  color: AppColors.gold,
                  label: 'Food & Dining',
                  value: '25%',
                  isSelected: _selectedIndex == 1,
                  isDimmed: _selectedIndex != -1 && _selectedIndex != 1,
                  onTap: () {
                    setState(() {
                      _selectedIndex = _selectedIndex == 1 ? -1 : 1;
                    });
                  },
                ),
                const SizedBox(height: 8),
                DonutLegendRow(
                  color: AppColors.green,
                  label: 'Transport',
                  value: '19%',
                  isSelected: _selectedIndex == 2,
                  isDimmed: _selectedIndex != -1 && _selectedIndex != 2,
                  onTap: () {
                    setState(() {
                      _selectedIndex = _selectedIndex == 2 ? -1 : 2;
                    });
                  },
                ),
                const SizedBox(height: 8),
                DonutLegendRow(
                  color: AppColors.brand,
                  label: 'Shopping',
                  value: '15%',
                  isSelected: _selectedIndex == 3,
                  isDimmed: _selectedIndex != -1 && _selectedIndex != 3,
                  onTap: () {
                    setState(() {
                      _selectedIndex = _selectedIndex == 3 ? -1 : 3;
                    });
                  },
                ),
                const SizedBox(height: 8),
                DonutLegendRow(
                  color: AppColors.inkFaint,
                  label: 'Others',
                  value: '8%',
                  isSelected: _selectedIndex == 4,
                  isDimmed: _selectedIndex != -1 && _selectedIndex != 4,
                  onTap: () {
                    setState(() {
                      _selectedIndex = _selectedIndex == 4 ? -1 : 4;
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

