import 'package:flutter/material.dart';
import 'package:medical_app/core/styles/app_colors.dart';

void mydiag(BuildContext context, String message, Color color) {
  final mediaQuery = MediaQuery.of(context);
  final isError = color == AppColors.redcolor || color == AppColors.red;

  ScaffoldMessenger.of(context).clearSnackBars();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: color,
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.only(
        bottom: mediaQuery.size.height - mediaQuery.padding.top - 80,
        left: 16,
        right: 16,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      content: Row(
        children: [
          Icon(
            isError ? Icons.error_outline : Icons.check_circle_outline,
            color: Colors.white,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
      duration: const Duration(seconds: 3),
      dismissDirection: DismissDirection.up,
    ),
  );
}
