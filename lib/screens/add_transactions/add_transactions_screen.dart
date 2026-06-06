import 'package:fiservtrack/themes/app_color.dart';
import 'package:flutter/material.dart';
import 'expense_tab.dart';
import 'income_tab.dart';
import 'transfer_tab.dart';

class AddTransactionsScreen extends StatefulWidget {
  const AddTransactionsScreen({Key? key}) : super(key: key);

  @override
  State<AddTransactionsScreen> createState() => _AddTransactionsScreenState();
}

class _AddTransactionsScreenState extends State<AddTransactionsScreen> {
  int _tab = 0; // 0=expense 1=income 2=transfer

  Widget _tabContent() {
    switch (_tab) {
      case 0:
        return const ExpenseTab();
      case 1:
        return const IncomeTab();
      case 2:
        return const TransferTab();
      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Column(
          children: [
            _header(),
            _typeToggle(),
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 220),
                switchInCurve: Curves.easeOutCubic,
                switchOutCurve: Curves.easeIn,
                transitionBuilder: (child, anim) => FadeTransition(
                  opacity: CurvedAnimation(parent: anim, curve: Curves.easeOut),
                  child: child,
                ),
                child: KeyedSubtree(
                  key: ValueKey(_tab),
                  child: _tabContent(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _header() => Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 14),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Add Entry',
                  style: TextStyle(
                    color: AppColors.ink,
                    fontSize: 23,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.5,
                  ),
                ),
              ],
            ),
          ],
        ),
      );

  Widget _typeToggle() {
    final tabs = [
      ('Expense', AppColors.redBg, AppColors.red),
      ('Income', AppColors.greenBg, AppColors.green),
      ('Transfer', AppColors.brandPale, AppColors.brand),
    ];
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.cardBorder, width: 1.5),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0F0D2840),
            blurRadius: 3,
            offset: Offset(0, 1),
          )
        ],
      ),
      child: Row(
        children: List.generate(3, (i) {
          final sel = _tab == i;
          final (lbl, bg, fg) = tabs[i];
          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _tab = i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 9),
                decoration: BoxDecoration(
                  color: sel ? bg : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                ),
                alignment: Alignment.center,
                child: Text(
                  lbl,
                  style: TextStyle(
                    color: sel ? fg : AppColors.inkMuted,
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}