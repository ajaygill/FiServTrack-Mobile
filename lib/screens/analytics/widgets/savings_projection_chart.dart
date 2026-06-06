import 'dart:async';
import 'dart:math' as math;
import 'package:fiservtrack/themes/app_color.dart';
import 'package:flutter/material.dart';

class SavingsProjectionChart extends StatefulWidget {
  const SavingsProjectionChart({Key? key}) : super(key: key);

  @override
  State<SavingsProjectionChart> createState() => _SavingsProjectionChartState();
}

class _SavingsProjectionChartState extends State<SavingsProjectionChart> {
  int _selectedIndex = -1;
  Timer? _hideTimer;

  void _onInteraction(double localX, double width) {
    _hideTimer?.cancel();
    final ratio = (localX / width).clamp(0.0, 1.0);
    const xRatios = [0.0, 0.15, 0.30, 0.45, 0.55, 0.72, 1.0];

    int closestIdx = 0;
    double minDiff = 999.0;
    for (int i = 0; i < xRatios.length; i++) {
      double diff = (ratio - xRatios[i]).abs();
      if (diff < minDiff) {
        minDiff = diff;
        closestIdx = i;
      }
    }

    if (_selectedIndex != closestIdx) {
      setState(() {
        _selectedIndex = closestIdx;
      });
    }
  }

  void _startHideTimer() {
    _hideTimer?.cancel();
    _hideTimer = Timer(const Duration(milliseconds: 1500), () {
      if (mounted) {
        setState(() {
          _selectedIndex = -1;
        });
      }
    });
  }

  @override
  void dispose() {
    _hideTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SizedBox(
      height: size.height * 0.12,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final w = constraints.maxWidth;
          return GestureDetector(
            onPanStart: (details) => _onInteraction(details.localPosition.dx, w),
            onPanUpdate: (details) => _onInteraction(details.localPosition.dx, w),
            onPanEnd: (_) => _startHideTimer(),
            onPanCancel: () => _startHideTimer(),
            onTapDown: (details) => _onInteraction(details.localPosition.dx, w),
            onTapUp: (_) => _startHideTimer(),
            onTapCancel: () => _startHideTimer(),
            child: CustomPaint(
              size: Size.infinite,
              painter: SavingsPainter(selectedIndex: _selectedIndex),
            ),
          );
        },
      ),
    );
  }
}

class SavingsPainter extends CustomPainter {
  final int selectedIndex;

  SavingsPainter({required this.selectedIndex});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height - 14;

    // Actual points (0..0.55 of width)
    final actual = [
      Offset(0, 0.90),
      Offset(w * 0.15, 0.78),
      Offset(w * 0.30, 0.65),
      Offset(w * 0.45, 0.52),
      Offset(w * 0.55, 0.43),
    ];
    // Projected points (0.55..1.0)
    final projected = [
      Offset(w * 0.55, 0.43),
      Offset(w * 0.72, 0.30),
      Offset(w, 0.20),
    ];

    void drawCurve(List<Offset> pts, Color color, {bool dashed = false}) {
      final paint = Paint()
        ..color = color
        ..strokeWidth = 2.0
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;

      final mapped = pts.map((p) => Offset(p.dx, p.dy * h)).toList();
      final path = Path();
      path.moveTo(mapped[0].dx, mapped[0].dy);
      for (int i = 0; i < mapped.length - 1; i++) {
        final cp1 = Offset((mapped[i].dx + mapped[i + 1].dx) / 2, mapped[i].dy);
        final cp2 = Offset((mapped[i].dx + mapped[i + 1].dx) / 2, mapped[i + 1].dy);
        path.cubicTo(cp1.dx, cp1.dy, cp2.dx, cp2.dy, mapped[i + 1].dx, mapped[i + 1].dy);
      }

      if (!dashed) {
        // Fill
        final fillPath = Path.from(path);
        fillPath.lineTo(mapped.last.dx, h);
        fillPath.lineTo(mapped.first.dx, h);
        fillPath.close();
        canvas.drawPath(
          fillPath,
          Paint()
            ..shader = LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [color.withOpacity(0.15), color.withOpacity(0.01)],
            ).createShader(Rect.fromLTWH(0, 0, size.width, h)),
        );
        canvas.drawPath(path, paint);
      } else {
        // Dashed
        paint.color = color.withOpacity(0.6);
        _drawDashedPath(canvas, path, paint);
      }
    }

    drawCurve(actual, AppColors.brand);
    drawCurve(projected, AppColors.inkFaint, dashed: true);

    // Render interactive highlight & tooltip
    if (selectedIndex == -1) {
      // Dot at junction under static state
      final junction = Offset(w * 0.55, 0.43 * h);
      canvas.drawCircle(junction, 5, Paint()..color = AppColors.brand);
    } else {
      // Horizontal coordinates lookup
      const xRatios = [0.0, 0.15, 0.30, 0.45, 0.55, 0.72, 1.0];
      final xCoord = w * xRatios[selectedIndex];

      // Draw vertical line
      final linePaint = Paint()
        ..color = AppColors.divider.withOpacity(0.8)
        ..strokeWidth = 1.0
        ..style = PaintingStyle.stroke;
      _drawVerticalDashedLine(canvas, xCoord, 0.0, h, linePaint);

      // Find y-coordinate
      double yVal = 0.0;
      if (selectedIndex <= 4) {
        yVal = actual[selectedIndex].dy * h;
      } else {
        yVal = projected[selectedIndex - 4].dy * h;
      }

      // Draw highlighted point
      final isProj = selectedIndex > 4;
      final pointColor = isProj ? AppColors.brandMid : AppColors.brand;
      final dotPaint = Paint()..style = PaintingStyle.fill;

      dotPaint.color = pointColor.withOpacity(0.25);
      canvas.drawCircle(Offset(xCoord, yVal), 8, dotPaint);
      dotPaint.color = pointColor;
      canvas.drawCircle(Offset(xCoord, yVal), 4, dotPaint);
      dotPaint.color = Colors.white;
      canvas.drawCircle(Offset(xCoord, yVal), 1.5, dotPaint);

      // Render tooltip
      final labels = ['Jan', 'Feb', 'Mar 1', 'Mar 15', 'Mar 30', 'Apr', 'May'];
      final values = ['₹28.0K', '₹36.5K', '₹44.0K', '₹51.7K', '₹56.0K', '₹64.0K (Proj)', '₹72.0K (Proj)'];

      final text = '${labels[selectedIndex]}: ${values[selectedIndex]}';
      final tp = TextPainter(textDirection: TextDirection.ltr);
      tp.text = TextSpan(
        text: text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 9.0,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.2,
        ),
      );
      tp.layout();

      final pillW = tp.width + 16;
      final pillH = tp.height + 8;
      double pillX = xCoord - pillW / 2;
      pillX = pillX.clamp(4.0, w - pillW - 4.0);
      const pillY = 1.0;

      final pillRect = RRect.fromRectAndRadius(
        Rect.fromLTWH(pillX, pillY, pillW, pillH),
        const Radius.circular(8),
      );

      final bgPaint = Paint()
        ..color = const Color(0xEE1E2022)
        ..style = PaintingStyle.fill;
      canvas.drawRRect(pillRect, bgPaint);

      final borderPaint = Paint()
        ..color = Colors.white.withOpacity(0.15)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0;
      canvas.drawRRect(pillRect, borderPaint);

      tp.paint(canvas, Offset(pillX + 8, pillY + 4));
    }

    // X-axis labels
    final tp = TextPainter(textDirection: TextDirection.ltr);
    for (final e in [('Jan', 0.0), ('Feb', 0.27), ('Mar', 0.52), ('Forecast', 0.70)]) {
      tp.text = TextSpan(
        text: e.$1,
        style: TextStyle(
          color: e.$1 == 'Forecast' ? AppColors.inkMuted.withOpacity(0.6) : AppColors.inkMuted,
          fontSize: 8,
          fontWeight: FontWeight.w600,
        ),
      );
      tp.layout();
      tp.paint(canvas, Offset(w * e.$2, h + 4));
    }
  }

  void _drawVerticalDashedLine(
      Canvas canvas, double x, double startY, double endY, Paint paint) {
    double y = startY;
    const dash = 4.0, gap = 3.0;
    while (y < endY) {
      canvas.drawLine(Offset(x, y), Offset(x, math.min(y + dash, endY)), paint);
      y += dash + gap;
    }
  }

  void _drawDashedPath(Canvas canvas, Path path, Paint paint) {
    final metrics = path.computeMetrics();
    for (final m in metrics) {
      double dist = 0;
      bool draw = true;
      while (dist < m.length) {
        const dash = 6.0, gap = 4.0;
        final end = math.min(dist + (draw ? dash : gap), m.length);
        if (draw) {
          canvas.drawPath(m.extractPath(dist, end), paint);
        }
        dist = end;
        draw = !draw;
      }
    }
  }

  @override
  bool shouldRepaint(covariant SavingsPainter oldDelegate) =>
      oldDelegate.selectedIndex != selectedIndex;
}
