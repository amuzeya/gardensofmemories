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
  final int? maxTitleLines; // Configurable title line limit
  final int? maxDescriptionLines; // Configurable description line limit

  const YslHomeLocationCard({
    super.key,
    required this.location,
    this.onTap,
    this.width = 150,
    this.height = 180,
    this.margin,
    this.isVertical = false,
    this.viewType = YslCardViewType.mapView,
    this.maxTitleLines,
    this.maxDescriptionLines,
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
        child: LayoutBuilder(
          builder: (context, constraints) {
            return isVertical 
                ? _buildVerticalLayout(constraints) 
                : (viewType == YslCardViewType.mapView 
                    ? _buildMapViewLayout(constraints)
                    : _buildListViewLayout(constraints));
          },
        ),
      ),
    );
  }

  // Compact layout for map view slider (fits in 100px height)
  Widget _buildMapViewLayout(BoxConstraints constraints) {
    final imageSize = constraints.maxHeight;
    final availableWidth = constraints.maxWidth - imageSize;
    
    // Prevent overflow by adjusting padding based on available width
    final padding = availableWidth < 150 
        ? const EdgeInsets.all(8.0) 
        : const EdgeInsets.all(12.0);
    
    return Row(
      children: [
        _buildImage(constraints),
        Expanded(
          child: Padding(
            padding: padding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTitleRow(constraints),
                if (constraints.maxHeight > 80) // Only show spacing if height allows
                  SizedBox(height: constraints.maxHeight > 90 ? 8.0 : 4.0),
                // Compact explore button - no description in map view
                _buildExploreButton(constraints),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Spacious layout for list view (fits in 160px+ height)
  Widget _buildListViewLayout(BoxConstraints constraints) {
    final imageSize = constraints.maxHeight;
    final availableWidth = constraints.maxWidth - imageSize;
    
    // Adjust padding and spacing based on available space
    final padding = availableWidth < 200 
        ? const EdgeInsets.all(12.0) 
        : const EdgeInsets.all(16.0);
    
    final spacing = constraints.maxHeight < 140 ? 6.0 : 8.0;
    final buttonSpacing = constraints.maxHeight < 140 ? 8.0 : 12.0;
    
    // Calculate max lines for description based on height
    final descriptionMaxLines = maxDescriptionLines ?? 
        (constraints.maxHeight < 140 ? 2 : (constraints.maxHeight < 180 ? 3 : 4));
    
    return Row(
      children: [
        _buildImage(constraints),
        Expanded(
          child: Padding(
            padding: padding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildTitleRow(constraints),
                SizedBox(height: spacing),
                // Location description with responsive styling
                if (constraints.maxHeight > 120) // Only show description if height allows
                  Flexible(
                    child: Text(
                      location.address,
                      style: AppText.bodySmall.copyWith(
                        color: AppColors.yslBlack.withValues(alpha: 0.65), // Lighter text
                        height: 1.3,
                        fontSize: _getDescriptionFontSize(constraints),
                        fontFamily: 'ITC Avant Garde Gothic Pro',
                        fontWeight: FontWeight.w300, // Even lighter font weight
                      ),
                      maxLines: descriptionMaxLines,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                SizedBox(height: buttonSpacing),
                // Explore button with proper spacing
                Align(
                  alignment: Alignment.centerLeft,
                  child: _buildListViewButton(constraints),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
  
  double _getDescriptionFontSize(BoxConstraints constraints) {
    if (constraints.maxHeight < 140) return 10;
    if (constraints.maxHeight < 160) return 11;
    return 12;
  }
  
  double _getTitleFontSize(BoxConstraints constraints) {
    if (viewType == YslCardViewType.listView) {
      if (constraints.maxHeight < 120) return 13;
      if (constraints.maxHeight < 140) return 14;
      return 15;
    } else {
      // Map view - smaller font sizes
      if (constraints.maxHeight < 80) return 11;
      if (constraints.maxHeight < 100) return 12;
      return 13;
    }
  }

  Widget _buildVerticalLayout(BoxConstraints constraints) {
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
                _buildTitleRow(constraints),
                const SizedBox(height: 12),
                // Description text
                Expanded(
                  child: Text(
                    location.address,
                    style: AppText.bodySmall.copyWith(
                      color: AppColors.yslBlack.withValues(alpha: 0.65), // Lighter text
                      height: 1.3,
                      fontFamily: 'ITC Avant Garde Gothic Pro',
                      fontWeight: FontWeight.w300, // Lighter font weight
                    ),
                    maxLines: maxDescriptionLines ?? 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(height: 12),
                _buildExploreButton(constraints),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildImage(BoxConstraints constraints) {
    final imageSize = constraints.maxHeight;
    return SizedBox(
      width: imageSize, // square-ish image block
      height: imageSize,
      child: ClipRect(
        child: location.imagePath != null
            ? Image.asset(
                location.imagePath!,
                fit: BoxFit.cover,
                width: imageSize,
                height: imageSize,
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

  Widget _buildTitleRow(BoxConstraints constraints) {
    // Responsive title sizing based on constraints and view type
    final titleFontSize = _getTitleFontSize(constraints);
    final titleStyle = viewType == YslCardViewType.listView
        ? AppText.titleLarge.copyWith(
            color: AppColors.yslBlack,
            fontWeight: FontWeight.w700,
            fontSize: titleFontSize,
            fontFamily: 'ITC Avant Garde Gothic Pro',
          )
        : AppText.titleLarge.copyWith(
            color: AppColors.yslBlack,
            fontWeight: FontWeight.w600,
            fontSize: titleFontSize,
            fontFamily: 'ITC Avant Garde Gothic Pro',
          );
    
    final titleMaxLines = maxTitleLines ?? 
        (constraints.maxHeight < 100 ? 1 : (constraints.maxWidth < 300 ? 1 : 2));

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
            maxLines: titleMaxLines,
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

  Widget _buildExploreButton(BoxConstraints constraints) {
    final buttonHeight = constraints.maxHeight < 90 ? 24.0 : 28.0;
    final fontSize = constraints.maxHeight < 90 ? 9.0 : 10.0;
    final horizontalPadding = constraints.maxWidth < 300 ? 8.0 : 12.0;
    
    return Align(
      alignment: Alignment.centerLeft,
      child: IntrinsicWidth(
        child: Container(
          height: buttonHeight,
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 4),
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
                fontSize: fontSize,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildListViewButton(BoxConstraints constraints) {
    final buttonHeight = constraints.maxHeight < 140 ? 28.0 : 32.0;
    final fontSize = constraints.maxHeight < 140 ? 10.0 : 11.0;
    final horizontalPadding = constraints.maxWidth < 400 ? 12.0 : 16.0;
    
    return Align(
      alignment: Alignment.centerLeft,
      child: IntrinsicWidth(
        child: Container(
          height: buttonHeight,
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 0), // Remove bottom padding
          decoration: const BoxDecoration(
            color: AppColors.yslBlack,
            borderRadius: BorderRadius.zero,
          ),
          child: Center( // Center the text in the container
            child: Text(
              'EXPLORE',
              style: AppText.bodySmall.copyWith(
                color: AppColors.yslWhite,
                letterSpacing: 0.8,
                fontWeight: FontWeight.w600,
                fontFamily: 'ITC Avant Garde Gothic Pro',
                fontSize: fontSize,
              ),
            ),
          ),
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
