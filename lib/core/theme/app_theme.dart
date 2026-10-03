import 'package:flutter/material.dart';

abstract final class AppColors {
  static const primary = Color(0xFF16796C);
  static const background = Color(0xFFF5F8F7);
  static const ink = Color(0xFF17332F);
}

abstract final class AppTextStyles {
  static const title = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    color: AppColors.ink,
  );
  static const cardTitle = TextStyle(fontSize: 20, fontWeight: FontWeight.w600);
}

ThemeData buildAppTheme() => ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
      scaffoldBackgroundColor: AppColors.background,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.ink,
        centerTitle: false,
      ),
      inputDecorationTheme: const InputDecorationTheme(
        border: OutlineInputBorder(),
      ),
    );
