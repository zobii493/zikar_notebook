import 'package:flutter/material.dart';

import '../core/app_colors.dart';

class CrosshatchPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.whiteColor.withValues(alpha: 0.05)
      ..strokeWidth = 1;

    const spacing = 18.0;

    // Lines going one diagonal direction (45°)
    for (double x = -size.height; x < size.width; x += spacing) {
      canvas.drawLine(
        Offset(x, 0),
        Offset(x + size.height, size.height),
        paint,
      );
    }
    // Lines going the other diagonal direction (-45°)
    for (double x = 0; x < size.width + size.height; x += spacing) {
      canvas.drawLine(
        Offset(x, 0),
        Offset(x - size.height, size.height),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}