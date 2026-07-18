import 'package:flutter/material.dart';

import '../../core/app_colors.dart';
import '../../core/app_theme_colors.dart';
import '../../utils/responsive.dart';

class AuthGradientButton extends StatelessWidget {
  const AuthGradientButton({
    super.key,
    required this.label,
    required this.onTap,
    this.isLoading = false,
    this.borderRadius = 16,
  });

  final String label;
  final VoidCallback onTap;
  final bool isLoading;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return SizedBox(
      width: double.infinity,
      height: 58,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          gradient: LinearGradient(
            colors: [colors.headerGradientEnd,colors.headerGradientEnd],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.emeraldDeepColor.withValues(alpha: 0.35),
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(borderRadius),
          child: InkWell(
            borderRadius: BorderRadius.circular(borderRadius),
            onTap: isLoading ? null : onTap,
            child: Center(
              child: isLoading
                  ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2.4,
                  color: AppColors.whiteColor,
                ),
              )
                  : Text(
                label,
                style: TextStyle(
                  fontSize: context.responsiveFont(18),
                  fontFamily: 'PlusJakartaSans',
                  fontWeight: FontWeight.bold,
                  color: AppColors.whiteColor,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}