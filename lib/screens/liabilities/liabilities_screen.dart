import 'package:fiservtrack/loan_types/loan_types_provider.dart';
import 'package:fiservtrack/themes/app_color.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../loan_types/loan_types_model.dart';

// ── Models ─────────────────────────────────────────────────────────────────────
class _LoanData {
  final String emoji, title, bank, outstanding, emi, paid, ends;
  final Color emojiBg, paidColor;
  final List<Color> barColors;
  final double progress;
  final double outstandingAmount;
  final double emiAmount;

  const _LoanData({
    required this.emoji,
    required this.emojiBg,
    required this.title,
    required this.bank,
    required this.outstanding,
    required this.emi,
    required this.paid,
    required this.ends,
    required this.paidColor,
    required this.barColors,
    required this.progress,
    required this.outstandingAmount,
    required this.emiAmount,
  });
}

class _CardData {
  final String name, number, limit, used, usedPct, dueDate, minDue, rewards;
  final double usageFactor;
  final double limitAmount;
  final double usedAmount;

  const _CardData({
    required this.name,
    required this.number,
    required this.limit,
    required this.used,
    required this.usedPct,
    required this.dueDate,
    required this.minDue,
    required this.rewards,
    required this.usageFactor,
    required this.limitAmount,
    required this.usedAmount,
  });
}

// ── Helpers ────────────────────────────────────────────────────────────────────
String _formatCurrency(double amount) {
  final String digits = amount.toInt().toString();
  if (digits.length <= 3) return '₹$digits';

  final String lastThree = digits.substring(digits.length - 3);
  final String remaining = digits.substring(0, digits.length - 3);

  final List<String> chunks = [];
  int i = remaining.length;
  while (i > 0) {
    if (i >= 2) {
      chunks.insert(0, remaining.substring(i - 2, i));
      i -= 2;
    } else {
      chunks.insert(0, remaining.substring(0, i));
      i = 0;
    }
  }

  return '₹${chunks.join(',')},$lastThree';
}

InputDecoration _inputDeco(String label, String hint) {
  return InputDecoration(
    labelText: label,
    hintText: hint,
    labelStyle: const TextStyle(
      color: AppColors.inkSoft,
      fontSize: 10,
      fontWeight: FontWeight.w800,
      letterSpacing: 0.5,
    ),
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

// ── Screen ─────────────────────────────────────────────────────────────────────
class LiabilitiesScreen extends StatefulWidget {
  const LiabilitiesScreen({Key? key}) : super(key: key);

  @override
  State<LiabilitiesScreen> createState() => _LiabilitiesScreenState();
}

class _LiabilitiesScreenState extends State<LiabilitiesScreen> {
  final List<_LoanData> _loans = [
    const _LoanData(
      emoji: '🚗',
      emojiBg: AppColors.greenBg,
      title: 'Car Loan',
      bank: 'HDFC Bank · Fixed 8.5%',
      outstanding: '₹6,40,000',
      emi: '₹12,400',
      paid: '48%',
      ends: 'Sep 2028',
      paidColor: AppColors.green,
      barColors: [AppColors.greenLight, AppColors.green],
      progress: 0.48,
      outstandingAmount: 640000.0,
      emiAmount: 12400.0,
    ),
    const _LoanData(
      emoji: '🏠',
      emojiBg: AppColors.goldBg,
      title: 'Home Loan',
      bank: 'SBI · Floating 8.9%',
      outstanding: '₹11,20,000',
      emi: '₹15,800',
      paid: '22%',
      ends: 'Jan 2041',
      paidColor: AppColors.gold,
      barColors: [AppColors.goldLight, AppColors.gold],
      progress: 0.22,
      outstandingAmount: 1120000.0,
      emiAmount: 15800.0,
    ),
  ];

  final List<_CardData> _cards = [
    const _CardData(
      name: 'HDFC Regalia',
      number: '•••• •••• •••• 4821',
      limit: '₹3,00,000',
      used: '₹48,200',
      usedPct: '(16%)',
      dueDate: 'Mar 15',
      minDue: '₹2,400',
      rewards: '4,820 pts',
      usageFactor: 0.16,
      limitAmount: 300000.0,
      usedAmount: 48200.0,
    ),
    const _CardData(
      name: 'SBI SimplyCLICK',
      number: '•••• •••• •••• 7291',
      limit: '₹2,00,000',
      used: '₹38,500',
      usedPct: '(19%)',
      dueDate: 'Mar 25',
      minDue: '₹1,925',
      rewards: '2,140 pts',
      usageFactor: 0.19,
      limitAmount: 200000.0,
      usedAmount: 38500.0,
    ),
  ];

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      Provider.of<LoanTypesProvider>(context, listen: false).getLoanTypes();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Calculate dynamic totals
    double totalOutstanding = 0;
    for (final l in _loans) {
      totalOutstanding += l.outstandingAmount;
    }
    for (final c in _cards) {
      totalOutstanding += c.usedAmount;
    }

    double totalEMI = 0;
    for (final l in _loans) {
      totalEMI += l.emiAmount;
    }

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _Header(
            activeLoansCount: _loans.length,
            creditCardsCount: _cards.length,
          ),
          Expanded(
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              padding: const EdgeInsets.only(bottom: 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 16),
                  _TotalCard(
                    totalOutstanding: _formatCurrency(totalOutstanding),
                    monthlyEMI: _formatCurrency(totalEMI),
                    debtToIncomeRatio: '27.1%',
                  ),
                  _SectionHeader(
                    title: 'Active Loans',
                    action: '+ Add Loan',
                    onActionTap: () => _showAddLoanSheet(context),
                  ),
                  for (final l in _loans) _LoanCard(data: l),
                  _SectionHeader(
                    title: 'Credit Cards',
                    action: '+ Add Card',
                    onActionTap: () => _showAddCardSheet(context),
                  ),
                  for (final c in _cards) _CCCard(data: c),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddLoanSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return _AddLoanBottomSheet(
          onLoanAdded: (newLoan) {
            setState(() {
              _loans.add(newLoan);
            });
          },
        );
      },
    );
  }

  void _showAddCardSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return _AddCardBottomSheet(
          onCardAdded: (newCard) {
            setState(() {
              _cards.add(newCard);
            });
          },
        );
      },
    );
  }
}

// ── ADD LOAN BOTTOM SHEET WIDGET ──────────────────────────────────────────────
class _AddLoanBottomSheet extends StatefulWidget {
  final Function(_LoanData) onLoanAdded;

  const _AddLoanBottomSheet({Key? key, required this.onLoanAdded})
    : super(key: key);

  @override
  State<_AddLoanBottomSheet> createState() => _AddLoanBottomSheetState();
}

class _AddLoanBottomSheetState extends State<_AddLoanBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final _titleCtrl = TextEditingController();
  final _bankCtrl = TextEditingController();
  final _outstandingCtrl = TextEditingController();
  final _emiCtrl = TextEditingController();
  final _endsCtrl = TextEditingController();

  // String _selectedCategory = '🚗';
  LoanTypesModel? _selectedCategory;
  double _paidPercent = 0.0;

  @override
  void dispose() {
    _titleCtrl.dispose();
    _bankCtrl.dispose();
    _outstandingCtrl.dispose();
    _emiCtrl.dispose();
    _endsCtrl.dispose();
    super.dispose();
  }

  String getCategoryIcon(String? name) {
    switch (name?.toLowerCase()) {
      case "car":
        return "🚗";
      case "home":
        return "🏠";
      case "study":
      case "education":
        return "🎓";
      case "personal":
        return "🛍";
      default:
        return "📄";
    }
  }

  Widget _categoryOption(LoanTypesModel category) {
    final isSel = _selectedCategory?.id == category.id;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedCategory = category;
        });
      },
      child: Column(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: isSel ? AppColors.brandPale : AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSel ? AppColors.brandMid : AppColors.cardBorder,
                width: 2,
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              getCategoryIcon(category.name),
              style: const TextStyle(fontSize: 22),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            category.name ?? "",
            style: TextStyle(
              fontSize: 10,
              fontWeight: isSel ? FontWeight.w800 : FontWeight.w500,
              color: isSel ? AppColors.brandMid : AppColors.inkSoft,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Form(
            key: _formKey,
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
                      color: AppColors.cardBorder,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const Text(
                  "Add New Loan Account",
                  style: TextStyle(
                    color: AppColors.ink,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),

                // Category Selection
                Consumer<LoanTypesProvider>(
                  builder: (context, provider, child) {
                    return Wrap(
                      spacing: 20,
                      runSpacing: 12,
                      alignment: WrapAlignment.center,
                      children: provider.loanTypes
                          .map((category) => _categoryOption(category))
                          .toList(),
                    );
                  },
                ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                //   children: [
                //     _categoryOption('🚗', 'Car'),
                //     _categoryOption('🏠', 'Home'),
                //     _categoryOption('🎓', 'Study'),
                //     _categoryOption('🛍', 'Personal'),
                //   ],
                // ),
                const SizedBox(height: 24),

                // Form Inputs
                TextFormField(
                  controller: _titleCtrl,
                  textCapitalization: TextCapitalization.words,
                  decoration: _inputDeco(
                    "LOAN NAME",
                    "e.g. Car Loan, Education Loan",
                  ),
                  validator: (val) => val == null || val.trim().isEmpty
                      ? "Name is required"
                      : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _bankCtrl,
                  textCapitalization: TextCapitalization.words,
                  decoration: _inputDeco(
                    "LENDER / BANK",
                    "e.g. HDFC Bank, SBI",
                  ),
                  validator: (val) => val == null || val.trim().isEmpty
                      ? "Bank is required"
                      : null,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _outstandingCtrl,
                        keyboardType: TextInputType.number,
                        decoration: _inputDeco("OUTSTANDING", "e.g. 500000"),
                        validator: (val) {
                          if (val == null || val.trim().isEmpty)
                            return "Required";
                          if (double.tryParse(val) == null) return "Invalid";
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        controller: _emiCtrl,
                        keyboardType: TextInputType.number,
                        decoration: _inputDeco("MONTHLY EMI", "e.g. 12400"),
                        validator: (val) {
                          if (val == null || val.trim().isEmpty)
                            return "Required";
                          if (double.tryParse(val) == null) return "Invalid";
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _endsCtrl,
                  decoration: _inputDeco("PAYOFF DATE", "e.g. Sep 2028"),
                  validator: (val) => val == null || val.trim().isEmpty
                      ? "Payoff date is required"
                      : null,
                ),
                const SizedBox(height: 20),

                // Slider progress
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "PAID PROGRESS",
                          style: TextStyle(
                            color: AppColors.inkSoft,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                          ),
                        ),
                        Text(
                          "${_paidPercent.toInt()}%",
                          style: const TextStyle(
                            color: AppColors.brandMid,
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                    Slider(
                      value: _paidPercent,
                      min: 0,
                      max: 100,
                      activeColor: AppColors.brandMid,
                      inactiveColor: AppColors.cardBorder,
                      onChanged: (val) {
                        setState(() {
                          _paidPercent = val;
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                ElevatedButton(
                  onPressed: () {
                    if (!_formKey.currentState!.validate()) return;

                    final outstanding = double.parse(_outstandingCtrl.text);
                    final emi = double.parse(_emiCtrl.text);

                    // Determine colors and layout values based on Category
                    Color emojiBg;
                    Color paidColor;
                    List<Color> barColors;

                    switch (_selectedCategory) {
                      case '🏠':
                        emojiBg = AppColors.goldBg;
                        paidColor = AppColors.gold;
                        barColors = [AppColors.goldLight, AppColors.gold];
                        break;
                      case '🎓':
                        emojiBg = AppColors.brandPale;
                        paidColor = AppColors.brand;
                        barColors = [AppColors.brandLight, AppColors.brand];
                        break;
                      case '🛍':
                        emojiBg = AppColors.redBg;
                        paidColor = AppColors.red;
                        barColors = [AppColors.redLight, AppColors.red];
                        break;
                      case '🚗':
                      default:
                        emojiBg = AppColors.greenBg;
                        paidColor = AppColors.green;
                        barColors = [AppColors.greenLight, AppColors.green];
                        break;
                    }

                    widget.onLoanAdded(
                      _LoanData(
                        emoji: _selectedCategory!.name ?? "",
                        emojiBg: emojiBg,
                        title: _titleCtrl.text,
                        bank: "${_bankCtrl.text} · Active",
                        outstanding: _formatCurrency(outstanding),
                        emi: _formatCurrency(emi),
                        paid: "${_paidPercent.toInt()}%",
                        ends: _endsCtrl.text,
                        paidColor: paidColor,
                        barColors: barColors,
                        progress: _paidPercent / 100.0,
                        outstandingAmount: outstanding,
                        emiAmount: emi,
                      ),
                    );

                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("New loan successfully added!"),
                        backgroundColor: AppColors.green,
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.brand,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Add Loan Account",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
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

// ── ADD CARD BOTTOM SHEET WIDGET ──────────────────────────────────────────────
class _AddCardBottomSheet extends StatefulWidget {
  final Function(_CardData) onCardAdded;

  const _AddCardBottomSheet({Key? key, required this.onCardAdded})
    : super(key: key);

  @override
  State<_AddCardBottomSheet> createState() => _AddCardBottomSheetState();
}

class _AddCardBottomSheetState extends State<_AddCardBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _numberCtrl = TextEditingController();
  final _limitCtrl = TextEditingController();
  final _usedCtrl = TextEditingController();
  final _dueDateCtrl = TextEditingController();
  final _minDueCtrl = TextEditingController();
  final _rewardsCtrl = TextEditingController();

  @override
  void dispose() {
    _nameCtrl.dispose();
    _numberCtrl.dispose();
    _limitCtrl.dispose();
    _usedCtrl.dispose();
    _dueDateCtrl.dispose();
    _minDueCtrl.dispose();
    _rewardsCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Form(
            key: _formKey,
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
                      color: AppColors.cardBorder,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const Text(
                  "Add New Credit Card",
                  style: TextStyle(
                    color: AppColors.ink,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),

                // Inputs
                TextFormField(
                  controller: _nameCtrl,
                  textCapitalization: TextCapitalization.words,
                  decoration: _inputDeco(
                    "CARD NAME / BANK",
                    "e.g. HDFC Regalia, ICICI Rubyx",
                  ),
                  validator: (val) => val == null || val.trim().isEmpty
                      ? "Card Name is required"
                      : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _numberCtrl,
                  keyboardType: TextInputType.number,
                  maxLength: 4,
                  decoration: _inputDeco("LAST 4 DIGITS", "e.g. 1234"),
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) return "Required";
                    if (val.length != 4 || int.tryParse(val) == null)
                      return "Must be exactly 4 digits";
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _limitCtrl,
                        keyboardType: TextInputType.number,
                        decoration: _inputDeco("LIMIT", "e.g. 300000"),
                        validator: (val) {
                          if (val == null || val.trim().isEmpty)
                            return "Required";
                          if (double.tryParse(val) == null) return "Invalid";
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        controller: _usedCtrl,
                        keyboardType: TextInputType.number,
                        decoration: _inputDeco("AMOUNT USED", "e.g. 48200"),
                        validator: (val) {
                          if (val == null || val.trim().isEmpty)
                            return "Required";
                          final amt = double.tryParse(val);
                          if (amt == null) return "Invalid";
                          if (_limitCtrl.text.isNotEmpty) {
                            final lim = double.tryParse(_limitCtrl.text) ?? 0.0;
                            if (amt > lim) return "Cannot exceed limit";
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _dueDateCtrl,
                        decoration: _inputDeco("DUE DATE", "e.g. Mar 15"),
                        validator: (val) => val == null || val.trim().isEmpty
                            ? "Required"
                            : null,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        controller: _minDueCtrl,
                        keyboardType: TextInputType.number,
                        decoration: _inputDeco("MIN DUE", "e.g. 2400"),
                        validator: (val) {
                          if (val == null || val.trim().isEmpty)
                            return "Required";
                          if (double.tryParse(val) == null) return "Invalid";
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _rewardsCtrl,
                  decoration: _inputDeco(
                    "REWARDS POINTS",
                    "e.g. 4820 (optional)",
                  ),
                ),
                const SizedBox(height: 24),

                ElevatedButton(
                  onPressed: () {
                    if (!_formKey.currentState!.validate()) return;

                    final limit = double.parse(_limitCtrl.text);
                    final used = double.parse(_usedCtrl.text);
                    final minDue = double.parse(_minDueCtrl.text);

                    final double usageFactor = limit > 0 ? used / limit : 0.0;
                    final String usedPct =
                        "(${((used / limit) * 100).toInt()}%)";
                    final String rewards = _rewardsCtrl.text.trim().isNotEmpty
                        ? "${_rewardsCtrl.text.replaceAll(RegExp(r'[^0-9]'), '')} pts"
                        : "0 pts";

                    widget.onCardAdded(
                      _CardData(
                        name: _nameCtrl.text,
                        number: "•••• •••• •••• ${_numberCtrl.text}",
                        limit: _formatCurrency(limit),
                        used: _formatCurrency(used),
                        usedPct: usedPct,
                        dueDate: _dueDateCtrl.text,
                        minDue: _formatCurrency(minDue),
                        rewards: rewards,
                        usageFactor: usageFactor,
                        limitAmount: limit,
                        usedAmount: used,
                      ),
                    );

                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("New credit card successfully added!"),
                        backgroundColor: AppColors.green,
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.brand,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Add Credit Card",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
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

// ── Header ─────────────────────────────────────────────────────────────────────
class _Header extends StatelessWidget {
  final int activeLoansCount;
  final int creditCardsCount;

  const _Header({
    required this.activeLoansCount,
    required this.creditCardsCount,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(32),
        bottomRight: Radius.circular(32),
      ),
      child: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.brandMid, AppColors.brandDeep],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          children: [
            // Decorative radial glow
            Positioned(
              top: -70,
              right: -50,
              child: Container(
                width: size.width * 0.5,
                height: size.width * 0.5,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      Colors.white.withOpacity(0.08),
                      Colors.transparent,
                    ],
                    stops: const [0.0, 0.7],
                  ),
                ),
              ),
            ),
            SafeArea(
              bottom: false,
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  20,
                  size.height * 0.02,
                  20,
                  size.height * 0.03,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Liabilities',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: size.height * 0.028,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$activeLoansCount active loans · $creditCardsCount credit cards',
                      style: TextStyle(
                        color: Colors.white54,
                        fontSize: size.height * 0.015,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Total Outstanding card ─────────────────────────────────────────────────────
class _TotalCard extends StatelessWidget {
  final String totalOutstanding;
  final String monthlyEMI;
  final String debtToIncomeRatio;

  const _TotalCard({
    required this.totalOutstanding,
    required this.monthlyEMI,
    required this.debtToIncomeRatio,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: EdgeInsets.fromLTRB(
        20,
        size.height * 0.02,
        20,
        size.height * 0.02,
      ),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.cardBorder, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: AppColors.ink.withOpacity(0.07),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'TOTAL OUTSTANDING',
            style: TextStyle(
              color: AppColors.inkMuted,
              fontSize: size.height * 0.013,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 6),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              totalOutstanding,
              style: TextStyle(
                color: AppColors.ink,
                fontSize: size.height * 0.04,
                fontWeight: FontWeight.w900,
                letterSpacing: -1.5,
              ),
            ),
          ),
          SizedBox(height: size.height * 0.02),
          Container(height: 1, color: AppColors.divider),
          SizedBox(height: size.height * 0.02),
          IntrinsicHeight(
            child: Row(
              children: [
                _TotalStat(
                  label: 'Monthly EMI',
                  value: monthlyEMI,
                  color: AppColors.ink,
                ),
                _VSep(),
                _TotalStat(
                  label: 'Debt / Income',
                  value: debtToIncomeRatio,
                  color: AppColors.gold,
                ),
                _VSep(),
                const _TotalStat(
                  label: 'Avg Payoff',
                  value: '38 mo',
                  color: AppColors.ink,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TotalStat extends StatelessWidget {
  final String label, value;
  final Color color;
  const _TotalStat({
    required this.label,
    required this.value,
    required this.color,
  });
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: AppColors.inkMuted,
              fontSize: size.height * 0.012,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              value,
              style: TextStyle(
                color: color,
                fontSize: size.height * 0.018,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _VSep extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
    width: 1,
    margin: const EdgeInsets.symmetric(horizontal: 12),
    color: AppColors.divider,
  );
}

// ── Section header ─────────────────────────────────────────────────────────────
class _SectionHeader extends StatelessWidget {
  final String title, action;
  final VoidCallback onActionTap;

  const _SectionHeader({
    required this.title,
    required this.action,
    required this.onActionTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: AppColors.ink,
              fontSize: 16,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.3,
            ),
          ),
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(10),
              onTap: onActionTap,
              child: Ink(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.brandPale,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: const Color(0xFFB8D0EC),
                    width: 1.5,
                  ),
                ),
                child: Text(
                  action,
                  style: const TextStyle(
                    color: AppColors.brandMid,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Loan card ──────────────────────────────────────────────────────────────────
class _LoanCard extends StatelessWidget {
  final _LoanData data;
  const _LoanCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, bottom: 12),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.cardBorder, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: AppColors.ink.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // ── Top row ──
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: data.emojiBg,
                  borderRadius: BorderRadius.circular(14),
                ),
                alignment: Alignment.center,
                child: Text(
                  data.emoji,
                  style: const TextStyle(
                    fontSize: 22,
                    fontFamilyFallback: [
                      'Apple Color Emoji',
                      'Noto Color Emoji',
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data.title,
                      style: const TextStyle(
                        color: AppColors.ink,
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      data.bank,
                      style: const TextStyle(
                        color: AppColors.inkSoft,
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    data.outstanding,
                    style: const TextStyle(
                      color: AppColors.ink,
                      fontSize: 15,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.4,
                    ),
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    'outstanding',
                    style: TextStyle(
                      color: AppColors.inkMuted,
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 16),

          // ── Progress bar ──
          ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: Container(
              height: 6,
              width: double.infinity,
              color: AppColors.divider,
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: data.progress,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: data.barColors),
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // ── Footer row ──
          Row(
            children: [
              _Stat(
                label: 'Monthly EMI',
                value: data.emi,
                color: AppColors.ink,
                align: CrossAxisAlignment.start,
              ),
              _Stat(
                label: 'Paid',
                value: data.paid,
                color: data.paidColor,
                align: CrossAxisAlignment.center,
              ),
              _Stat(
                label: 'Ends',
                value: data.ends,
                color: AppColors.ink,
                align: CrossAxisAlignment.end,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  final String label, value;
  final Color color;
  final CrossAxisAlignment align;
  const _Stat({
    required this.label,
    required this.value,
    required this.color,
    required this.align,
  });
  @override
  Widget build(BuildContext context) => Expanded(
    child: Column(
      crossAxisAlignment: align,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppColors.inkMuted,
            fontSize: 10,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 13,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    ),
  );
}

// ── Credit card ────────────────────────────────────────────────────────────────
class _CCCard extends StatelessWidget {
  final _CardData data;
  const _CCCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(22),
      child: Container(
        margin: const EdgeInsets.only(left: 20, right: 20, bottom: 12),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              AppColors.brandDeep,
              AppColors.brandMid,
              AppColors.brandLight,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: AppColors.brand.withOpacity(0.30),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Glow top-right
            Positioned(
              top: -45,
              right: -45,
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      Colors.white.withOpacity(0.10),
                      Colors.transparent,
                    ],
                    stops: const [0.0, 0.7],
                  ),
                ),
              ),
            ),
            // Glow bottom-left
            Positioned(
              bottom: -35,
              left: -25,
              child: Container(
                width: 110,
                height: 110,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      const Color(0xFF2471C8).withOpacity(0.28),
                      Colors.transparent,
                    ],
                    stops: const [0.0, 0.7],
                  ),
                ),
              ),
            ),

            // ── Content ──
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name + chip
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            data.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            data.number,
                            style: const TextStyle(
                              color: Colors.white54,
                              fontSize: 11,
                              letterSpacing: 2.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Gold EMV chip rectangle
                    Container(
                      width: 34,
                      height: 26,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [AppColors.goldCard, AppColors.gold],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Credit Limit row
                _CCRow(
                  label: 'Credit Limit',
                  value: data.limit,
                  valueColor: Colors.white,
                ),
                const SizedBox(height: 7),

                // Amount Used row
                _CCRow(
                  label: 'Amount Used',
                  value: '${data.used} ${data.usedPct}',
                  valueColor: AppColors.goldCard,
                ),
                const SizedBox(height: 10),

                // Usage bar
                ClipRRect(
                  borderRadius: BorderRadius.circular(3),
                  child: Container(
                    height: 5,
                    width: double.infinity,
                    color: Colors.white.withOpacity(0.15),
                    child: FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: data.usageFactor,
                      child: Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [AppColors.goldLight, AppColors.goldCard],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 18),

                // Stats row
                Row(
                  children: [
                    _CCStat(
                      label: 'Due Date',
                      value: data.dueDate,
                      color: Colors.white,
                    ),
                    _CCStat(
                      label: 'Min. Due',
                      value: data.minDue,
                      color: Colors.white,
                    ),
                    _CCStat(
                      label: 'Rewards',
                      value: data.rewards,
                      color: AppColors.greenLight,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _CCRow extends StatelessWidget {
  final String label, value;
  final Color valueColor;
  const _CCRow({
    required this.label,
    required this.value,
    required this.valueColor,
  });
  @override
  Widget build(BuildContext context) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        label,
        style: const TextStyle(
          color: Colors.white60,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
      Text(
        value,
        style: TextStyle(
          color: valueColor,
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
    ],
  );
}

class _CCStat extends StatelessWidget {
  final String label, value;
  final Color color;
  const _CCStat({
    required this.label,
    required this.value,
    required this.color,
  });
  @override
  Widget build(BuildContext context) => Expanded(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white54,
            fontSize: 10,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 13,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    ),
  );
}
