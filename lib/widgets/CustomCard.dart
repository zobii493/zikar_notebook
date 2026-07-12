import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:naqashbandi_shazli/core/app_colors.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class CustomProgressCard extends StatelessWidget {
  final String title;
  final FaIconData icon;
  final Color iconColor;
  final Color iconBackColor;
  final double progressPercentage;
  final Color backgroundcolor;
  final VoidCallback onTap;

  CustomProgressCard({
    required this.title,
    required this.icon,
    required this.iconColor,
    required this.iconBackColor,
    required this.progressPercentage,
    required this.backgroundcolor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10, top: 16),
              child: Container(
                decoration: BoxDecoration(
                  color: iconBackColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                width: 40,
                height: 40,
                child: Center(
                  child: FaIcon(
                    icon,
                    color: iconColor,
                    size: 24,
                  ),
                ),
              ),
            ),
            SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Align(
                alignment: .centerRight,
                child: Text(
                  title,
                  style: TextStyle(
                      color: AppColors.emeraldDeepColor,
                      fontSize: 20,
                    fontFamily: 'Amiri'
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 5.0,right: 5.0),
              child: LinearPercentIndicator(
                lineHeight: 6,
                percent: progressPercentage,
                progressColor: backgroundcolor,
                backgroundColor: AppColors.ivoryColor,
                barRadius: Radius.circular(10),
                animation: true,
                linearStrokeCap: LinearStrokeCap.round,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16,top: 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Progress',
                    style: TextStyle(
                        color: AppColors.emeraldDeepColor,fontFamily: 'PlusJakartaSans'),
                  ),
                  Text(
                    '${(progressPercentage * 100).toStringAsFixed(0)}%',
                    style: TextStyle(
                        color: AppColors.emeraldDeepColor, fontFamily: 'SpaceGrotesk'),
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
