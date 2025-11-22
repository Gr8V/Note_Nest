import 'package:flutter/material.dart';
import 'colors.dart';

class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    useMaterial3: true,
    scaffoldBackgroundColor: AppColors.lightScaffold,
    cardColor: AppColors.lightCard,
    primaryColor: AppColors.lightPrimary,
    colorScheme: const ColorScheme.light(
      primary: AppColors.lightPrimary,
      onPrimary: Colors.white,
      secondary: AppColors.lightSecondary,
      onSecondary: Colors.white,
      tertiary: AppColors.lightScaffold,
      onTertiary: Colors.white,
      surface: AppColors.lightCard,
      onSurface: AppColors.lightTextPrimary,
      error: AppColors.lightError,
      onError: Colors.white,
      outline: Color(0xFFD8D8D8),
      shadow: Color(0x1A000000),
      surfaceTint: Colors.transparent,
      inverseSurface: AppColors.lightCard,
      onInverseSurface: AppColors.lightTextPrimary,
      inversePrimary: AppColors.lightPrimary,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.lightScaffold,
      elevation: 0,
      iconTheme: IconThemeData(color: AppColors.lightTextPrimary),
      titleTextStyle: TextStyle(
        color: AppColors.lightTextPrimary,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    useMaterial3: true,
    scaffoldBackgroundColor: AppColors.darkScaffold,
    cardColor: AppColors.darkCard,
    primaryColor: AppColors.darkPrimary,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.darkPrimary,
      onPrimary: Colors.black,
      secondary: AppColors.darkSecondary,
      onSecondary: Colors.white,
      tertiary: AppColors.darkScaffold,
      onTertiary: Colors.white,
      surface: AppColors.darkCard,
      onSurface: AppColors.darkTextPrimary,
      error: AppColors.darkError,
      onError: Colors.white,
      outline: Color(0xFF2C2C2C),
      shadow: Colors.black,
      surfaceTint: Colors.transparent,
      inverseSurface: AppColors.darkCard,
      onInverseSurface: AppColors.darkTextPrimary,
      inversePrimary: AppColors.darkPrimary,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.darkScaffold,
      elevation: 0,
      iconTheme: IconThemeData(color: AppColors.darkTextPrimary),
      titleTextStyle: TextStyle(
        color: AppColors.darkTextPrimary,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
    ),
  );
}
