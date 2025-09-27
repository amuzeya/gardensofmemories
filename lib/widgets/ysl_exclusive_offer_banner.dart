import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text.dart';

/// YSL Exclusive Offer Banner Component
/// 
/// A banner component that typically appears at the top of screens to announce
/// exclusive offers. Features YSL brand styling with text and a decorative icon.
class YslExclusiveOfferBanner extends StatelessWidget {
  final String text;
  final String? subText;
  final VoidCallback? onTap;
  final IconData? icon;
  final bool isCloseable;
  final VoidCallback? onClose;

  const YslExclusiveOfferBanner({
    super.key,
    required this.text,
    this.subText,
    this.onTap,
    this.icon,
    this.isCloseable = false,
    this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: const BoxDecoration(
          color: AppColors.yslBlack,
          // Hard edges per YSL guidelines
          borderRadius: BorderRadius.zero,
        ),
        child: Row(
          children: [
            // Main text content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    text.toUpperCase(),
                    style: AppText.bodyMedium.copyWith(
                      color: AppColors.yslWhite,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.8,
                      fontFamily: 'ITC Avant Garde Gothic Pro',
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (subText != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      subText!.toUpperCase(),
                      style: AppText.bodySmall.copyWith(
                        color: AppColors.yslWhite.withValues(alpha: 0.8),
                        fontWeight: FontWeight.w400,
                        letterSpacing: 0.5,
                        fontFamily: 'ITC Avant Garde Gothic Pro',
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
            
            // Right side icon
            if (icon != null) ...[
              const SizedBox(width: 12),
              Icon(
                icon!,
                color: AppColors.yslWhite,
                size: 16,
              ),
            ],
            
            // Close button (if closeable)
            if (isCloseable) ...[
              const SizedBox(width: 12),
              GestureDetector(
                onTap: onClose,
                child: const Icon(
                  Icons.close,
                  color: AppColors.yslWhite,
                  size: 16,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Predefined YSL Exclusive Offer Banner variants
class YslExclusiveOfferBannerVariants {
  YslExclusiveOfferBannerVariants._();
  
  /// Free shipping offer banner
  static YslExclusiveOfferBanner freeShipping({
    VoidCallback? onTap,
    bool isCloseable = false,
    VoidCallback? onClose,
  }) {
    return YslExclusiveOfferBanner(
      text: 'FREE SHIPPING ON ALL ORDERS',
      subText: 'No minimum purchase required',
      icon: Icons.local_shipping_outlined,
      onTap: onTap,
      isCloseable: isCloseable,
      onClose: onClose,
    );
  }
  
  /// Limited time offer banner
  static YslExclusiveOfferBanner limitedOffer({
    required String offerText,
    String? timeText,
    VoidCallback? onTap,
    bool isCloseable = false,
    VoidCallback? onClose,
  }) {
    return YslExclusiveOfferBanner(
      text: offerText,
      subText: timeText ?? 'Limited time only',
      icon: Icons.access_time_outlined,
      onTap: onTap,
      isCloseable: isCloseable,
      onClose: onClose,
    );
  }
  
  /// Exclusive access banner
  static YslExclusiveOfferBanner exclusiveAccess({
    String? experienceText,
    VoidCallback? onTap,
    bool isCloseable = false,
    VoidCallback? onClose,
  }) {
    return YslExclusiveOfferBanner(
      text: experienceText ?? 'EXCLUSIVE ACCESS AVAILABLE',
      subText: 'Members only experience',
      icon: Icons.star_outline,
      onTap: onTap,
      isCloseable: isCloseable,
      onClose: onClose,
    );
  }
  
  /// New arrival announcement banner
  static YslExclusiveOfferBanner newArrival({
    String? productText,
    VoidCallback? onTap,
    bool isCloseable = false,
    VoidCallback? onClose,
  }) {
    return YslExclusiveOfferBanner(
      text: productText ?? 'NEW ARRIVALS NOW AVAILABLE',
      subText: 'Discover the latest collection',
      icon: Icons.fiber_new_outlined,
      onTap: onTap,
      isCloseable: isCloseable,
      onClose: onClose,
    );
  }
  
  /// Figma-exact offer banner with plus icon (no subtext)
  static YslExclusiveOfferBanner figmaOffer({
    required String offerText,
    VoidCallback? onTap,
    bool isCloseable = false,
    VoidCallback? onClose,
  }) {
    return YslExclusiveOfferBanner(
      text: offerText,
      // No subText - exactly like Figma
      icon: Icons.add,
      onTap: onTap,
      isCloseable: isCloseable,
      onClose: onClose,
    );
  }
}
