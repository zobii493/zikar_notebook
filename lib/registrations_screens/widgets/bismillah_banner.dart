import 'package:flutter/material.dart';

import '../../core/app_colors.dart';
import '../../core/app_theme_colors.dart';
import '../../utils/responsive.dart';
import 'gradient_crosshatch_background.dart';

class BismillahBanner extends StatelessWidget {
  const BismillahBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Container(
      width: double.infinity,
      height: 110,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.emeraldDeepColor.withValues(alpha: 0.3),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: GradientCrosshatchBackground(
        borderRadius: BorderRadius.circular(20),
        crosshatchOpacity: 0.45,
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 22,
                height: 1,
                color: colors.gold.withValues(alpha: 0.6),
              ),
              const SizedBox(width: 10),
              Text(
                'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
                textDirection: TextDirection.rtl,
                style: TextStyle(
                  fontSize: context.responsiveFont(24),
                  fontWeight: FontWeight.w600,
                  color: colors.gold,
                  fontFamily: 'Amiri',
                ),
              ),
              const SizedBox(width: 10),
              Container(
                width: 22,
                height: 1,
                color: colors.gold.withValues(alpha: 0.6),
              ),
            ],
          ),
        ),
      ),
    );
  }
}