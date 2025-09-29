// YSL Beauty Experience - Content Card Component
// Reusable white content card with YSL branding and typography
// Following YSL brand principles: hard-edged rectangles, elegant typography

import 'package:flutter/material.dart';
import '../theme/app_text.dart';
import '../theme/app_colors.dart';
import '../widgets/ysl_button.dart';

/// YSL Content Card Widget
/// Features:
/// - Hard-edged white container following YSL guidelines
/// - Proper padding and spacing
/// - Support for title, subtitle, and CTA button
/// - Consistent with YSL brand aesthetic
class YslContentCard extends StatelessWidget {
  final String? subtitle;
  final String? title;
  final String? description;
  final String? buttonText;
  final VoidCallback? onButtonPressed;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final List<Widget>? customContent;

  const YslContentCard({
    super.key,
    this.subtitle,
    this.title,
    this.description,
    this.buttonText,
    this.onButtonPressed,
    this.padding,
    this.margin,
    this.customContent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: margin ?? const EdgeInsets.all(0),
      padding:
          padding ?? const EdgeInsets.symmetric(horizontal: 30, vertical: 50),
      clipBehavior: Clip.antiAlias,
      decoration: const BoxDecoration(
        color: AppColors.yslWhite,
        borderRadius: BorderRadius.zero, // Hard edges per YSL brand
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Text content section
          if (subtitle != null || title != null) _buildTextContent(),

          // Custom content
          if (customContent != null) ...[
            const SizedBox(height: 24),
            ...customContent!,
          ],

          // Button section
          if (buttonText != null && onButtonPressed != null) ...[
            const SizedBox(height: 24),
            _buildButton(),
          ],
        ],
      ),
    );
  }

  Widget _buildTextContent() {
    return SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Subtitle
          if (subtitle != null) ...[
            SizedBox(
              width: double.infinity,
              child: Text(
                subtitle!,
                textAlign: TextAlign.center,
                style: AppText.bodyLarge.copyWith(
                  color: AppColors.yslBlack,
                  letterSpacing: 0.60,
                  height: 1.50,
                  fontSize: 12,
                ),
              ),
            ),
            const SizedBox(height: 15),
          ],

          // Title
          if (title != null)
            SizedBox(
              width: double.infinity, // Adjusting for left padding
              child: Text(
                title!,
                textAlign: TextAlign.center,
                style: AppText.titleLarge.copyWith(color: AppColors.yslBlack),
              ),
            ),

          SizedBox(height: 20,),

          if (description != null)
            SizedBox(
              width: double.infinity,
              child: Text(
                description!,
                textAlign: TextAlign.center,
                style: AppText.bodySmallLight.copyWith(
                  color: AppColors.yslBlack,
                  letterSpacing: 0.60,
                  height: 1.50,
                  fontSize: 12,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildButton() {
    return YslButton(
      text: buttonText!,
      onPressed: onButtonPressed!,
      variant: YslButtonVariant.light,
      // Using lighter font weight variant
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 20),
    );
  }
}
