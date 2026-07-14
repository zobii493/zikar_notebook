import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../core/app_colors.dart';
import '../../utils/responsive.dart';

class AuthTextField extends StatelessWidget {
  const AuthTextField({
    super.key,
    required this.controller,
    required this.hint,
    required this.icon,
    required this.iconBg,
    this.obscureText = false,
    this.keyboardType,
    this.errorText,
    this.suffixIcon,
    this.validator,
  });

  final TextEditingController controller;
  final String hint;
  final FaIconData icon;
  final Color iconBg;
  final bool obscureText;
  final TextInputType? keyboardType;
  final String? errorText;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        cursorColor: AppColors.emeraldDeepColor,
        style: TextStyle(
          fontFamily: 'PlusJakartaSans',
          fontSize: context.responsiveFont(15),
          color: Colors.black87,
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(
            fontFamily: 'PlusJakartaSans',
            color: Colors.black38,
          ),
          errorText: errorText,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: iconBg.withOpacity(0.5), width: 1.4),
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 16),
          prefixIcon: Padding(
            padding: const EdgeInsets.all(12),
            child: Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: iconBg.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: Center(child: FaIcon(icon, size: 15, color: iconBg)),
            ),
          ),
          prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
          suffixIcon: suffixIcon,
        ),
        validator: validator,
      ),
    );
  }
}