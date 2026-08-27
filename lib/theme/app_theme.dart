// theme/app_theme.dart
import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

/// 构建全局 B 站主题
ThemeData buildAppTheme() {
  final colorScheme = ColorScheme.fromSeed(seedColor: AppColors.biliPink);

  return ThemeData(
    useMaterial3: true,
    colorScheme: colorScheme,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.biliPink,
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
    ),
    tabBarTheme: const TabBarThemeData(
      indicatorColor: AppColors.biliPink,
      labelColor: AppColors.biliPink,
      unselectedLabelColor: AppColors.textSecondary,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.biliPink,
        foregroundColor: Colors.white,
      ),
    ),
    sliderTheme: const SliderThemeData(
      activeTrackColor: AppColors.biliPink,
      thumbColor: AppColors.biliPink,
      overlayColor: AppColors.biliPinkLight,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      selectedItemColor: AppColors.biliPink,
      unselectedItemColor: AppColors.textSecondary,
      type: BottomNavigationBarType.fixed,
    ),
  );
}
