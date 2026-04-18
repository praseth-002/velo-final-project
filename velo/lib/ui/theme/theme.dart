import 'package:flutter/material.dart';

///
/// Bike Rental app color palette.
///
class AppColors {
  static const Color primary = Color(0xFFF5A623);       // orange — main brand
  static const Color primaryLight = Color(0xFFFFF3E0);  // soft orange bg (banners)
  static const Color success = Color(0xFF4CAF50);       // green (booking success)

  static const Color textDark = Color(0xFF1A1A1A);
  static const Color textMedium = Color(0xFF666666);
  static const Color textLight = Color(0xFF999999);

  static const Color cardBorder = Color(0xFFE0E0E0);
  static const Color cardBackground = Color(0xFFFFFFFF);
  static const Color scaffoldBackground = Color(0xFFF5F5F5);

  static const Color disabled = Color(0xFFBDBDBD);
}

///
/// Text styles.
///
class AppTextStyles {
  static const TextStyle stationName = TextStyle(
    fontSize: 26,
    fontWeight: FontWeight.w800,
    color: AppColors.textDark,
  );

  static const TextStyle stationAddress = TextStyle(
    fontSize: 13,
    color: AppColors.textMedium,
  );

  static const TextStyle dockLabel = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w600,
    color: AppColors.textMedium,
    letterSpacing: 0.5,
  );

  static const TextStyle availableLabel = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: AppColors.primary,
  );

  static const TextStyle availableCount = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w800,
    color: AppColors.primary,
  );

  static const TextStyle bannerText = TextStyle(
    fontSize: 13,
    color: Color(0xFF7A4F00),
  );

  static const TextStyle heading = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: AppColors.textDark,
  );

  static const TextStyle body = TextStyle(
    fontSize: 14,
    color: AppColors.textMedium,
  );
}

///
/// Global MaterialApp theme.
///
ThemeData appTheme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
  scaffoldBackgroundColor: AppColors.scaffoldBackground,
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.white,
    foregroundColor: AppColors.textDark,
    elevation: 0,
    titleTextStyle: TextStyle(
      color: AppColors.textDark,
      fontSize: 18,
      fontWeight: FontWeight.w700,
    ),
  ),
);
