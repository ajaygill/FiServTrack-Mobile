import 'package:fiservtrack/themes/app_color.dart';
import 'package:flutter/material.dart';

class ForecastBars extends StatefulWidget {
  const ForecastBars({Key? key}) : super(key: key);

  @override
  State<ForecastBars> createState() => _ForecastBarsState();
}

class _ForecastBarsState extends State<ForecastBars> {
  int _selectedIndex = 3; // Default to Thursday (Projected)

  @override
  Widget build(BuildContext context) {
    const data = [
      ('Mon', 0.35, false),
      ('Tue', 0.55, false),
      ('Wed', 0.28, false),
      ('Thu', 0.90, true), // Projected
      ('Fri', 0.48, false),
      ('Sat', 0.72, false),
      ('Sun', 0.20, false),
    ];

    return FittedBox(
      fit: BoxFit.scaleDown,
      child: SizedBox(
        width: 290,
        height: 115,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(data.length, (i) {
            final d = data[i];
            final dayName = d.$1;
            final val = d.$2;
            final isProjected = d.$3;
            final isSelected = _selectedIndex == i;

            // Compute amount dynamically
            final amountStr = '₹${(val * 10).toStringAsFixed(1)}K';

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
                  // Tooltip bubble space
                  SizedBox(
                    height: 24,
                    child: AnimatedOpacity(
                      duration: const Duration(milliseconds: 200),
                      opacity: isSelected ? 1.0 : 0.0,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: isProjected ? AppColors.brand : const Color(0xFF1E2022),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: isProjected
                                ? Colors.white.withOpacity(0.2)
                                : AppColors.divider.withOpacity(0.2),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          isProjected ? '$amountStr Proj' : amountStr,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 7.5,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  // The bar
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    width: 28,
                    height: 65 * val,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? (isProjected ? AppColors.brand : AppColors.brandMid)
                          : (isProjected
                              ? AppColors.brandLight.withOpacity(0.35)
                              : AppColors.inkFaint),
                      borderRadius: BorderRadius.circular(6),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: (isProjected ? AppColors.brand : AppColors.brandMid)
                                    .withOpacity(0.3),
                                blurRadius: 6,
                                spreadRadius: 1,
                              )
                            ]
                          : null,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    dayName,
                    style: TextStyle(
                      color: isSelected ? AppColors.ink : AppColors.inkMuted,
                      fontSize: 9,
                      fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}
