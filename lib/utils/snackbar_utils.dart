import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../core/app_colors.dart';

extension SnackBarContext on BuildContext {
  void showTopSnackBar(
      String message,
      Color color, {
        IconData icon = CupertinoIcons.check_mark_circled,
      }) {
    final overlay = Overlay.of(this);
    final topPadding = MediaQuery.of(this).padding.top;

    late final OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (_) => Positioned(
        top: topPadding + 10,
        left: 15,
        right: 15,
        child: TopSnackBar(
          message: message,
          backgroundColor: color,
          icon: icon,
        ),
      ),
    );

    overlay.insert(overlayEntry);

    Future.delayed(const Duration(seconds: 3), () {
      overlayEntry.remove();
    });
  }
}

class TopSnackBar extends StatelessWidget {
  final String message;
  final Color backgroundColor;
  final IconData icon;

  const TopSnackBar({
    super.key,
    required this.message,
    this.backgroundColor = AppColors.antiqueGoldColor,
    this.icon = CupertinoIcons.check_mark_circled,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.15),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.black),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  fontFamily: 'PlusJakartaSans',
                  color: Colors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  decoration: TextDecoration.none,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}