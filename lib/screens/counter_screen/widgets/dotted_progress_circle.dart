import 'dart:math';

import 'package:flutter/material.dart';

import '../../../core/app_theme_colors.dart';

class DottedProgressCircle extends StatelessWidget {
  final double percent; // 0.0 - 1.0
  final int current;
  final int dotCount;
  final double dotRadius;
  final Color? activeColor;
  final Color? inactiveColor;
  final String label;

  const DottedProgressCircle({
    super.key,
    required this.percent,
    required this.current,
    this.dotCount = 36,
    this.dotRadius = 7,
    this.activeColor,
    this.inactiveColor,
    this.label = 'CURRENT COUNT',
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double screenWidth = MediaQuery.of(context).size.width;
        final double size = screenWidth * 0.62;
        final colors = context.appColors;

        return SizedBox(
          width: size,
          height: size,
          child: CustomPaint(
            painter: _DottedCircularProgressPainter(
              percent: percent,
              dotCount: dotCount,
              dotRadius: dotRadius,
              activeColor: activeColor ?? colors.gold,
              inactiveColor: inactiveColor ?? colors.border,
            ),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '$current',
                    style: TextStyle(
                      fontSize: 46,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'SpaceGrotesk',
                      color: colors.headingPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 13,
                      letterSpacing: 1.2,
                      fontFamily: 'PlusJakartaSans',
                      color: Colors.blueGrey,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _DottedCircularProgressPainter extends CustomPainter {
  final double percent;
  final int dotCount;
  final double dotRadius;
  final Color activeColor;
  final Color inactiveColor;

  _DottedCircularProgressPainter({
    required this.percent,
    required this.dotCount,
    required this.dotRadius,
    required this.activeColor,
    required this.inactiveColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Offset center = Offset(size.width / 2, size.height / 2);
    final double radius = (size.shortestSide / 2) - dotRadius;
    final int activeDots = (dotCount * percent).round();

    for (int i = 0; i < dotCount; i++) {
      final double angle = -pi / 2 + (2 * pi / dotCount) * i;
      final double dx = center.dx + radius * cos(angle);
      final double dy = center.dy + radius * sin(angle);

      final Paint paint = Paint()
        ..color = i < activeDots ? activeColor : inactiveColor
        ..style = PaintingStyle.fill;

      canvas.drawCircle(Offset(dx, dy), dotRadius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _DottedCircularProgressPainter oldDelegate) {
    return oldDelegate.percent != percent ||
        oldDelegate.dotCount != dotCount ||
        oldDelegate.dotRadius != dotRadius ||
        oldDelegate.activeColor != activeColor ||
        oldDelegate.inactiveColor != inactiveColor;
  }
}
