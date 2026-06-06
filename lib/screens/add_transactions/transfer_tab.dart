import 'package:fiservtrack/themes/app_color.dart';
import 'package:flutter/material.dart';
import 'widgets/constants.dart';
import 'widgets/amount_hero.dart';
import 'widgets/custom_text_field.dart';
import 'widgets/tap_field.dart';
import 'widgets/account_sheet.dart';
import 'widgets/date_picker_sheet.dart';
import 'widgets/save_button.dart';

class TransferTab extends StatefulWidget {
  const TransferTab({Key? key}) : super(key: key);

  @override
  State<TransferTab> createState() => _TransferTabState();
}

class _TransferTabState extends State<TransferTab> {
  String _xfrAmount = '00.00';
  int _xfrFrom = 0;
  int _xfrTo = 1;
  final _xfrNote = TextEditingController();
  DateTime? _xfrDate;

  @override
  void dispose() {
    _xfrNote.dispose();
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

  void _showAccountSheet({
    required String title,
    required int selected,
    required ValueChanged<int> onPick,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => AccountSheet(
        title: title,
        selected: selected,
        onPick: (i) {
          onPick(i);
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
          amount: _xfrAmount,
          gradColors: const [AppColors.brandLight, AppColors.brandDeep],
          badgeIcon: Icons.sync_rounded,
          badgeText: 'Between your accounts',
          badgeColor: const Color(0xD9FFFFFF),
          badgeBg: const Color(0x1FFFFFFF),
          badgeBorder: const Color(0x33FFFFFF),
          onChanged: (v) => setState(() => _xfrAmount = v),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
          child: const Text(
            'FROM → TO',
            style: TextStyle(
              color: AppColors.inkMuted,
              fontSize: 11,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.5,
            ),
          ),
        ),
        Stack(
          alignment: Alignment.center,
          children: [
            Column(
              children: [
                TapField(
                  label: 'From Account',
                  value: '${kAccounts[_xfrFrom].$1} ${kAccounts[_xfrFrom].$2} ${kAccounts[_xfrFrom].$3}',
                  icon: Icons.keyboard_arrow_down_rounded,
                  onTap: () => _showAccountSheet(
                    title: 'From Account',
                    selected: _xfrFrom,
                    onPick: (i) => setState(() {
                      _xfrFrom = i;
                      if (_xfrFrom == _xfrTo) {
                        _xfrTo = (i + 1) % kAccounts.length;
                      }
                    }),
                  ),
                ),
                TapField(
                  label: 'To Account',
                  value: '${kAccounts[_xfrTo].$1} ${kAccounts[_xfrTo].$2} ${kAccounts[_xfrTo].$3}',
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
            Positioned(
              child: Transform.translate(
                offset: const Offset(0, -5.5),
                child: GestureDetector(
                  onTap: () => setState(() {
                    final tmp = _xfrFrom;
                    _xfrFrom = _xfrTo;
                    _xfrTo = tmp;
                  }),
                  child: Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: AppColors.brand,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.surface, width: 3),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.brand.withOpacity(0.30),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        )
                      ],
                    ),
                    child: const Icon(Icons.swap_vert_rounded, color: Colors.white, size: 18),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        TapField(
          label: 'Date',
          value: _xfrDate != null ? _fmtDate(_xfrDate) : 'Today',
          icon: Icons.calendar_today_rounded,
          onTap: () async {
            final d = await _pickDate(_xfrDate);
            if (d != null) setState(() => _xfrDate = d);
          },
        ),
        CustomTextField(
          label: 'Note',
          controller: _xfrNote,
          hint: 'Add a note...',
          multiline: true,
        ),
        SaveButton(
          label: 'Transfer ₹$_xfrAmount',
          colors: const [AppColors.brandLight, AppColors.brandDeep],
          onTap: _save,
        ),
      ],
    );
  }
}
