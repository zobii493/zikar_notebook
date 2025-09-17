import 'package:flutter/material.dart';

class FullWidthWavyTopRightClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(size.width, 0); // Top right corner
    path.lineTo(size.width, size.height * 0.7);
    path.quadraticBezierTo(
        size.width * 0.8, size.height, size.width * 0.6, size.height * 0.7);
    path.quadraticBezierTo(size.width * 0.4, size.height * 0.4,
        size.width * 0.2, size.height * 0.7);
    path.lineTo(0, size.height * 0.5);
    path.lineTo(0, 0); // Return to top left corner
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
