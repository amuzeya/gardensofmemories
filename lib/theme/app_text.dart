// YSL Beauty Experience - Typography System
// Based on exact Figma font extractions: ITC Avant Garde Gothic Pro + Arial
// Both fonts now use REAL bundled font files for pixel-perfect typography
// Following brand guidelines: elegant, uppercase titles, minimal hierarchy

import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Typography styles for YSL Beauty Experience
/// Using actual bundled font files from Figma designs
class AppText {
  AppText._(); // Private constructor

  /// Primary font family - ITC Avant Garde Gothic Pro (bundled font file)
  /// From Style Guide, Tests UI/UX, and Components sections
  static const String primaryFontFamily = 'ITC Avant Garde Gothic Pro';
  
  /// Display font family - Arial (bundled font files)
  /// From Brief section: 72px title and 24px subtitle
  static const String displayFontFamily = 'Arial';
  
  /// Legacy font family reference (for backward compatibility)
  static const String fontFamily = primaryFontFamily;
  
  /// Base font style using primary bundled font (ITC Avant Garde Gothic Pro)
  static TextStyle _baseFont({
    required double fontSize,
    required FontWeight fontWeight,
    Color? color,
    double? letterSpacing,
    double? height,
  }) {
    return TextStyle(
      fontFamily: primaryFontFamily,
      fontFamilyFallback: const ['Arial', 'Helvetica', 'sans-serif'],
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color ?? AppColors.yslBlack,
      letterSpacing: letterSpacing,
      height: height,
    );
  }
  
  /// Display font style using bundled Arial font (for large display text)
  static TextStyle _baseDisplayFont({
    required double fontSize,
    required FontWeight fontWeight,
    Color? color,
    double? letterSpacing,
    double? height,
  }) {
    return TextStyle(
      fontFamily: displayFontFamily,
      fontFamilyFallback: const ['Helvetica', 'sans-serif'],
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color ?? AppColors.yslBlack,
      letterSpacing: letterSpacing,
      height: height,
    );
  }

  // HERO TYPOGRAPHY (Brief Section - Arial)
  /// Massive brand display text (72px Arial from Brief section)
  static TextStyle get brandDisplay => _baseDisplayFont(
    fontSize: 72,
    fontWeight: FontWeight.w700,
    height: 1.15, // 82.79px / 72px from Figma
  );
  
  /// Large display subtitle (24px Arial from Brief section)
  static TextStyle get displaySubtitle => _baseDisplayFont(
    fontSize: 24,
    fontWeight: FontWeight.w400,
    height: 1.15, // 27.6px / 24px from Figma
  );

  // SECTION HEADINGS (Tests UI/UX - ITC Avant Garde Gothic Pro)
  /// Section headers (22px bold from Tests UI/UX)
  static TextStyle get sectionHeader => _baseFont(
    fontSize: 22,
    fontWeight: FontWeight.w700,
    height: 1.2, // 26.4px / 22px from Figma
  );

  // STANDARD TYPOGRAPHY (Style Guide - ITC Avant Garde Gothic Pro)
  /// Hero display text - largest standard text (32px bold from Style Guide)
  static TextStyle get heroDisplay => _baseFont(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    height: 1.2, // 38.4px / 32px from Figma
  );
  
  /// Large title - main headers (22px bold from Style Guide)
  static TextStyle get titleLarge => _baseFont(
    fontSize: 22,
    fontWeight: FontWeight.w700,
    height: 1.2, // 26.4px / 22px from Figma
  );
  
  /// Medium title - subsection headers (19px light from Style Guide)
  static TextStyle get titleMedium => _baseFont(
    fontSize: 19,
    fontWeight: FontWeight.w300,
    letterSpacing: 0.95,
    height: 1.26, // 24px / 19px from Figma
  );
  
  /// Small title - card headers (18px light from Style Guide)
  static TextStyle get titleSmall => _baseFont(
    fontSize: 18,
    fontWeight: FontWeight.w300,
    letterSpacing: 0.9,
    height: 1.2, // 21.6px / 18px from Figma
  );
  
  /// Product name text (14px semibold from Style Guide)
  static TextStyle get productName => _baseFont(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.56,
    height: 1.2, // 16.8px / 14px from Figma
  );
  
  /// Product price text - for pricing displays
  static TextStyle get productPrice => _baseFont(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.5,
    height: 1.2,
  );
  
  // BODY TYPOGRAPHY
  /// Large body text - main content (12px medium from Style Guide)
  static TextStyle get bodyLarge => _baseFont(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.48,
    height: 1.2, // 14.4px / 12px from Figma
  );
  
  /// Medium body text - secondary content (12px light from Style Guide)
  static TextStyle get bodyMedium => _baseFont(
    fontSize: 12,
    fontWeight: FontWeight.w300,
    letterSpacing: 0.48,
    height: 1.2, // 14.4px / 12px from Figma
  );
  
  /// Small body text - fine print (12px light from Style Guide alternate)
  static TextStyle get bodySmall => _baseFont(
    fontSize: 12,
    fontWeight: FontWeight.w300,
    height: 1.33, // 16px / 12px from Figma
  );
  
  /// UI description text - for explanatory text (12px light from Tests UI/UX)
  static TextStyle get uiDescription => _baseFont(
    fontSize: 12,
    fontWeight: FontWeight.w300,
    letterSpacing: 0.6,
    height: 1.5, // 18px / 12px from Figma
  );
  
  // UI COMPONENT TYPOGRAPHY
  /// Button text - for CTAs and interactive elements
  static TextStyle get button => _baseFont(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    letterSpacing: 1.0,
    height: 1.2,
  );
  
  /// Navigation text - for nav items and menus
  static TextStyle get navigation => _baseFont(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.8,
    height: 1.2,
  );
  
  // SPECIAL TYPOGRAPHY FOR YSL BRAND
  /// Luxury accent text - for premium product highlights (with gold color)
  static TextStyle get luxuryAccent => _baseFont(
    fontSize: 12,
    fontWeight: FontWeight.w300,
    letterSpacing: 2.0,
    height: 1.4,
    color: AppColors.yslGold,
  );
  
  /// Image overlay text - for text over images/videos
  static TextStyle get imageOverlay => _baseFont(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: 1.0,
    height: 1.3,
    color: AppColors.yslWhite,
  );
  
  // Flutter TextTheme for Material Design integration
  static TextTheme get yslTextTheme => TextTheme(
    // Use Arial display fonts for largest text
    displayLarge: brandDisplay,
    displayMedium: displaySubtitle,
    displaySmall: heroDisplay,
    // Use ITC Avant Garde Gothic Pro for headlines
    headlineLarge: sectionHeader,
    headlineMedium: titleLarge,
    headlineSmall: titleMedium,
    // Standard hierarchy
    titleLarge: titleLarge,
    titleMedium: titleMedium,
    titleSmall: titleSmall,
    // Body text hierarchy
    bodyLarge: bodyLarge,
    bodyMedium: bodyMedium,
    bodySmall: bodySmall,
    // UI text
    labelLarge: button,
    labelMedium: navigation,
    labelSmall: bodySmall,
  );

  // LEGACY SUPPORT for MCP-generated styles
  /// YslBeauté"brandWorld"Brief text style (Figma-extracted)
  /// Font: Arial, Size: 72px, Weight: 700
  static TextStyle get yslBeautbrandWorldBrief => brandDisplay;

  /// DisplaySmall text style (Figma-extracted)
  /// Font: Arial, Size: 24px, Weight: 400
  static TextStyle get displaySmall => displaySubtitle;
  
  // FIGMA-EXTRACTED STYLES (MCP generated, kept for compatibility)
  static TextStyle get displayLargeBold => heroDisplay;
  static TextStyle get headlineLargeBold => titleLarge;
  static TextStyle get headlineSmallLight => titleMedium;
  static TextStyle get bodySmallMedium => bodyLarge;
  static TextStyle get bodySmallLight => bodyMedium;
  static TextStyle get levels => heroDisplay;
  static TextStyle get colors => heroDisplay;
  static TextStyle get displayLarge => brandDisplay;
  static TextStyle get h_4LibreProductName => productName;
}
