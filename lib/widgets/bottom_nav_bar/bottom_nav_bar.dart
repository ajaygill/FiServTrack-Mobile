import 'dart:ui';
import 'package:fiservtrack/screens/add_transactions/add_transactions_screen.dart';
import 'package:fiservtrack/screens/profile_screen/profile_screen.dart';
import 'package:fiservtrack/themes/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fiservtrack/screens/home/home_page_screen.dart';
import 'package:fiservtrack/screens/analytics/analytics_screen.dart';
import 'package:fiservtrack/screens/liabilities/liabilities_screen.dart';

class TabNotifier {
  static ValueNotifier<int> index = ValueNotifier<int>(0);
}

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  final List<Widget> _pages = const [
    HomeScreen(),
    LiabilitiesScreen(),
    AnalyticsScreen(),
    ProfileScreen(),
    AddTransactionsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: TabNotifier.index,
      builder: (context, selectedIndex, child) {
        return PopScope(
          canPop: false,
          onPopInvoked: (didPop) async {
            if (didPop) return;

            final navigator = Navigator.of(context);
            if (navigator.canPop()) {
              navigator.pop();
              return;
            }

            // If not on the first tab, go back to Dashboard (index 0)
            if (selectedIndex != 0) {
              TabNotifier.index.value = 0;
              return;
            }

            // If on the first tab and no history, exit app
            await SystemNavigator.pop();
          },
          child: Scaffold(
            backgroundColor: AppColors.surface, // App surface color
            // extendBody is crucial here! It lets the body scroll BEHIND the
            // bottom nav bar so our blur effect actually blurs the content.
            extendBody: true,
            body: _pages[selectedIndex],
            // We use a custom Stack here instead of the default BottomAppBar
            // to allow the FAB to overlap the top border perfectly.
            bottomNavigationBar: _buildCustomBottomNav(selectedIndex),
          ),
        );
      },
    );
  }

  Widget _buildCustomBottomNav(int selectedIndex) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.topCenter,
      children: [
        // ── 1. The Solid White Premium Bar ───────────────────────────────────
        Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(
              top: BorderSide(color: AppColors.cardBorder, width: 1.2),
            ),
            boxShadow: [
              BoxShadow(
                color: Color(0x0F0D2840), // inline shadow with opacity corresponding to ink.withOpacity(0.06)
                blurRadius: 20,
                offset: Offset(0, -6),
              ),
            ],
          ),
          child: SafeArea(
            child: SizedBox(
              height: 70,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNavItem(
                    index: 0,
                    selectedIndex: selectedIndex,
                    activeIcon: Icons.home_rounded,
                    inactiveIcon: Icons.home_outlined,
                    label: 'Home',
                  ),
                  _buildNavItem(
                    index: 1,
                    selectedIndex: selectedIndex,
                    activeIcon: Icons.receipt_long_rounded,
                    inactiveIcon: Icons.receipt_long_outlined,
                    label: 'Liabilities',
                  ),
                  const SizedBox(width: 60), // Spacer for the overlapping FAB
                  _buildNavItem(
                    index: 2,
                    selectedIndex: selectedIndex,
                    activeIcon: Icons.bar_chart_rounded,
                    inactiveIcon: Icons.bar_chart_outlined,
                    label: 'Analytics',
                  ),
                  _buildNavItem(
                    index: 3,
                    selectedIndex: selectedIndex,
                    activeIcon: Icons.person_rounded,
                    inactiveIcon: Icons.person_outline_rounded,
                    label: 'Account',
                  ),
                ],
              ),
            ),
          ),
        ),

        // ── 2. The Overlapping Floating Action Button ────────────────────────
        Positioned(
          top: -22,
          child: Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: AppColors.brand.withOpacity(0.35),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(18),
                onTap: () {
                  TabNotifier.index.value = 4;
                },
                child: Ink(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: selectedIndex == 4
                          ? [AppColors.brandDeep, AppColors.brand]
                          : [AppColors.brandLight, AppColors.brandDeep],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Center(
                    child: Icon(
                      selectedIndex == 4 ? Icons.close_rounded : Icons.add_rounded,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNavItem({
    required int index,
    required int selectedIndex,
    required IconData activeIcon,
    required IconData inactiveIcon,
    required String label,
  }) {
    final bool isActive = selectedIndex == index;
    const Color activeColor = AppColors.brand; // Brand Blue
    const Color inactiveColor = AppColors.inkFaint; // Faint Ink

    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            TabNotifier.index.value = index;
          },
          highlightColor: activeColor.withOpacity(0.04),
          splashColor: activeColor.withOpacity(0.08),
          child: SizedBox(
            height: 70,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // ── Active Top Indicator Line ──
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeOutCubic,
                  top: 0,
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 200),
                    opacity: isActive ? 1.0 : 0.0,
                    child: Container(
                      width: 24,
                      height: 3.5,
                      decoration: const BoxDecoration(
                        color: activeColor,
                        borderRadius: BorderRadius.vertical(bottom: Radius.circular(3.5)),
                      ),
                    ),
                  ),
                ),

                // ── Icon and Label ──
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      child: Icon(
                        isActive ? activeIcon : inactiveIcon,
                        color: isActive ? activeColor : inactiveColor,
                        size: 22,
                      ),
                    ),
                    const SizedBox(height: 4),
                    AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 200),
                      style: TextStyle(
                        fontSize: 9.5,
                        fontWeight: FontWeight.w800,
                        color: isActive ? activeColor : inactiveColor,
                        letterSpacing: 0.3,
                      ),
                      child: Text(label),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}