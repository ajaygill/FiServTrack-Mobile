import 'package:fiservtrack/themes/app_color.dart';
import 'package:flutter/material.dart';

class PrimaryBtn extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const PrimaryBtn({Key? key, required this.label, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Ink(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 17),
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: [AppColors.brandLight, AppColors.brandDeep]),
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                color: Color(0x3D134372),
                blurRadius: 20,
                offset: Offset(0, 8),
              )
            ],
          ),
          child: Center(
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w900,
                letterSpacing: -0.2,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
