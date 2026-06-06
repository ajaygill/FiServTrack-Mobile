import 'dart:async';
import 'dart:math' as math;
import 'package:fiservtrack/themes/app_color.dart';
import 'package:flutter/material.dart';

class TrendChart extends StatefulWidget {
  const TrendChart({Key? key}) : super(key: key);

  @override
  State<TrendChart> createState() => _TrendChartState();
}

class _TrendChartState extends State<TrendChart> {
  int _selectedIndex = -1;
  Timer? _hideTimer;

  void _onInteraction(double localX, double width) {
    _hideTimer?.cancel();
    final ratio = (localX / width).clamp(0.0, 1.0);
    const xRatios = [0.0, 0.25, 0.49, 0.74, 1.0];

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
              painter: TrendPainter(selectedIndex: _selectedIndex),
            ),
          );
        },
      ),
    );
  }
}

class TrendPainter extends CustomPainter {
  final int selectedIndex;

  TrendPainter({required this.selectedIndex});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height - 14; // Leave room for x-labels

    // Income path data (normalised 0..1 y inverted)
    final incPts = [
      Offset(0, 0.66),
      Offset(w * 0.25, 0.53),
      Offset(w * 0.49, 0.41),
      Offset(w * 0.74, 0.36),
      Offset(w, 0.28),
    ];
    // Expense path
    final expPts = [
      Offset(0, 0.79),
      Offset(w * 0.25, 0.85),
      Offset(w * 0.49, 0.68),
      Offset(w * 0.74, 0.64),
      Offset(w, 0.62),
    ];

    _drawFilledLine(canvas, size, incPts, h, const Color(0xFF0F7B50));
    _drawFilledLine(canvas, size, expPts, h, const Color(0xFFC0392B));

    // End points/dots when NOT interactive
    if (selectedIndex == -1) {
      final endInc = Offset(w, incPts.last.dy * h);
      canvas.drawCircle(endInc, 7, Paint()..color = const Color(0x330F7B50));
      canvas.drawCircle(endInc, 4, Paint()..color = const Color(0xFF0F7B50));
    } else {
      // Draw vertical tracker line
      const xRatios = [0.0, 0.25, 0.49, 0.74, 1.0];
      final xCoord = w * xRatios[selectedIndex];

      final linePaint = Paint()
        ..color = AppColors.divider.withOpacity(0.8)
        ..strokeWidth = 1.0
        ..style = PaintingStyle.stroke;

      _drawVerticalDashedLine(canvas, xCoord, 0.0, h, linePaint);

      // Highlight points on both curves
      final incY = incPts[selectedIndex].dy * h;
      final expY = expPts[selectedIndex].dy * h;

      final dotPaint = Paint()..style = PaintingStyle.fill;

      // Income point glow + circle
      dotPaint.color = const Color(0xFF0F7B50).withOpacity(0.25);
      canvas.drawCircle(Offset(xCoord, incY), 8, dotPaint);
      dotPaint.color = const Color(0xFF0F7B50);
      canvas.drawCircle(Offset(xCoord, incY), 4, dotPaint);
      dotPaint.color = Colors.white;
      canvas.drawCircle(Offset(xCoord, incY), 1.5, dotPaint);

      // Expense point glow + circle
      dotPaint.color = const Color(0xFFC0392B).withOpacity(0.25);
      canvas.drawCircle(Offset(xCoord, expY), 8, dotPaint);
      dotPaint.color = const Color(0xFFC0392B);
      canvas.drawCircle(Offset(xCoord, expY), 4, dotPaint);
      dotPaint.color = Colors.white;
      canvas.drawCircle(Offset(xCoord, expY), 1.5, dotPaint);

      // Draw custom floating tooltip box at the top
      final date = ['Mar 1', 'Mar 8', 'Mar 15', 'Mar 22', 'Today'][selectedIndex];
      final incVal = ['₹80K', '₹92K', '₹102K', '₹108K', '₹1.2L'][selectedIndex];
      final expVal = ['₹54K', '₹58K', '₹46K', '₹43K', '₹68.2K'][selectedIndex];

      final text = '$date  •  Inc: $incVal  •  Exp: $expVal';
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
        ..color = const Color(0xEE1E2022) // Translucent premium dark
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
    for (final e in [('Mar 1', 0.0), ('Mar 15', 0.43), ('Today', 0.87)]) {
      tp.text = TextSpan(
        text: e.$1,
        style: const TextStyle(
          color: AppColors.inkMuted,
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

  void _drawFilledLine(
      Canvas canvas, Size size, List<Offset> pts, double h, Color color) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2.2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final path = Path();
    final mapped = pts.map((p) => Offset(p.dx, p.dy * h)).toList();
    path.moveTo(mapped[0].dx, mapped[0].dy);
    for (int i = 0; i < mapped.length - 1; i++) {
      final cp1 = Offset((mapped[i].dx + mapped[i + 1].dx) / 2, mapped[i].dy);
      final cp2 = Offset((mapped[i].dx + mapped[i + 1].dx) / 2, mapped[i + 1].dy);
      path.cubicTo(
          cp1.dx, cp1.dy, cp2.dx, cp2.dy, mapped[i + 1].dx, mapped[i + 1].dy);
    }

    // Fill
    final fillPath = Path.from(path);
    fillPath.lineTo(mapped.last.dx, h);
    fillPath.lineTo(mapped.first.dx, h);
    fillPath.close();

    final grad = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [color.withOpacity(0.18), color.withOpacity(0.01)],
      ).createShader(Rect.fromLTWH(0, 0, size.width, h));
    canvas.drawPath(fillPath, grad);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant TrendPainter oldDelegate) =>
      oldDelegate.selectedIndex != selectedIndex;
}
