import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../core/app_colors.dart';
import '../../core/app_theme_colors.dart';
import '../../utils/responsive.dart';
import 'gradient_crosshatch_background.dart';

class AuthHeader extends StatelessWidget {
  const AuthHeader({
    super.key,
    required this.label,
    required this.title,
    this.showBack = false,
  });

  final String label;
  final String title;
  final bool showBack;

  @override
  Widget build(BuildContext context) {
    final height = context.responsiveHeight(0.2).clamp(140.0, 200.0);
    final colors = context.appColors;

    return SizedBox(
      width: double.infinity,
      height: height,
      child: GradientCrosshatchBackground(
        crosshatchOpacity: 1,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 40, 20, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (showBack)
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: InkWell(
                    onTap: () => Navigator.pop(context),
                    child: const FaIcon(
                      FontAwesomeIcons.angleLeft,
                      color: AppColors.whiteColor,
                      size: 20,
                    ),
                  ),
                ),
              Text(
                label,
                style: TextStyle(
                  fontFamily: 'PlusJakartaSans',
                  fontSize: context.responsiveFont(12),
                  fontWeight: FontWeight.w600,
                  letterSpacing: 2,
                  color: AppColors.whiteColor.withValues(alpha: 0.70),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                title,
                style: TextStyle(
                  fontFamily: 'PlusJakartaSans',
                  fontSize: context.responsiveFont(24),
                  fontWeight: FontWeight.w800,
                  color: colors.headingSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}