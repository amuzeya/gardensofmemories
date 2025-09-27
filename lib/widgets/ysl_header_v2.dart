import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../theme/app_colors.dart';
import '../theme/app_text.dart';

/// YSL Header V2 Component
/// 
/// A vertical header component featuring the YSL BEAUTÉ logo on top
/// and a title text below. Perfect for screen headers and content sections.
class YslHeaderV2 extends StatelessWidget {
  final String title;
  final Color backgroundColor;
  final double logoHeight;
  final TextStyle? titleStyle;
  final EdgeInsetsGeometry? padding;
  final MainAxisAlignment alignment;
  final double spacing;

  const YslHeaderV2({
    Key? key,
    required this.title,
    this.backgroundColor = AppColors.yslWhite,
    this.logoHeight = 28,
    this.titleStyle,
    this.padding,
    this.alignment = MainAxisAlignment.center,
    this.spacing = 12,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: backgroundColor,
        // Hard edges per YSL guidelines
        borderRadius: BorderRadius.zero,
      ),
      padding: padding ?? const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: alignment,
        mainAxisSize: MainAxisSize.min,
        children: [
          // YSL BEAUTÉ Logo
          SvgPicture.asset(
            'assets/svgs/logos/state_logo_beaut_on.svg',
            height: logoHeight,
            colorFilter: const ColorFilter.mode(
              AppColors.yslBlack,
              BlendMode.srcIn,
            ),
          ),
          
          SizedBox(height: spacing),
          
          // Title Text
          Text(
            title.toUpperCase(),
            style: titleStyle ?? AppText.sectionHeader.copyWith(
              color: AppColors.yslBlack,
              letterSpacing: 1.2,
              fontFamily: 'ITC Avant Garde Gothic Pro',
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

/// Predefined YSL Header V2 variants for common use cases
class YslHeaderV2Variants {
  YslHeaderV2Variants._();

  /// Gardens of Memories header (matching Figma)
  static YslHeaderV2 gardensOfMemories() {
    return const YslHeaderV2(
      title: 'GARDENS OF MEMORIES',
      logoHeight: 24,
      spacing: 10,
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
    );
  }

  /// Experience header variant
  static YslHeaderV2 experienceHeader({
    required String title,
    double? logoHeight,
    EdgeInsetsGeometry? padding,
  }) {
    return YslHeaderV2(
      title: title,
      logoHeight: logoHeight ?? 28,
      spacing: 12,
      padding: padding ?? const EdgeInsets.all(20),
    );
  }

  /// Compact header variant
  static YslHeaderV2 compactHeader({
    required String title,
    EdgeInsetsGeometry? padding,
  }) {
    return YslHeaderV2(
      title: title,
      logoHeight: 20,
      spacing: 8,
      padding: padding ?? const EdgeInsets.all(12),
      titleStyle: AppText.titleMedium.copyWith(
        color: AppColors.yslBlack,
        letterSpacing: 1.0,
        fontFamily: 'ITC Avant Garde Gothic Pro',
        fontWeight: FontWeight.w600,
      ),
    );
  }

  /// Hero header variant
  static YslHeaderV2 heroHeader({
    required String title,
    EdgeInsetsGeometry? padding,
  }) {
    return YslHeaderV2(
      title: title,
      logoHeight: 32,
      spacing: 16,
      padding: padding ?? const EdgeInsets.all(24),
      titleStyle: AppText.heroDisplay.copyWith(
        color: AppColors.yslBlack,
        letterSpacing: 1.5,
        fontFamily: 'ITC Avant Garde Gothic Pro',
        fontWeight: FontWeight.w700,
      ),
    );
  }

  /// Product header variant
  static YslHeaderV2 productHeader({
    required String productName,
    EdgeInsetsGeometry? padding,
  }) {
    return YslHeaderV2(
      title: productName,
      logoHeight: 24,
      spacing: 10,
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      titleStyle: AppText.productName.copyWith(
        color: AppColors.yslBlack,
        letterSpacing: 1.0,
        fontFamily: 'ITC Avant Garde Gothic Pro',
        fontWeight: FontWeight.w600,
      ),
    );
  }
}