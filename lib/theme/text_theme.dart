// TextTheme - Material Design text theme
// Generated on 2025-09-26T22:49:40.771Z
// This file was automatically generated from Figma design system

import 'package:flutter/material.dart';
import 'app_text.dart';

/// Material Design text theme
/// Generated from Figma design system
class AppTextTheme {
  AppTextTheme._();

  /// Get Material Design text theme
  static TextTheme get textTheme {
    return TextTheme(
      displayLarge: AppText.displayLarge,
      displayMedium: AppText.displayLargeBold,
      displaySmall: AppText.levels,
      headlineLarge: AppText.colors,
      headlineMedium: AppText.headlineLargeBold,
      headlineSmall: AppText.headlineSmallLight,
      bodyLarge: AppText.headlineSmallLight,
      bodyMedium: AppText.h_4LibreProductName,
      bodySmall: AppText.bodySmallMedium,
    );
  }
}
