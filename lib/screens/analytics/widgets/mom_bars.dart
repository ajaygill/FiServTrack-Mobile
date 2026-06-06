import 'package:fiservtrack/themes/app_color.dart';
import 'package:flutter/material.dart';
import 'utils.dart';

class MoMBars extends StatefulWidget {
  const MoMBars({Key? key}) : super(key: key);

  @override
  State<MoMBars> createState() => _MoMBarsState();
}

class _MoMBarsState extends State<MoMBars> {
  int _selectedIndex = 5; // Default to March (latest month)

  @override
  Widget build(BuildContext context) {
    const data = [
      ('Oct', 52000),
      ('Nov', 61000),
      ('Dec', 74000),
      ('Jan', 59000),
      ('Feb', 68200),
      ('Mar', 82500),
    ];
    const maxVal = 90000.0;

    // Calculate percentage difference for selected month if possible
    String growthText = '';
    Color growthColor = AppColors.brand;
    if (_selectedIndex > 0) {
      final prev = data[_selectedIndex - 1].$2;
      final curr = data[_selectedIndex].$2;
      final pct = ((curr - prev) / prev) * 100;
      final sign = pct >= 0 ? '+' : '';
      growthText = '$sign${pct.toStringAsFixed(0)}% MoM';
      growthColor = pct >= 0 ? AppColors.red : AppColors.green; // Expense up is red, down is green
    }

    return FittedBox(
      fit: BoxFit.scaleDown,
      child: SizedBox(
        width: 290,
        height: 145,
        child: Column(
          children: [
            // Details Banner
            Container(
              height: 28,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.brandLight.withOpacity(0.08),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.brandPale.withOpacity(0.5), width: 1),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${data[_selectedIndex].$1} Spending',
                    style: const TextStyle(
                      color: AppColors.ink,
                      fontSize: 10.5,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        '₹${fmt(data[_selectedIndex].$2)}',
                        style: const TextStyle(
                          color: AppColors.ink,
                          fontSize: 11,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      if (growthText.isNotEmpty) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1.5),
                          decoration: BoxDecoration(
                            color: growthColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            growthText,
                            style: TextStyle(
                              color: growthColor,
                              fontSize: 8,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Bars row
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(data.length, (i) {
                  final d = data[i];
                  final isSelected = _selectedIndex == i;
                  final frac = d.$2 / maxVal;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedIndex = i;
                      });
                    },
                    behavior: HitTestBehavior.opaque,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          fmtK(d.$2),
                          style: TextStyle(
                            color: isSelected ? AppColors.brand : AppColors.inkMuted,
                            fontSize: 9,
                            fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 5),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          width: 34,
                          height: 72 * frac,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: isSelected
                                  ? [AppColors.brandLight, AppColors.brand]
                                  : [
                                      AppColors.inkFaint.withOpacity(0.7),
                                      AppColors.inkFaint.withOpacity(0.5)
                                    ],
                            ),
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: isSelected
                                ? [
                                    BoxShadow(
                                      color: AppColors.brand.withOpacity(0.25),
                                      blurRadius: 6,
                                      spreadRadius: 1,
                                    )
                                  ]
                                : null,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          d.$1,
                          style: TextStyle(
                            color: isSelected ? AppColors.ink : AppColors.inkMuted,
                            fontSize: 9.5,
                            fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
