import 'package:fiservtrack/themes/app_color.dart';
import 'package:flutter/material.dart';
import 'widgets/constants.dart';
import 'widgets/amount_hero.dart';
import 'widgets/category_row.dart';
import 'widgets/custom_text_field.dart';
import 'widgets/tap_field.dart';
import 'widgets/account_sheet.dart';
import 'widgets/date_picker_sheet.dart';
import 'widgets/save_button.dart';
import 'widgets/section_label.dart';

class ExpenseTab extends StatefulWidget {
  const ExpenseTab({Key? key}) : super(key: key);

  @override
  State<ExpenseTab> createState() => _ExpenseTabState();
}

class _ExpenseTabState extends State<ExpenseTab> {
  int _expCat = 1;
  String _expAmount = '00.00';
  int _expAccount = 0;
  final _expDesc = TextEditingController(text: 'HP Petrol Station');
  final _expNote = TextEditingController();
  DateTime? _expDate;

  @override
  void dispose() {
    _expDesc.dispose();
    _expNote.dispose();
    super.dispose();
  }

  String _fmtDate(DateTime? d) {
    if (d == null) return 'Tap to select';
    const months = ['', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${d.day} ${months[d.month]} ${d.year}';
  }

  Future<DateTime?> _pickDate(DateTime? initial) => showModalBottomSheet<DateTime>(
        context: context,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        builder: (_) => DatePickerSheet(initialDate: initial),
      );

  void _showAccountSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => AccountSheet(
        title: 'Select Account',
        selected: _expAccount,
        onPick: (i) {
          setState(() => _expAccount = i);
          Navigator.pop(context);
        },
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

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.only(bottom: 120),
      physics: const BouncingScrollPhysics(),
      children: [
        AmountHero(
          amount: _expAmount,
          gradColors: const [AppColors.brandMid, AppColors.brandDeep],
          badgeIcon: Icons.info_outline_rounded,
          badgeText: 'Transport over budget',
          badgeColor: AppColors.redLight,
          badgeBg: const Color(0x33F46C60),
          badgeBorder: const Color(0x4DF46C60),
          onChanged: (v) => setState(() => _expAmount = v),
        ),
        const SectionLabel(label: 'Category'),
        CategoryRow(
          cats: const [
            ('🛒', 'Food'),
            ('⛽', 'Transport'),
            ('🏥', 'Health'),
            ('🎬', 'Fun'),
            ('🧾', 'Bills'),
            ('🛍', 'Shop'),
          ],
          selected: _expCat,
          onSelect: (i) => setState(() => _expCat = i),
          activeBg: AppColors.brandPale,
          activeBorder: AppColors.brandMid,
          activeFg: AppColors.brand,
        ),
        CustomTextField(
          label: 'Description',
          controller: _expDesc,
          hint: 'e.g. HP Petrol Station',
          icon: Icons.edit_outlined,
          multiline: true,
        ),
        TapField(
          label: 'Account',
          value: '${kAccounts[_expAccount].$1} ${kAccounts[_expAccount].$2} ${kAccounts[_expAccount].$3}',
          icon: Icons.keyboard_arrow_down_rounded,
          onTap: _showAccountSheet,
        ),
        TapField(
          label: 'Date',
          value: _expDate != null ? _fmtDate(_expDate) : 'Today',
          icon: Icons.calendar_today_rounded,
          onTap: () async {
            final d = await _pickDate(_expDate);
            if (d != null) setState(() => _expDate = d);
          },
        ),
        CustomTextField(
          label: 'Note',
          controller: _expNote,
          hint: 'Add a note...',
          multiline: true,
        ),
        SaveButton(
          label: 'Save Expense',
          colors: const [AppColors.brandLight, AppColors.brandDeep],
          onTap: _save,
        ),
      ],
    );
  }
}
