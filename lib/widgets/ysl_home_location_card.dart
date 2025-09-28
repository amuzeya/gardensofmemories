// YSL Home Location Card - hero style for home page slider
// Closer to Figma look: large title, no description, badge on the right

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../theme/app_colors.dart';
import '../theme/app_text.dart';
import 'ysl_location_card.dart';

enum YslCardViewType { mapView, listView }

class YslHomeLocationCard extends StatelessWidget {
  final YslLocationData location;
  final VoidCallback? onTap;
  final double width;
  final double height;
  final EdgeInsetsGeometry? margin;
  final bool isVertical;
  final YslCardViewType viewType;

  const YslHomeLocationCard({
    super.key,
    required this.location,
    this.onTap,
    this.width = 560,
    this.height = 180,
    this.margin,
    this.isVertical = false,
    this.viewType = YslCardViewType.mapView,
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
        child: isVertical 
            ? _buildVerticalLayout() 
            : (viewType == YslCardViewType.mapView 
                ? _buildMapViewLayout() 
                : _buildListViewLayout()),
      ),
    );
  }

  // Compact layout for map view slider (fits in 100px height)
  Widget _buildMapViewLayout() {
    return Row(
      children: [
        _buildImage(),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTitleRow(),
                SizedBox(height: 8.0,),
                // Compact explore button - no description in map view
                Align(
                  alignment: Alignment.centerLeft,
                  child: _buildExploreButton(),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Spacious layout for list view (fits in 160px+ height)
  Widget _buildListViewLayout() {
    return Row(
      children: [
        _buildImage(),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16.0), // More padding for list view
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildTitleRow(),
                const SizedBox(height: 8), // Proper spacing
                // Location description with better styling
                Text(
                  location.address,
                  style: AppText.bodySmall.copyWith(
                    color: AppColors.yslBlack.withValues(alpha: 0.8),
                    height: 1.3, // Comfortable line height
                    fontSize: 12, // Readable font size
                    fontFamily: 'ITC Avant Garde Gothic Pro',
                  ),
                  maxLines: 3, // More lines for list view
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12), // Proper spacing
                // Explore button with proper spacing
                Align(
                  alignment: Alignment.centerLeft,
                  child: _buildListViewButton(),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildVerticalLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Image at top
        SizedBox(
          height: 120,
          child: ClipRect(
            child: location.imagePath != null
                ? Image.asset(
                    location.imagePath!,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 120,
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
        ),
        // Content below image
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTitleRow(),
                const SizedBox(height: 12),
                // Description text
                Expanded(
                  child: Text(
                    location.address,
                    style: AppText.bodySmall.copyWith(
                      color: AppColors.yslBlack,
                      height: 1.3,
                      fontFamily: 'ITC Avant Garde Gothic Pro',
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(height: 12),
                _buildExploreButton(),
              ],
            ),
          ),
        ),
      ],
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
    // Different styling based on view type
    final titleStyle = viewType == YslCardViewType.listView
        ? AppText.titleLarge.copyWith(
            color: AppColors.yslBlack,
            fontWeight: FontWeight.w700,
            fontSize: 15, // Bigger for list view
            fontFamily: 'ITC Avant Garde Gothic Pro',
          )
        : AppText.titleLarge.copyWith(
            color: AppColors.yslBlack,
            fontWeight: FontWeight.w600,
            fontSize: 13, // Smaller for map view
            fontFamily: 'ITC Avant Garde Gothic Pro',
          );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // SVG pin icon (primary) with circular badge fallback
        _buildPinIcon(),
        const SizedBox(width: 12),
        // Title
        Expanded(
          child: Text(
            location.name.toUpperCase(),
            style: titleStyle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  // ignore: unused_element
  Widget _buildCircularBadge(String letter) {
    return Container(
      width: 32,
      height: 32,
      decoration: const BoxDecoration(
        color: AppColors.yslBlack,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          letter,
          style: AppText.bodyLarge.copyWith(
            color: AppColors.yslWhite,
            fontWeight: FontWeight.w700,
            fontSize: 16,
            fontFamily: 'ITC Avant Garde Gothic Pro',
          ),
        ),
      ),
    );
  }

  Widget _buildExploreButton() {
    return Container(
      height: 28, // Reduced from 32
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), // Reduced padding
      decoration: const BoxDecoration(
        color: AppColors.yslBlack,
        borderRadius: BorderRadius.zero,
      ),
      child: Text(
        'EXPLORE',
        style: AppText.bodySmall.copyWith(
          color: AppColors.yslWhite,
          letterSpacing: 0.8,
          fontWeight: FontWeight.w600,
          fontFamily: 'ITC Avant Garde Gothic Pro',
          fontSize: 10, // Reduced font size
        ),
      ),
    );
  }

  Widget _buildListViewButton() {
    return Container(
      height: 32, // Bigger for list view
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: const BoxDecoration(
        color: AppColors.yslBlack,
        borderRadius: BorderRadius.zero,
      ),
      child: Text(
        'EXPLORE',
        style: AppText.bodySmall.copyWith(
          color: AppColors.yslWhite,
          letterSpacing: 0.8,
          fontWeight: FontWeight.w600,
          fontFamily: 'ITC Avant Garde Gothic Pro',
          fontSize: 11,
        ),
      ),
    );
  }

  Widget _buildPinIcon() {
    // You can switch between SVG and circular badge here
    return SizedBox(
      width: 28,
      height: 28,
      child: SvgPicture.asset(
        _getPinAssetPath(),
        width: 28,
        height: 28,
      ),
    );
    // Alternative: return _buildCircularBadge(_getPinLetter());
  }

  // ignore: unused_element
  String _getPinLetter() {
    switch (location.pinVariation) {
      case PinVariation.pinA:
        return 'A';
      case PinVariation.pinB:
        return 'B';
      case PinVariation.pinC:
        return 'C';
    }
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
