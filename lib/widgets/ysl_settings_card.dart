// YSL Beauty Experience - Settings Card Component
// Based on Figma designs: Settings/Preferences card with toggle functionality
// Following YSL brand principles: clean typography, structured layouts, elegant spacing

import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text.dart';
import 'ysl_toggle_switch.dart';

/// YSL Settings Card Widget
/// Features:
/// - Clean card layout with title and description
/// - Integrated YSL toggle switch
/// - Customizable content and toggle options
/// - YSL brand styling throughout
/// - Optional padding and margin control
class YslSettingsCard extends StatelessWidget {
  final String title;
  final String? description;
  final YslToggleOption selectedToggleOption;
  final ValueChanged<YslToggleOption> onToggleChanged;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? backgroundColor;
  final double? width;
  final String? toggleLabel;
  final bool showToggleLabel;

  const YslSettingsCard({
    super.key,
    required this.title,
    this.description,
    required this.selectedToggleOption,
    required this.onToggleChanged,
    this.padding,
    this.margin,
    this.backgroundColor,
    this.width,
    this.toggleLabel,
    this.showToggleLabel = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      margin: margin ?? const EdgeInsets.symmetric(vertical: 8),
      padding: padding ?? const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.yslWhite,
        border: Border.all(
          color: AppColors.yslBlack,
          width: 1,
        ),
        borderRadius: BorderRadius.zero, // YSL hard-edged design
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Main content section
          _buildMainContent(),
          
          const SizedBox(height: 16),
          
          // Toggle section
          _buildToggleSection(),
        ],
      ),
    );
  }

  Widget _buildMainContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
        Text(
          title.toUpperCase(),
          style: AppText.titleLarge.copyWith(
            color: AppColors.yslBlack,
            fontFamily: 'ITC Avant Garde Gothic Pro',
            fontWeight: FontWeight.w700,
            letterSpacing: 1.2,
          ),
        ),
        
        // Description (if provided)
        if (description != null) ...[
          const SizedBox(height: 8),
          Text(
            description!,
            style: AppText.bodyMedium.copyWith(
              color: AppColors.yslBlack.withValues(alpha: 0.8),
              fontFamily: 'ITC Avant Garde Gothic Pro',
              fontWeight: FontWeight.w400,
              height: 1.4,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildToggleSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Toggle label (if provided and enabled)
        if (showToggleLabel && toggleLabel != null) ...[
          Text(
            toggleLabel!.toUpperCase(),
            style: AppText.bodySmall.copyWith(
              color: AppColors.yslBlack,
              fontFamily: 'ITC Avant Garde Gothic Pro',
              fontWeight: FontWeight.w600,
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: 8),
        ],
        
        // Toggle switch - aligned to the right
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            YslToggleSwitch(
              selectedOption: selectedToggleOption,
              onToggle: onToggleChanged,
              width: 175,
              height: 45,
            ),
          ],
        ),
      ],
    );
  }
}

/// Predefined YSL Settings Card variants
class YslSettingsCardVariants {
  YslSettingsCardVariants._();

  /// Map preferences card
  static YslSettingsCard mapPreferences({
    required YslToggleOption selectedOption,
    required ValueChanged<YslToggleOption> onToggleChanged,
  }) {
    return YslSettingsCard(
      title: 'View Preferences',
      description: 'Choose how you want to view store locations and beauty experiences in your area.',
      selectedToggleOption: selectedOption,
      onToggleChanged: onToggleChanged,
      toggleLabel: 'Display Mode',
      showToggleLabel: true,
    );
  }

  /// Experience display preferences
  static YslSettingsCard experienceDisplay({
    required YslToggleOption selectedOption,
    required ValueChanged<YslToggleOption> onToggleChanged,
  }) {
    return YslSettingsCard(
      title: 'Experience Display',
      description: 'Select your preferred way to browse YSL Beauty experiences and product showcases.',
      selectedToggleOption: selectedOption,
      onToggleChanged: onToggleChanged,
      backgroundColor: AppColors.yslWhite,
    );
  }

  /// Compact settings card
  static YslSettingsCard compactSettings({
    required String title,
    required YslToggleOption selectedOption,
    required ValueChanged<YslToggleOption> onToggleChanged,
    String? description,
  }) {
    return YslSettingsCard(
      title: title,
      description: description,
      selectedToggleOption: selectedOption,
      onToggleChanged: onToggleChanged,
      padding: const EdgeInsets.all(16),
      width: 320,
    );
  }

  /// Full-width settings card
  static YslSettingsCard fullWidth({
    required String title,
    required YslToggleOption selectedOption,
    required ValueChanged<YslToggleOption> onToggleChanged,
    String? description,
    String? toggleLabel,
  }) {
    return YslSettingsCard(
      title: title,
      description: description,
      selectedToggleOption: selectedOption,
      onToggleChanged: onToggleChanged,
      toggleLabel: toggleLabel,
      showToggleLabel: toggleLabel != null,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
    );
  }

  /// Figma exact variant - based on the component structure
  static YslSettingsCard figmaExact({
    required YslToggleOption selectedOption,
    required ValueChanged<YslToggleOption> onToggleChanged,
  }) {
    return YslSettingsCard(
      title: 'Location Services',
      description: 'Enable location-based services to discover YSL Beauty experiences and store locations near you. This helps personalize your beauty journey.',
      selectedToggleOption: selectedOption,
      onToggleChanged: onToggleChanged,
      width: 393,
      padding: const EdgeInsets.all(18),
      backgroundColor: AppColors.yslWhite,
    );
  }
}