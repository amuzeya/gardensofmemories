// YSL Beauty Experience - Complete Theme Configuration
// Based on YSL Beauty brand guidelines: Hard-edged rectangles, black & white, elegant experience

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_colors.dart';
import 'app_text.dart';

/// Complete theme configuration for YSL Beauty Experience
/// Following brand guidelines: consistent with YSL site/Instagram aesthetic
class AppTheme {
  AppTheme._(); // Private constructor

  /// Light theme - primary YSL experience (white background, black text)
  static ThemeData get lightTheme {
    return ThemeData.from(
      colorScheme: AppColors.lightColorScheme,
    ).copyWith(
      // Visual identity
      visualDensity: VisualDensity.adaptivePlatformDensity,
      
      // Scaffold & background
      scaffoldBackgroundColor: AppColors.yslWhite,
      canvasColor: AppColors.yslWhite,
      
      // App bar theme - black header with white text (YSL signature)
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.yslBlack,
        foregroundColor: AppColors.yslWhite,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleSpacing: 20,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        iconTheme: IconThemeData(
          color: AppColors.yslWhite,
          size: 24,
        ),
        actionsIconTheme: IconThemeData(
          color: AppColors.yslWhite,
          size: 24,
        ),
      ),
      
      // Typography
      textTheme: AppText.yslTextTheme,
      primaryTextTheme: AppText.yslTextTheme,
      
      // Card theme - hard-edged rectangles (no rounded corners)
      cardTheme: const CardThemeData(
        color: AppColors.yslWhite,
        shadowColor: AppColors.overlayLight,
        elevation: 2,
        margin: EdgeInsets.all(8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.zero, // Hard edges per brand guideline
        ),
      ),
      
      // Button themes - hard-edged, high contrast
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.yslBlack,
          foregroundColor: AppColors.yslWhite,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.zero, // Hard edges
          ),
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          textStyle: AppText.button,
        ),
      ),
      
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.yslBlack,
          side: const BorderSide(color: AppColors.yslBlack, width: 2),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.zero, // Hard edges
          ),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          textStyle: AppText.button,
        ),
      ),
      
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.yslBlack,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.zero, // Hard edges
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          textStyle: AppText.navigation,
        ),
      ),
      
      // Gold accent for special CTAs
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.yslGold,
        foregroundColor: AppColors.yslBlack,
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.zero, // Hard edges
        ),
      ),
      
      // Input decoration - minimalist, hard-edged
      inputDecorationTheme: const InputDecorationTheme(
        filled: false,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.zero, // Hard edges
          borderSide: BorderSide(color: AppColors.yslBlack, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide(color: AppColors.grey400, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide(color: AppColors.yslBlack, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide(color: AppColors.error, width: 2),
        ),
        labelStyle: TextStyle(color: AppColors.grey600),
        hintStyle: TextStyle(color: AppColors.grey500),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      
      // Bottom navigation - minimal, elegant
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.yslWhite,
        selectedItemColor: AppColors.yslBlack,
        unselectedItemColor: AppColors.grey500,
        elevation: 8,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        unselectedLabelStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
      ),
      
      // Divider theme
      dividerTheme: const DividerThemeData(
        color: AppColors.grey300,
        thickness: 1,
        space: 1,
      ),
      
      // Chip theme - for tags and filters
      chipTheme: const ChipThemeData(
        backgroundColor: AppColors.grey100,
        deleteIconColor: AppColors.yslBlack,
        disabledColor: AppColors.grey200,
        selectedColor: AppColors.yslBlack,
        secondarySelectedColor: AppColors.yslGold,
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        labelStyle: TextStyle(color: AppColors.yslBlack),
        secondaryLabelStyle: TextStyle(color: AppColors.yslWhite),
        brightness: Brightness.light,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.zero, // Hard edges
        ),
      ),
      
      // Progress indicators
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.yslBlack,
        linearTrackColor: AppColors.grey200,
        circularTrackColor: AppColors.grey200,
      ),
      
      // Dialog theme
      dialogTheme: const DialogThemeData(
        backgroundColor: AppColors.yslWhite,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.zero, // Hard edges
        ),
        elevation: 16,
        titleTextStyle: TextStyle(
          color: AppColors.yslBlack,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        contentTextStyle: TextStyle(
          color: AppColors.yslBlack,
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
      ),
      
      // Snackbar theme
      snackBarTheme: const SnackBarThemeData(
        backgroundColor: AppColors.yslBlack,
        contentTextStyle: TextStyle(
          color: AppColors.yslWhite,
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
        actionTextColor: AppColors.yslGold,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.zero, // Hard edges
        ),
        elevation: 8,
      ),
    );
  }

  /// Dark theme - premium night mode (black background, white text)
  static ThemeData get darkTheme {
    return ThemeData.from(
      colorScheme: AppColors.darkColorScheme,
    ).copyWith(
      // Visual identity
      visualDensity: VisualDensity.adaptivePlatformDensity,
      
      // Scaffold & background - inverted
      scaffoldBackgroundColor: AppColors.yslBlack,
      canvasColor: AppColors.yslBlack,
      
      // App bar theme - white header with black text (inverted)
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.yslWhite,
        foregroundColor: AppColors.yslBlack,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleSpacing: 20,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        iconTheme: IconThemeData(
          color: AppColors.yslBlack,
          size: 24,
        ),
        actionsIconTheme: IconThemeData(
          color: AppColors.yslBlack,
          size: 24,
        ),
      ),
      
      // Typography with inverted colors
      textTheme: AppText.yslTextTheme.apply(
        bodyColor: AppColors.yslWhite,
        displayColor: AppColors.yslWhite,
      ),
      primaryTextTheme: AppText.yslTextTheme.apply(
        bodyColor: AppColors.yslWhite,
        displayColor: AppColors.yslWhite,
      ),
      
      // Card theme - dark mode
      cardTheme: const CardThemeData(
        color: AppColors.grey900,
        shadowColor: Color(0x80000000),
        elevation: 4,
        margin: EdgeInsets.all(8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.zero, // Hard edges per brand guideline
        ),
      ),
      
      // Button themes - inverted colors
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.yslWhite,
          foregroundColor: AppColors.yslBlack,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.zero, // Hard edges
          ),
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          textStyle: AppText.button.copyWith(color: AppColors.yslBlack),
        ),
      ),
      
      // Input decoration - dark mode
      inputDecorationTheme: const InputDecorationTheme(
        filled: false,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.zero, // Hard edges
          borderSide: BorderSide(color: AppColors.yslWhite, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide(color: AppColors.grey600, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide(color: AppColors.yslWhite, width: 2),
        ),
        labelStyle: TextStyle(color: AppColors.grey400),
        hintStyle: TextStyle(color: AppColors.grey500),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      
      // Bottom navigation - dark mode
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.yslBlack,
        selectedItemColor: AppColors.yslWhite,
        unselectedItemColor: AppColors.grey500,
        elevation: 8,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
  
  /// System UI overlay styles for different contexts
  static const SystemUiOverlayStyle yslLightOverlay = SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
    statusBarBrightness: Brightness.light,
    systemNavigationBarColor: AppColors.yslWhite,
    systemNavigationBarIconBrightness: Brightness.dark,
  );
  
  static const SystemUiOverlayStyle yslDarkOverlay = SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    statusBarBrightness: Brightness.dark,
    systemNavigationBarColor: AppColors.yslBlack,
    systemNavigationBarIconBrightness: Brightness.light,
  );
  
  /// For image/video overlay contexts
  static const SystemUiOverlayStyle yslImageOverlay = SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    statusBarBrightness: Brightness.dark,
    systemNavigationBarColor: Colors.transparent,
    systemNavigationBarIconBrightness: Brightness.light,
  );
}