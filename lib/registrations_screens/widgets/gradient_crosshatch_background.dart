import 'package:flutter/material.dart';
import '../../core/app_theme_colors.dart';
import '../../widgets/custom_paint.dart';

class GradientCrosshatchBackground extends StatelessWidget {
  const GradientCrosshatchBackground({
    super.key,
    this.borderRadius,
    this.crosshatchOpacity = 0.5,
    this.darkenBottom = false,
    this.child,
  });

  final BorderRadius? borderRadius;
  final double crosshatchOpacity;
  final bool darkenBottom;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final content = Stack(
      children: [
        Positioned.fill(
          child: Opacity(
            opacity: crosshatchOpacity,
            child: CustomPaint(painter: CrosshatchPainter()),
          ),
        ),
        if (darkenBottom)
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.08),
                  ],
                ),
              ),
            ),
          ),
        if (child != null) child!,
      ],
    );

    final decorated = Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [colors.headerGradientStart,colors.headerGradientEnd],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: borderRadius,
      ),
      child: borderRadius != null
          ? ClipRRect(borderRadius: borderRadius!, child: content)
          : content,
    );

    return decorated;
  }
}