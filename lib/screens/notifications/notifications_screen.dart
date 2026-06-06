import 'package:fiservtrack/themes/app_color.dart';
import 'package:flutter/material.dart';

class NotificationItem {
  final String id;
  final String title;
  final String description;
  final String time;
  final String dateGroup; // 'Today', 'Yesterday', 'Earlier'
  final IconData icon;
  final Color iconColor;
  final Color iconBgColor;
  final String category; // 'all', 'transaction', 'alert', 'system'
  bool isRead;

  NotificationItem({
    required this.id,
    required this.title,
    required this.description,
    required this.time,
    required this.dateGroup,
    required this.icon,
    required this.iconColor,
    required this.iconBgColor,
    required this.category,
    this.isRead = false,
  });
}

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  // Filter state
  String _selectedCategory = 'all';

  // Mock Notification List
  final List<NotificationItem> _notifications = [
    NotificationItem(
      id: '1',
      title: 'Salary Credited',
      description: '₹1,00,000 has been credited to your HDFC savings account for the month of June.',
      time: '10:30 AM',
      dateGroup: 'Today',
      icon: Icons.account_balance_wallet_rounded,
      iconColor: AppColors.green,
      iconBgColor: AppColors.greenBg,
      category: 'transaction',
      isRead: false,
    ),
    NotificationItem(
      id: '2',
      title: 'Budget Alert: Food & Dining',
      description: 'You have spent 87% of your set monthly limit for Food & Dining budget.',
      time: '09:15 AM',
      dateGroup: 'Today',
      icon: Icons.warning_amber_rounded,
      iconColor: AppColors.gold,
      iconBgColor: AppColors.goldBg,
      category: 'alert',
      isRead: false,
    ),
    NotificationItem(
      id: '3',
      title: 'New Login Detected',
      description: 'A new login attempt was detected from Chrome browser on Windows (IP: 192.168.1.45). If this wasn\'t you, please secure your account.',
      time: 'Yesterday, 11:45 PM',
      dateGroup: 'Yesterday',
      icon: Icons.security_rounded,
      iconColor: AppColors.red,
      iconBgColor: AppColors.redBg,
      category: 'alert',
      isRead: true,
    ),
    NotificationItem(
      id: '4',
      title: 'Zepto Groceries Expense',
      description: 'Transaction of ₹1,240 was successful at Zepto Groceries using your linked credit card.',
      time: 'Yesterday, 02:15 PM',
      dateGroup: 'Yesterday',
      icon: Icons.shopping_bag_rounded,
      iconColor: AppColors.red,
      iconBgColor: AppColors.redBg,
      category: 'transaction',
      isRead: true,
    ),
    NotificationItem(
      id: '5',
      title: 'System Maintenance Scheduled',
      description: 'FiServTrack will undergo scheduled core database upgrades on Sunday from 02:00 AM to 04:00 AM IST. Some services might be temporarily offline.',
      time: 'June 4, 11:00 AM',
      dateGroup: 'Earlier',
      icon: Icons.info_outline_rounded,
      iconColor: AppColors.brandMid,
      iconBgColor: AppColors.brandPale,
      category: 'system',
      isRead: true,
    ),
    NotificationItem(
      id: '6',
      title: 'Goal Achieved! 🎯',
      description: 'Congratulations! You hit 100% of your savings goal "New Car Fund" this month.',
      time: 'June 2, 05:30 PM',
      dateGroup: 'Earlier',
      icon: Icons.stars_rounded,
      iconColor: AppColors.green,
      iconBgColor: AppColors.greenBg,
      category: 'system',
      isRead: true,
    ),
  ];

  // Get notifications filtered by category
  List<NotificationItem> get _filteredNotifications {
    if (_selectedCategory == 'all') return _notifications;
    return _notifications.where((n) => n.category == _selectedCategory).toList();
  }

  // Count unread notifications
  int get _unreadCount => _notifications.where((n) => !n.isRead).length;

  void _markAllAsRead() {
    setState(() {
      for (var item in _notifications) {
        item.isRead = true;
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('All notifications marked as read'),
        duration: Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    final list = _filteredNotifications;

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: Column(
        children: [
          _buildHeader(),
          _buildFilterTabs(),
          Expanded(
            child: list.isEmpty ? _buildEmptyState() : _buildNotificationList(list),
          ),
        ],
      ),
    );
  }

  // Header Widget
  Widget _buildHeader() {
    final hasUnread = _unreadCount > 0;
    return Container(
      decoration: const BoxDecoration(
        gradient: AppColors.brandGradient,
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
            top: -70,
            right: -60,
            child: Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [Colors.white.withOpacity(0.07), Colors.transparent],
                  stops: const [0.0, 0.7],
                ),
              ),
            ),
          ),
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Back Button
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.white.withOpacity(0.18)),
                      ),
                      child: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 16),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Title & Subtitle
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Notifications',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Row(
                          children: [
                            Text(
                              hasUnread
                                  ? 'You have $_unreadCount unread'
                                  : 'All caught up!',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.7),
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            if (hasUnread) ...[
                              const SizedBox(width: 6),
                              Container(
                                width: 6,
                                height: 6,
                                decoration: const BoxDecoration(
                                  color: AppColors.greenLight,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ]
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Action Buttons
                  if (_notifications.isNotEmpty) ...[
                    // Mark all as read icon button
                    GestureDetector(
                      onTap: hasUnread ? _markAllAsRead : null,
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(hasUnread ? 0.12 : 0.05),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.white.withOpacity(hasUnread ? 0.18 : 0.08),
                          ),
                        ),
                        child: Icon(
                          Icons.done_all_rounded,
                          color: hasUnread ? Colors.white : Colors.white30,
                          size: 18,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Filters Tab row
  Widget _buildFilterTabs() {
    final categories = [
      {'label': 'All', 'value': 'all'},
      {'label': 'Transactions', 'value': 'transaction'},
      {'label': 'Alerts', 'value': 'alert'},
      {'label': 'Updates', 'value': 'system'},
    ];

    return Container(
      height: 46,
      margin: const EdgeInsets.only(top: 16, bottom: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final cat = categories[index];
          final isSelected = _selectedCategory == cat['value'];

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedCategory = cat['value']!;
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.brand : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected ? AppColors.brand : AppColors.cardBorder,
                    width: 1.5,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: AppColors.brand.withOpacity(0.15),
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          )
                        ]
                      : null,
                ),
                alignment: Alignment.center,
                child: Text(
                  cat['label']!,
                  style: TextStyle(
                    color: isSelected ? Colors.white : AppColors.inkSoft,
                    fontSize: 13,
                    fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // Empty state view
  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.brandPale,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.notifications_none_rounded,
                color: AppColors.brandMid,
                size: 36,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'No Notifications',
              style: TextStyle(
                color: AppColors.ink,
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _selectedCategory == 'all'
                  ? 'We\'ll notify you when transactions happen, budgets approach limit, or security actions are needed.'
                  : 'No notifications in this category currently.',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.inkSoft,
                fontSize: 13,
                height: 1.4,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Notification list grouped by dates
  Widget _buildNotificationList(List<NotificationItem> list) {
    // Group notifications by dateGroup
    final Map<String, List<NotificationItem>> groups = {};
    for (var item in list) {
      groups.putIfAbsent(item.dateGroup, () => []).add(item);
    }

    final dateGroups = ['Today', 'Yesterday', 'Earlier'].where((g) => groups.containsKey(g)).toList();

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
      physics: const BouncingScrollPhysics(),
      itemCount: dateGroups.length,
      itemBuilder: (context, groupIndex) {
        final dateGroup = dateGroups[groupIndex];
        final groupItems = groups[dateGroup]!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 4, top: 16, bottom: 12),
              child: Text(
                dateGroup.toUpperCase(),
                style: const TextStyle(
                  color: AppColors.inkMuted,
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.2,
                ),
              ),
            ),
            ...groupItems.map((item) => _buildNotificationCard(item)),
          ],
        );
      },
    );
  }

  // Single card view
  Widget _buildNotificationCard(NotificationItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: item.isRead ? AppColors.cardBorder : AppColors.brandLight.withOpacity(0.25),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.ink.withOpacity(0.04),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Dismissible(
          key: Key(item.id),
          direction: item.isRead ? DismissDirection.none : DismissDirection.endToStart,
          confirmDismiss: (direction) async {
            setState(() {
              item.isRead = true;
            });
            return false; // return false to prevent dismissal and slide the card back
          },
          background: Container(
            color: AppColors.brandMid,
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20),
            child: const Icon(Icons.done_all_rounded, color: Colors.white, size: 24),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Icon container
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: item.iconBgColor,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(item.icon, color: item.iconColor, size: 20),
                  ),
                  const SizedBox(width: 14),
                  // Text detail
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                item.title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: AppColors.ink,
                                  fontSize: 14,
                                  fontWeight: item.isRead ? FontWeight.w700 : FontWeight.w900,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              item.time,
                              style: const TextStyle(
                                color: AppColors.inkMuted,
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Text(
                          item.description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: item.isRead ? AppColors.inkSoft : AppColors.inkMid,
                            fontSize: 12,
                            height: 1.4,
                            fontWeight: item.isRead ? FontWeight.w500 : FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Unread indicator dot
                  if (!item.isRead) ...[
                    const SizedBox(width: 8),
                    Container(
                      margin: const EdgeInsets.only(top: 6),
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: AppColors.brandLight,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ]
                ],
              ),
            ),
        ),
      ),
    );
  }
}
