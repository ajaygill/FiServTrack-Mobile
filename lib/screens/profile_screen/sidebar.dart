import 'package:fiservtrack/themes/app_color.dart';
import 'package:flutter/material.dart';


class Sidebar extends StatefulWidget {
  final VoidCallback onClose;
  final VoidCallback onSignOut;
  final ValueChanged<String>? onItemTap;

  const Sidebar({
    Key? key,
    required this.onClose,
    required this.onSignOut,
    this.onItemTap,
  }) : super(key: key);

  @override
  State<Sidebar> createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
  // Local states for settings/switches
  bool _notificationsEnabled = true;
  bool _appLockEnabled = true;
  String _selectedItem = "My Profile";

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(46),
          bottomLeft: Radius.circular(46),
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0x380D2840),
            blurRadius: 32,
            offset: Offset(-8, 0),
          )
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(46),
          bottomLeft: Radius.circular(46),
        ),
        child: Column(
          children: [
            _buildDrawerHeader(),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.only(bottom: 40),
                child: _buildDrawerContent(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerHeader() {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.brandMid, AppColors.brandDeep],
          begin: Alignment.topCenter,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -50,
            right: -40,
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [Colors.white.withOpacity(0.09), Colors.transparent],
                  stops: const [0.0, 0.7],
                ),
              ),
            ),
          ),
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 16, 22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      onPressed: widget.onClose,
                      splashRadius: 20,
                      icon: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.12),
                          border: Border.all(color: Colors.white.withOpacity(0.2)),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.close_rounded, color: Colors.white, size: 16),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFFE8C96A), AppColors.gold],
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            )
                          ],
                        ),
                        alignment: Alignment.center,
                        child: const Text(
                          "A",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Arjun Mehta",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w900,
                                letterSpacing: -0.3,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              "arjun@example.com",
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.5),
                                fontSize: 11,
                              ),
                            ),
                            const SizedBox(height: 6),
                            _buildPill(
                              "⭐ Premium",
                              AppColors.goldBorder,
                              const Color(0x33E8C96A),
                              const Color(0x59E8C96A),
                            ),
                          ],
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        _buildDrawerTitle("General"),
        _buildDrawerRow(
          icon: Icons.person_outline_rounded,
          label: "My Profile",
          iconColor: AppColors.brand,
          iconBg: AppColors.brandPale,
          itemName: "My Profile",
        ),
        _buildDrawerRow(
          icon: Icons.account_balance_rounded,
          label: "Linked Banks",
          iconColor: AppColors.brand,
          iconBg: AppColors.brandPale,
          badgeText: "2",
          badgeColor: AppColors.green,
          badgeBg: AppColors.greenBg,
          itemName: "Linked Banks",
        ),
        _buildDrawerRow(
          icon: Icons.credit_card_rounded,
          label: "Credit Cards",
          iconColor: AppColors.gold,
          iconBg: AppColors.goldBg,
          itemName: "Credit Cards",
        ),
        _buildDrawerRow(
          icon: Icons.inventory_2_outlined,
          label: "Asset Vault",
          iconColor: AppColors.green,
          iconBg: AppColors.greenBg,
          badgeText: "1 alert",
          badgeColor: AppColors.red,
          badgeBg: AppColors.redBg,
          itemName: "Asset Vault",
        ),

        const Divider(color: AppColors.divider, height: 32, indent: 18, endIndent: 18),
        _buildDrawerTitle("Preferences"),
        _buildDrawerRow(
          icon: Icons.notifications_none_rounded,
          label: "Notifications",
          iconColor: const Color(0xFF7C3AED),
          iconBg: const Color(0xFFF3EFFF),
          hasToggle: true,
          toggleState: _notificationsEnabled,
          onToggleChanged: (val) {
            setState(() {
              _notificationsEnabled = val;
            });
            if (widget.onItemTap != null) widget.onItemTap!("Toggle Notifications: $val");
          },
          itemName: "Notifications",
        ),
        _buildDrawerRow(
          icon: Icons.lock_outline_rounded,
          label: "App Lock",
          iconColor: AppColors.red,
          iconBg: AppColors.redBg,
          hasToggle: true,
          toggleState: _appLockEnabled,
          onToggleChanged: (val) {
            setState(() {
              _appLockEnabled = val;
            });
            if (widget.onItemTap != null) widget.onItemTap!("Toggle App Lock: $val");
          },
          itemName: "App Lock",
        ),
        _buildDrawerRow(
          icon: Icons.language_rounded,
          label: "Language & Region",
          iconColor: const Color(0xFF0284C7),
          iconBg: const Color(0xFFF0F9FF),
          trailingText: "EN · IN",
          itemName: "Language & Region",
        ),
        _buildDrawerRow(
          icon: Icons.workspace_premium_rounded,
          label: "Subscription",
          iconColor: AppColors.gold,
          iconBg: AppColors.goldBg,
          badgeText: "Premium",
          badgeColor: AppColors.gold,
          badgeBg: AppColors.goldBg,
          isPremiumBadge: true,
          itemName: "Subscription",
        ),

        const Divider(color: AppColors.divider, height: 32, indent: 18, endIndent: 18),
        _buildDrawerTitle("Support"),
        _buildDrawerRow(
          icon: Icons.help_outline_rounded,
          label: "Help & FAQ",
          iconColor: const Color(0xFF0284C7),
          iconBg: const Color(0xFFF0F9FF),
          itemName: "Help & FAQ",
        ),
        _buildDrawerRow(
          icon: Icons.chat_bubble_outline_rounded,
          label: "Send Feedback",
          iconColor: AppColors.green,
          iconBg: const Color(0xFFF0FDF4),
          itemName: "Send Feedback",
        ),
        _buildDrawerRow(
          icon: Icons.shield_outlined,
          label: "Privacy Policy",
          iconColor: AppColors.inkSoft,
          iconBg: const Color(0xFFF8F9FA),
          itemName: "Privacy Policy",
        ),

        const Divider(color: AppColors.divider, height: 32, indent: 18, endIndent: 18),

        // Sign Out Button
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: AppColors.redBg,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(14),
              onTap: widget.onSignOut,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: AppColors.red.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.logout_rounded, color: AppColors.red, size: 16),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      "Sign Out",
                      style: TextStyle(
                        color: AppColors.red,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),

        const Padding(
          padding: EdgeInsets.only(top: 24, bottom: 100),
          child: Center(
            child: Text(
              "FiservTrack v1.2.0 · Build 204",
              style: TextStyle(
                color: AppColors.inkFaint,
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDrawerTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 0, 18, 5),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          color: AppColors.inkMuted,
          fontSize: 9.5,
          fontWeight: FontWeight.w800,
          letterSpacing: 2.0,
        ),
      ),
    );
  }

  Widget _buildDrawerRow({
    required IconData icon,
    required String label,
    required Color iconColor,
    required Color iconBg,
    required String itemName,
    String? badgeText,
    Color? badgeColor,
    Color? badgeBg,
    bool hasToggle = false,
    bool toggleState = false,
    ValueChanged<bool>? onToggleChanged,
    String? trailingText,
    bool isPremiumBadge = false,
  }) {
    final bool isSelected = _selectedItem == itemName;

    return Material(
      color: isSelected ? AppColors.brandPale : Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            left: BorderSide(
              color: isSelected ? AppColors.brand : Colors.transparent,
              width: 3,
            ),
          ),
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 18),
          minLeadingWidth: 0,
          leading: Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 16),
          ),
          title: Text(
            label,
            style: TextStyle(
              color: isSelected ? AppColors.brand : AppColors.ink,
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (badgeText != null)
                Container(
                  margin: const EdgeInsets.only(right: 6),
                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                  decoration: BoxDecoration(
                    color: badgeBg,
                    borderRadius: BorderRadius.circular(8),
                    border: isPremiumBadge ? Border.all(color: AppColors.goldBorder) : null,
                  ),
                  child: Text(
                    badgeText,
                    style: TextStyle(color: badgeColor, fontSize: 10, fontWeight: FontWeight.w800),
                  ),
                ),
              if (trailingText != null)
                Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: Text(
                    trailingText,
                    style: const TextStyle(
                      color: AppColors.inkSoft,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              if (hasToggle)
                SizedBox(
                  height: 20,
                  width: 36,
                  child: Switch(
                    value: toggleState,
                    onChanged: onToggleChanged,
                    activeThumbColor: Colors.white,
                    activeTrackColor: AppColors.brand,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                )
              else
                Icon(
                  Icons.chevron_right_rounded,
                  color: isSelected ? AppColors.brand : AppColors.inkFaint,
                  size: 20,
                ),
            ],
          ),
          onTap: hasToggle
              ? null
              : () {
                  setState(() {
                    _selectedItem = itemName;
                  });
                  if (widget.onItemTap != null) {
                    widget.onItemTap!(itemName);
                  }
                },
        ),
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
}