// YSL Home Location Card - hero style for home page slider
// Closer to Figma look: large title, no description, badge on the right

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../theme/app_colors.dart';
import '../theme/app_text.dart';
import 'ysl_location_card.dart';

class YslHomeLocationCard extends StatelessWidget {
  final YslLocationData location;
  final VoidCallback? onTap;
  final double width;
  final double height;
  final EdgeInsetsGeometry? margin;

  const YslHomeLocationCard({
    super.key,
    required this.location,
    this.onTap,
    this.width = 560,
    this.height = 180,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        margin: margin ?? const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.yslWhite,
          border: Border.all(color: Colors.grey.shade300, width: 1),
          borderRadius: BorderRadius.zero,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            _buildImage(),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildTitleRow(),
                    const SizedBox(height: 8),
                    _buildExploreButton(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage() {
    return SizedBox(
      width: height, // square-ish image block
      height: height,
      child: ClipRect(
        child: location.imagePath != null
            ? Image.asset(
                location.imagePath!,
                fit: BoxFit.cover,
                width: height,
                height: height,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey.shade200,
                    child: const Icon(Icons.image, color: AppColors.yslBlack),
                  );
                },
              )
            : Container(
                color: Colors.grey.shade200,
                child: const Icon(Icons.image, color: AppColors.yslBlack),
              ),
      ),
    );
  }

  Widget _buildTitleRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Pin icon (match Figma feel using existing SVG)
        SizedBox(
          width: 20,
          height: 20,
          child: SvgPicture.asset(
            _getPinAssetPath(),
            width: 50,
            height: 50,
          ),
        ),
        const SizedBox(width: 12),
        // Title
        Expanded(
          child: Text(
            location.name.toUpperCase(),
            style: AppText.titleLarge.copyWith(
              color: AppColors.yslBlack,
              fontWeight: FontWeight.w400,
              fontSize: 12,
              fontFamily: 'ITC Avant Garde Gothic Pro',
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 10),
        // Trailing badge (simple N badge)
      ],
    );
  }

  // ignore: unused_element
  Widget _buildBadge(String text) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF9C623), // yellow fill hint
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
        border: Border.all(color: const Color(0xFF1F8A70), width: 4), // green ring hint
      ),
      padding: const EdgeInsets.all(6),
      child: Center(
        child: Text(
          text,
          style: AppText.bodySmall.copyWith(
            color: AppColors.yslBlack,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  Widget _buildExploreButton() {
    return Container(
      height: 28,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: const BoxDecoration(
        color: AppColors.yslBlack,
        borderRadius: BorderRadius.zero,
      ),
      child: Center(
        child: Text(
          'EXPLORE',
          style: AppText.bodySmall.copyWith(
            color: AppColors.yslWhite,
            letterSpacing: 0.8,
            fontWeight: FontWeight.w600,
            fontFamily: 'ITC Avant Garde Gothic Pro',
            fontSize: 10,
          ),
        ),
      ),
    );
  }

  String _getPinAssetPath() {
    switch (location.pinVariation) {
      case PinVariation.pinA:
        return 'assets/svgs/icons/pin_a.svg';
      case PinVariation.pinB:
        return 'assets/svgs/icons/pin_b.svg';
      case PinVariation.pinC:
        return 'assets/svgs/icons/pin_c.svg';
    }
  }
}