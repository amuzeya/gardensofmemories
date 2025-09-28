// YSL Beauty Experience - Responsive Layout Utilities
// Provides screen size calculations and responsive parameters
// Following YSL brand principles: elegant layouts that adapt gracefully

import 'package:flutter/material.dart';

/// Responsive breakpoints for YSL Beauty Experience
class YslBreakpoints {
  static const double mobile = 480;
  static const double tablet = 768;
  static const double desktop = 1024;
  static const double widescreen = 1440;
}

/// Responsive utilities for calculating layout parameters
class YslResponsiveUtils {
  YslResponsiveUtils._();

  /// Get device type based on screen width
  static YslDeviceType getDeviceType(double width) {
    if (width < YslBreakpoints.mobile) {
      return YslDeviceType.mobile;
    } else if (width < YslBreakpoints.tablet) {
      return YslDeviceType.mobileLarge;
    } else if (width < YslBreakpoints.desktop) {
      return YslDeviceType.tablet;
    } else if (width < YslBreakpoints.widescreen) {
      return YslDeviceType.desktop;
    } else {
      return YslDeviceType.widescreen;
    }
  }

  /// Calculate responsive location slider parameters
  static YslLocationSliderResponsive getLocationSliderParams(
    BuildContext context,
    YslDeviceType deviceType,
    bool isMapView,
  ) {
    final screenWidth = MediaQuery.of(context).size.width;
    
    switch (deviceType) {
      case YslDeviceType.mobile:
        return YslLocationSliderResponsive(
          cardWidth: screenWidth * 0.8, // 80% of screen for mobile
          cardSpacing: 12,
          visibleCards: 1.2,
          height: isMapView ? 100 : 160,
          viewportFraction: 0.85,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          showArrows: false,
        );

      case YslDeviceType.mobileLarge:
        return YslLocationSliderResponsive(
          cardWidth: screenWidth * 0.75,
          cardSpacing: 14,
          visibleCards: 1.3,
          height: isMapView ? 100 : 160,
          viewportFraction: 0.82,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          showArrows: false,
        );

      case YslDeviceType.tablet:
        return YslLocationSliderResponsive(
          cardWidth: 300,
          cardSpacing: 16,
          visibleCards: 2.2,
          height: isMapView ? 110 : 170,
          viewportFraction: 0.5,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          showArrows: true,
        );

      case YslDeviceType.desktop:
        return YslLocationSliderResponsive(
          cardWidth: 320,
          cardSpacing: 20,
          visibleCards: 3.2,
          height: isMapView ? 120 : 180,
          viewportFraction: 0.33,
          padding: const EdgeInsets.symmetric(horizontal: 24),
          showArrows: true,
        );

      case YslDeviceType.widescreen:
        return YslLocationSliderResponsive(
          cardWidth: 350,
          cardSpacing: 24,
          visibleCards: 4.2,
          height: isMapView ? 130 : 190,
          viewportFraction: 0.25,
          padding: const EdgeInsets.symmetric(horizontal: 32),
          showArrows: true,
        );
    }
  }

  /// Calculate responsive hero header parameters
  static YslHeroHeaderResponsive getHeroHeaderParams(
    BuildContext context,
    YslDeviceType deviceType,
  ) {
    switch (deviceType) {
      case YslDeviceType.mobile:
        return const YslHeroHeaderResponsive(
          logoHeight: 32,
          titleFontSize: 24,
          subtitleFontSize: 12,
          descriptionFontSize: 14,
          maxDescriptionWidth: 300,
          padding: EdgeInsets.all(16),
          spacing: 12,
        );

      case YslDeviceType.mobileLarge:
        return const YslHeroHeaderResponsive(
          logoHeight: 36,
          titleFontSize: 26,
          subtitleFontSize: 12,
          descriptionFontSize: 15,
          maxDescriptionWidth: 350,
          padding: EdgeInsets.all(18),
          spacing: 14,
        );

      case YslDeviceType.tablet:
        return const YslHeroHeaderResponsive(
          logoHeight: 40,
          titleFontSize: 28,
          subtitleFontSize: 13,
          descriptionFontSize: 16,
          maxDescriptionWidth: 400,
          padding: EdgeInsets.all(20),
          spacing: 16,
        );

      case YslDeviceType.desktop:
        return const YslHeroHeaderResponsive(
          logoHeight: 44,
          titleFontSize: 32,
          subtitleFontSize: 14,
          descriptionFontSize: 18,
          maxDescriptionWidth: 500,
          padding: EdgeInsets.all(24),
          spacing: 18,
        );

      case YslDeviceType.widescreen:
        return const YslHeroHeaderResponsive(
          logoHeight: 48,
          titleFontSize: 36,
          subtitleFontSize: 15,
          descriptionFontSize: 20,
          maxDescriptionWidth: 600,
          padding: EdgeInsets.all(28),
          spacing: 20,
        );
    }
  }

  /// Calculate list view responsive parameters
  static YslListViewResponsive getListViewParams(
    BuildContext context,
    YslDeviceType deviceType,
  ) {
    final screenWidth = MediaQuery.of(context).size.width;

    switch (deviceType) {
      case YslDeviceType.mobile:
        return YslListViewResponsive(
          itemHeight: 140,
          itemSpacing: 12,
          padding: const EdgeInsets.all(16),
          crossAxisCount: 1,
          maxWidth: screenWidth,
        );

      case YslDeviceType.mobileLarge:
        return YslListViewResponsive(
          itemHeight: 150,
          itemSpacing: 14,
          padding: const EdgeInsets.all(16),
          crossAxisCount: 1,
          maxWidth: screenWidth,
        );

      case YslDeviceType.tablet:
        return YslListViewResponsive(
          itemHeight: 160,
          itemSpacing: 16,
          padding: const EdgeInsets.all(20),
          crossAxisCount: screenWidth > 900 ? 2 : 1,
          maxWidth: screenWidth > 900 ? screenWidth * 0.48 : screenWidth,
        );

      case YslDeviceType.desktop:
        return YslListViewResponsive(
          itemHeight: 170,
          itemSpacing: 18,
          padding: const EdgeInsets.all(24),
          crossAxisCount: 2,
          maxWidth: screenWidth * 0.48,
        );

      case YslDeviceType.widescreen:
        return YslListViewResponsive(
          itemHeight: 180,
          itemSpacing: 20,
          padding: const EdgeInsets.all(32),
          crossAxisCount: 3,
          maxWidth: screenWidth * 0.32,
        );
    }
  }

  /// Check if content will overflow and suggest adjustments
  static bool willOverflow({
    required double containerWidth,
    required double cardWidth,
    required double cardSpacing,
    required int cardCount,
  }) {
    final totalWidth = (cardWidth * cardCount) + (cardSpacing * (cardCount - 1));
    return totalWidth > containerWidth;
  }

  /// Calculate safe card parameters to prevent overflow
  static YslSafeCardParams getSafeCardParams({
    required double containerWidth,
    required int desiredCardCount,
    required double minCardWidth,
    required double defaultSpacing,
  }) {
    final availableWidth = containerWidth - (defaultSpacing * 2); // Account for padding
    final spacingTotal = defaultSpacing * (desiredCardCount - 1);
    final cardAreaWidth = availableWidth - spacingTotal;
    final calculatedCardWidth = cardAreaWidth / desiredCardCount;

    if (calculatedCardWidth < minCardWidth) {
      // Reduce card count if cards would be too small
      final adjustedCount = (cardAreaWidth / minCardWidth).floor();
      final finalCardWidth = (cardAreaWidth - (defaultSpacing * (adjustedCount - 1))) / adjustedCount;
      
      return YslSafeCardParams(
        cardWidth: finalCardWidth.clamp(minCardWidth, containerWidth * 0.9),
        cardCount: adjustedCount.clamp(1, desiredCardCount),
        spacing: defaultSpacing,
      );
    }

    return YslSafeCardParams(
      cardWidth: calculatedCardWidth,
      cardCount: desiredCardCount,
      spacing: defaultSpacing,
    );
  }
}

/// Device type enumeration
enum YslDeviceType {
  mobile,
  mobileLarge,
  tablet,
  desktop,
  widescreen,
}

/// Location slider responsive parameters
class YslLocationSliderResponsive {
  final double cardWidth;
  final double cardSpacing;
  final double visibleCards;
  final double height;
  final double viewportFraction;
  final EdgeInsetsGeometry padding;
  final bool showArrows;

  const YslLocationSliderResponsive({
    required this.cardWidth,
    required this.cardSpacing,
    required this.visibleCards,
    required this.height,
    required this.viewportFraction,
    required this.padding,
    required this.showArrows,
  });
}

/// Hero header responsive parameters
class YslHeroHeaderResponsive {
  final double logoHeight;
  final double titleFontSize;
  final double subtitleFontSize;
  final double descriptionFontSize;
  final double maxDescriptionWidth;
  final EdgeInsetsGeometry padding;
  final double spacing;

  const YslHeroHeaderResponsive({
    required this.logoHeight,
    required this.titleFontSize,
    required this.subtitleFontSize,
    required this.descriptionFontSize,
    required this.maxDescriptionWidth,
    required this.padding,
    required this.spacing,
  });
}

/// List view responsive parameters
class YslListViewResponsive {
  final double itemHeight;
  final double itemSpacing;
  final EdgeInsetsGeometry padding;
  final int crossAxisCount;
  final double maxWidth;

  const YslListViewResponsive({
    required this.itemHeight,
    required this.itemSpacing,
    required this.padding,
    required this.crossAxisCount,
    required this.maxWidth,
  });
}

/// Safe card calculation parameters
class YslSafeCardParams {
  final double cardWidth;
  final int cardCount;
  final double spacing;

  const YslSafeCardParams({
    required this.cardWidth,
    required this.cardCount,
    required this.spacing,
  });
}