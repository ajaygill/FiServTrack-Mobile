import 'package:fiservtrack/themes/app_color.dart';
import 'dart:ui';
import 'package:fiservtrack/screens/auth/welcome_screen.dart';
import 'package:flutter/material.dart';

import 'sidebar.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isDrawerOpen = false;

  void _toggleDrawer() {
    setState(() {
      _isDrawerOpen = !_isDrawerOpen;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final drawerWidth = screenWidth * 0.8; // Takes up 80% of the screen

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: Stack(
        children: [
          // ── 1. MAIN CONTENT ──
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.only(bottom: 120), // Clear bottom nav
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                _buildStatStrip(),

                _buildSectionTitle(context, "Bank Accounts", "Manage"),
                _buildBankItem(context, "🏦", "HDFC Bank", "Savings •••• 4821 · Connected", "₹4,82,000"),
                _buildBankItem(context, "🏛", "SBI Bank", "Savings •••• 9933 · Connected", "₹1,12,400"),
                _buildAddBankButton(context),

                _buildSectionTitle(context, "Asset Vault", "View All →"),
                _buildAssetItem(context, "🚗", "Honda City 2021", "Health 72% · Warranty: 8 mo left", "Good", AppColors.green, AppColors.greenBg),
                _buildAssetItem(context, "❄️", "Samsung 1.5T AC", "Service due · Warranty expired", "Alert", AppColors.red, AppColors.redBg),
              ],
            ),
          ),

          // ── 2. DIMMING OVERLAY WITH GLASSMORPHISM ──
          if (_isDrawerOpen)
            GestureDetector(
              onTap: _toggleDrawer,
              child: ClipRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    color: AppColors.ink.withOpacity(0.4),
                  ),
                ),
              ),
            ),

          // ── 3. SLIDE-OUT DRAWER (SIDEBAR) ──
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutCubic,
            top: 0,
            bottom: 0,
            right: _isDrawerOpen ? 0 : -drawerWidth - 20, // Hide off-screen
            width: drawerWidth,
            child: Sidebar(
              onClose: _toggleDrawer,
              onSignOut: () => _showSignOutDialog(context),
              onItemTap: (item) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Selected: $item"),
                    duration: const Duration(seconds: 1),
                    backgroundColor: AppColors.brand,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // ── MAIN VIEW WIDGETS
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildHeader() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.brandMid, AppColors.brandDeep],
          begin: Alignment.topCenter,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: Stack(
        clipBehavior: Clip.hardEdge,
        children: [
          // Background Glow
          Positioned(
            top: -60,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [Colors.white.withOpacity(0.06), Colors.transparent],
                    stops: const [0.0, 0.65],
                  ),
                ),
              ),
            ),
          ),

          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
              child: Column(
                children: [
                  // Menu Icon (Hamburger)
                  Align(
                    alignment: Alignment.topRight,
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.12),
                        border: Border.all(color: Colors.white.withOpacity(0.2)),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: _toggleDrawer,
                            child: const Icon(
                              Icons.menu_rounded,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Profile Details
                  Container(
                    width: 80,
                    height: 80,
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFE8C96A), AppColors.gold],
                      ),
                      borderRadius: BorderRadius.circular(26),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                      border: Border.all(color: Colors.white.withOpacity(0.15), width: 3),
                    ),
                    alignment: Alignment.center,
                    child: const Text(
                      "A",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  const Text(
                    "Arjun Mehta",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 21,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.4,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "arjun@example.com",
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.5),
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Badges
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildPill("⭐ Premium", AppColors.gold, AppColors.goldBg, AppColors.goldBorder),
                      const SizedBox(width: 8),
                      _buildPill("✓ KYC Verified", AppColors.green, AppColors.greenBg, null),
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildPill(String text, Color fg, Color bg, Color? border) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        border: border != null ? Border.all(color: border) : null,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(color: fg, fontSize: 10, fontWeight: FontWeight.w800),
      ),
    );
  }

  Widget _buildStatStrip() {
    return Container(
      margin: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.cardBorder, width: 1.5),
        boxShadow: const [AppColors.shadowSm],
      ),
      child: Row(
        children: [
          Expanded(child: _buildStatItem("Net Worth", "₹28.4L", AppColors.brand)),
          Container(width: 1, height: 40, color: AppColors.divider),
          Expanded(child: _buildStatItem("Savings", "43%", AppColors.green)),
          Container(width: 1, height: 40, color: AppColors.divider),
          Expanded(child: _buildStatItem("EMIs", "3", AppColors.red)),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Column(
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
          const SizedBox(height: 3),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: TextStyle(
                color: color,
                fontSize: 16,
                fontWeight: FontWeight.w900,
                letterSpacing: -0.3,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title, String action) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: AppColors.ink,
              fontSize: 15,
              fontWeight: FontWeight.w800,
            ),
          ),
          GestureDetector(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("$action clicked for $title"),
                  backgroundColor: AppColors.brand,
                ),
              );
            },
            child: Text(
              action,
              style: const TextStyle(
                color: AppColors.brandMid,
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBankItem(BuildContext context, String emoji, String name, String details, String balance) {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, bottom: 9),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.cardBorder, width: 1.5),
        boxShadow: const [AppColors.shadowSm],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Selected $name: $balance"),
                backgroundColor: AppColors.brand,
                duration: const Duration(seconds: 2),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 13),
            child: Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.cardBorder, width: 1.5),
                  ),
                  alignment: Alignment.center,
                  child: Text(emoji, style: const TextStyle(fontSize: 20)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          color: AppColors.ink,
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        details,
                        style: const TextStyle(
                          color: AppColors.inkSoft,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  balance,
                  style: const TextStyle(
                    color: AppColors.green,
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAddBankButton(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
      decoration: BoxDecoration(
        color: AppColors.brandPale,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.brandMid, width: 1.5, style: BorderStyle.solid),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: () => _showConnectBankSheet(context),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 13),
            child: Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: AppColors.brand.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  alignment: Alignment.center,
                  child: const Text("+", style: TextStyle(color: AppColors.brand, fontSize: 26)),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Connect a Bank",
                      style: TextStyle(
                        color: AppColors.brand,
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      "Via AA Framework or Net Banking",
                      style: TextStyle(
                        color: AppColors.brandMid.withOpacity(0.6),
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAssetItem(BuildContext context, String emoji, String title, String sub, String badgeTxt, Color badgeFg, Color badgeBg) {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, bottom: 8),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cardBorder, width: 1.5),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Viewing asset details for $title"),
                backgroundColor: AppColors.brand,
                duration: const Duration(seconds: 2),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
            child: Row(
              children: [
                Text(emoji, style: const TextStyle(fontSize: 22)),
                const SizedBox(width: 11),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          color: AppColors.ink,
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        sub,
                        style: const TextStyle(
                          color: AppColors.inkSoft,
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                _buildPill(badgeTxt, badgeFg, badgeBg, null),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // ── POPUPS, BOTTOM SHEETS AND DIALOGS
  // ═══════════════════════════════════════════════════════════════════════════

  void _showConnectBankSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: AppColors.inkFaint,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const Text(
                "Connect a New Bank",
                style: TextStyle(
                  color: AppColors.ink,
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Text(
                "Select a secure connection method below to fetch your account balances and transactions automatically.",
                style: TextStyle(
                  color: AppColors.inkSoft,
                  fontSize: 13,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              _buildConnectionMethod(
                icon: Icons.account_tree_outlined,
                title: "Account Aggregator (Recommended)",
                subtitle: "Highly secure, consent-based instant linkage.",
                onTap: () {
                  Navigator.pop(context);
                  _showAAFrameworkLinkage(context);
                },
              ),
              const SizedBox(height: 12),
              _buildConnectionMethod(
                icon: Icons.vpn_key_outlined,
                title: "Net Banking / Credentials",
                subtitle: "Link directly using bank login details.",
                onTap: () {
                  Navigator.pop(context);
                  _showLinkageInProgress(context, "Net Banking Credentials");
                },
              ),
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }

  Widget _buildConnectionMethod({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.brandPale,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: AppColors.brand, size: 20),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          color: AppColors.ink,
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          color: AppColors.inkSoft,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.arrow_forward_ios_rounded, color: AppColors.inkMuted, size: 14),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showAAFrameworkLinkage(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text("Account Aggregator Linkage", style: TextStyle(fontWeight: FontWeight.w900)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.security, color: AppColors.green, size: 48),
              const SizedBox(height: 16),
              const Text(
                "You will be redirected to the secure AA portal to complete your consent verification. Consent is encrypted and can be revoked at any time.",
                style: TextStyle(fontSize: 13, color: AppColors.inkSoft),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel", style: TextStyle(color: AppColors.inkSoft)),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _showLinkageInProgress(context, "Account Aggregator");
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.brand,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text("Proceed", style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  void _showLinkageInProgress(BuildContext context, String method) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        Future.delayed(const Duration(seconds: 3), () {
          if (Navigator.canPop(context)) {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Bank account successfully linked!"),
                backgroundColor: AppColors.green,
              ),
            );
          }
        });

        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 16),
              const CircularProgressIndicator(color: AppColors.brand),
              const SizedBox(height: 24),
              Text(
                "Connecting via $method...",
                style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.ink),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Text(
                "Securing connection and fetching latest statements.",
                style: TextStyle(fontSize: 11, color: AppColors.inkSoft),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  void _showSignOutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text("Sign Out", style: TextStyle(fontWeight: FontWeight.w900)),
          content: const Text(
            "Are you sure you want to sign out of FiservTrack?",
            style: TextStyle(fontSize: 14, color: AppColors.ink),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel", style: TextStyle(color: AppColors.inkSoft, fontWeight: FontWeight.w600)),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const WelcomeScreen()),
                      (route) => false,
                );
                if (_isDrawerOpen) {
                  _toggleDrawer();
                }
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Signed out successfully"),
                    backgroundColor: AppColors.red,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.red,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text("Sign Out", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
            ),
          ],
        );
      },
    );
  }
}