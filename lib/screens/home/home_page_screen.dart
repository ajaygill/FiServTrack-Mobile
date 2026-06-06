import 'dart:ui';
import 'package:fiservtrack/screens/notifications/notifications_screen.dart';
import 'package:fiservtrack/screens/transactions/transactions_screen.dart';
import 'package:fiservtrack/themes/app_color.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final topPadding = MediaQuery.of(context).padding.top;
    final greeting = _getGreeting();

    return Scaffold(
      backgroundColor: AppColors.surface, // App body background matching --surface
      body: CustomScrollView(
        physics: const ClampingScrollPhysics(),
        slivers: [
          SliverPersistentHeader(
            delegate: _HomeHeaderDelegate(
              topPadding: topPadding,
              greeting: greeting,
            ),
            pinned: true,
          ),
          SliverPadding(
            padding: const EdgeInsets.only(bottom: 120), // Padding for BottomNav
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                SizedBox(height: size.height * 0.025),
                _buildBentoGrid(context),
                SizedBox(height: size.height * 0.025),
                _buildRecentSection(context),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour >= 5 && hour < 12) {
      return "Good morning 👋";
    } else if (hour >= 12 && hour < 17) {
      return "Good afternoon ☀️";
    } else if (hour >= 17 && hour < 22) {
      return "Good evening 👋";
    } else {
      return "Good night 🌙";
    }
  }
}

class _HomeHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double topPadding;
  final String greeting;

  _HomeHeaderDelegate({
    required this.topPadding,
    required this.greeting,
  });

  @override
  double get maxExtent => topPadding + 395.0;

  @override
  double get minExtent => topPadding + 250.0;

  @override
  bool shouldRebuild(covariant _HomeHeaderDelegate oldDelegate) {
    return oldDelegate.topPadding != topPadding || oldDelegate.greeting != greeting;
  }

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    final size = MediaQuery.of(context).size;
    final currentHeight = (maxExtent - shrinkOffset).clamp(minExtent, maxExtent);
    final t = ((shrinkOffset) / (maxExtent - minExtent)).clamp(0.0, 1.0);
    final double fadeOpacity = (1.0 - t * 1.5).clamp(0.0, 1.0);

    return Container(
      height: currentHeight,
      decoration: BoxDecoration(
        gradient: AppColors.brandGradient,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32 * (1.0 - t)),
          bottomRight: Radius.circular(32 * (1.0 - t)),
        ),
      ),
      child: Stack(
        clipBehavior: Clip.hardEdge,
        children: [
          // Decorative Circle Top Right
          Positioned(
            top: -70 - (30 * t),
            right: -60,
            child: Opacity(
              opacity: (1.0 - t).clamp(0.0, 1.0),
              child: Container(
                width: size.width * 0.55,
                height: size.width * 0.55,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [Colors.white.withOpacity(0.08), Colors.transparent],
                    stops: const [0.0, 0.7],
                  ),
                ),
              ),
            ),
          ),
          // Decorative Circle Bottom Left
          Positioned(
            bottom: -40 + (100 * t),
            left: -40,
            child: Opacity(
              opacity: (1.0 - t).clamp(0.0, 1.0),
              child: Container(
                width: size.width * 0.4,
                height: size.width * 0.4,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [AppColors.brandLight.withOpacity(0.3), Colors.transparent],
                    stops: const [0.0, 0.7],
                  ),
                ),
              ),
            ),
          ),

          SafeArea(
            bottom: false,
            child: SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top Row
                    SizedBox(
                      height: 65,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  greeting,
                                  style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: size.height * 0.015,
                                      fontWeight: FontWeight.w500
                                  ),
                                ),
                                const SizedBox(height: 1),
                                Text(
                                  "Arjun Mehta",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: size.height * 0.024,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: -0.4,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const NotificationsScreen(),
                                    ),
                                  );
                                },
                                child: Container(
                                  width: size.height * 0.045,
                                  height: size.height * 0.045,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: Colors.white.withOpacity(0.15)),
                                  ),
                                  child: Icon(Icons.notifications_none_rounded, color: Colors.white70, size: size.height * 0.025),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),

                    const SizedBox(height: 10),
                    _buildNetWorthCard(context, size),

                    // Collapsible Content
                    if (fadeOpacity > 0)
                      Opacity(
                        opacity: fadeOpacity,
                        child: Transform.translate(
                          offset: Offset(0, -20 * t),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 12),
                              _buildFlowCards(context, size),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNetWorthCard(BuildContext context, Size size) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(22),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: size.height * 0.023),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.10),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: Colors.white.withOpacity(0.18)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Total Net Worth".toUpperCase(),
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: size.height * 0.013,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 6),
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      "₹",
                      style: TextStyle(color: Colors.white70, fontSize: size.height * 0.025, fontWeight: FontWeight.w600),
                    ),
                    Text(
                      "28,47,320",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: size.height * 0.045,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -2.0,
                        height: 1.0,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: size.height * 0.015),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: size.height * 0.022,
                            height: size.height * 0.022,
                            decoration: BoxDecoration(
                              color: AppColors.greenLight.withOpacity(0.25),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Icon(Icons.arrow_upward_rounded, color: AppColors.greenLight, size: size.height * 0.014),
                          ),
                          const SizedBox(width: 5),
                          Text("3.2% this month", style: TextStyle(color: AppColors.greenLight, fontSize: size.height * 0.014, fontWeight: FontWeight.w700)),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        "vs ₹27,55,000 last month",
                        style: TextStyle(color: Colors.white60, fontSize: size.height * 0.013, fontWeight: FontWeight.w500),
                      )
                    ],
                  ),
                  _buildSparkline(size),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSparkline(Size size) {
    List<double> heights = [0.35, 0.50, 0.42, 0.68, 0.55, 1.0];
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: heights.map((h) {
        bool isMax = h == 1.0;
        bool isMid = h > 0.4 && h < 0.7;
        return Container(
          margin: const EdgeInsets.only(left: 3),
          width: size.width * 0.012,
          height: (size.height * 0.032) * h,
          decoration: BoxDecoration(
            color: isMax
                ? Colors.white.withOpacity(0.8)
                : isMid ? Colors.white.withOpacity(0.45) : Colors.white.withOpacity(0.2),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(2)),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildFlowCards(BuildContext context, Size size) {
    return Row(
      children: [
        Expanded(child: _buildFlowCard(
            context: context,
            title: "Monthly Income",
            amount: "₹1,20,000",
            subtitle: "Salary + Freelance",
            icon: Icons.arrow_outward_rounded,
            color: AppColors.greenLight,
            pillText: "+12%",
            iconBg: AppColors.greenLight.withOpacity(0.2),
            pillBg: AppColors.greenLight.withOpacity(0.2)
        )),
        const SizedBox(width: 10),
        Expanded(child: _buildFlowCard(
            context: context,
            title: "Monthly Spend",
            amount: "₹68,240",
            subtitle: "of income",
            icon: Icons.arrow_downward_rounded,
            color: AppColors.redLight,
            pillText: "57%",
            iconBg: AppColors.redLight.withOpacity(0.2),
            pillBg: AppColors.redLight.withOpacity(0.2)
        )),
      ],
    );
  }

  Widget _buildFlowCard({
    required BuildContext context,
    required String title, required String amount, required String subtitle,
    required IconData icon, required Color color, required String pillText,
    required Color iconBg, required Color pillBg
  }) {
    final size = MediaQuery.of(context).size;
    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.09),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withOpacity(0.14)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: size.height * 0.035,
                height: size.height * 0.035,
                decoration: BoxDecoration(color: iconBg, borderRadius: BorderRadius.circular(9)),
                child: Icon(icon, color: color, size: size.height * 0.02),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                decoration: BoxDecoration(color: pillBg, borderRadius: BorderRadius.circular(10)),
                child: Text(pillText, style: TextStyle(color: color, fontSize: size.height * 0.011, fontWeight: FontWeight.w800)),
              )
            ],
          ),
          SizedBox(height: size.height * 0.01),
          Text(title, style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: size.height * 0.012, fontWeight: FontWeight.w600)),
          const SizedBox(height: 3),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(amount, style: TextStyle(color: Colors.white, fontSize: size.height * 0.022, fontWeight: FontWeight.w900, letterSpacing: -0.5)),
          ),
          const SizedBox(height: 2),
          Text(subtitle, style: TextStyle(color: color, fontSize: size.height * 0.012, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}

  Widget _buildBentoGrid(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: _buildBentoCard(
                    size,
                    "SAVINGS RATE",
                    "43%",
                    AppColors.green,
                    "₹51,760 saved",
                    showProgress: true,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildBentoCard(
                    size,
                    "ACTIVE EMIS",
                    "3",
                    AppColors.brand,
                    "₹32,500 / mo",
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),

          // Alert Card (Golden)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.goldBg, Color(0xFFFFF5D0)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.goldBorder, width: 1.5),
                boxShadow: const [AppColors.shadowGold]
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("⚙ SERVICE DUE", style: TextStyle(color: AppColors.gold, fontSize: size.height * 0.012, fontWeight: FontWeight.w800, letterSpacing: 1)),
                const SizedBox(height: 7),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("🚗 Car — Oil Change", style: TextStyle(color: AppColors.ink, fontSize: size.height * 0.016, fontWeight: FontWeight.w800)),
                        const SizedBox(height: 3),
                        Text("Honda City · Due in 12 days", style: TextStyle(color: AppColors.inkSoft, fontSize: size.height * 0.013, fontWeight: FontWeight.w500)),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.goldBg,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.goldBorder),
                      ),
                      child: Text("Due Soon", style: TextStyle(color: AppColors.gold, fontSize: size.height * 0.012, fontWeight: FontWeight.w800)),
                    )
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildBentoCard(Size size, String label, String value, Color valueColor, String subtext, {bool showProgress = false}) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.cardBorder, width: 1.5),
        boxShadow: [
          AppColors.ink.withOpacity(0.06),
          AppColors.ink.withOpacity(0.04),
        ].map((c) => BoxShadow(color: c, blurRadius: 3, offset: const Offset(0, 1))).toList(),
      ),
      // Column fills the card height (IntrinsicHeight + stretch gives us this)
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          // Label
          Text(
            label,
            style: TextStyle(
              color: AppColors.inkMuted,
              fontSize: size.height * 0.012,
              fontWeight: FontWeight.w700,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 6),
          // Big value
          Text(
            value,
            style: TextStyle(
              color: valueColor,
              fontSize: size.height * 0.04,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.5,
            ),
          ),
          // Progress bar only on savings card
          if (showProgress) ...[
            const SizedBox(height: 4),
            Container(
              height: 5,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.divider,
                borderRadius: BorderRadius.circular(3),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: 0.43,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.greenLight, AppColors.green],
                    ),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 4),
          ],
          // Spacer pushes subtext to the bottom on both cards equally
          const Spacer(),
          Text(
            subtext,
            style: TextStyle(
              color: AppColors.inkSoft,
              fontSize: size.height * 0.014,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Recent", style: TextStyle(color: AppColors.ink, fontSize: 16, fontWeight: FontWeight.w800, letterSpacing: -0.3)),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TransactionsScreen(),
                    ),
                  );
                },
                child: const Text(
                  "View All",
                  style: TextStyle(
                    color: AppColors.brandMid,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildTransactionRow("🛒", AppColors.redBg, "Zepto Groceries", "Food & Groceries", "−₹1,240", "Today, 2pm", isDebit: true),
          _buildTransactionRow("💰", AppColors.greenBg, "Salary Credit", "Income · TCS", "+₹1,00,000", "Mar 1", isDebit: false),
          _buildTransactionRow("⛽", AppColors.brandPale, "HP Petrol Station", "Transport", "−₹2,100", "Mar 5", isDebit: true),
          _buildTransactionRow("☕", AppColors.goldBg, "Starbucks Coffee", "Food & Dining", "−₹450", "Mar 4", isDebit: true),
          _buildTransactionRow("🎬", AppColors.brandPale, "BookMyShow Movie", "Entertainment", "−₹950", "Mar 3", isDebit: true, isLast: true),
        ],
      ),
    );
  }

  Widget _buildTransactionRow(String emoji, Color bgColor, String title, String category, String amount, String time, {required bool isDebit, bool isLast = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 11), // Matched 11px HTML padding
      decoration: BoxDecoration(
        border: isLast ? null : const Border(bottom: BorderSide(color: AppColors.divider)),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(13)),
            alignment: Alignment.center,
            child: Text(emoji, style: const TextStyle(fontSize: 19)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: AppColors.ink, fontSize: 13, fontWeight: FontWeight.w700)),
                const SizedBox(height: 2),
                Text(category, style: const TextStyle(color: AppColors.inkSoft, fontSize: 11, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                amount,
                style: TextStyle(
                  color: isDebit ? AppColors.red : AppColors.green,
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 3),
              Text(time, style: const TextStyle(color: AppColors.inkMuted, fontSize: 10)),
            ],
          )
        ],
      ),
    );
  }