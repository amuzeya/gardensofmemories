// YSL Beauty Experience - Brand Colors
// Based on YSL Beauty brand guidelines: Black and white only, color from images/videos

import 'package:flutter/material.dart';

class AppColors {
  AppColors._(); // Private constructor to prevent instantiation

  // Core YSL Brand Colors
  /// YSL signature black - primary brand color
  static const Color yslBlack = Color(0xFF000000);
  
  /// YSL clean white - primary background
  static const Color yslWhite = Color(0xFFFFFFFF);
  
  /// YSL luxury gold accent - used sparingly for premium touches
  static const Color yslGold = Color(0xFFC5A46D);
  
  // Functional Greys
  /// For disabled states and subtle overlays
  static const Color grey100 = Color(0xFFF5F5F5);
  static const Color grey200 = Color(0xFFE5E5E5);
  static const Color grey300 = Color(0xFFD4D4D4);
  static const Color grey400 = Color(0xFFA3A3A3);
  static const Color grey500 = Color(0xFF737373);
  static const Color grey600 = Color(0xFF525252);
  static const Color grey700 = Color(0xFF404040);
  static const Color grey800 = Color(0xFF262626);
  static const Color grey900 = Color(0xFF171717);
  
  // Overlay colors for images and videos
  /// Semi-transparent black overlay for text readability over images
  static const Color overlayBlack = Color(0x80000000);
  /// Light overlay for subtle depth
  static const Color overlayLight = Color(0x1A000000);
  
  // System colors (minimal, as per brand guidelines)
  static const Color error = Color(0xFFDC2626);
  static const Color success = Color(0xFF16A34A);
  static const Color warning = Color(0xFFEA580C);
  static const Color info = Color(0xFF2563EB);
  
  // Light Theme ColorScheme
  static const ColorScheme lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: yslBlack,
    onPrimary: yslWhite,
    secondary: yslGold,
    onSecondary: yslBlack,
    tertiary: grey600,
    onTertiary: yslWhite,
    error: error,
    onError: yslWhite,
    surface: yslWhite,
    onSurface: yslBlack,
    surfaceContainerHighest: grey100,
    onSurfaceVariant: grey700,
    outline: grey300,
    outlineVariant: grey200,
    shadow: overlayBlack,
    scrim: overlayBlack,
    inverseSurface: yslBlack,
    onInverseSurface: yslWhite,
    inversePrimary: yslWhite,
    surfaceTint: yslBlack,
  );
  
  // Dark Theme ColorScheme (inverted for premium night mode)
  static const ColorScheme darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: yslWhite,
    onPrimary: yslBlack,
    secondary: yslGold,
    onSecondary: yslBlack,
    tertiary: grey400,
    onTertiary: yslBlack,
    error: error,
    onError: yslWhite,
    surface: yslBlack,
    onSurface: yslWhite,
    surfaceContainerHighest: grey900,
    onSurfaceVariant: grey300,
    outline: grey700,
    outlineVariant: grey800,
    shadow: Color(0xFF000000),
    scrim: Color(0xFF000000),
    inverseSurface: yslWhite,
    onInverseSurface: yslBlack,
    inversePrimary: yslBlack,
    surfaceTint: yslWhite,
  );

  // Legacy support for generated color
  /// Principles (legacy from Figma extraction)
  @Deprecated('Use AppColors.yslWhite instead')
  static const Color principles = yslWhite;
}
