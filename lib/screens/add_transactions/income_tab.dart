import 'package:fiservtrack/themes/app_color.dart';
import 'package:flutter/material.dart';
import 'widgets/constants.dart';
import 'widgets/amount_hero.dart';
import 'widgets/category_row.dart';
import 'widgets/custom_text_field.dart';
import 'widgets/tap_field.dart';
import 'widgets/account_sheet.dart';
import 'widgets/date_picker_sheet.dart';
import 'widgets/recurring_toggle.dart';
import 'widgets/save_button.dart';
import 'widgets/section_label.dart';

class IncomeTab extends StatefulWidget {
  const IncomeTab({Key? key}) : super(key: key);

  @override
  State<IncomeTab> createState() => _IncomeTabState();
}

class _IncomeTabState extends State<IncomeTab> {
  int _incCat = 0;
  String _incAmount = '00.00';
  int _incAccount = 0;
  bool _recurring = true;
  final _incDesc = TextEditingController(text: 'TCS Monthly Salary');
  DateTime? _incDate;

  @override
  void dispose() {
    _incDesc.dispose();
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
        title: 'Credited To',
        selected: _incAccount,
        onPick: (i) {
          setState(() => _incAccount = i);
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
          amount: _incAmount,
          gradColors: const [AppColors.green, AppColors.greenDeep],
          badgeIcon: Icons.arrow_upward_rounded,
          badgeText: 'Above last month avg',
          badgeColor: AppColors.greenLight,
          badgeBg: const Color(0x3334C88A),
          badgeBorder: const Color(0x4D34C88A),
          onChanged: (v) => setState(() => _incAmount = v),
        ),
        const SectionLabel(label: 'Source'),
        CategoryRow(
          cats: const [
            ('💼', 'Salary'),
            ('💻', 'Freelance'),
            ('📈', 'Invest'),
            ('🏠', 'Rental'),
            ('🎁', 'Gift'),
            ('➕', 'Other'),
          ],
          selected: _incCat,
          onSelect: (i) => setState(() => _incCat = i),
          activeBg: AppColors.greenBg,
          activeBorder: AppColors.green,
          activeFg: AppColors.green,
        ),
        CustomTextField(
          label: 'Description',
          controller: _incDesc,
          hint: 'e.g. TCS Monthly Salary',
          icon: Icons.edit_outlined,
          multiline: true,
        ),
        TapField(
          label: 'Credited To',
          value: '${kAccounts[_incAccount].$1} ${kAccounts[_incAccount].$2} ${kAccounts[_incAccount].$3}',
          icon: Icons.keyboard_arrow_down_rounded,
          onTap: _showAccountSheet,
        ),
        TapField(
          label: 'Date',
          value: _incDate != null ? _fmtDate(_incDate) : 'Mar 1, 2026',
          icon: Icons.calendar_today_rounded,
          onTap: () async {
            final d = await _pickDate(_incDate);
            if (d != null) setState(() => _incDate = d);
          },
        ),
        RecurringToggle(
          value: _recurring,
          onChanged: (v) => setState(() => _recurring = v),
        ),
        SaveButton(
          label: 'Save Income',
          colors: const [AppColors.green, AppColors.greenDeep],
          onTap: _save,
        ),
      ],
    );
  }
}
