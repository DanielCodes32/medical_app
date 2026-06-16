import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:medical_app/core/constants/app_fonts.dart';
import 'package:medical_app/core/styles/app_colors.dart';
import 'package:medical_app/core/styles/text_styles.dart';

abstract class AppThemes {
  static ThemeData get lightTheme => ThemeData(
    fontFamily: AppFonts.rubik,
    scaffoldBackgroundColor: Colors.transparent,
    appBarTheme: AppBarTheme(
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      backgroundColor: Colors.transparent,
      elevation: 0,
    ),
    datePickerTheme: DatePickerThemeData(
      backgroundColor: AppColors.backgroundColor,
    ),
    timePickerTheme: TimePickerThemeData(
      backgroundColor: AppColors.backgroundColor,
    ),

    cardColor: AppColors.backgroundColor,
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Color(0xffF7F8F9),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: AppColors.lightgrey1),
      ),
    ),
    colorScheme: ColorScheme.fromSeed(
      onSurface: AppColors.blackColor,
      seedColor: AppColors.primaryColor,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: AppColors.primaryColor,
      unselectedItemColor: AppColors.lightgrey1,
      backgroundColor: Colors.transparent,
      selectedLabelStyle: TextStyles.caption2.copyWith(
        fontWeight: FontWeight.w600,
        height: 2,
      ),
      unselectedLabelStyle: TextStyles.caption2.copyWith(
        fontWeight: FontWeight.w600,
        height: 2,
      ),
      showSelectedLabels: false,
      showUnselectedLabels: false,
      elevation: 0,
    ),
    dividerColor: AppColors.lightgrey1,
  );
  static ThemeData get darktheme => ThemeData(
    dividerColor: AppColors.lightgrey1,
    cardColor: AppColors.blackColor,
    fontFamily: AppFonts.rubik,
    scaffoldBackgroundColor: Colors.transparent,
    appBarTheme: AppBarTheme(
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      backgroundColor: Colors.transparent,
      titleTextStyle: TextStyles.title.copyWith(
        color: AppColors.backgroundColor,
        fontFamily: AppFonts.rubik,
      ),
      elevation: 0,
      foregroundColor: AppColors.backgroundColor,
    ),
    colorScheme: ColorScheme.fromSeed(
      onSurface: AppColors.backgroundColor,
      seedColor: AppColors.primaryColor,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Color(0xffF7F8F9),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: AppColors.lightgrey1),
      ),
    ),

    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: AppColors.primaryColor,
      unselectedItemColor: AppColors.lightgrey1,
      backgroundColor: Colors.transparent,
      selectedLabelStyle: TextStyles.caption2.copyWith(
        fontWeight: FontWeight.w600,
        height: 2,
      ),
      unselectedLabelStyle: TextStyles.caption2.copyWith(
        fontWeight: FontWeight.w600,
        height: 2,
      ),
      showSelectedLabels: false,
      showUnselectedLabels: false,
      elevation: 0,
    ),
    datePickerTheme: DatePickerThemeData(
      backgroundColor: AppColors.blackColor,
      headerBackgroundColor: AppColors.primaryColor,
      headerForegroundColor: AppColors.backgroundColor,
    ),
    timePickerTheme: TimePickerThemeData(
      backgroundColor: AppColors.blackColor,
      dialBackgroundColor: AppColors.blackColor,
      hourMinuteColor: AppColors.primaryColor,
    ),
  );
}
