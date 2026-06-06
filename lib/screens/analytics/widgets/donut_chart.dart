import 'dart:math' as math;
import 'package:fiservtrack/themes/app_color.dart';
import 'package:flutter/material.dart';

class DonutChart extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  const DonutChart({
    Key? key,
    required this.selectedIndex,
    required this.onSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final chartSize = size.width * 0.28; // Slightly larger for better touch targeting
    return SizedBox(
      width: chartSize,
      height: chartSize,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final w = constraints.maxWidth;
          final h = constraints.maxHeight;
          final c = Offset(w / 2, h / 2);
          final r = w * 0.40;
          final strokeW = w * 0.15;

          return GestureDetector(
            onTapDown: (details) {
              final localPos = details.localPosition;
              final dx = localPos.dx - c.dx;
              final dy = localPos.dy - c.dy;
              final dist = math.sqrt(dx * dx + dy * dy);

              // Allow tolerance around the donut ring
              final minRadius = r - strokeW * 1.5;
              final maxRadius = r + strokeW * 1.5;

              if (dist >= minRadius && dist <= maxRadius) {
                // Angle relative to center
                double angle = math.atan2(dy, dx);
                // Normalize angle to [0, 2*pi] clockwise starting from -pi/2
                double normalizedAngle = angle - (-math.pi / 2);
                if (normalizedAngle < 0) {
                  normalizedAngle += 2 * math.pi;
                }

                const segments = [0.33, 0.25, 0.19, 0.15, 0.08];
                double currentAngle = 0.0;
                int tappedIndex = -1;

                for (int i = 0; i < segments.length; i++) {
                  double sweep = 2 * math.pi * segments[i];
                  if (normalizedAngle >= currentAngle &&
                      normalizedAngle < currentAngle + sweep) {
                    tappedIndex = i;
                    break;
                  }
                  currentAngle += sweep;
                }

                if (tappedIndex != -1) {
                  onSelected(selectedIndex == tappedIndex ? -1 : tappedIndex);
                }
              } else {
                // Reset selection if tapped inside center hole or outside
                onSelected(-1);
              }
            },
            child: CustomPaint(
              painter: DonutPainter(selectedIndex: selectedIndex),
            ),
          );
        },
      ),
    );
  }
}

class DonutPainter extends CustomPainter {
  final int selectedIndex;

  DonutPainter({required this.selectedIndex});

  @override
  void paint(Canvas canvas, Size size) {
    final c = Offset(size.width / 2, size.height / 2);
    final r = size.width * 0.40;
    final strokeW = size.width * 0.15;
    const segments = [
      (AppColors.red, 0.33, 'EMI / Loans', '₹22.5K'),
      (AppColors.gold, 0.25, 'Food & Dining', '₹17.0K'),
      (AppColors.green, 0.19, 'Transport', '₹13.0K'),
      (AppColors.brand, 0.15, 'Shopping', '₹10.2K'),
      (AppColors.inkFaint, 0.08, 'Others', '₹5.5K'),
    ];

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeW
      ..strokeCap = StrokeCap.round;

    // Background ring
    paint.color = AppColors.divider;
    canvas.drawCircle(c, r, paint);

    double startAngle = -math.pi / 2;
    for (int i = 0; i < segments.length; i++) {
      final seg = segments[i];
      final sweep = 2 * math.pi * seg.$2;
      paint.color = seg.$1;

      final isSelected = selectedIndex == i;
      Offset drawCenter = c;
      if (isSelected) {
        final bisectorAngle = startAngle + sweep / 2;
        // Shift outward along bisector angle
        const shift = 5.0;
        drawCenter = Offset(
          c.dx + math.cos(bisectorAngle) * shift,
          c.dy + math.sin(bisectorAngle) * shift,
        );
        paint.strokeWidth = strokeW * 1.25;
      } else {
        paint.strokeWidth = strokeW;
      }

      canvas.drawArc(
        Rect.fromCircle(center: drawCenter, radius: r),
        startAngle + 0.05,
        sweep - 0.1,
        false,
        paint,
      );
      startAngle += sweep;
    }

    // Centre text
    final tp = TextPainter(textDirection: TextDirection.ltr);

    String centerLabel = 'Total';
    String centerVal = '₹68.2K';
    Color labelColor = AppColors.inkMuted;

    if (selectedIndex >= 0 && selectedIndex < segments.length) {
      final seg = segments[selectedIndex];
      centerLabel = seg.$3;
      centerVal = seg.$4;
      labelColor = seg.$1;
    }

    tp.text = TextSpan(
      text: centerLabel,
      style: TextStyle(
        color: labelColor,
        fontSize: size.width * (centerLabel.length > 10 ? 0.065 : 0.08),
        fontWeight: FontWeight.w700,
        letterSpacing: -0.3,
      ),
    );
    tp.layout();
    tp.paint(canvas, Offset(c.dx - tp.width / 2, c.dy - size.width * 0.15));

    tp.text = TextSpan(
      text: centerVal,
      style: TextStyle(
        color: AppColors.ink,
        fontSize: size.width * 0.11,
        fontWeight: FontWeight.w900,
        letterSpacing: -0.5,
      ),
    );
    tp.layout();
    tp.paint(canvas, Offset(c.dx - tp.width / 2, c.dy - size.width * 0.01));
  }

  @override
  bool shouldRepaint(covariant DonutPainter oldDelegate) =>
      oldDelegate.selectedIndex != selectedIndex;
}

