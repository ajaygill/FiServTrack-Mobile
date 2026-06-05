import 'package:fiservtrack/themes/app_color.dart';
import 'package:flutter/material.dart';

// ── Filter state ──────────────────────────────────────────────────────────────
enum _TimePeriod { today, week, month, custom }

class _FilterState {
  final _TimePeriod time;
  final String category;
  final DateTime? rangeStart;
  final DateTime? rangeEnd;

  const _FilterState({
    this.time = _TimePeriod.month,
    this.category = 'All',
    this.rangeStart,
    this.rangeEnd,
  });

  String get headerSubtitle {
    final cat = category == 'All' ? '' : ' · $category';
    switch (time) {
      case _TimePeriod.today:  return 'Today$cat · 34 entries';
      case _TimePeriod.week:   return 'This Week$cat · 34 entries';
      case _TimePeriod.month:  return 'March 2026$cat · 34 entries';
      case _TimePeriod.custom:
        if (rangeStart != null && rangeEnd != null) {
          final s = '${rangeStart!.day} ${_monthShort(rangeStart!.month)}';
          final e = '${rangeEnd!.day} ${_monthShort(rangeEnd!.month)}';
          return '$s – $e$cat · 34 entries';
        }
        return 'Custom Range$cat';
    }
  }

  static String _monthShort(int m) =>
      ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'][m - 1];

  bool get hasActiveFilters => time != _TimePeriod.month || category != 'All';
}

// ── Data model ────────────────────────────────────────────────────────────────
class _TxnData {
  final String emoji, title, category, amount, time;
  final Color bgColor;
  final bool isDebit;

  const _TxnData({
    required this.emoji, required this.bgColor,
    required this.title, required this.category,
    required this.amount, required this.time,
    required this.isDebit,
  });
}

class _TxnGroup {
  final String label;
  final List<_TxnData> txns;
  const _TxnGroup(this.label, this.txns);
}

// ── Screen ────────────────────────────────────────────────────────────────────
class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({Key? key}) : super(key: key);

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  String _selectedFilter = 'All';
  _FilterState _filters = const _FilterState();

  static const _groups = [
    _TxnGroup('Today · Mar 8', [
      _TxnData(emoji: '🛒', bgColor: Color(0xFFFEF0EE), title: 'Zepto Groceries',
          category: 'Food & Groceries', amount: '−₹1,240', time: '2:15 PM', isDebit: true),
      _TxnData(emoji: '🎬', bgColor: Color(0xFFF3EFFF), title: 'Netflix',
          category: 'Entertainment', amount: '−₹649', time: '12:00 AM', isDebit: true),
    ]),
    _TxnGroup('Yesterday · Mar 7', [
      _TxnData(emoji: '🍔', bgColor: Color(0xFFFFF4E8), title: 'Swiggy Order',
          category: 'Food & Dining', amount: '−₹420', time: '8:32 PM', isDebit: true),
      _TxnData(emoji: '⛽', bgColor: Color(0xFFEAF2FB), title: 'HP Fuel Station',
          category: 'Transport', amount: '−₹2,100', time: '6:44 PM', isDebit: true),
      _TxnData(emoji: '🏦', bgColor: Color(0xFFFEF0EE), title: 'HDFC Car EMI',
          category: 'Loan Repayment', amount: '−₹12,400', time: '10:00 AM', isDebit: true),
    ]),
    _TxnGroup('Mar 1', [
      _TxnData(emoji: '💰', bgColor: Color(0xFFE8FAF3), title: 'Salary — TCS',
          category: 'Income · Salary', amount: '+₹1,00,000', time: '9:00 AM', isDebit: false),
    ]),
  ];

  void _openFilterSheet() async {
    final result = await showModalBottomSheet<_FilterState>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _FilterSheet(current: _filters),
    );
    if (result != null) setState(() => _filters = result);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.only(bottom: 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Header(
              showBack: Navigator.canPop(context),
              subtitle: _filters.headerSubtitle,
              hasActiveFilters: _filters.hasActiveFilters,
              onFilterTap: _openFilterSheet,
            ),
            _SearchBar(),
            _FilterChips(
              selected: _selectedFilter,
              onSelect: (f) => setState(() => _selectedFilter = f),
            ),
            for (final group in _groups) ...[
              _DateLabel(group.label),
              _TxnGroupWidget(group.txns),
            ],
          ],
        ),
      ),
    );
  }
}

// ── Header ────────────────────────────────────────────────────────────────────
class _Header extends StatelessWidget {
  final bool showBack;
  final String subtitle;
  final bool hasActiveFilters;
  final VoidCallback onFilterTap;

  const _Header({
    this.showBack = false,
    required this.subtitle,
    required this.hasActiveFilters,
    required this.onFilterTap,
  });

  @override
  Widget build(BuildContext context) {
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
        clipBehavior: Clip.hardEdge,
        children: [
          Positioned(
            top: -70, right: -60,
            child: Container(
              width: 180, height: 180,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(colors: [
                  Colors.white.withOpacity(0.07), Colors.transparent,
                ], stops: const [0.0, 0.7]),
              ),
            ),
          ),
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (showBack) ...[
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            width: 36, height: 36,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.white.withOpacity(0.18)),
                            ),
                            child: const Icon(Icons.arrow_back_ios_new_rounded,
                                color: Colors.white, size: 16),
                          ),
                        ),
                        const SizedBox(width: 12),
                      ],
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Transactions", style: TextStyle(
                                color: Colors.white, fontSize: 22,
                                fontWeight: FontWeight.w900, letterSpacing: -0.5)),
                            const SizedBox(height: 3),
                            Text(subtitle, style: const TextStyle(
                                color: Colors.white54, fontSize: 12,
                                fontWeight: FontWeight.w500)),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: onFilterTap,
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Container(
                              width: 36, height: 36,
                              decoration: BoxDecoration(
                                color: hasActiveFilters
                                    ? Colors.white.withOpacity(0.22)
                                    : Colors.white.withOpacity(0.12),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                    color: hasActiveFilters
                                        ? Colors.white.withOpacity(0.4)
                                        : Colors.white.withOpacity(0.18)),
                              ),
                              child: const Icon(Icons.tune_rounded,
                                  color: Colors.white, size: 17),
                            ),
                            if (hasActiveFilters)
                              Positioned(
                                top: -3, right: -3,
                                child: Container(
                                  width: 9, height: 9,
                                  decoration: const BoxDecoration(
                                      color: Color(0xFF34C88A),
                                      shape: BoxShape.circle),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(child: _SummaryPill(label: "INCOME",
                          amount: "₹1,20,000", color: const Color(0xFF34C88A))),
                      const SizedBox(width: 10),
                      Expanded(child: _SummaryPill(label: "EXPENSE",
                          amount: "₹68,240", color: const Color(0xFFF46C60))),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Summary pill ──────────────────────────────────────────────────────────────
class _SummaryPill extends StatelessWidget {
  final String label, amount;
  final Color color;
  const _SummaryPill({required this.label, required this.amount, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(0.25)),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label, style: TextStyle(color: color, fontSize: 10,
            fontWeight: FontWeight.w800, letterSpacing: 1.0)),
        const SizedBox(height: 3),
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Text(amount, style: const TextStyle(color: Colors.white, fontSize: 19,
              fontWeight: FontWeight.w900, letterSpacing: -0.5)),
        ),
      ]),
    );
  }
}

// ── Search bar ────────────────────────────────────────────────────────────────
class _SearchBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 14, 20, 0),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 11),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.cardBorder, width: 1.5),
        boxShadow: [BoxShadow(color: AppColors.ink.withOpacity(0.06),
            blurRadius: 3, offset: const Offset(0, 1))],
      ),
      child: const TextField(
        style: TextStyle(color: AppColors.ink, fontSize: 13, fontWeight: FontWeight.w600),
        decoration: InputDecoration(
          hintText: "Search transactions...",
          hintStyle: TextStyle(color: AppColors.inkMuted, fontSize: 14, fontWeight: FontWeight.w500),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          filled: false,
          fillColor: Colors.transparent,
          icon: Icon(Icons.search_rounded, color: AppColors.inkMuted, size: 18),
          isDense: true,
          contentPadding: EdgeInsets.zero,
        ),
      ),
    );
  }
}

// ── Filter chips ──────────────────────────────────────────────────────────────
class _FilterChips extends StatelessWidget {
  final String selected;
  final ValueChanged<String> onSelect;
  static const _filters = ['All', 'Income', 'Expenses', 'Food', 'EMI', 'Transport'];
  const _FilterChips({required this.selected, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
      child: Row(
        children: _filters.map((f) {
          final bool on = selected == f;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () => onSelect(f),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 9),
                decoration: BoxDecoration(
                  color: on ? AppColors.brand : AppColors.card,
                  borderRadius: BorderRadius.circular(20),
                  border: on ? null : Border.all(color: AppColors.cardBorder, width: 1.5),
                  boxShadow: on ? [BoxShadow(color: AppColors.brand.withOpacity(0.25),
                      blurRadius: 10, offset: const Offset(0, 4))] : [],
                ),
                child: Text(f, style: TextStyle(
                    color: on ? Colors.white : AppColors.inkMid,
                    fontSize: 11, fontWeight: FontWeight.w700)),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

// ── Date group label ──────────────────────────────────────────────────────────
class _DateLabel extends StatelessWidget {
  final String label;
  const _DateLabel(this.label);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 4),
      child: Text(label.toUpperCase(), style: const TextStyle(
          color: AppColors.inkMuted, fontSize: 11,
          fontWeight: FontWeight.w700, letterSpacing: 1.0)),
    );
  }
}

// ── Transaction group ─────────────────────────────────────────────────────────
class _TxnGroupWidget extends StatelessWidget {
  final List<_TxnData> txns;
  const _TxnGroupWidget(this.txns);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.cardBorder, width: 1.5),
        boxShadow: [BoxShadow(color: AppColors.ink.withOpacity(0.04),
            blurRadius: 6, offset: const Offset(0, 2))],
      ),
      child: Column(
        children: txns.asMap().entries.map((e) =>
            _TxnRow(data: e.value, isLast: e.key == txns.length - 1)).toList(),
      ),
    );
  }
}

// ── Transaction row ───────────────────────────────────────────────────────────
class _TxnRow extends StatelessWidget {
  final _TxnData data;
  final bool isLast;
  const _TxnRow({required this.data, required this.isLast});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        border: isLast ? null : const Border(
            bottom: BorderSide(color: AppColors.divider, width: 1)),
      ),
      child: Row(children: [
        Container(
          width: 40, height: 40,
          decoration: BoxDecoration(color: data.bgColor,
              borderRadius: BorderRadius.circular(13)),
          alignment: Alignment.center,
          child: Text(data.emoji, style: const TextStyle(fontSize: 19)),
        ),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(data.title, style: const TextStyle(
              color: AppColors.ink, fontSize: 13, fontWeight: FontWeight.w700)),
          const SizedBox(height: 2),
          Text(data.category, style: const TextStyle(
              color: AppColors.inkSoft, fontSize: 11, fontWeight: FontWeight.w500)),
        ])),
        Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
          Text(data.amount, style: TextStyle(
              color: data.isDebit ? AppColors.red : AppColors.green,
              fontSize: 13, fontWeight: FontWeight.w800)),
          const SizedBox(height: 3),
          Text(data.time, style: const TextStyle(color: AppColors.inkMuted, fontSize: 10)),
        ]),
      ]),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// ── Filter Bottom Sheet ───────────────────────────────────────────────────────
// ══════════════════════════════════════════════════════════════════════════════
class _FilterSheet extends StatefulWidget {
  final _FilterState current;
  const _FilterSheet({required this.current});

  @override
  State<_FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<_FilterSheet> {
  late _FilterState _draft;

  static const _categories = [
    ('All',           '🗂️'),
    ('Food',          '🍔'),
    ('Transport',     '⛽'),
    ('EMI',           '🏦'),
    ('Entertainment', '🎬'),
    ('Income',        '💰'),
  ];

  @override
  void initState() {
    super.initState();
    _draft = widget.current;
  }

  void _onDayTapped(DateTime day) {
    setState(() {
      final hasStart = _draft.rangeStart != null;
      final hasEnd   = _draft.rangeEnd   != null;

      if (!hasStart || (hasStart && hasEnd)) {
        // Start fresh — first tap picks start
        _draft = _FilterState(
          time: _TimePeriod.custom,
          category: _draft.category,
          rangeStart: day,
          rangeEnd: null,
        );
      } else {
        // Second tap picks end
        if (day.isBefore(_draft.rangeStart!)) {
          _draft = _FilterState(
            time: _TimePeriod.custom,
            category: _draft.category,
            rangeStart: day,
            rangeEnd: _draft.rangeStart,
          );
        } else {
          _draft = _FilterState(
            time: _TimePeriod.custom,
            category: _draft.category,
            rangeStart: _draft.rangeStart,
            rangeEnd: day,
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.92,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 12, bottom: 6),
              width: 38, height: 4,
              decoration: BoxDecoration(
                  color: AppColors.cardBorder, borderRadius: BorderRadius.circular(2)),
            ),
          ),

          // Sheet header
          Padding(
            padding: const EdgeInsets.fromLTRB(22, 10, 22, 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Filter Transactions", style: TextStyle(
                    color: AppColors.ink, fontSize: 18,
                    fontWeight: FontWeight.w900, letterSpacing: -0.4)),
                GestureDetector(
                  onTap: () => setState(() {
                    _draft = const _FilterState();
                  }),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 5),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.cardBorder),
                    ),
                    child: const Text("Reset", style: TextStyle(
                        color: AppColors.inkSoft, fontSize: 11, fontWeight: FontWeight.w700)),
                  ),
                ),
              ],
            ),
          ),

          Flexible(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.only(bottom: 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [

                  // ── TIME PERIOD ────────────────────────────────────────────
                  _SheetSection(
                    label: "TIME PERIOD",
                    child: Column(children: [
                      Row(children: [
                        _TimePill(
                          label: "Today", icon: Icons.wb_sunny_outlined,
                          selected: _draft.time == _TimePeriod.today,
                          onTap: () => setState(() => _draft = _FilterState(
                              time: _TimePeriod.today, category: _draft.category)),
                        ),
                        const SizedBox(width: 8),
                        _TimePill(
                          label: "This Week", icon: Icons.view_week_outlined,
                          selected: _draft.time == _TimePeriod.week,
                          onTap: () => setState(() => _draft = _FilterState(
                              time: _TimePeriod.week, category: _draft.category)),
                        ),
                        const SizedBox(width: 8),
                        _TimePill(
                          label: "This Month", icon: Icons.calendar_month_outlined,
                          selected: _draft.time == _TimePeriod.month,
                          onTap: () => setState(() => _draft = _FilterState(
                              time: _TimePeriod.month, category: _draft.category)),
                        ),
                      ]),

                      const SizedBox(height: 10),

                      // Custom range toggle button
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            if (_draft.time == _TimePeriod.custom) {
                              // Already open → collapse back to month
                              _draft = _FilterState(
                                time: _TimePeriod.month,
                                category: _draft.category,
                              );
                            } else {
                              _draft = _FilterState(
                                time: _TimePeriod.custom,
                                category: _draft.category,
                              );
                            }
                          });
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
                          decoration: BoxDecoration(
                            color: _draft.time == _TimePeriod.custom
                                ? AppColors.brand.withOpacity(0.06) : AppColors.surface,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: _draft.time == _TimePeriod.custom
                                  ? AppColors.brand.withOpacity(0.5) : AppColors.cardBorder,
                              width: 1.5,
                            ),
                          ),
                          child: Row(children: [
                            Icon(Icons.date_range_rounded, size: 17,
                                color: _draft.time == _TimePeriod.custom
                                    ? AppColors.brand : AppColors.inkMuted),
                            const SizedBox(width: 10),
                            Expanded(
                              child: _draft.time == _TimePeriod.custom &&
                                  _draft.rangeStart != null &&
                                  _draft.rangeEnd != null
                                  ? Row(children: [
                                _DateChip(date: _draft.rangeStart!),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8),
                                  child: Icon(Icons.arrow_forward_rounded,
                                      size: 14, color: AppColors.inkMuted),
                                ),
                                _DateChip(date: _draft.rangeEnd!),
                              ])
                                  : _draft.time == _TimePeriod.custom &&
                                  _draft.rangeStart != null
                                  ? Row(children: [
                                _DateChip(date: _draft.rangeStart!),
                                const SizedBox(width: 8),
                                const Text("→ pick end date",
                                    style: TextStyle(color: AppColors.inkMuted,
                                        fontSize: 12, fontWeight: FontWeight.w500)),
                              ])
                                  : Text("Custom Date Range",
                                  style: TextStyle(
                                      color: _draft.time == _TimePeriod.custom
                                          ? AppColors.brand : AppColors.inkMuted,
                                      fontSize: 13, fontWeight: FontWeight.w600)),
                            ),
                            Icon(
                              _draft.time == _TimePeriod.custom
                                  ? Icons.expand_less_rounded
                                  : Icons.expand_more_rounded,
                              size: 18,
                              color: _draft.time == _TimePeriod.custom
                                  ? AppColors.brand : AppColors.inkMuted,
                            ),
                          ]),
                        ),
                      ),

                      // Inline calendar — only visible when custom is selected
                      AnimatedSize(
                        duration: const Duration(milliseconds: 240),
                        curve: Curves.easeInOut,
                        child: _draft.time == _TimePeriod.custom
                            ? _InlineCalendar(
                          rangeStart: _draft.rangeStart,
                          rangeEnd: _draft.rangeEnd,
                          onDayTapped: _onDayTapped,
                        )
                            : const SizedBox.shrink(),
                      ),
                    ]),
                  ),

                  // ── CATEGORY ──────────────────────────────────────────────
                  _SheetSection(
                    label: "CATEGORY",
                    child: Wrap(
                      spacing: 8, runSpacing: 8,
                      children: _categories.map((c) {
                        final (name, emoji) = c;
                        final bool on = _draft.category == name;
                        return GestureDetector(
                          onTap: () => setState(() => _draft = _FilterState(
                              time: _draft.time, category: name,
                              rangeStart: _draft.rangeStart, rangeEnd: _draft.rangeEnd)),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 180),
                            padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 9),
                            decoration: BoxDecoration(
                              color: on ? AppColors.brand : AppColors.surface,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                  color: on ? AppColors.brand : AppColors.cardBorder, width: 1.5),
                              boxShadow: on ? [BoxShadow(
                                  color: AppColors.brand.withOpacity(0.2),
                                  blurRadius: 8, offset: const Offset(0, 3))] : [],
                            ),
                            child: Row(mainAxisSize: MainAxisSize.min, children: [
                              Text(emoji, style: const TextStyle(fontSize: 13)),
                              const SizedBox(width: 6),
                              Text(name, style: TextStyle(
                                  color: on ? Colors.white : AppColors.inkMid,
                                  fontSize: 12, fontWeight: FontWeight.w700)),
                            ]),
                          ),
                        );
                      }).toList(),
                    ),
                  ),

                  const SizedBox(height: 8),

                  // ── APPLY ─────────────────────────────────────────────────
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 22),
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context, _draft),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [AppColors.brandMid, AppColors.brandDeep],
                            begin: Alignment.topLeft, end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [BoxShadow(color: AppColors.brand.withOpacity(0.35),
                              blurRadius: 16, offset: const Offset(0, 6))],
                        ),
                        child: const Center(
                          child: Text("Apply Filters", style: TextStyle(
                              color: Colors.white, fontSize: 15,
                              fontWeight: FontWeight.w800, letterSpacing: 0.2)),
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
}

// ── Date chip (shows a selected date nicely) ──────────────────────────────────
class _DateChip extends StatelessWidget {
  final DateTime date;
  const _DateChip({required this.date});

  static const _months = ['Jan','Feb','Mar','Apr','May','Jun',
    'Jul','Aug','Sep','Oct','Nov','Dec'];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.brand,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        '${date.day} ${_months[date.month - 1]}',
        style: const TextStyle(color: Colors.white,
            fontSize: 12, fontWeight: FontWeight.w700),
      ),
    );
  }
}

// ── Inline calendar widget ────────────────────────────────────────────────────
class _InlineCalendar extends StatefulWidget {
  final DateTime? rangeStart;
  final DateTime? rangeEnd;
  final ValueChanged<DateTime> onDayTapped;

  static const _weekDays  = ['Su', 'Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa'];
  static const _monthNames = [
    'January','February','March','April','May','June',
    'July','August','September','October','November','December'
  ];

  const _InlineCalendar({
    required this.rangeStart,
    required this.rangeEnd,
    required this.onDayTapped,
  });

  @override
  State<_InlineCalendar> createState() => _InlineCalendarState();
}

class _InlineCalendarState extends State<_InlineCalendar> {
  late DateTime _calMonth;

  @override
  void initState() {
    super.initState();
    _calMonth = DateTime(DateTime.now().year, DateTime.now().month);
  }

  void _prevMonth() => setState(() =>
  _calMonth = DateTime(
    _calMonth.month == 1 ? _calMonth.year - 1 : _calMonth.year,
    _calMonth.month == 1 ? 12 : _calMonth.month - 1,
  ));

  void _nextMonth() => setState(() =>
  _calMonth = DateTime(
    _calMonth.month == 12 ? _calMonth.year + 1 : _calMonth.year,
    _calMonth.month == 12 ? 1 : _calMonth.month + 1,
  ));

  bool _isStart(DateTime d) =>
      widget.rangeStart != null && _sameDay(d, widget.rangeStart!);
  bool _isEnd(DateTime d) =>
      widget.rangeEnd != null && _sameDay(d, widget.rangeEnd!);
  bool _isInRange(DateTime d) =>
      widget.rangeStart != null && widget.rangeEnd != null &&
          d.isAfter(widget.rangeStart!) && d.isBefore(widget.rangeEnd!);
  bool _sameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  @override
  Widget build(BuildContext context) {
    final firstDay    = DateTime(_calMonth.year, _calMonth.month, 1);
    final daysInMonth = DateTime(_calMonth.year, _calMonth.month + 1, 0).day;
    final startOffset = firstDay.weekday % 7; // Sunday = 0
    final today       = DateTime.now();

    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.fromLTRB(14, 16, 14, 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.brand.withOpacity(0.25), width: 1.5),
      ),
      child: Column(children: [

        // Month navigation header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: _prevMonth,
              child: Container(
                width: 32, height: 32,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.cardBorder, width: 1.5),
                ),
                child: const Icon(Icons.chevron_left_rounded,
                    size: 18, color: AppColors.inkMid),
              ),
            ),
            Text(
              '${_InlineCalendar._monthNames[_calMonth.month - 1]} ${_calMonth.year}',
              style: const TextStyle(
                  color: AppColors.ink, fontSize: 14,
                  fontWeight: FontWeight.w800, letterSpacing: -0.3),
            ),
            GestureDetector(
              onTap: _nextMonth,
              child: Container(
                width: 32, height: 32,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.cardBorder, width: 1.5),
                ),
                child: const Icon(Icons.chevron_right_rounded,
                    size: 18, color: AppColors.inkMid),
              ),
            ),
          ],
        ),

        const SizedBox(height: 14),

        // Weekday labels
        Row(
          children: _InlineCalendar._weekDays.map((d) => Expanded(
            child: Center(
              child: Text(d, style: const TextStyle(
                  color: AppColors.inkMuted, fontSize: 10,
                  fontWeight: FontWeight.w700, letterSpacing: 0.5)),
            ),
          )).toList(),
        ),

        const SizedBox(height: 8),

        // Day grid — always 6 rows x 7 cols so height is identical every month
        LayoutBuilder(builder: (_, constraints) {
          const totalRows = 6;
          final cellW = constraints.maxWidth / 7;
          const cellH = 38.0; // fixed cell height -> grid is always 6 x 38 = 228px

          final List<Widget> cells = List.generate(42, (index) {
            final dayNum = index - startOffset + 1;
            if (dayNum < 1 || dayNum > daysInMonth) {
              return SizedBox(width: cellW, height: cellH);
            }
            final date     = DateTime(_calMonth.year, _calMonth.month, dayNum);
            final isS      = _isStart(date);
            final isE      = _isEnd(date);
            final inRange  = _isInRange(date);
            final isToday  = _sameDay(date, today);
            final isFuture = date.isAfter(today);

            return _DayCell(
              day: dayNum,
              cellW: cellW,
              cellH: cellH,
              isStart: isS,
              isEnd: isE,
              inRange: inRange,
              isToday: isToday,
              isFuture: isFuture,
              isFirstInRow: index % 7 == 0,
              isLastInRow:  index % 7 == 6,
              onTap: isFuture ? null : () => widget.onDayTapped(date),
            );
          });

          return Column(
            children: List.generate(totalRows, (row) => Row(
              children: cells.sublist(row * 7, row * 7 + 7),
            )),
          );
        }),

        // Legend
        if (widget.rangeStart != null || widget.rangeEnd != null) ...[
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.cardBorder),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _LegendDot(color: AppColors.brand),
                const SizedBox(width: 5),
                Text(
                  widget.rangeStart != null
                      ? '${widget.rangeStart!.day} ${_FilterState._monthShort(widget.rangeStart!.month)}'
                      : '—',
                  style: const TextStyle(color: AppColors.ink,
                      fontSize: 12, fontWeight: FontWeight.w700),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    widget.rangeEnd != null ? '→' : '· tap to pick end',
                    style: TextStyle(
                        color: widget.rangeEnd != null ? AppColors.inkMid : AppColors.inkMuted,
                        fontSize: 12, fontWeight: FontWeight.w500),
                  ),
                ),
                if (widget.rangeEnd != null) ...[
                  _LegendDot(color: AppColors.brand),
                  const SizedBox(width: 5),
                  Text(
                    '${widget.rangeEnd!.day} ${_FilterState._monthShort(widget.rangeEnd!.month)}',
                    style: const TextStyle(color: AppColors.ink,
                        fontSize: 12, fontWeight: FontWeight.w700),
                  ),
                ],
              ],
            ),
          ),
        ],
      ]),
    );
  }
}

class _LegendDot extends StatelessWidget {
  final Color color;
  const _LegendDot({required this.color});
  @override
  Widget build(BuildContext context) =>
      Container(width: 8, height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle));
}

// ── Single day cell ───────────────────────────────────────────────────────────
class _DayCell extends StatelessWidget {
  final int day;
  final double cellW, cellH;
  final bool isStart, isEnd, inRange, isToday, isFuture;
  final bool isFirstInRow, isLastInRow;
  final VoidCallback? onTap;

  const _DayCell({
    required this.day,
    required this.cellW, required this.cellH,
    required this.isStart, required this.isEnd,
    required this.inRange, required this.isToday,
    required this.isFuture, required this.isFirstInRow,
    required this.isLastInRow, required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool highlighted = isStart || isEnd;

    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: cellW, height: cellH,
        child: Stack(alignment: Alignment.center, children: [

          // Range background strip (between start and end)
          if (inRange || (isStart && !isEnd) || (isEnd && !isStart))
            Positioned.fill(
              child: Row(children: [
                // Left half
                Expanded(
                  child: Container(
                    color: (inRange || isEnd) && !isFirstInRow
                        ? AppColors.brand.withOpacity(0.10) : Colors.transparent,
                  ),
                ),
                // Right half
                Expanded(
                  child: Container(
                    color: (inRange || isStart) && !isLastInRow
                        ? AppColors.brand.withOpacity(0.10) : Colors.transparent,
                  ),
                ),
              ]),
            ),

          // Circle for selected days
          if (highlighted)
            Container(
              width: cellW * 0.78,
              height: cellH * 0.78,
              decoration: const BoxDecoration(
                color: AppColors.brand,
                shape: BoxShape.circle,
              ),
            )
          else if (inRange)
            Container(
              width: cellW * 0.72,
              height: cellH * 0.72,
              decoration: BoxDecoration(
                color: AppColors.brand.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
            )
          else if (isToday)
              Container(
                width: cellW * 0.72,
                height: cellH * 0.72,
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.brand, width: 1.5),
                  shape: BoxShape.circle,
                ),
              ),

          // Day number
          Text(
            '$day',
            style: TextStyle(
              color: highlighted
                  ? Colors.white
                  : isFuture
                  ? AppColors.inkMuted.withOpacity(0.4)
                  : inRange
                  ? AppColors.brand
                  : isToday
                  ? AppColors.brand
                  : AppColors.ink,
              fontSize: 12,
              fontWeight: highlighted || isToday
                  ? FontWeight.w800 : FontWeight.w500,
            ),
          ),
        ]),
      ),
    );
  }
}

// ── Sheet section wrapper ─────────────────────────────────────────────────────
class _SheetSection extends StatelessWidget {
  final String label;
  final Widget child;
  const _SheetSection({required this.label, required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(22, 0, 22, 0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label, style: const TextStyle(color: AppColors.inkMuted, fontSize: 10,
            fontWeight: FontWeight.w800, letterSpacing: 1.2)),
        const SizedBox(height: 10),
        child,
        const SizedBox(height: 18),
      ]),
    );
  }
}

// ── Time period pill ──────────────────────────────────────────────────────────
class _TimePill extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _TimePill({
    required this.label, required this.icon,
    required this.selected, required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(vertical: 11),
          decoration: BoxDecoration(
            color: selected ? AppColors.brand : AppColors.surface,
            borderRadius: BorderRadius.circular(13),
            border: Border.all(
                color: selected ? AppColors.brand : AppColors.cardBorder, width: 1.5),
            boxShadow: selected ? [BoxShadow(color: AppColors.brand.withOpacity(0.22),
                blurRadius: 8, offset: const Offset(0, 3))] : [],
          ),
          child: Column(children: [
            Icon(icon, size: 17, color: selected ? Colors.white : AppColors.inkMuted),
            const SizedBox(height: 5),
            Text(label, style: TextStyle(
                color: selected ? Colors.white : AppColors.inkMid,
                fontSize: 10, fontWeight: FontWeight.w700),
                textAlign: TextAlign.center),
          ]),
        ),
      ),
    );
  }
}