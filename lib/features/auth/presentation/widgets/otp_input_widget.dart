import 'package:flutter/material.dart';
import 'package:medical_app/core/styles/app_colors.dart';
import 'package:medical_app/core/styles/text_styles.dart';
import 'package:pinput/pinput.dart';

class OtpInputWidget extends StatelessWidget {
  final int length;
  final Function(String) onCompleted;
  final TextEditingController controller;

  const OtpInputWidget({
    super.key,
    required this.length,
    required this.onCompleted,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 45,
      height: 55,
      textStyle: TextStyles.title.copyWith(
        color: AppColors.primaryColor,
        fontWeight: FontWeight.bold,
      ),
      decoration: BoxDecoration(
        color: AppColors.darkwhite,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.lightgrey1, width: 1.5),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration!.copyWith(
        border: Border.all(color: AppColors.primaryColor, width: 2),
      ),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration!.copyWith(
        color: AppColors.darkwhite,
      ),
    );

    return Pinput(
      length: length,
      controller: controller,
      defaultPinTheme: defaultPinTheme,
      focusedPinTheme: focusedPinTheme,
      submittedPinTheme: submittedPinTheme,
      showCursor: true,
      onCompleted: onCompleted,
      hapticFeedbackType: HapticFeedbackType.lightImpact,
    );
  }
}
