import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class CustomProgressCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color iconColor;
  final List<Color> gradientColors;
  final Color shadowColor;
  final double progressPercentage;
  final Color backgroundcolor;
  final VoidCallback onTap;

  CustomProgressCard({
    required this.title,
    required this.icon,
    required this.iconColor,
    required this.gradientColors,
    required this.shadowColor,
    required this.progressPercentage,
    required this.backgroundcolor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(42)),
      ),
      child: InkWell(
        onTap: onTap,
        child: Container(
          width: 170,
          height: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(42),
            boxShadow: [
              BoxShadow(
                color: shadowColor,
                offset: const Offset(0, 20),
                blurRadius: 30,
                spreadRadius: -5,
              ),
            ],
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomCenter,
              colors: gradientColors,
              stops: const [0.1, 0.3, 0.9, 1.0],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10, top: 20),
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 20,
                  child: FaIcon(
                    icon,
                    color: iconColor,
                    size: 24,
                  ),
                ),
              ),
              SizedBox(height: 10,),
              Center(
                child: Text(
                  title,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 5.0),
                child: LinearPercentIndicator(
                  width: 160,
                  lineHeight: 12,
                  percent: progressPercentage,
                  progressColor: Colors.white,
                  backgroundColor: backgroundcolor,
                  barRadius: Radius.circular(10),
                  animation: true,
                  linearStrokeCap: LinearStrokeCap.round,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Progress',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '${(progressPercentage * 100).toStringAsFixed(0)}%',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
