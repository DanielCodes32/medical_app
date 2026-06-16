import 'package:flutter/material.dart';
import 'package:medical_app/core/constants/app_fonts.dart';
import 'package:medical_app/core/styles/app_colors.dart';

class TextStyles {
  static TextStyle headline = TextStyle(
    fontSize: 28,
    fontFamily: AppFonts.rubik,
    fontWeight: FontWeight.w500,
    color: AppColors.blackColor,
  );

  static TextStyle title = TextStyle(
    fontSize: 25,
    fontFamily: AppFonts.rubik,
    fontWeight: FontWeight.w700,
    color: AppColors.blackColor,
  );

  static TextStyle button = TextStyle(
    fontSize: 18,
    fontFamily: AppFonts.rubik,
    fontWeight: FontWeight.w500,
    color: AppColors.backgroundColor,
  );

  static TextStyle body1 = TextStyle(
    fontSize: 14,
    fontFamily: AppFonts.rubik,
    fontWeight: FontWeight.w400,
    color: AppColors.bodycolor,
  );

  static TextStyle caption2 = TextStyle(
    color: AppColors.darkgreycolor,
    fontSize: 14,
  );
}
