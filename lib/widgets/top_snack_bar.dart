import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TopSnackBar extends StatelessWidget {
  final String message;
  final Color backgroundColor;

  TopSnackBar({required this.message, this.backgroundColor = Colors.amber});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 10),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            offset: Offset(0, 4),
            blurRadius: 6,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min, // Minimize width to fit content
        children: [
          Expanded(
            child: Text(
              message,
              style: TextStyle(color: Colors.black, fontSize: 16,decoration: TextDecoration.none),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(width: 8),
          Icon(CupertinoIcons.check_mark_circled, color: Colors.black),
        ],
      ),
    );
  }
}
