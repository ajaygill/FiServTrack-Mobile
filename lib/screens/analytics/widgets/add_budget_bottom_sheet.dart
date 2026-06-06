import 'package:fiservtrack/themes/app_color.dart';
import 'package:flutter/material.dart';
import 'primary_btn.dart';
import 'utils.dart';

class AddBudgetBottomSheet extends StatefulWidget {
  final Function(String emoji, String label, int limit, List<Color> colors) onAdded;

  const AddBudgetBottomSheet({Key? key, required this.onAdded}) : super(key: key);

  @override
  State<AddBudgetBottomSheet> createState() => _AddBudgetBottomSheetState();
}

class _AddBudgetBottomSheetState extends State<AddBudgetBottomSheet> {
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
                    const Text(
                      'Add Budget',
                      style: TextStyle(
                        color: AppColors.ink,
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -0.4,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        width: 34,
                        height: 34,
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(11),
                          border: Border.all(color: AppColors.cardBorder, width: 1.5),
                        ),
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
                    _categoryOption('💊', 'Healthcare', [
                      const Color(0xFF9D7AE4),
                      const Color(0xFF7A4EE2),
                    ]),
                    _categoryOption('📝', 'Other', [AppColors.inkSoft, AppColors.inkMuted]),
                  ],
                ),
                const SizedBox(height: 24),

                if (_selectedLabel == 'Other') ...[
                  TextFormField(
                    controller: _customLabelCtrl,
                    textCapitalization: TextCapitalization.words,
                    decoration: inputDeco("BUDGET CATEGORY NAME", "e.g. Groceries, Gym"),
                    validator: (val) =>
                        val == null || val.trim().isEmpty ? "Category name is required" : null,
                  ),
                  const SizedBox(height: 12),
                ],

                TextFormField(
                  controller: _limitCtrl,
                  keyboardType: TextInputType.number,
                  decoration: inputDeco("MONTHLY LIMIT", "e.g. 15000"),
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) return "Monthly limit is required";
                    if (int.tryParse(val) == null || int.parse(val) <= 0) {
                      return "Must be a positive number";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),

                PrimaryBtn(
                  label: 'Add Budget',
                  onTap: () {
                    if (!_formKey.currentState!.validate()) return;

                    final limit = int.parse(_limitCtrl.text);
                    final label =
                        _selectedLabel == 'Other' ? _customLabelCtrl.text : _selectedLabel;

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
