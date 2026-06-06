import 'package:fiservtrack/themes/app_color.dart';
import 'package:flutter/material.dart';

class CategoryRow extends StatelessWidget {
  final List<(String, String)> cats;
  final int selected;
  final ValueChanged<int> onSelect;
  final Color activeBg, activeBorder, activeFg;

  const CategoryRow({
    Key? key,
    required this.cats,
    required this.selected,
    required this.onSelect,
    required this.activeBg,
    required this.activeBorder,
    required this.activeFg,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 18),
      child: Row(
        children: List.generate(cats.length, (i) {
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
                  color: sel ? activeBorder : AppColors.cardBorder,
                  width: 1.5,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: sel
                    ? null
                    : const [
                        BoxShadow(
                          color: Color(0x0F0D2840),
                          blurRadius: 3,
                          offset: Offset(0, 1),
                        )
                      ],
              ),
              child: Column(
                children: [
                  Text(ico, style: const TextStyle(fontSize: 22)),
                  const SizedBox(height: 5),
                  Text(
                    name,
                    style: TextStyle(
                      color: sel ? activeFg : AppColors.inkSoft,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
