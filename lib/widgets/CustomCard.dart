import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import '../core/app_theme_colors.dart';
import '../utils/responsive.dart';

class CustomProgressCard extends StatelessWidget {
  final String title;
  final FaIconData? icon;
  final Color? iconColor;
  final String? svgAsset;
  final Color iconBackColor;
  final double progressPercentage;
  final Color backgroundcolor;
  final VoidCallback onTap;

  const CustomProgressCard({
    super.key,
    required this.title,
    this.icon,
    this.iconColor,
    this.svgAsset,
    required this.iconBackColor,
    required this.progressPercentage,
    required this.backgroundcolor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    final iconBoxSize = context.responsiveWidth(0.11).clamp(34.0, 48.0);
    final iconSize = iconBoxSize * 0.55;
    final cardRadius = context.responsiveWidth(0.05).clamp(16.0, 24.0);
    final horizontalGap = context.responsiveWidth(0.025).clamp(8.0, 14.0);
    final verticalGap = context.responsiveHeight(0.012).clamp(8.0, 14.0);

    return Card(
      color: colors.cardBackground,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(cardRadius)),
      ),
      child: InkWell(
        borderRadius: BorderRadius.all(Radius.circular(cardRadius)),
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: horizontalGap, top: verticalGap * 1.3),
              child: Container(
                decoration: BoxDecoration(
                  color: iconBackColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                width: iconBoxSize,
                height: iconBoxSize,
                child: Center(
                  child: svgAsset != null
                      ? SvgPicture.asset(
                    svgAsset!,
                    width: iconSize,
                    height: iconSize,
                  )
                      : FaIcon(
                    icon,
                    color: iconColor,
                    size: iconSize,
                  ),
                ),
              ),
            ),
            SizedBox(height: verticalGap),
            Padding(
              padding: EdgeInsets.only(right: horizontalGap * 1.6),
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  title,
                  style: TextStyle(
                    color: colors.textPrimary,
                    fontSize: context.responsiveFont(20),
                    fontFamily: 'Amiri',
                  ),
                ),
              ),
            ),
            SizedBox(height: verticalGap * 2),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalGap * 0.6),
              child: LinearPercentIndicator(
                lineHeight: context.responsiveHeight(0.007).clamp(5.0, 8.0),
                percent: progressPercentage.clamp(0.0, 1.0),
                progressColor: backgroundcolor,
                backgroundColor: colors.background,
                barRadius: const Radius.circular(10),
                animation: true,
                linearStrokeCap: LinearStrokeCap.round,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                left: horizontalGap * 1.6,
                right: horizontalGap * 1.6,
                top: verticalGap * 0.6,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Progress',
                    style: TextStyle(
                      color: colors.textPrimary,
                      fontSize: context.responsiveFont(13),
                      fontFamily: 'PlusJakartaSans',
                    ),
                  ),
                  Text(
                    '${(progressPercentage * 100).toStringAsFixed(0)}%',
                    style: TextStyle(
                      color: colors.textPrimary,
                      fontSize: context.responsiveFont(13),
                      fontFamily: 'SpaceGrotesk',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}