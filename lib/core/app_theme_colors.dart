import 'package:flutter/material.dart';
import 'app_colors.dart';

@immutable
class AppThemeColors extends ThemeExtension<AppThemeColors> {
  final Color headingPrimary;
  final Color headingSecondary;
  final Color background;
  final Color surface;
  final Color surfaceAlt;
  final Color border;
  final Color divider;
  final Color headerGradientStart;
  final Color headerGradientEnd;
  final Color emeraldDeep;
  final Color emerald;
  final Color gold;
  final Color goldLight;
  final Color textPrimary;
  final Color textSecondary;
  final Color maroon;
  final Color cardBackground;
  final Color lightPink;
  final Color lightPurple;
  final Color lightBlue;

  const AppThemeColors({
    required this.headingPrimary,
    required this.headingSecondary,
    required this.background,
    required this.surface,
    required this.surfaceAlt,
    required this.border,
    required this.divider,
    required this.headerGradientStart,
    required this.headerGradientEnd,
    required this.emeraldDeep,
    required this.emerald,
    required this.gold,
    required this.goldLight,
    required this.textPrimary,
    required this.textSecondary,
    required this.maroon,
    required this.cardBackground,
    required this.lightPink,
    required this.lightPurple,
    required this.lightBlue,
  });

  static final light = AppThemeColors(
    headingPrimary: AppColors.emeraldDeepColor,
    headingSecondary: AppColors.whiteColor,
    background: AppColors.ivoryColor,
    surface: AppColors.whiteColor,
    surfaceAlt: const Color(0xFFF3ECDD),
    border: const Color(0xFFE5E0D5),
    divider: const Color(0xFFE5E0D5),
    headerGradientStart: AppColors.emeraldDeepColor,
    headerGradientEnd: AppColors.emeraldColor,
    emeraldDeep: AppColors.emeraldDeepColor,
    emerald: AppColors.emeraldColor,
    gold: AppColors.antiqueGoldColor,
    goldLight: AppColors.antiqueGoldColor,
    textPrimary: const Color(0xFF1A1A1A),
    textSecondary: const Color(0xFF6B6B6B),
    maroon: AppColors.maroonColor,
    cardBackground: AppColors.whiteColor,
    lightPink: AppColors.lightPinkColor,
    lightPurple: AppColors.lightPurpleColor,
    lightBlue: AppColors.lightBlueColor,
  );

  static final dark = AppThemeColors(
    headingPrimary: AppColors.antiqueGoldColor,
    headingSecondary: AppColors.antiqueGoldColor,
    background: AppColors.darkBg,
    surface: AppColors.darkSurface,
    surfaceAlt: AppColors.darkSurface2,
    border: AppColors.darkBorder,
    divider: AppColors.darkBorder,
    headerGradientStart: AppColors.darkHeaderGradientStart,
    headerGradientEnd: AppColors.darkHeaderGradientEnd,
    emeraldDeep: AppColors.darkEmerald,
    emerald: AppColors.darkEmeraldBright,
    gold: AppColors.darkGold,
    goldLight: AppColors.darkGoldLight,
    textPrimary: AppColors.darkText,
    textSecondary: AppColors.darkTextSoft,
    maroon: AppColors.darkMaroon,
    cardBackground: AppColors.darkSurface,
    lightPink: AppColors.darkPinkIconBackground,
    lightPurple: AppColors.darkPurpleIconBackground,
    lightBlue: AppColors.darkBlueIconBackground,
  );

  @override
  AppThemeColors copyWith({
    Color? headingPrimary,
    Color? headingSecondary,
    Color? background,
    Color? surface,
    Color? surfaceAlt,
    Color? border,
    Color? divider,
    Color? headerGradientStart,
    Color? headerGradientEnd,
    Color? emeraldDeep,
    Color? emerald,
    Color? gold,
    Color? goldLight,
    Color? textPrimary,
    Color? textSecondary,
    Color? maroon,
    Color? cardBackground,
    Color? lightPink,
    Color? lightPurple,
    Color? lightBlue,
  }) {
    return AppThemeColors(
      headingPrimary: headingPrimary ?? this.headingPrimary,
      headingSecondary: headingSecondary ?? this.headingSecondary,
      background: background ?? this.background,
      surface: surface ?? this.surface,
      surfaceAlt: surfaceAlt ?? this.surfaceAlt,
      border: border ?? this.border,
      divider: divider ?? this.divider,
      headerGradientStart: headerGradientStart ?? this.headerGradientStart,
      headerGradientEnd: headerGradientEnd ?? this.headerGradientEnd,
      emeraldDeep: emeraldDeep ?? this.emeraldDeep,
      emerald: emerald ?? this.emerald,
      gold: gold ?? this.gold,
      goldLight: goldLight ?? this.goldLight,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      maroon: maroon ?? this.maroon,
      cardBackground: cardBackground ?? this.cardBackground,
      lightPink: lightPink ?? this.lightPink,
      lightPurple: lightPurple ?? this.lightPurple,
      lightBlue: lightBlue ?? this.lightBlue,
    );
  }

  @override
  AppThemeColors lerp(ThemeExtension<AppThemeColors>? other, double t) {
    if (other is! AppThemeColors) return this;
    return AppThemeColors(
      headingPrimary: Color.lerp(headingPrimary, other.headingPrimary, t)!,
      headingSecondary: Color.lerp(headingSecondary, other.headingSecondary, t)!,
      background: Color.lerp(background, other.background, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      surfaceAlt: Color.lerp(surfaceAlt, other.surfaceAlt, t)!,
      border: Color.lerp(border, other.border, t)!,
      divider: Color.lerp(divider, other.divider, t)!,
      headerGradientStart: Color.lerp(
        headerGradientStart,
        other.headerGradientStart,
        t,
      )!,
      headerGradientEnd: Color.lerp(
        headerGradientEnd,
        other.headerGradientEnd,
        t,
      )!,
      emeraldDeep: Color.lerp(emeraldDeep, other.emeraldDeep, t)!,
      emerald: Color.lerp(emerald, other.emerald, t)!,
      gold: Color.lerp(gold, other.gold, t)!,
      goldLight: Color.lerp(goldLight, other.goldLight, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      maroon: Color.lerp(maroon, other.maroon, t)!,
      cardBackground: Color.lerp(cardBackground, other.cardBackground, t)!,
      lightPink: Color.lerp(lightPink, other.lightPink, t)!,
      lightPurple: Color.lerp(lightPurple, other.lightPurple, t)!,
      lightBlue: Color.lerp(lightBlue, other.lightBlue, t)!,
    );
  }
}

/// Shortcut: 'context.appColors.emeraldDeep' anywhere in the widget tree.
extension AppThemeContext on BuildContext {
  AppThemeColors get appColors => Theme.of(this).extension<AppThemeColors>()!;
}
