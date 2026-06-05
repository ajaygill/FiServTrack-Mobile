import 'package:fiservtrack/themes/app_color.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

// ── Input Decoration ───────────────────────────────────────────────────────────
InputDecoration _inputDeco(String label, String hint) {
  return InputDecoration(
    labelText: label,
    hintText: hint,
    labelStyle: const TextStyle(color: AppColors.inkSoft, fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 0.5),
    hintStyle: const TextStyle(color: AppColors.inkMuted, fontSize: 12),
    filled: true,
    fillColor: AppColors.surface,
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppColors.cardBorder, width: 1.5),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppColors.brandMid, width: 1.8),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Colors.redAccent, width: 1.8),
    ),
  );
}

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
            top: -70, right: -60,
            child: Container(
              width: 200, height: 200,
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
                      Text('Analytics',
                        style: TextStyle(
                          color: Colors.white, fontSize: 22,
                          fontWeight: FontWeight.w900, letterSpacing: -0.5,
                        ),
                      ),
                      SizedBox(height: 3),
                      Text('March 2026',
                        style: TextStyle(
                          color: Color(0x80FFFFFF), fontSize: 12,
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
                            Text(_monthLabel,
                              style: const TextStyle(
                                color: Color(0xCCFFFFFF), fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(width: 5),
                            const Icon(Icons.keyboard_arrow_down_rounded,
                                color: Color(0xCCFFFFFF), size: 16),
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
        boxShadow: const [BoxShadow(color: Color(0x090D2840), blurRadius: 8, offset: Offset(0,2))],
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
                    boxShadow: sel ? [const BoxShadow(color: Color(0x3D134372), blurRadius: 10, offset: Offset(0,4))] : [],
                  ),
                  alignment: Alignment.center,
                  child: Text(labels[i],
                    style: TextStyle(
                      color: sel ? Colors.white : AppColors.inkMuted,
                      fontSize: 12, fontWeight: FontWeight.w800,
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
      case 0: return _OverviewTab(key: key, anim: _chartFade);
      case 1: return _BudgetTab(key: key, anim: _chartFade);
      case 2: return _ForecastTab(key: key, anim: _chartFade);
      default: return _OverviewTab(key: key, anim: _chartFade);
    }
  }

  void _pickMonth() {
    const months = [
      'Jan 2026','Feb 2026','Mar 2026','Apr 2026','May 2026','Jun 2026',
    ];
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => _MonthPickerSheet(
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

// ══════════════════════════════════════════════════════════════════════════════
// OVERVIEW TAB
// ══════════════════════════════════════════════════════════════════════════════
class _OverviewTab extends StatelessWidget {
  final Animation<double> anim;
  const _OverviewTab({Key? key, required this.anim}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: anim,
      child: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.only(top: 16, bottom: 100),
        children: [
          // ── Spending Trend Chart ──
          _ChartCard(
            title: 'Spending Trend',
            subtitle: 'Daily spend · March',
            child: Column(
              children: [
                const SizedBox(height: 4),
                _TrendChart(),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _LegendItem(color: AppColors.green, label: 'Income', value: '₹1.2L'),
                    const SizedBox(width: 16),
                    _LegendItem(color: AppColors.red, label: 'Expenses', value: '₹68.2K'),
                  ],
                ),
              ],
            ),
          ),

          // ── Spend Breakdown Donut ──
          _ChartCard(
            title: 'Spend Breakdown',
            subtitle: 'Category split · March',
            child: Row(
              children: [
                _DonutChart(),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      _DonutLegendRow(color: AppColors.red,       label: 'EMI / Loans',   value: '33%'),
                      SizedBox(height: 8),
                      _DonutLegendRow(color: AppColors.gold,      label: 'Food & Dining',  value: '25%'),
                      SizedBox(height: 8),
                      _DonutLegendRow(color: AppColors.green,     label: 'Transport',      value: '19%'),
                      SizedBox(height: 8),
                      _DonutLegendRow(color: AppColors.brand,     label: 'Shopping',       value: '15%'),
                      SizedBox(height: 8),
                      _DonutLegendRow(color: AppColors.inkFaint,  label: 'Others',         value: '8%'),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ── Quick Budget Preview ──
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 6, 20, 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('🎯 Budgets', style: TextStyle(
                  color: AppColors.ink, fontSize: 15, fontWeight: FontWeight.w800, letterSpacing: -0.3,
                )),
                const Text('Preview Mode', style: TextStyle(
                  color: AppColors.inkSoft, fontSize: 11, fontWeight: FontWeight.w600,
                )),
              ],
            ),
          ),
          const _BudgetRow(emoji: '🛒', label: 'Food & Dining', spent: 16800, limit: 20000,
              barColor: [AppColors.gold, AppColors.goldLight]),
          const _BudgetRow(emoji: '⛽', label: 'Transport', spent: 9200, limit: 8000,
              barColor: [AppColors.red, AppColors.redLight], isOver: true),
          const _BudgetRow(emoji: '🎬', label: 'Entertainment', spent: 2400, limit: 5000,
              barColor: [AppColors.green, AppColors.greenLight]),

          // ── AI Insight ──
          const _InsightBox(),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// BUDGET TAB
// ══════════════════════════════════════════════════════════════════════════════
class _BudgetTab extends StatefulWidget {
  final Animation<double> anim;
  const _BudgetTab({Key? key, required this.anim}) : super(key: key);

  @override
  State<_BudgetTab> createState() => _BudgetTabState();
}

class _BudgetTabState extends State<_BudgetTab> {
  final List<_Budget> _budgets = [
    const _Budget(emoji: '🛒', label: 'Food & Dining',  spent: 16800, limit: 20000, colors: [AppColors.gold, AppColors.goldLight]),
    const _Budget(emoji: '⛽', label: 'Transport',       spent: 9200,  limit: 8000,  colors: [AppColors.red, AppColors.redLight]),
    const _Budget(emoji: '🎬', label: 'Entertainment',  spent: 2400,  limit: 5000,  colors: [AppColors.green, AppColors.greenLight]),
    const _Budget(emoji: '🛍️', label: 'Shopping',       spent: 6100,  limit: 10000, colors: [AppColors.brand, AppColors.brandLight]),
    const _Budget(emoji: '💊', label: 'Healthcare',     spent: 1200,  limit: 3000,  colors: [Color(0xFF9D7AE4), Color(0xFF7A4EE2)]),
    const _Budget(emoji: '✈️', label: 'Travel',          spent: 0,     limit: 15000, colors: [AppColors.inkMuted, AppColors.inkFaint]),
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
              boxShadow: const [BoxShadow(color: Color(0x2A134372), blurRadius: 16, offset: Offset(0,6))],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      const Text('TOTAL SPENT', style: TextStyle(
                        color: Color(0x80FFFFFF), fontSize: 10,
                        fontWeight: FontWeight.w700, letterSpacing: 1.5,
                      )),
                      const SizedBox(height: 4),
                      Text('₹${_fmt(total.toInt())}', style: const TextStyle(
                        color: Colors.white, fontSize: 26,
                        fontWeight: FontWeight.w900, letterSpacing: -1,
                      )),
                    ]),
                    if (overCount > 0)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: AppColors.redBg,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text('$overCount over budget',
                          style: const TextStyle(color: AppColors.red, fontSize: 11, fontWeight: FontWeight.w800),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 12),
                // overall bar
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: math.min(total / math.max(1.0, _budgets.fold(0.0, (s, b) => s + b.limit)), 1.0),
                    minHeight: 6,
                    backgroundColor: Colors.white.withOpacity(0.15),
                    valueColor: const AlwaysStoppedAnimation(Color(0xFF34C88A)),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '₹${_fmt(total.toInt())} of ₹${_fmt(_budgets.fold(0, (s, b) => s + b.limit))} total budget',
                  style: const TextStyle(color: Color(0x80FFFFFF), fontSize: 11, fontWeight: FontWeight.w500),
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
                const Text('Budget Limits', style: TextStyle(
                  color: AppColors.ink, fontSize: 15, fontWeight: FontWeight.w800, letterSpacing: -0.3,
                )),
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
                      child: const Text('+ Add', style: TextStyle(
                        color: AppColors.brand, fontSize: 11, fontWeight: FontWeight.w800,
                      )),
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
            ..._budgets.map((b) => _BudgetDetailCard(
              budget: b,
              onEdit: () => _showEditBudgetSheet(b),
            )),
        ],
      ),
    );
  }

  void _showAddBudgetSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _AddBudgetBottomSheet(
        onAdded: (emoji, label, limit, colors) {
          setState(() {
            _budgets.add(_Budget(
              emoji: emoji,
              label: label,
              spent: 0,
              limit: limit,
              colors: colors,
            ));
          });
        },
      ),
    );
  }

  void _showEditBudgetSheet(_Budget b) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _EditBudgetBottomSheet(
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

// ── ADD BUDGET BOTTOM SHEET WIDGET ───────────────────────────────────────────
class _AddBudgetBottomSheet extends StatefulWidget {
  final Function(String emoji, String label, int limit, List<Color> colors) onAdded;

  const _AddBudgetBottomSheet({Key? key, required this.onAdded}) : super(key: key);

  @override
  State<_AddBudgetBottomSheet> createState() => _AddBudgetBottomSheetState();
}

class _AddBudgetBottomSheetState extends State<_AddBudgetBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final _limitCtrl = TextEditingController();
  final _customLabelCtrl = TextEditingController();

  String _selectedEmoji = '🍔';
  String _selectedLabel = 'Food & Dining';
  List<Color> _selectedColors = [AppColors.gold, AppColors.goldLight];

  Widget _categoryOption(String emoji, String label, List<Color> colors) {
    final isSel = _selectedLabel == label;
    return Column(
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: () {
              setState(() {
                _selectedEmoji = emoji;
                _selectedLabel = label;
                _selectedColors = colors;
              });
            },
            child: Ink(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: isSel ? AppColors.brandPale : AppColors.surface,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isSel ? AppColors.brandMid : AppColors.cardBorder,
                  width: 2,
                ),
              ),
              child: Center(
                child: Text(emoji, style: const TextStyle(fontSize: 20)),
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label.split(' ').first, // Just show first word
          style: TextStyle(
            fontSize: 10,
            fontWeight: isSel ? FontWeight.w800 : FontWeight.w500,
            color: isSel ? AppColors.brandMid : AppColors.inkSoft,
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _limitCtrl.dispose();
    _customLabelCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        padding: const EdgeInsets.fromLTRB(22, 16, 22, 32),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 38,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.inkFaint,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Add Budget', style: TextStyle(
                      color: AppColors.ink, fontSize: 20, fontWeight: FontWeight.w900, letterSpacing: -0.4,
                    )),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        width: 34, height: 34,
                        decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(11),
                            border: Border.all(color: AppColors.cardBorder, width: 1.5)),
                        alignment: Alignment.center,
                        child: const Icon(Icons.close_rounded, size: 16, color: AppColors.inkSoft),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Category Grid Selection
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _categoryOption('🍔', 'Food & Dining', [AppColors.gold, AppColors.goldLight]),
                    _categoryOption('🚗', 'Transport', [AppColors.red, AppColors.redLight]),
                    _categoryOption('🍿', 'Entertainment', [AppColors.green, AppColors.greenLight]),
                    _categoryOption('🛍️', 'Shopping', [AppColors.brand, AppColors.brandLight]),
                    _categoryOption('💊', 'Healthcare', [const Color(0xFF9D7AE4), const Color(0xFF7A4EE2)]),
                    _categoryOption('📝', 'Other', [AppColors.inkSoft, AppColors.inkMuted]),
                  ],
                ),
                const SizedBox(height: 24),

                if (_selectedLabel == 'Other') ...[
                  TextFormField(
                    controller: _customLabelCtrl,
                    textCapitalization: TextCapitalization.words,
                    decoration: _inputDeco("BUDGET CATEGORY NAME", "e.g. Groceries, Gym"),
                    validator: (val) => val == null || val.trim().isEmpty ? "Category name is required" : null,
                  ),
                  const SizedBox(height: 12),
                ],

                TextFormField(
                  controller: _limitCtrl,
                  keyboardType: TextInputType.number,
                  decoration: _inputDeco("MONTHLY LIMIT", "e.g. 15000"),
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) return "Monthly limit is required";
                    if (int.tryParse(val) == null || int.parse(val) <= 0) return "Must be a positive number";
                    return null;
                  },
                ),
                const SizedBox(height: 24),

                _PrimaryBtn(
                  label: 'Add Budget',
                  onTap: () {
                    if (!_formKey.currentState!.validate()) return;

                    final limit = int.parse(_limitCtrl.text);
                    final label = _selectedLabel == 'Other' ? _customLabelCtrl.text : _selectedLabel;

                    widget.onAdded(_selectedEmoji, label, limit, _selectedColors);
                    Navigator.pop(context);

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Budget '$label' successfully created!"),
                        backgroundColor: AppColors.green,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── EDIT BUDGET BOTTOM SHEET WIDGET ──────────────────────────────────────────
class _EditBudgetBottomSheet extends StatefulWidget {
  final _Budget budget;
  final Function(int newLimit) onSaved;
  final VoidCallback onDelete;

  const _EditBudgetBottomSheet({
    Key? key,
    required this.budget,
    required this.onSaved,
    required this.onDelete,
  }) : super(key: key);

  @override
  State<_EditBudgetBottomSheet> createState() => _EditBudgetBottomSheetState();
}

class _EditBudgetBottomSheetState extends State<_EditBudgetBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final _limitCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _limitCtrl.text = widget.budget.limit.toString();
  }

  @override
  void dispose() {
    _limitCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        padding: const EdgeInsets.fromLTRB(22, 16, 22, 32),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 38,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.inkFaint,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('${widget.budget.emoji} ${widget.budget.label}', style: const TextStyle(
                      color: AppColors.ink, fontSize: 20, fontWeight: FontWeight.w900, letterSpacing: -0.4,
                    )),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        width: 34, height: 34,
                        decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(11),
                            border: Border.all(color: AppColors.cardBorder, width: 1.5)),
                        alignment: Alignment.center,
                        child: const Icon(Icons.close_rounded, size: 16, color: AppColors.inkSoft),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.brandPale,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.brandMid.withOpacity(0.3), width: 1.5),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        const Text('CURRENT SPEND', style: TextStyle(
                          color: AppColors.inkMuted, fontSize: 9, fontWeight: FontWeight.w700, letterSpacing: 1,
                        )),
                        Text('₹${_fmt(widget.budget.spent)}', style: const TextStyle(
                          color: AppColors.ink, fontSize: 20, fontWeight: FontWeight.w900, letterSpacing: -0.5,
                        )),
                      ]),
                      Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                        const Text('CURRENT LIMIT', style: TextStyle(
                          color: AppColors.inkMuted, fontSize: 9, fontWeight: FontWeight.w700, letterSpacing: 1,
                        )),
                        Text('₹${_fmt(widget.budget.limit)}', style: const TextStyle(
                          color: AppColors.brand, fontSize: 20, fontWeight: FontWeight.w900, letterSpacing: -0.5,
                        )),
                      ]),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                TextFormField(
                  controller: _limitCtrl,
                  keyboardType: TextInputType.number,
                  decoration: _inputDeco("NEW MONTHLY LIMIT", "e.g. ${_fmt(widget.budget.limit)}"),
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) return "Monthly limit is required";
                    if (int.tryParse(val) == null || int.parse(val) <= 0) return "Must be a positive number";
                    return null;
                  },
                ),
                const SizedBox(height: 24),

                _PrimaryBtn(
                  label: 'Save Changes',
                  onTap: () {
                    if (!_formKey.currentState!.validate()) return;

                    final limit = int.parse(_limitCtrl.text);
                    widget.onSaved(limit);
                    Navigator.pop(context);

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Budget '${widget.budget.label}' limit updated successfully!"),
                        backgroundColor: AppColors.green,
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),

                Center(
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(8),
                      onTap: () {
                        widget.onDelete();
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Budget '${widget.budget.label}' successfully deleted."),
                            backgroundColor: AppColors.red,
                          ),
                        );
                      },
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                        child: Text(
                          'Delete Budget',
                          style: TextStyle(
                            color: AppColors.red,
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// FORECAST TAB
// ══════════════════════════════════════════════════════════════════════════════
class _ForecastTab extends StatelessWidget {
  final Animation<double> anim;
  const _ForecastTab({Key? key, required this.anim}) : super(key: key);

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
              boxShadow: const [BoxShadow(color: Color(0x0A0D2840), blurRadius: 12, offset: Offset(0,4))],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [
                      Text('PROJECTED SPEND', style: TextStyle(
                        color: AppColors.inkMuted, fontSize: 10,
                        fontWeight: FontWeight.w700, letterSpacing: 1.5,
                      )),
                      SizedBox(height: 5),
                      Text('₹82,500', style: TextStyle(
                        color: AppColors.ink, fontSize: 26,
                        fontWeight: FontWeight.w900, letterSpacing: -1,
                      )),
                    ]),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.redBg, borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: const [
                          Icon(Icons.arrow_upward_rounded, color: AppColors.red, size: 12),
                          SizedBox(width: 4),
                          Text('21%', style: TextStyle(
                            color: AppColors.red, fontSize: 11, fontWeight: FontWeight.w800,
                          )),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                const Text('vs ₹68,200 last month', style: TextStyle(
                  color: AppColors.inkSoft, fontSize: 11, fontWeight: FontWeight.w500,
                )),
                const SizedBox(height: 20),

                // Forecast bar chart
                _ForecastBars(),
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
                          style: TextStyle(color: AppColors.inkMid, fontSize: 11, fontWeight: FontWeight.w500, height: 1.4),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Monthly comparison
          _ChartCard(
            title: 'Month-over-Month',
            subtitle: 'Last 6 months spending',
            child: _MoMBars(),
          ),

          // Savings projection
          _ChartCard(
            title: 'Savings Projection',
            subtitle: 'If current trend continues',
            child: Column(
              children: [
                const SizedBox(height: 4),
                _SavingsProjectionChart(),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _LegendItem(color: AppColors.brand, label: 'Actual', value: '₹51,760'),
                    const SizedBox(width: 16),
                    _LegendItem(color: AppColors.inkFaint, label: 'Projected', value: '₹64,000'),
                  ],
                ),
              ],
            ),
          ),

          // Goal cards
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 6, 20, 12),
            child: const Text('🎯 Savings Goals', style: TextStyle(
              color: AppColors.ink, fontSize: 15, fontWeight: FontWeight.w800, letterSpacing: -0.3,
            )),
          ),
          _GoalCard(
            emoji: '🏖️', label: 'Goa Trip',
            saved: 18000, target: 40000,
            deadline: 'Aug 2026',
            colors: const [AppColors.brandLight, AppColors.brand],
          ),
          _GoalCard(
            emoji: '📱', label: 'New Phone',
            saved: 32000, target: 50000,
            deadline: 'Apr 2026',
            colors: const [Color(0xFF9D7AE4), Color(0xFF7A4EE2)],
          ),
          _GoalCard(
            emoji: '🛡️', label: 'Emergency Fund',
            saved: 10000, target: 200000,
            deadline: 'Dec 2026',
            colors: const [AppColors.green, AppColors.greenLight],
          ),

          _InsightBox(
            text: 'You\'re on track to save ₹64,000 by end of March — that\'s 18% above your monthly goal!',
          ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// CHART WIDGETS
// ══════════════════════════════════════════════════════════════════════════════

// Trend Line Chart (SVG-style via CustomPainter)
class _TrendChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SizedBox(
      height: size.height * 0.12,
      child: CustomPaint(
        size: Size.infinite,
        painter: _TrendPainter(),
      ),
    );
  }
}

class _TrendPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height - 14; // Leave room for x-labels

    // Income path data (normalised 0..1 y inverted)
    final incPts = [
      Offset(0, 0.66), Offset(w * 0.25, 0.53), Offset(w * 0.49, 0.41),
      Offset(w * 0.74, 0.36), Offset(w, 0.28),
    ];
    // Expense path
    final expPts = [
      Offset(0, 0.79), Offset(w * 0.25, 0.85), Offset(w * 0.49, 0.68),
      Offset(w * 0.74, 0.64), Offset(w, 0.62),
    ];

    _drawFilledLine(canvas, size, incPts, h, const Color(0xFF0F7B50));
    _drawFilledLine(canvas, size, expPts, h, const Color(0xFFC0392B));

    // Dot at end of income
    final endInc = Offset(w, incPts.last.dy * h);
    canvas.drawCircle(endInc, 7, Paint()..color = const Color(0x330F7B50));
    canvas.drawCircle(endInc, 4, Paint()..color = const Color(0xFF0F7B50));

    // X-axis labels
    final tp = TextPainter(textDirection: TextDirection.ltr);
    for (final e in [('Mar 1', 0.0), ('Mar 15', 0.43), ('Today', 0.87)]) {
      tp.text = TextSpan(
        text: e.$1,
        style: const TextStyle(color: AppColors.inkMuted, fontSize: 8, fontWeight: FontWeight.w600),
      );
      tp.layout();
      tp.paint(canvas, Offset(w * e.$2, h + 4));
    }
  }

  void _drawFilledLine(Canvas canvas, Size size, List<Offset> pts, double h, Color color) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2.2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final path = Path();
    final mapped = pts.map((p) => Offset(p.dx, p.dy * h)).toList();
    path.moveTo(mapped[0].dx, mapped[0].dy);
    for (int i = 0; i < mapped.length - 1; i++) {
      final cp1 = Offset((mapped[i].dx + mapped[i + 1].dx) / 2, mapped[i].dy);
      final cp2 = Offset((mapped[i].dx + mapped[i + 1].dx) / 2, mapped[i + 1].dy);
      path.cubicTo(cp1.dx, cp1.dy, cp2.dx, cp2.dy, mapped[i + 1].dx, mapped[i + 1].dy);
    }

    // Fill
    final fillPath = Path.from(path);
    fillPath.lineTo(mapped.last.dx, h);
    fillPath.lineTo(mapped.first.dx, h);
    fillPath.close();

    final grad = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [color.withOpacity(0.18), color.withOpacity(0.01)],
      ).createShader(Rect.fromLTWH(0, 0, size.width, h));
    canvas.drawPath(fillPath, grad);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Donut Chart
class _DonutChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final chartSize = size.width * 0.25;
    return SizedBox(
      width: chartSize, height: chartSize,
      child: CustomPaint(painter: _DonutPainter()),
    );
  }
}

class _DonutPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final c = Offset(size.width / 2, size.height / 2);
    final r = size.width * 0.40;
    final strokeW = size.width * 0.15;
    const segments = [
      (AppColors.red,      0.33),
      (AppColors.gold,     0.25),
      (AppColors.green,    0.19),
      (AppColors.brand,    0.15),
      (AppColors.inkFaint, 0.08),
    ];

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeW
      ..strokeCap = StrokeCap.round;

    // Background ring
    paint.color = AppColors.divider;
    canvas.drawCircle(c, r, paint);

    double startAngle = -math.pi / 2;
    for (final seg in segments) {
      final sweep = 2 * math.pi * seg.$2;
      paint.color = seg.$1;
      canvas.drawArc(
        Rect.fromCircle(center: c, radius: r),
        startAngle + 0.05, sweep - 0.1, false, paint,
      );
      startAngle += sweep;
    }

    // Centre text
    final tp = TextPainter(textDirection: TextDirection.ltr);
    tp.text = TextSpan(text: 'Total',
        style: TextStyle(color: AppColors.inkMuted, fontSize: size.width * 0.09, fontWeight: FontWeight.w600));
    tp.layout();
    tp.paint(canvas, Offset(c.dx - tp.width / 2, c.dy - size.width * 0.15));

    tp.text = TextSpan(text: '₹68.2K',
        style: TextStyle(color: AppColors.ink, fontSize: size.width * 0.11, fontWeight: FontWeight.w900));
    tp.layout();
    tp.paint(canvas, Offset(c.dx - tp.width / 2, c.dy - size.width * 0.01));
  }

  @override
  bool shouldRepaint(covariant CustomPainter o) => false;
}

// Forecast Bars
class _ForecastBars extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const data = [
      ('Mon', 0.35, false), ('Tue', 0.55, false), ('Wed', 0.28, false),
      ('Thu', 0.90, true),  ('Fri', 0.48, false), ('Sat', 0.72, false),
      ('Sun', 0.20, false),
    ];
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: SizedBox(
        width: 280,
        height: 80,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: data.map((d) => Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                width: 28,
                height: 60 * d.$2,
                decoration: BoxDecoration(
                  color: d.$3 ? AppColors.brandLight : AppColors.inkFaint,
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              const SizedBox(height: 6),
              Text(d.$1, style: const TextStyle(color: AppColors.inkMuted, fontSize: 9, fontWeight: FontWeight.w600)),
            ],
          )).toList(),
        ),
      ),
    );
  }
}

// Month-over-Month Bars
class _MoMBars extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const data = [
      ('Oct', 52000), ('Nov', 61000), ('Dec', 74000),
      ('Jan', 59000), ('Feb', 68200), ('Mar', 82500),
    ];
    const maxVal = 90000.0;
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: SizedBox(
        width: 280,
        height: 100,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(data.length, (i) {
            final d = data[i];
            final isLast = i == data.length - 1;
            final frac = d.$2 / maxVal;
            return Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(_fmtK(d.$2), style: TextStyle(
                  color: isLast ? AppColors.brand : AppColors.inkMuted,
                  fontSize: 9, fontWeight: FontWeight.w700,
                )),
                const SizedBox(height: 4),
                Container(
                  width: 34,
                  height: 70 * frac,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: isLast
                          ? [AppColors.brandLight, AppColors.brand]
                          : [AppColors.inkFaint, AppColors.inkFaint],
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                const SizedBox(height: 6),
                Text(d.$1, style: const TextStyle(
                  color: AppColors.inkMuted, fontSize: 10, fontWeight: FontWeight.w600,
                )),
              ],
            );
          }),
        ),
      ),
    );
  }
}

// Savings Projection Line Chart (dashed projected portion)
class _SavingsProjectionChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SizedBox(
      height: size.height * 0.12,
      child: CustomPaint(painter: _SavingsPainter()),
    );
  }
}

class _SavingsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height - 14;

    // Actual points (0..0.5 of width)
    final actual = [
      Offset(0, 0.90), Offset(w * 0.15, 0.78), Offset(w * 0.30, 0.65),
      Offset(w * 0.45, 0.52), Offset(w * 0.55, 0.43),
    ];
    // Projected points (0.55..1.0)
    final projected = [
      Offset(w * 0.55, 0.43), Offset(w * 0.72, 0.30), Offset(w, 0.20),
    ];

    void drawCurve(List<Offset> pts, Color color, {bool dashed = false}) {
      final paint = Paint()
        ..color = color
        ..strokeWidth = 2.0
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;

      final mapped = pts.map((p) => Offset(p.dx, p.dy * h)).toList();
      final path = Path();
      path.moveTo(mapped[0].dx, mapped[0].dy);
      for (int i = 0; i < mapped.length - 1; i++) {
        final cp1 = Offset((mapped[i].dx + mapped[i + 1].dx) / 2, mapped[i].dy);
        final cp2 = Offset((mapped[i].dx + mapped[i + 1].dx) / 2, mapped[i + 1].dy);
        path.cubicTo(cp1.dx, cp1.dy, cp2.dx, cp2.dy, mapped[i + 1].dx, mapped[i + 1].dy);
      }

      if (!dashed) {
        // Fill
        final fillPath = Path.from(path);
        fillPath.lineTo(mapped.last.dx, h);
        fillPath.lineTo(mapped.first.dx, h);
        fillPath.close();
        canvas.drawPath(fillPath, Paint()
          ..shader = LinearGradient(
            begin: Alignment.topCenter, end: Alignment.bottomCenter,
            colors: [color.withOpacity(0.15), color.withOpacity(0.01)],
          ).createShader(Rect.fromLTWH(0, 0, size.width, h)));
        canvas.drawPath(path, paint);
      } else {
        // Dashed
        paint.color = color.withOpacity(0.6);
        _drawDashedPath(canvas, path, paint);
      }
    }

    drawCurve(actual, AppColors.brand);
    drawCurve(projected, AppColors.inkFaint, dashed: true);

    // Dot at junction
    final junction = Offset(w * 0.55, 0.43 * h);
    canvas.drawCircle(junction, 5, Paint()..color = AppColors.brand);

    // X-axis labels
    final tp = TextPainter(textDirection: TextDirection.ltr);
    for (final e in [('Jan', 0.0), ('Feb', 0.27), ('Mar', 0.52), ('Forecast', 0.70)]) {
      tp.text = TextSpan(
        text: e.$1,
        style: TextStyle(
          color: e.$1 == 'Forecast' ? AppColors.inkMuted.withOpacity(0.6) : AppColors.inkMuted,
          fontSize: 8, fontWeight: FontWeight.w600,
        ),
      );
      tp.layout();
      tp.paint(canvas, Offset(w * e.$2, h + 4));
    }
  }

  void _drawDashedPath(Canvas canvas, Path path, Paint paint) {
    final metrics = path.computeMetrics();
    for (final m in metrics) {
      double dist = 0;
      bool draw = true;
      while (dist < m.length) {
        const dash = 6.0, gap = 4.0;
        final end = math.min(dist + (draw ? dash : gap), m.length);
        if (draw) {
          canvas.drawPath(m.extractPath(dist, end), paint);
        }
        dist = end;
        draw = !draw;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter o) => false;
}

// ══════════════════════════════════════════════════════════════════════════════
// REUSABLE CARD / ROW WIDGETS
// ══════════════════════════════════════════════════════════════════════════════

class _ChartCard extends StatelessWidget {
  final String title, subtitle;
  final Widget child;
  const _ChartCard({required this.title, required this.subtitle, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 14),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.cardBorder, width: 1.5),
        boxShadow: const [BoxShadow(color: Color(0x0C0D2840), blurRadius: 12, offset: Offset(0,4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(
            color: AppColors.ink, fontSize: 14, fontWeight: FontWeight.w800, letterSpacing: -0.3,
          )),
          const SizedBox(height: 2),
          Text(subtitle, style: const TextStyle(
            color: AppColors.inkSoft, fontSize: 11, fontWeight: FontWeight.w500,
          )),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label, value;
  const _LegendItem({required this.color, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(color: AppColors.inkSoft, fontSize: 11)),
        const SizedBox(width: 4),
        Text(value, style: const TextStyle(color: AppColors.ink, fontSize: 11, fontWeight: FontWeight.w800)),
      ],
    );
  }
}

class _DonutLegendRow extends StatelessWidget {
  final Color color;
  final String label, value;
  const _DonutLegendRow({required this.color, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 6),
        Expanded(child: Text(label, style: const TextStyle(color: AppColors.inkSoft, fontSize: 11))),
        Text(value, style: const TextStyle(color: AppColors.ink, fontSize: 11, fontWeight: FontWeight.w800)),
      ],
    );
  }
}

class _BudgetRow extends StatelessWidget {
  final String emoji, label;
  final int spent, limit;
  final List<Color> barColor;
  final bool isOver;
  const _BudgetRow({
    required this.emoji, required this.label,
    required this.spent, required this.limit,
    required this.barColor, this.isOver = false,
  });

  @override
  Widget build(BuildContext context) {
    final progress = math.min(spent / limit, 1.0);
    final remaining = limit - spent;

    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, bottom: 9),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isOver ? const Color(0xFFFEF5F4) : AppColors.card,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isOver ? AppColors.redLight.withOpacity(0.3) : AppColors.cardBorder,
          width: 1.5,
        ),
        boxShadow: const [BoxShadow(color: Color(0x060D2840), blurRadius: 4, offset: Offset(0,1))],
      ),
      child: Column(children: [
        Row(children: [
          Text(emoji, style: const TextStyle(fontSize: 18)),
          const SizedBox(width: 9),
          Expanded(child: Text(label, style: const TextStyle(
            color: AppColors.ink, fontSize: 13, fontWeight: FontWeight.w700,
          ))),
          Text('₹${_fmt(spent)}', style: TextStyle(
            color: isOver ? AppColors.red : AppColors.ink, fontSize: 13, fontWeight: FontWeight.w900,
          )),
          const SizedBox(width: 4),
          Text('/ ₹${_fmt(limit)}', style: const TextStyle(
            color: AppColors.inkMuted, fontSize: 10, fontWeight: FontWeight.w600,
          )),
        ]),
        const SizedBox(height: 10),
        ClipRRect(
          borderRadius: BorderRadius.circular(3),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 5,
            backgroundColor: AppColors.divider,
            valueColor: AlwaysStoppedAnimation(barColor.first),
          ),
        ),
        const SizedBox(height: 6),
        Align(
          alignment: Alignment.centerRight,
          child: isOver
              ? Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(color: AppColors.redBg, borderRadius: BorderRadius.circular(8)),
            child: Text('↑ Over ₹${_fmt(-remaining)}',
                style: const TextStyle(color: AppColors.red, fontSize: 10, fontWeight: FontWeight.w800)),
          )
              : Text('₹${_fmt(remaining)} left', style: const TextStyle(
            color: AppColors.inkSoft, fontSize: 10, fontWeight: FontWeight.w700,
          )),
        ),
      ]),
    );
  }
}

// Full Budget Detail Card (Budget Tab)
class _BudgetDetailCard extends StatelessWidget {
  final _Budget budget;
  final VoidCallback onEdit;
  const _BudgetDetailCard({required this.budget, required this.onEdit});

  @override
  Widget build(BuildContext context) {
    final isOver = budget.spent > budget.limit;
    final progress = math.min(budget.spent / budget.limit, 1.0);
    final remaining = budget.limit - budget.spent;

    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isOver ? const Color(0xFFFEF5F4) : AppColors.card,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isOver ? AppColors.redLight.withOpacity(0.3) : AppColors.cardBorder, width: 1.5,
        ),
        boxShadow: const [BoxShadow(color: Color(0x070D2840), blurRadius: 6, offset: Offset(0,2))],
      ),
      child: Column(children: [
        Row(children: [
          Text(budget.emoji, style: const TextStyle(fontSize: 20)),
          const SizedBox(width: 10),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(budget.label, style: const TextStyle(
              color: AppColors.ink, fontSize: 13, fontWeight: FontWeight.w800,
            )),
            Text('₹${_fmt(budget.spent)} spent of ₹${_fmt(budget.limit)}',
                style: const TextStyle(color: AppColors.inkSoft, fontSize: 11, fontWeight: FontWeight.w500)),
          ])),
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(8),
              onTap: onEdit,
              child: Ink(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: AppColors.brandPale,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text('Edit', style: TextStyle(
                  color: AppColors.brand, fontSize: 10, fontWeight: FontWeight.w800,
                )),
              ),
            ),
          ),
        ]),
        const SizedBox(height: 12),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 6,
            backgroundColor: AppColors.divider,
            valueColor: AlwaysStoppedAnimation(budget.colors.first),
          ),
        ),
        const SizedBox(height: 8),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text('${(progress * 100).round()}% used',
              style: const TextStyle(color: AppColors.inkMuted, fontSize: 10, fontWeight: FontWeight.w600)),
          isOver
              ? Row(children: [
            const Icon(Icons.warning_amber_rounded, color: AppColors.red, size: 12),
            const SizedBox(width: 3),
            Text('Over by ₹${_fmt(-remaining)}',
                style: const TextStyle(color: AppColors.red, fontSize: 10, fontWeight: FontWeight.w800)),
          ])
              : Text('₹${_fmt(remaining)} remaining',
              style: const TextStyle(color: AppColors.inkSoft, fontSize: 10, fontWeight: FontWeight.w600)),
        ]),
      ]),
    );
  }
}

// Goal card
class _GoalCard extends StatelessWidget {
  final String emoji, label, deadline;
  final int saved, target;
  final List<Color> colors;
  const _GoalCard({
    required this.emoji, required this.label, required this.deadline,
    required this.saved, required this.target, required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    final pct = math.min(saved / target, 1.0);
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.cardBorder, width: 1.5),
        boxShadow: const [BoxShadow(color: Color(0x060D2840), blurRadius: 4, offset: Offset(0,1))],
      ),
      child: Column(children: [
        Row(children: [
          Text(emoji, style: const TextStyle(fontSize: 20)),
          const SizedBox(width: 10),
          Expanded(child: Text(label, style: const TextStyle(
            color: AppColors.ink, fontSize: 13, fontWeight: FontWeight.w800,
          ))),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: AppColors.brandPale,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(deadline, style: const TextStyle(
              color: AppColors.brand, fontSize: 10, fontWeight: FontWeight.w700,
            )),
          ),
        ]),
        const SizedBox(height: 10),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text('₹${_fmt(saved)}', style: TextStyle(
            color: colors.first, fontSize: 12, fontWeight: FontWeight.w800,
          )),
          Text('₹${_fmt(target)}', style: const TextStyle(
            color: AppColors.inkMuted, fontSize: 11, fontWeight: FontWeight.w600,
          )),
        ]),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: pct,
            minHeight: 6,
            backgroundColor: AppColors.divider,
            valueColor: AlwaysStoppedAnimation(colors.first),
          ),
        ),
        const SizedBox(height: 6),
        Align(
          alignment: Alignment.centerRight,
          child: Text('${(pct * 100).round()}% saved',
              style: const TextStyle(color: AppColors.inkMuted, fontSize: 10, fontWeight: FontWeight.w600)),
        ),
      ]),
    );
  }
}

// AI Insight Box
class _InsightBox extends StatelessWidget {
  final String text;
  const _InsightBox({
    this.text = 'You\'re spending 28% more on Food compared to last month. Consider cutting back on dining out to stay within your budget.',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 12, 20, 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F5FF),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE6DDF8), width: 1.5),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32, height: 32,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF9D7AE4), Color(0xFF7A4EE2)],
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            alignment: Alignment.center,
            child: const Icon(Icons.auto_awesome_rounded, color: Colors.white, size: 16),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('AI Insight', style: TextStyle(
                  color: Color(0xFF5134A2), fontSize: 11, fontWeight: FontWeight.w800,
                )),
                const SizedBox(height: 4),
                Text(text, style: const TextStyle(
                  color: Color(0xFF6B52AD), fontSize: 12, height: 1.4, fontWeight: FontWeight.w500,
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// BOTTOM SHEETS
// ══════════════════════════════════════════════════════════════════════════════

class _MonthPickerSheet extends StatelessWidget {
  final List<String> months;
  final String selected;
  final ValueChanged<String> onSelect;
  const _MonthPickerSheet({required this.months, required this.selected, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          Center(child: Container(width: 38, height: 4, decoration: BoxDecoration(
            color: AppColors.inkFaint, borderRadius: BorderRadius.circular(2),
          ))),
          const SizedBox(height: 16),
          const Text('Select Month', style: TextStyle(
            color: AppColors.ink, fontSize: 18, fontWeight: FontWeight.w900, letterSpacing: -0.4,
          )),
          const SizedBox(height: 16),
          ...months.map((m) {
            final sel = m == selected;
            return Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(14),
                  onTap: () => onSelect(m),
                  child: Ink(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: sel ? AppColors.brandPale : AppColors.surface,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: sel ? AppColors.brandMid : AppColors.cardBorder, width: 1.5),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(m, style: TextStyle(
                          color: sel ? AppColors.brand : AppColors.ink,
                          fontSize: 13, fontWeight: FontWeight.w700,
                        )),
                        if (sel) const Icon(Icons.check_rounded, color: AppColors.brand, size: 18),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _PrimaryBtn extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _PrimaryBtn({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Ink(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 17),
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: [AppColors.brandLight, AppColors.brandDeep]),
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [BoxShadow(
              color: Color(0x3D134372), blurRadius: 20, offset: Offset(0, 8),
            )],
          ),
          child: Center(
            child: Text(label, style: const TextStyle(
              color: Colors.white, fontSize: 14, fontWeight: FontWeight.w900, letterSpacing: -0.2,
            )),
          ),
        ),
      ),
    );
  }
}

// ── Data model ───────────────────────────────────────────────────────────────

class _Budget {
  final String emoji, label;
  final int spent, limit;
  final List<Color> colors;

  const _Budget({
    required this.emoji,
    required this.label,
    required this.spent,
    required this.limit,
    required this.colors,
  });

  _Budget copyWith({
    String? emoji,
    String? label,
    int? spent,
    int? limit,
    List<Color>? colors,
  }) {
    return _Budget(
      emoji: emoji ?? this.emoji,
      label: label ?? this.label,
      spent: spent ?? this.spent,
      limit: limit ?? this.limit,
      colors: colors ?? this.colors,
    );
  }
}

// ── Helpers ──────────────────────────────────────────────────────────────────

String _fmt(int v) {
  if (v >= 100000) return '${(v / 100000).toStringAsFixed(v % 100000 == 0 ? 0 : 1)}L';
  if (v >= 1000) {
    final thousands = v ~/ 1000;
    final remainder = v % 1000;
    return remainder == 0 ? '${thousands},000' : '${thousands},${remainder.toString().padLeft(3, '0')}';
  }
  return v.toString();
}

String _fmtK(int v) {
  if (v >= 1000) return '₹${(v / 1000).toStringAsFixed(0)}K';
  return '₹$v';
}