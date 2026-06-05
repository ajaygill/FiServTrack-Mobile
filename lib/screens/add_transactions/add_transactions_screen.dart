import 'package:fiservtrack/themes/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ── Shared account options ─────────────────────────────────────────────────────
const _kAccounts = [
  ('🏦', 'HDFC Savings',  '•••• 4821'),
  ('🏛', 'SBI Savings',   '•••• 9933'),
  ('💳', 'ICICI Current', '•••• 7120'),
];

// ── Screen ─────────────────────────────────────────────────────────────────────
class AddTransactionsScreen extends StatefulWidget {
  const AddTransactionsScreen({Key? key}) : super(key: key);
  @override
  State<AddTransactionsScreen> createState() => _State();
}

class _State extends State<AddTransactionsScreen> {
  // Tab
  int _tab = 0; // 0=expense 1=income 2=transfer

  // Expense
  int    _expCat     = 1;
  String _expAmount  = '2,450';
  int    _expAccount = 0;
  final  _expDesc    = TextEditingController(text: 'HP Petrol Station');
  final  _expNote    = TextEditingController();
  DateTime? _expDate;

  // Income
  int    _incCat     = 0;
  String _incAmount  = '20,000';
  int    _incAccount = 0;
  bool   _recurring  = true;
  final  _incDesc    = TextEditingController(text: 'TCS Monthly Salary');
  DateTime? _incDate;

  // Transfer
  String _xfrAmount  = '15,000';
  int    _xfrFrom    = 0;
  int    _xfrTo      = 1;
  final  _xfrNote    = TextEditingController();
  DateTime? _xfrDate;

  @override
  void dispose() {
    _expDesc.dispose(); _expNote.dispose();
    _incDesc.dispose();
    _xfrNote.dispose();
    super.dispose();
  }

  // ── helpers ──────────────────────────────────────────────────────────────
  String _fmtDate(DateTime? d) {
    if (d == null) return 'Tap to select';
    const months = ['','Jan','Feb','Mar','Apr','May','Jun',
      'Jul','Aug','Sep','Oct','Nov','Dec'];
    return '${d.day} ${months[d.month]} ${d.year}';
  }

  Future<DateTime?> _pickDate(DateTime? initial) => showDatePicker(
    context: context,
    initialDate: initial ?? DateTime.now(),
    firstDate: DateTime(2020),
    lastDate: DateTime(2030),
    builder: (ctx, child) => Theme(
      data: Theme.of(ctx).copyWith(
        colorScheme: const ColorScheme.light(
          primary: AppColors.brand,
          onPrimary: Colors.white,
          surface: AppColors.card,
          onSurface: AppColors.ink,
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(foregroundColor: AppColors.brand),
        ),
      ),
      child: child!,
    ),
  );

  void _showAccountSheet({
    required String title,
    required int selected,
    required ValueChanged<int> onPick,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => _AccountSheet(
        title: title,
        selected: selected,
        onPick: (i) { onPick(i); Navigator.pop(context); },
      ),
    );
  }

  void _save() {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text('Transaction saved!'),
      backgroundColor: AppColors.green,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.all(16),
    ));
    Navigator.maybePop(context);
  }

  // ── build ────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      // Resize so keyboard doesn't hide content — scroll handles it
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        bottom: false,
        child: Column(children: [
          _header(),
          _typeToggle(),
          // Each tab is its own independently scrollable area — fixes income/transfer scroll
          Expanded(child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 220),
            switchInCurve: Curves.easeOutCubic,
            switchOutCurve: Curves.easeIn,
            transitionBuilder: (child, anim) => FadeTransition(
              opacity: CurvedAnimation(parent: anim, curve: Curves.easeOut),
              child: child,
            ),
            child: KeyedSubtree(
              key: ValueKey(_tab),
              child: ListView(
                // INCREASED BOTTOM PADDING TO CLEAR THE BOTTOM NAV BAR
                padding: const EdgeInsets.only(bottom: 120),
                physics: const BouncingScrollPhysics(),
                children: _tabContent(),
              ),
            ),
          )),
        ]),
      ),
    );
  }

  // ── Header ────────────────────────────────────────────────────────────────
  Widget _header() => Padding(
    padding: const EdgeInsets.fromLTRB(20, 16, 20, 14),
    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [
        Text('Add Entry', style: TextStyle(
          color: AppColors.ink, fontSize: 23,
          fontWeight: FontWeight.w900, letterSpacing: -0.5,
        )),
      ]),
    ]),
  );

  // ── Type Toggle ───────────────────────────────────────────────────────────
  Widget _typeToggle() {
    final tabs = [
      ('Expense', AppColors.redBg,    AppColors.red),
      ('Income',  AppColors.greenBg,  AppColors.green),
      ('Transfer',AppColors.brandPale, AppColors.brand),
    ];
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.cardBorder, width: 1.5),
        boxShadow: const [BoxShadow(
          color: Color(0x0F0D2840), blurRadius: 3, offset: Offset(0, 1),
        )],
      ),
      child: Row(children: List.generate(3, (i) {
        final sel = _tab == i;
        final (lbl, bg, fg) = tabs[i];
        return Expanded(child: GestureDetector(
          onTap: () => setState(() => _tab = i),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(vertical: 9),
            decoration: BoxDecoration(
              color: sel ? bg : Colors.transparent,
              borderRadius: BorderRadius.circular(10),
            ),
            alignment: Alignment.center,
            child: Text(lbl, style: TextStyle(
              color: sel ? fg : AppColors.inkMuted,
              fontSize: 12, fontWeight: FontWeight.w800,
            )),
          ),
        ));
      })),
    );
  }

  // ── Tab content (returns list of widgets for ListView) ────────────────────
  List<Widget> _tabContent() {
    switch (_tab) {
      case 0: return _expenseWidgets();
      case 1: return _incomeWidgets();
      case 2: return _transferWidgets();
      default: return [];
    }
  }

  // ══════════════════════════ EXPENSE ════════════════════════════════════════
  List<Widget> _expenseWidgets() => [
    _AmountHero(
      amount: _expAmount,
      gradColors: const [AppColors.brandMid, AppColors.brandDeep],
      badgeIcon: Icons.info_outline_rounded,
      badgeText: 'Transport over budget',
      badgeColor: AppColors.redLight,
      badgeBg: const Color(0x33F46C60),
      badgeBorder: const Color(0x4DF46C60),
      onChanged: (v) => setState(() => _expAmount = v),
    ),
    _sectionLabel('Category'),
    _CategoryRow(
      cats: const [
        ('🛒','Food'),('⛽','Transport'),('🏥','Health'),
        ('🎬','Fun'),('🧾','Bills'),('🛍','Shop'),
      ],
      selected: _expCat,
      onSelect: (i) => setState(() => _expCat = i),
      activeBg: AppColors.brandPale, activeBorder: AppColors.brandMid, activeFg: AppColors.brand,
    ),
    _TextField(
      label: 'Description',
      controller: _expDesc,
      hint: 'e.g. HP Petrol Station',
      icon: Icons.edit_outlined,
      multiline: true,
    ),
    _TapField(
      label: 'Account',
      value: '${_kAccounts[_expAccount].$1} ${_kAccounts[_expAccount].$2} ${_kAccounts[_expAccount].$3}',
      icon: Icons.keyboard_arrow_down_rounded,
      onTap: () => _showAccountSheet(
        title: 'Select Account',
        selected: _expAccount,
        onPick: (i) => setState(() => _expAccount = i),
      ),
    ),
    _TapField(
      label: 'Date',
      value: _expDate != null ? _fmtDate(_expDate) : 'Today',
      icon: Icons.calendar_today_rounded,
      onTap: () async {
        final d = await _pickDate(_expDate);
        if (d != null) setState(() => _expDate = d);
      },
    ),
    _TextField(
      label: 'Note',
      controller: _expNote,
      hint: 'Add a note...',
      multiline: true,
    ),
    // const _OcrBar(),
    _SaveButton(
      label: 'Save Expense',
      colors: const [AppColors.brandLight, AppColors.brandDeep],
      onTap: _save,
    ),
  ];

  // ══════════════════════════ INCOME ═════════════════════════════════════════
  List<Widget> _incomeWidgets() => [
    _AmountHero(
      amount: _incAmount,
      gradColors: const [AppColors.green, AppColors.greenDeep],
      badgeIcon: Icons.arrow_upward_rounded,
      badgeText: 'Above last month avg',
      badgeColor: AppColors.greenLight,
      badgeBg: const Color(0x3334C88A),
      badgeBorder: const Color(0x4D34C88A),
      onChanged: (v) => setState(() => _incAmount = v),
    ),
    _sectionLabel('Source'),
    _CategoryRow(
      cats: const [
        ('💼','Salary'),('💻','Freelance'),('📈','Invest'),
        ('🏠','Rental'),('🎁','Gift'),('➕','Other'),
      ],
      selected: _incCat,
      onSelect: (i) => setState(() => _incCat = i),
      activeBg: AppColors.greenBg, activeBorder: AppColors.green, activeFg: AppColors.green,
    ),
    _TextField(
      label: 'Description',
      controller: _incDesc,
      hint: 'e.g. TCS Monthly Salary',
      icon: Icons.edit_outlined,
      multiline: true,
    ),
    _TapField(
      label: 'Credited To',
      value: '${_kAccounts[_incAccount].$1} ${_kAccounts[_incAccount].$2} ${_kAccounts[_incAccount].$3}',
      icon: Icons.keyboard_arrow_down_rounded,
      onTap: () => _showAccountSheet(
        title: 'Credited To',
        selected: _incAccount,
        onPick: (i) => setState(() => _incAccount = i),
      ),
    ),
    _TapField(
      label: 'Date',
      value: _incDate != null ? _fmtDate(_incDate) : 'Mar 1, 2026',
      icon: Icons.calendar_today_rounded,
      onTap: () async {
        final d = await _pickDate(_incDate);
        if (d != null) setState(() => _incDate = d);
      },
    ),
    _RecurringToggle(
      value: _recurring,
      onChanged: (v) => setState(() => _recurring = v),
    ),
    _SaveButton(
      label: 'Save Income',
      colors: const [AppColors.green, AppColors.greenDeep],
      onTap: _save,
    ),
  ];

  // ══════════════════════════ TRANSFER ═══════════════════════════════════════
  List<Widget> _transferWidgets() => [
    _AmountHero(
      amount: _xfrAmount,
      gradColors: const [AppColors.brandLight, AppColors.brandDeep],
      badgeIcon: Icons.sync_rounded,
      badgeText: 'Between your accounts',
      badgeColor: const Color(0xD9FFFFFF),
      badgeBg: const Color(0x1FFFFFFF),
      badgeBorder: const Color(0x33FFFFFF),
      onChanged: (v) => setState(() => _xfrAmount = v),
    ),
    // FROM → TO section label
    Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
      child: Text('FROM → TO', style: const TextStyle(
        color: AppColors.inkMuted, fontSize: 11,
        fontWeight: FontWeight.w800, letterSpacing: 1.5,
      )),
    ),
    Stack(
      alignment: Alignment.center,
      children: [
        Column(
          children: [
            // From account picker
            _TapField(
              label: 'From Account',
              value: '${_kAccounts[_xfrFrom].$1} ${_kAccounts[_xfrFrom].$2} ${_kAccounts[_xfrFrom].$3}',
              icon: Icons.keyboard_arrow_down_rounded,
              onTap: () => _showAccountSheet(
                title: 'From Account',
                selected: _xfrFrom,
                onPick: (i) => setState(() => _xfrFrom = i == _xfrTo ? _xfrTo = (i + 1) % _kAccounts.length : i),
              ),
            ),
            // To account picker
            _TapField(
              label: 'To Account',
              value: '${_kAccounts[_xfrTo].$1} ${_kAccounts[_xfrTo].$2} ${_kAccounts[_xfrTo].$3}',
              icon: Icons.keyboard_arrow_down_rounded,
              highlighted: true,
              onTap: () => _showAccountSheet(
                title: 'To Account',
                selected: _xfrTo,
                onPick: (i) => setState(() => _xfrTo = i),
              ),
            ),
          ],
        ),
        // Swap arrow perfectly centered in the gap between the two fields
        Positioned(
          child: Transform.translate(
            offset: const Offset(0, -5.5), // Corrects for the bottom margin of the 'From' field
            child: GestureDetector(
              onTap: () => setState(() {
                final tmp = _xfrFrom; _xfrFrom = _xfrTo; _xfrTo = tmp;
              }),
              child: Container(
                width: 38, height: 38,
                decoration: BoxDecoration(
                  color: AppColors.brand,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.surface, width: 3), // Creates a cutout effect
                  boxShadow: [BoxShadow(
                    color: AppColors.brand.withOpacity(0.30),
                    blurRadius: 8, offset: const Offset(0, 3),
                  )],
                ),
                child: const Icon(Icons.swap_vert_rounded, color: Colors.white, size: 18),
              ),
            ),
          ),
        ),
      ],
    ),
    const SizedBox(height: 8),
    _TapField(
      label: 'Date',
      value: _xfrDate != null ? _fmtDate(_xfrDate) : 'Today',
      icon: Icons.calendar_today_rounded,
      onTap: () async {
        final d = await _pickDate(_xfrDate);
        if (d != null) setState(() => _xfrDate = d);
      },
    ),
    _TextField(
      label: 'Note',
      controller: _xfrNote,
      hint: 'Add a note...',
      multiline: true,
    ),
    _SaveButton(
      label: 'Transfer ₹$_xfrAmount',
      colors: const [AppColors.brandLight, AppColors.brandDeep],
      onTap: _save,
    ),
  ];

  Widget _sectionLabel(String t) => Padding(
    padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
    child: Text(t.toUpperCase(), style: const TextStyle(
      color: AppColors.inkMuted, fontSize: 11,
      fontWeight: FontWeight.w800, letterSpacing: 1.5,
    )),
  );
}

// ── Amount Hero ────────────────────────────────────────────────────────────────
class _AmountHero extends StatefulWidget {
  final String amount;
  final List<Color> gradColors;
  final IconData badgeIcon;
  final String badgeText;
  final Color badgeColor, badgeBg, badgeBorder;
  final ValueChanged<String> onChanged;

  const _AmountHero({
    required this.amount, required this.gradColors,
    required this.badgeIcon, required this.badgeText,
    required this.badgeColor, required this.badgeBg, required this.badgeBorder,
    required this.onChanged,
  });

  @override
  State<_AmountHero> createState() => _AmountHeroState();
}

class _AmountHeroState extends State<_AmountHero> {
  late final TextEditingController _ctrl;
  late final FocusNode _focus;

  @override
  void initState() {
    super.initState();
    _ctrl = TextEditingController(text: widget.amount);
    _focus = FocusNode();
  }

  @override
  void didUpdateWidget(_AmountHero old) {
    super.didUpdateWidget(old);
    if (old.amount != widget.amount && !_focus.hasFocus) {
      _ctrl.text = widget.amount;
    }
  }

  @override
  void dispose() { _ctrl.dispose(); _focus.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(
          color: widget.gradColors.last.withOpacity(0.38),
          blurRadius: 28, offset: const Offset(0, 10),
        )],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Container(
          padding: const EdgeInsets.fromLTRB(24, 26, 24, 22),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: widget.gradColors,
              begin: Alignment.topLeft, end: Alignment.bottomRight,
            ),
          ),
          child: Stack(children: [
            Positioned(top: -50, right: -50, child: Container(
              width: 150, height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(colors: [
                  Colors.white.withOpacity(0.08), Colors.transparent,
                ], stops: const [0.0, 0.7]),
              ),
            )),
            Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
              Text('AMOUNT', style: TextStyle(
                color: Colors.white.withOpacity(0.5),
                fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 2,
              )),
              const SizedBox(height: 8),
              // Tappable amount row with inline TextField
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text('₹', style: TextStyle(
                    color: Colors.white.withOpacity(0.5),
                    fontSize: 28, fontWeight: FontWeight.w600,
                  )),
                  IntrinsicWidth(
                    child: TextField(
                      controller: _ctrl,
                      focusNode: _focus,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white, fontSize: 52,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -3.0, height: 1.0,
                      ),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        filled: false,
                        fillColor: Colors.transparent,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[\d,.]')),
                      ],
                      onChanged: widget.onChanged,
                    ),
                  ),
                  _BlinkingCursor(),
                ],
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: widget.badgeBg,
                  border: Border.all(color: widget.badgeBorder),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  Icon(widget.badgeIcon, color: widget.badgeColor, size: 11),
                  const SizedBox(width: 5),
                  Text(widget.badgeText, style: TextStyle(
                    color: widget.badgeColor, fontSize: 10, fontWeight: FontWeight.w700,
                  )),
                ]),
              ),
            ]),
          ]),
        ),
      ),
    );
  }
}

// ── Category Row ───────────────────────────────────────────────────────────────
class _CategoryRow extends StatelessWidget {
  final List<(String, String)> cats;
  final int selected;
  final ValueChanged<int> onSelect;
  final Color activeBg, activeBorder, activeFg;

  const _CategoryRow({
    required this.cats, required this.selected, required this.onSelect,
    required this.activeBg, required this.activeBorder, required this.activeFg,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 18),
      child: Row(children: List.generate(cats.length, (i) {
        final sel = i == selected;
        final (ico, name) = cats[i];
        return GestureDetector(
          onTap: () => onSelect(i),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            margin: const EdgeInsets.only(right: 9),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
            decoration: BoxDecoration(
              color: sel ? activeBg : AppColors.card,
              border: Border.all(
                color: sel ? activeBorder : AppColors.cardBorder, width: 1.5,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: sel ? null : const [BoxShadow(
                color: Color(0x0F0D2840), blurRadius: 3, offset: Offset(0, 1),
              )],
            ),
            child: Column(children: [
              Text(ico, style: const TextStyle(fontSize: 22)),
              const SizedBox(height: 5),
              Text(name, style: TextStyle(
                color: sel ? activeFg : AppColors.inkSoft,
                fontSize: 10, fontWeight: FontWeight.w700,
              )),
            ]),
          ),
        );
      })),
    );
  }
}

// ── Multiline text field ───────────────────────────────────────────────────────
class _TextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String? hint;
  final IconData? icon;
  final bool multiline;

  const _TextField({
    required this.label,
    required this.controller,
    this.hint,
    this.icon,
    this.multiline = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 11),
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      decoration: BoxDecoration(
        color: AppColors.card,
        border: Border.all(color: AppColors.cardBorder, width: 1.5),
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [BoxShadow(
          color: Color(0x0F0D2840), blurRadius: 3, offset: Offset(0, 1),
        )],
      ),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Expanded(child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label.toUpperCase(), style: const TextStyle(
              color: AppColors.inkMuted, fontSize: 10,
              fontWeight: FontWeight.w700, letterSpacing: 0.5,
            )),
            const SizedBox(height: 4),
            TextField(
              controller: controller,
              minLines: 1,
              maxLines: multiline ? 4 : 1,
              style: const TextStyle(
                color: AppColors.ink, fontSize: 13, fontWeight: FontWeight.w600,
                height: 1.5,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                filled: false,
                fillColor: Colors.transparent,
                isDense: true,
                contentPadding: EdgeInsets.zero,
                hintText: hint,
                hintStyle: const TextStyle(
                  color: AppColors.inkFaint, fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        )),
        if (icon != null) ...[
          const SizedBox(width: 8),
          Padding(
            padding: const EdgeInsets.only(top: 18),
            child: Icon(icon, size: 16, color: AppColors.inkMuted),
          ),
        ],
      ]),
    );
  }
}

// ── Tap field (date / account — read-only, opens picker on tap) ───────────────
class _TapField extends StatelessWidget {
  final String label, value;
  final IconData icon;
  final VoidCallback onTap;
  final bool highlighted;

  const _TapField({
    required this.label,
    required this.value,
    required this.icon,
    required this.onTap,
    this.highlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.fromLTRB(20, 0, 20, 11),
        padding: const EdgeInsets.fromLTRB(16, 13, 16, 13),
        decoration: BoxDecoration(
          color: highlighted ? AppColors.brandPale : AppColors.card,
          border: Border.all(
            color: highlighted ? AppColors.brandMid : AppColors.cardBorder, width: 1.5,
          ),
          borderRadius: BorderRadius.circular(15),
          boxShadow: highlighted
              ? [BoxShadow(color: AppColors.brand.withOpacity(0.07), blurRadius: 0, spreadRadius: 3)]
              : const [BoxShadow(color: Color(0x0F0D2840), blurRadius: 3, offset: Offset(0, 1))],
        ),
        child: Row(children: [
          Expanded(child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label.toUpperCase(), style: const TextStyle(
                color: AppColors.inkMuted, fontSize: 10,
                fontWeight: FontWeight.w700, letterSpacing: 0.5,
              )),
              const SizedBox(height: 4),
              Text(value, style: TextStyle(
                color: highlighted ? AppColors.brand : AppColors.ink,
                fontSize: 13, fontWeight: FontWeight.w700,
              )),
            ],
          )),
          Icon(icon, size: icon == Icons.calendar_today_rounded ? 16 : 20,
              color: AppColors.inkMuted),
        ]),
      ),
    );
  }
}

// ── Account picker bottom sheet ────────────────────────────────────────────────
class _AccountSheet extends StatelessWidget {
  final String title;
  final int selected;
  final ValueChanged<int> onPick;

  const _AccountSheet({
    required this.title, required this.selected, required this.onPick,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.fromLTRB(
        20, 16, 20, MediaQuery.of(context).viewInsets.bottom + 36,
      ),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Container(
          width: 36, height: 4,
          margin: const EdgeInsets.only(bottom: 18),
          decoration: BoxDecoration(
            color: AppColors.inkFaint, borderRadius: BorderRadius.circular(2),
          ),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(title, style: const TextStyle(
            color: AppColors.ink, fontSize: 15, fontWeight: FontWeight.w800,
          )),
        ),
        const SizedBox(height: 16),
        ...List.generate(_kAccounts.length, (i) {
          final (emoji, name, num) = _kAccounts[i];
          final sel = i == selected;
          return GestureDetector(
            onTap: () => onPick(i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 160),
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: sel ? AppColors.brandPale : AppColors.surface,
                border: Border.all(
                  color: sel ? AppColors.brandMid : AppColors.cardBorder, width: 1.5,
                ),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(children: [
                Container(
                  width: 38, height: 38,
                  decoration: BoxDecoration(
                    color: sel ? AppColors.brandPale : AppColors.card,
                    borderRadius: BorderRadius.circular(11),
                    border: Border.all(color: AppColors.cardBorder),
                  ),
                  alignment: Alignment.center,
                  child: Text(emoji, style: const TextStyle(fontSize: 18)),
                ),
                const SizedBox(width: 12),
                Expanded(child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: TextStyle(
                      color: sel ? AppColors.brand : AppColors.ink,
                      fontSize: 13, fontWeight: FontWeight.w800,
                    )),
                    const SizedBox(height: 2),
                    Text(num, style: const TextStyle(
                      color: AppColors.inkMuted, fontSize: 11, fontWeight: FontWeight.w500,
                    )),
                  ],
                )),
                if (sel) const Icon(Icons.check_circle_rounded,
                    color: AppColors.brand, size: 20),
              ]),
            ),
          );
        }),
      ]),
    );
  }
}

// ── OCR Bar ────────────────────────────────────────────────────────────────────
class _OcrBar extends StatelessWidget {
  const _OcrBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 5, 20, 14),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 11),
      decoration: BoxDecoration(
        color: AppColors.greenBg,
        border: Border.all(color: AppColors.greenBorder, width: 1.5),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(
          color: AppColors.green.withOpacity(0.08),
          blurRadius: 8, offset: const Offset(0, 2),
        )],
      ),
      child: Row(children: [
        const Text('📷', style: TextStyle(fontSize: 20)),
        const SizedBox(width: 10),
        Expanded(child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Scan Receipt with OCR', style: TextStyle(
              color: AppColors.green, fontSize: 12, fontWeight: FontWeight.w800,
            )),
            const SizedBox(height: 2),
            Text('Auto-fill from photo', style: TextStyle(
              color: AppColors.green.withOpacity(0.7),
              fontSize: 11, fontWeight: FontWeight.w500,
            )),
          ],
        )),
        Container(
          width: 30, height: 30,
          decoration: BoxDecoration(
            color: AppColors.green.withOpacity(0.12),
            borderRadius: BorderRadius.circular(9),
          ),
          child: const Icon(Icons.arrow_forward_ios_rounded,
              color: AppColors.green, size: 13),
        ),
      ]),
    );
  }
}

// ── Recurring Toggle ───────────────────────────────────────────────────────────
class _RecurringToggle extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  const _RecurringToggle({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 11),
      padding: const EdgeInsets.fromLTRB(16, 13, 14, 13),
      decoration: BoxDecoration(
        color: AppColors.greenBg,
        border: Border.all(color: AppColors.greenBorder, width: 1.5),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(children: [
        const Text('🔁', style: TextStyle(fontSize: 18)),
        const SizedBox(width: 10),
        Expanded(child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Set as Recurring', style: TextStyle(
              color: AppColors.green, fontSize: 13, fontWeight: FontWeight.w800,
            )),
            const SizedBox(height: 2),
            Text('Auto-log monthly on same date', style: TextStyle(
              color: AppColors.green.withOpacity(0.7),
              fontSize: 11, fontWeight: FontWeight.w500,
            )),
          ],
        )),
        // Custom pill toggle — matches HTML design exactly
        GestureDetector(
          onTap: () => onChanged(!value),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 44, height: 24,
            decoration: BoxDecoration(
              color: value ? AppColors.green : AppColors.inkFaint,
              borderRadius: BorderRadius.circular(12),
            ),
            child: AnimatedAlign(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
              alignment: value ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(
                margin: const EdgeInsets.all(3),
                width: 18, height: 18,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [BoxShadow(
                    color: Color(0x22000000),
                    blurRadius: 4, offset: Offset(0, 1),
                  )],
                ),
              ),
            ),
          ),
        ),
      ]),
    );
  }
}

// ── Save / Primary Button ──────────────────────────────────────────────────────
class _SaveButton extends StatelessWidget {
  final String label;
  final List<Color> colors;
  final VoidCallback onTap;

  const _SaveButton({
    required this.label, required this.colors, required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 4, 20, 6),
      height: 56,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: colors,
          begin: Alignment.topLeft, end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(17),
        boxShadow: [
          BoxShadow(
            color: colors.last.withOpacity(0.35),
            blurRadius: 24, offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: colors.last.withOpacity(0.18),
            blurRadius: 6, offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(17),
          splashColor: Colors.white.withOpacity(0.12),
          onTap: onTap,
          child: Center(child: Text(label, style: const TextStyle(
            color: Colors.white, fontSize: 15,
            fontWeight: FontWeight.w900, letterSpacing: -0.2,
          ))),
        ),
      ),
    );
  }
}

// ── Blinking Cursor ────────────────────────────────────────────────────────────
class _BlinkingCursor extends StatefulWidget {
  @override
  State<_BlinkingCursor> createState() => _BlinkingCursorState();
}

class _BlinkingCursorState extends State<_BlinkingCursor>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 500),
    )..repeat(reverse: true);
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) => FadeTransition(
    opacity: _ctrl,
    child: Container(
      margin: const EdgeInsets.only(left: 3),
      width: 2.5, height: 46,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.75),
        borderRadius: BorderRadius.circular(1.5),
      ),
    ),
  );
}