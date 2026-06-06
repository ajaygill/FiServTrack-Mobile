import 'package:fiservtrack/themes/app_color.dart';
import 'package:flutter/material.dart';
import 'widgets/chart_card.dart';
import 'widgets/forecast_bars.dart';
import 'widgets/mom_bars.dart';
import 'widgets/savings_projection_chart.dart';
import 'widgets/legend_item.dart';
import 'widgets/goal_card.dart';
import 'widgets/insight_box.dart';

class ForecastTab extends StatelessWidget {
  final Animation<double> anim;
  const ForecastTab({Key? key, required this.anim}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: anim,
      child: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.only(top: 16, bottom: 100),
        children: [
          // Forecast summary card
          Container(
            margin: const EdgeInsets.fromLTRB(20, 0, 20, 14),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: AppColors.cardBorder, width: 1.5),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x0A0D2840),
                  blurRadius: 12,
                  offset: Offset(0, 4),
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
                      children: const [
                        Text(
                          'PROJECTED SPEND',
                          style: TextStyle(
                            color: AppColors.inkMuted,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.5,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          '₹82,500',
                          style: TextStyle(
                            color: AppColors.ink,
                            fontSize: 26,
                            fontWeight: FontWeight.w900,
                            letterSpacing: -1,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.redBg,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: const [
                          Icon(Icons.arrow_upward_rounded, color: AppColors.red, size: 12),
                          SizedBox(width: 4),
                          Text(
                            '21%',
                            style: TextStyle(
                              color: AppColors.red,
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                const Text(
                  'vs ₹68,200 last month',
                  style: TextStyle(
                    color: AppColors.inkSoft,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 20),

                // Forecast bar chart
                const ForecastBars(),
                const SizedBox(height: 16),

                // Insight strip
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.brandTint,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.brandPale, width: 1.5),
                  ),
                  child: Row(
                    children: const [
                      Icon(Icons.lightbulb_outline_rounded, color: AppColors.brandMid, size: 16),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'At this rate you\'ll exceed budget by ₹14K · cut dining out by 2 meals/week',
                          style: TextStyle(
                            color: AppColors.inkMid,
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Monthly comparison
          const ChartCard(
            title: 'Month-over-Month',
            subtitle: 'Last 6 months spending',
            child: MoMBars(),
          ),

          // Savings projection
          ChartCard(
            title: 'Savings Projection',
            subtitle: 'If current trend continues',
            child: Column(
              children: [
                const SizedBox(height: 4),
                const SavingsProjectionChart(),
                const SizedBox(height: 12),
                Row(
                  children: const [
                    LegendItem(color: AppColors.brand, label: 'Actual', value: '₹51,760'),
                    SizedBox(width: 16),
                    LegendItem(color: AppColors.inkFaint, label: 'Projected', value: '₹64,000'),
                  ],
                ),
              ],
            ),
          ),

          // Goal cards
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 6, 20, 12),
            child: const Text(
              '🎯 Savings Goals',
              style: TextStyle(
                color: AppColors.ink,
                fontSize: 15,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.3,
              ),
            ),
          ),
          const GoalCard(
            emoji: '🏖️',
            label: 'Goa Trip',
            saved: 18000,
            target: 40000,
            deadline: 'Aug 2026',
            colors: [AppColors.brandLight, AppColors.brand],
          ),
          const GoalCard(
            emoji: '📱',
            label: 'New Phone',
            saved: 32000,
            target: 50000,
            deadline: 'Apr 2026',
            colors: [Color(0xFF9D7AE4), Color(0xFF7A4EE2)],
          ),
          const GoalCard(
            emoji: '🛡️',
            label: 'Emergency Fund',
            saved: 10000,
            target: 200000,
            deadline: 'Dec 2026',
            colors: [AppColors.green, AppColors.greenLight],
          ),

          const InsightBox(
            text:
                'You\'re on track to save ₹64,000 by end of March — that\'s 18% above your monthly goal!',
          ),
        ],
      ),
    );
  }
}
