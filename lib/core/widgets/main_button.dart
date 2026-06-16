import 'package:flutter/material.dart';
import 'package:medical_app/core/styles/app_colors.dart';
import 'package:medical_app/core/styles/text_styles.dart';

class MainButton extends StatelessWidget {
  final String? title;
  final Function()? onTap;
  final Color bgcolor;
  final Color textcolor;
  final Color? bordercolor;
  final Size? size;
  const MainButton({
    super.key,
    required this.title,
    this.onTap,
    this.bordercolor,
    this.bgcolor = AppColors.primaryColor,
    this.textcolor = AppColors.backgroundColor,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        minimumSize: size ?? const Size(double.infinity, 50),
        backgroundColor: bgcolor,
        side: bordercolor != null ? BorderSide(color: bordercolor!) : null,
      ),
      child: Text(
        title ?? "",
        style: TextStyles.title.copyWith(
          color: textcolor,
          decoration: TextDecoration.none,
        ),
      ),
    );
  }
}
