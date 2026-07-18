import 'package:flutter/material.dart';
import 'app_theme_colors.dart';

ThemeData buildLightTheme() {
  final colors = AppThemeColors.light;
  return ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: colors.background,
    fontFamily: 'PlusJakartaSans',
    colorScheme: ColorScheme.fromSeed(
      seedColor: colors.emeraldDeep,
      brightness: Brightness.light,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: colors.emeraldDeep,
      foregroundColor: AppThemeColors.light.background,
      elevation: 0,
    ),
    cardColor: colors.cardBackground,
    dividerColor: colors.divider,
    extensions: [AppThemeColors.light],
  );
}

ThemeData buildDarkTheme() {
  final colors = AppThemeColors.dark;
  return ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: colors.background,
    fontFamily: 'PlusJakartaSans',
    colorScheme: ColorScheme.fromSeed(
      seedColor: colors.emerald,
      brightness: Brightness.dark,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: colors.surface,
      foregroundColor: colors.textPrimary,
      elevation: 0,
    ),
    cardColor: colors.cardBackground,
    dividerColor: colors.divider,
    extensions: [AppThemeColors.dark],
  );
}