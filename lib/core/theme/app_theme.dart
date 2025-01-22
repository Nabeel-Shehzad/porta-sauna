import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:portasauna/core/theme/pallete.dart';

class AppTheme {
  static ThemeData theme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: Pallete.backgroundColor,
    fontFamily: 'poppins',
    appBarTheme: const AppBarTheme(
      backgroundColor: Pallete.backgroundColor,
      elevation: 0,
    ),
    canvasColor: Pallete.whiteColor,
    textTheme: TextTheme(
      headlineLarge: TextStyle(
        fontSize: 55.sp,
        color: Pallete.whiteColor,
        fontWeight: FontWeight.bold,
      ),
      headlineSmall: TextStyle(
        fontSize: 30.sp,
        color: Pallete.whiteColor,
        fontWeight: FontWeight.bold,
      ),
      titleSmall: TextStyle(
        fontSize: 20.sp,
        color: Pallete.whiteColor,
        fontWeight: FontWeight.bold,
      ),
      bodySmall: TextStyle(
        fontSize: 18.sp,
        color: Pallete.whiteColor,
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Pallete.primarColor,
    ),
  );
}
