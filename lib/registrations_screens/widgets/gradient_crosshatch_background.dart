import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../core/app_colors.dart';
import '../../utils/responsive.dart';
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
                    Colors.black.withOpacity(0.08),
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
        gradient: const LinearGradient(
          colors: [AppColors.emeraldDeepColor, AppColors.emeraldColor],
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