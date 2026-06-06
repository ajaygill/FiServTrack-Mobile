import 'package:fiservtrack/themes/app_color.dart';
import 'package:flutter/material.dart';
import 'budget_model.dart';
import 'primary_btn.dart';
import 'utils.dart';

class EditBudgetBottomSheet extends StatefulWidget {
  final Budget budget;
  final Function(int newLimit) onSaved;
  final VoidCallback onDelete;

  const EditBudgetBottomSheet({
    Key? key,
    required this.budget,
    required this.onSaved,
    required this.onDelete,
  }) : super(key: key);

  @override
  State<EditBudgetBottomSheet> createState() => _EditBudgetBottomSheetState();
}

class _EditBudgetBottomSheetState extends State<EditBudgetBottomSheet> {
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
                    Text(
                      '${widget.budget.emoji} ${widget.budget.label}',
                      style: const TextStyle(
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
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'CURRENT SPEND',
                            style: TextStyle(
                              color: AppColors.inkMuted,
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1,
                            ),
                          ),
                          Text(
                            '₹${fmt(widget.budget.spent)}',
                            style: const TextStyle(
                              color: AppColors.ink,
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                              letterSpacing: -0.5,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text(
                            'CURRENT LIMIT',
                            style: TextStyle(
                              color: AppColors.inkMuted,
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1,
                            ),
                          ),
                          Text(
                            '₹${fmt(widget.budget.limit)}',
                            style: const TextStyle(
                              color: AppColors.brand,
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                              letterSpacing: -0.5,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                TextFormField(
                  controller: _limitCtrl,
                  keyboardType: TextInputType.number,
                  decoration: inputDeco("NEW MONTHLY LIMIT", "e.g. ${fmt(widget.budget.limit)}"),
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
                  label: 'Save Changes',
                  onTap: () {
                    if (!_formKey.currentState!.validate()) return;

                    final limit = int.parse(_limitCtrl.text);
                    widget.onSaved(limit);
                    Navigator.pop(context);

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content:
                            Text("Budget '${widget.budget.label}' limit updated successfully!"),
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
