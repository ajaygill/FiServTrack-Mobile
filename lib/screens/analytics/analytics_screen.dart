import 'package:fiservtrack/themes/app_color.dart';
import 'package:flutter/material.dart';
import 'overview_tab.dart';
import 'budget_tab.dart';
import 'forecast_tab.dart';
import 'widgets/month_picker_sheet.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({Key? key}) : super(key: key);

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen>
    with TickerProviderStateMixin {
  int _tab = 0; // 0: Overview, 1: Budget, 2: Forecast
  String _monthLabel = 'Mar 2026';

  late AnimationController _chartAnim;
  late Animation<double> _chartFade;

  @override
  void initState() {
    super.initState();
    _chartAnim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..forward();
    _chartFade = CurvedAnimation(parent: _chartAnim, curve: Curves.easeOut);
  }

  @override
  void dispose() {
    _chartAnim.dispose();
    super.dispose();
  }

  void _switchTab(int t) {
    setState(() => _tab = t);
    _chartAnim.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: Column(
        children: [
          _buildHeader(),
          _buildTabBar(),
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              switchInCurve: Curves.easeOut,
              switchOutCurve: Curves.easeIn,
              child: _buildTabContent(key: ValueKey(_tab)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.brandMid, AppColors.brandDeep],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -70,
            right: -60,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [Colors.white.withOpacity(0.07), Colors.transparent],
                ),
              ),
            ),
          ),
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 22),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Analytics',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          letterSpacing: -0.5,
                        ),
                      ),
                      SizedBox(height: 3),
                      Text(
                        'March 2026',
                        style: TextStyle(
                          color: Color(0x80FFFFFF),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(11),
                      onTap: _pickMonth,
                      child: Ink(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(11),
                          border: Border.all(color: Colors.white.withOpacity(0.2)),
                        ),
                        child: Row(
                          children: [
                            Text(
                              _monthLabel,
                              style: const TextStyle(
                                color: Color(0xCCFFFFFF),
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(width: 5),
                            const Icon(
                              Icons.keyboard_arrow_down_rounded,
                              color: Color(0xCCFFFFFF),
                              size: 16,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    const labels = ['Overview', 'Budget', 'Forecast'];
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 14, 20, 0),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: AppColors.cardBorder, width: 1.5),
        boxShadow: const [
          BoxShadow(
            color: Color(0x090D2840),
            blurRadius: 8,
            offset: Offset(0, 2),
          )
        ],
      ),
      child: Row(
        children: List.generate(3, (i) {
          final sel = _tab == i;
          return Expanded(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: () => _switchTab(i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(vertical: 9),
                  decoration: BoxDecoration(
                    color: sel ? AppColors.brand : Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: sel
                        ? [
                            const BoxShadow(
                              color: Color(0x3D134372),
                              blurRadius: 10,
                              offset: Offset(0, 4),
                            )
                          ]
                        : [],
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    labels[i],
                    style: TextStyle(
                      color: sel ? Colors.white : AppColors.inkMuted,
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildTabContent({Key? key}) {
    switch (_tab) {
      case 0:
        return OverviewTab(key: key, anim: _chartFade);
      case 1:
        return BudgetTab(key: key, anim: _chartFade);
      case 2:
        return ForecastTab(key: key, anim: _chartFade);
      default:
        return OverviewTab(key: key, anim: _chartFade);
    }
  }

  void _pickMonth() {
    const months = [
      'Jan 2026',
      'Feb 2026',
      'Mar 2026',
      'Apr 2026',
      'May 2026',
      'Jun 2026',
    ];
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => MonthPickerSheet(
        months: months,
        selected: _monthLabel,
        onSelect: (m) {
          setState(() => _monthLabel = m);
          Navigator.pop(context);
        },
      ),
    );
  }
}