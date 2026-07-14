import 'package:flutter/material.dart';

import '../../core/app_colors.dart';
import '../../utils/responsive.dart';

class AuthOutlinedButton extends StatelessWidget {
  const AuthOutlinedButton({
    super.key,
    required this.label,
    required this.onTap,
  });

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 58,
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          side: const BorderSide(
            color: AppColors.emeraldDeepColor,
            width: 1.6,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          backgroundColor: Colors.white,
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: context.responsiveFont(18),
            fontFamily: 'PlusJakartaSans',
            fontWeight: FontWeight.bold,
            color: AppColors.emeraldDeepColor,
          ),
        ),
      ),
    );
  }
}