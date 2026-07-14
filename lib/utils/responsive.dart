import 'package:flutter/material.dart';

/// Central place for responsive sizing so screens stop hard-coding
/// pixel values. Scales fonts/spacing gently between small phones and
/// tablets/foldables/web instead of stretching everything 1:1.
extension ResponsiveContext on BuildContext {
  Size get _size => MediaQuery.of(this).size;

  double get screenWidth => _size.width;
  double get screenHeight => _size.height;

  /// >= 600 logical px is treated as tablet, matching Material
  /// breakpoints.
  bool get isTablet => screenWidth >= 600;

  /// Scales a font size against a 375-wide phone baseline, clamped so
  /// text never gets uncomfortably small or huge.
  double responsiveFont(double baseSize) {
    final scale = (screenWidth / 375).clamp(0.85, 1.3);
    return baseSize * scale;
  }

  double responsiveWidth(double fraction) => screenWidth * fraction;
  double responsiveHeight(double fraction) => screenHeight * fraction;

  /// Horizontal padding that grows on wide/tablet screens so content
  /// doesn't stretch edge-to-edge on tablets or web.
  EdgeInsets get horizontalPadding => EdgeInsets.symmetric(
    horizontal: isTablet ? screenWidth * 0.15 : 20,
  );

  /// Caps the width of forms/cards on very wide screens so the layout
  /// stays readable instead of one giant stretched column.
  double get maxContentWidth => isTablet ? 480 : double.infinity;
}
