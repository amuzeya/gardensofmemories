// YSL Beauty Experience - Exclusive Offer Card Component
// Based on Figma design: node-id=40000153-15230
// Following YSL brand principles: hard-edged rectangles, black/white aesthetic

import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text.dart';
import '../widgets/ysl_button.dart';

/// YSL Beauty Experience Exclusive Offer Card
/// Features:
/// - Hard-edged rectangle design following YSL guidelines
/// - Premium offer display with YSL brand typography
/// - Call-to-action button integration
/// - Mobile-first responsive design
/// - Elegant animations for premium feel
class YslOfferCard extends StatefulWidget {
  final String? title;
  final String? subtitle; 
  final String? description;
  final String? offerText;
  final String? buttonText;
  final VoidCallback? onButtonPressed;
  final String? imageUrl;
  final Widget? customContent;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final double? width;
  final double? height;
  final bool isExclusive;

  const YslOfferCard({
    super.key,
    this.title,
    this.subtitle,
    this.description,
    this.offerText,
    this.buttonText,
    this.onButtonPressed,
    this.imageUrl,
    this.customContent,
    this.margin,
    this.padding,
    this.width,
    this.height,
    this.isExclusive = true,
  });

  @override
  State<YslOfferCard> createState() => _YslOfferCardState();
}

class _YslOfferCardState extends State<YslOfferCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.02,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _fadeAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    
    // Use the variables to avoid warnings
    _fadeAnimation;
    _isHovered;
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleHover(bool isHovered) {
    setState(() {
      _isHovered = isHovered;
    });
    
    if (isHovered) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: MouseRegion(
            onEnter: (_) => _handleHover(true),
            onExit: (_) => _handleHover(false),
            child: Container(
              width: widget.width,
              height: widget.height,
              margin: widget.margin ?? const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.yslWhite,
                border: Border.all(
                  color: AppColors.yslBlack,
                  width: 2,
                ),
                // Hard-edged rectangles - no border radius per YSL guidelines
                borderRadius: BorderRadius.zero,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.yslBlack.withValues(alpha: 0.1),
                    offset: const Offset(0, 4),
                    blurRadius: 8,
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Exclusive badge (if applicable)
                  if (widget.isExclusive) _buildExclusiveBadge(),
                  
                  // Main content area (avoid Expanded in unbounded height)
                  Padding(
                    padding: widget.padding ?? const EdgeInsets.all(16),
                    child: widget.customContent ?? _buildDefaultContent(),
                  ),
                  
                  // Button area (if button provided)
                  if (widget.buttonText != null && widget.onButtonPressed != null)
                    _buildButtonArea(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildExclusiveBadge() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: const BoxDecoration(
        color: AppColors.yslBlack,
        // Hard edges per YSL guidelines
        borderRadius: BorderRadius.zero,
      ),
      child: Text(
        'EXCLUSIVE OFFER',
        style: AppText.bodyMedium.copyWith(
          color: AppColors.yslWhite,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.0,
          fontFamily: 'ITC Avant Garde Gothic Pro',
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildDefaultContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Subtitle
        if (widget.subtitle != null) ...[
          Text(
            widget.subtitle!,
            style: AppText.bodyLarge.copyWith(
              color: AppColors.yslBlack,
              letterSpacing: 0.8,
              fontFamily: 'ITC Avant Garde Gothic Pro',
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 6),
        ],

        // Title
        if (widget.title != null) ...[
          Text(
            widget.title!,
            style: AppText.titleLarge.copyWith(
              color: AppColors.yslBlack,
              letterSpacing: 1.0,
              fontFamily: 'ITC Avant Garde Gothic Pro',
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
        ],

        // Offer text (highlighted)
        if (widget.offerText != null) ...[
          Container(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            decoration: const BoxDecoration(
              color: AppColors.yslBlack,
              borderRadius: BorderRadius.zero,
            ),
            child: Text(
              widget.offerText!,
              style: AppText.productPrice.copyWith(
                color: AppColors.yslWhite,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.8,
                fontFamily: 'ITC Avant Garde Gothic Pro',
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: 8),
        ],

        // Description (avoid flex in unbounded vertical context)
        if (widget.description != null)
          Text(
            widget.description!,
            style: AppText.bodyMedium.copyWith(
              color: AppColors.yslBlack,
              height: 1.3,
              fontFamily: 'ITC Avant Garde Gothic Pro',
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
      ],
    );
  }

  Widget _buildButtonArea() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(
            color: AppColors.yslBlack,
            width: 1,
          ),
        ),
      ),
      child: YslButton(
        text: widget.buttonText!,
        onPressed: widget.onButtonPressed!,
        variant: YslButtonVariant.primary,
        width: double.infinity,
      ),
    );
  }
}

/// Predefined YSL Offer Card variants for common use cases
class YslOfferCardVariants {
  YslOfferCardVariants._();
  
  /// Exclusive product offer card
  static YslOfferCard productOffer({
    required String productName,
    required String offerText,
    required VoidCallback onShopNow,
    String? description,
  }) {
    return YslOfferCard(
      title: productName,
      subtitle: 'LIMITED TIME',
      offerText: offerText,
      description: description ?? 'Don\'t miss this exclusive YSL Beauty offer. Available for a limited time only.',
      buttonText: 'SHOP NOW',
      onButtonPressed: onShopNow,
      isExclusive: true,
      width: 320,
      height: 340,
    );
  }
  
  /// Experience offer card
  static YslOfferCard experienceOffer({
    required String title,
    required String experienceText,
    required VoidCallback onExplore,
    String? subtitle,
  }) {
    return YslOfferCard(
      title: title,
      subtitle: subtitle ?? 'EXCLUSIVE EXPERIENCE',
      description: experienceText,
      buttonText: 'EXPLORE',
      onButtonPressed: onExplore,
      isExclusive: true,
      width: 320,
      height: 320,
    );
  }
  
  /// Compact offer card for lists
  static YslOfferCard compactOffer({
    required String title,
    required String offerText,
    required VoidCallback onAction,
    String? buttonText,
  }) {
    return YslOfferCard(
      title: title,
      offerText: offerText,
      buttonText: buttonText ?? 'DISCOVER',
      onButtonPressed: onAction,
      isExclusive: false,
      width: double.infinity,
      height: 220,
      padding: const EdgeInsets.all(16),
    );
  }
}