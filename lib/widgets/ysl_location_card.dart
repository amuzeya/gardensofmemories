// YSL Beauty Experience - Location Card Component
// Based on Figma designs: Location display card with image and details
// Following YSL brand principles: clean layouts, elegant typography, structured information

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../theme/app_colors.dart';
import '../theme/app_text.dart';
import '../constants/assets.dart';

/// YSL Location Card Model
/// Data model for location information
class YslLocationData {
  final String name;
  final String address;
  final String? city;
  final String? distance;
  final String? hours;
  final String? phone;
  final String? imagePath;
  final bool isOpen;
  final LocationType type;
  final PinVariation pinVariation;

  const YslLocationData({
    required this.name,
    required this.address,
    this.city,
    this.distance,
    this.hours,
    this.phone,
    this.imagePath,
    this.isOpen = true,
    this.type = LocationType.store,
    this.pinVariation = PinVariation.pinA,
  });
}

/// Location types for different YSL venues
enum LocationType {
  store,
  boutique,
  experience,
  popup,
}

/// Pin icon variations for location cards
enum PinVariation {
  pinA,
  pinB,
  pinC,
}

/// YSL Location Card Widget
/// Features:
/// - Location image display
/// - Store/boutique information
/// - Distance and status indicators
/// - YSL brand styling and typography
/// - Responsive layout design
/// - Interactive touch handling
class YslLocationCard extends StatelessWidget {
  final YslLocationData location;
  final VoidCallback? onTap;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final bool showDistance;
  final bool showStatus;
  final bool showBorder;

  const YslLocationCard({
    super.key,
    required this.location,
    this.onTap,
    this.width = 363,
    this.height = 165,
    this.margin,
    this.padding,
    this.showDistance = true,
    this.showStatus = true,
    this.showBorder = true,
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
          border: showBorder ? Border.all(
            color: AppColors.yslBlack,
            width: 1,
          ) : null,
          borderRadius: BorderRadius.zero, // YSL hard-edged design
        ),
        child: Row(
          children: [
            // Location Image - no padding, full height
            _buildLocationImage(),
            
            // Location Information with padding
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: _buildLocationInfo(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationImage() {
    return SizedBox(
      width: 140,
      height: height, // Full height of the card
      child: ClipRect(
        child: location.imagePath != null
            ? Image.asset(
                location.imagePath!,
                fit: BoxFit.cover,
                width: 140,
                height: height,
                errorBuilder: (context, error, stackTrace) {
                  return _buildPlaceholderImage();
                },
              )
            : _buildPlaceholderImage(),
      ),
    );
  }

  Widget _buildPlaceholderImage() {
    return Container(
      width: 140,
      height: height,
      color: Colors.grey.shade200,
      child: Center(
        child: Icon(
          Icons.location_on_outlined,
          color: AppColors.yslBlack.withValues(alpha: 0.5),
          size: 32,
        ),
      ),
    );
  }

  Widget _buildLocationInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Location header with pin icon and name
        _buildLocationHeader(),
        
        const SizedBox(height: 6),
        
        // Description text - flexible to fit available space
        Expanded(
          child: _buildLocationDescription(),
        ),
        
        const SizedBox(height: 6),
        
        // Explore button
        _buildExploreButton(),
      ],
    );
  }

  Widget _buildLocationHeader() {
    return Row(
      children: [
        // SVG Location pin icon
        SizedBox(
          width: 20,
          height: 20,
          child: SvgPicture.asset(
            _getPinAssetPath(),
            width: 20,
            height: 20,
          ),
        ),
        
        const SizedBox(width: 8),
        
        // Location name
        Expanded(
          child: Text(
            location.name.toUpperCase(),
            style: AppText.titleMedium.copyWith(
              color: AppColors.yslBlack,
              fontFamily: 'ITC Avant Garde Gothic Pro',
              fontWeight: FontWeight.w400,
              letterSpacing: 1.0,
              fontSize: 10,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildLocationDescription() {
    final description = location.address.isNotEmpty 
        ? location.address 
        : 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut.';
        
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        description,
        style: AppText.bodyMedium.copyWith(
          color: AppColors.yslBlack,
          fontFamily: 'ITC Avant Garde Gothic Pro',
          fontWeight: FontWeight.w400,
          height: 1.3,
          fontSize: 11,
        ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.left,
      ),
    );
  }

  Widget _buildExploreButton() {
    return Container(
      height: 26,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: const BoxDecoration(
        color: AppColors.yslBlack,
        borderRadius: BorderRadius.zero, // Hard-edged per YSL guidelines
      ),
      child: Center(
        child: Text(
          'EXPLORE',
          style: AppText.bodyMedium.copyWith(
            color: AppColors.yslWhite,
            fontFamily: 'ITC Avant Garde Gothic Pro',
            fontWeight: FontWeight.w600,
            letterSpacing: 1.0,
            fontSize: 10,
          ),
        ),
      ),
    );
  }

  /// Get the SVG asset path based on pin variation
  String _getPinAssetPath() {
    switch (location.pinVariation) {
      case PinVariation.pinA:
        return Assets.iconPinA;
      case PinVariation.pinB:
        return Assets.iconPinB;
      case PinVariation.pinC:
        return Assets.iconPinC;
    }
  }
}

/// Predefined YSL Location Card variants
class YslLocationCardVariants {
  YslLocationCardVariants._();

  /// Standard store location card
  static YslLocationCard store({
    required String name,
    required String address,
    String? city,
    String? distance,
    bool isOpen = true,
    PinVariation pinVariation = PinVariation.pinA,
    bool showBorder = true,
    VoidCallback? onTap,
  }) {
    return YslLocationCard(
      location: YslLocationData(
        name: name,
        address: address.isNotEmpty ? address : 'Discover exclusive YSL Beauty collections and personalized beauty consultations at our premium store location.',
        city: city,
        distance: distance,
        isOpen: isOpen,
        type: LocationType.store,
        pinVariation: pinVariation,
        imagePath: Assets.frame845083630,
      ),
      onTap: onTap,
      showBorder: showBorder,
    );
  }

  /// Boutique location card
  static YslLocationCard boutique({
    required String name,
    required String address,
    String? city,
    String? distance,
    bool isOpen = true,
    PinVariation pinVariation = PinVariation.pinB,
    VoidCallback? onTap,
  }) {
    return YslLocationCard(
      location: YslLocationData(
        name: name,
        address: address,
        city: city,
        distance: distance,
        isOpen: isOpen,
        type: LocationType.boutique,
        pinVariation: pinVariation,
        imagePath: Assets.frame845083630,
      ),
      onTap: onTap,
    );
  }

  /// Experience location card
  static YslLocationCard experience({
    required String name,
    required String address,
    String? city,
    String? distance,
    bool isOpen = true,
    PinVariation pinVariation = PinVariation.pinC,
    VoidCallback? onTap,
  }) {
    return YslLocationCard(
      location: YslLocationData(
        name: name,
        address: address,
        city: city,
        distance: distance,
        isOpen: isOpen,
        type: LocationType.experience,
        pinVariation: pinVariation,
        imagePath: Assets.frame845083630,
      ),
      onTap: onTap,
    );
  }

  /// Compact location card (smaller variant)
  static YslLocationCard compact({
    required String name,
    required String address,
    String? distance,
    bool isOpen = true,
    PinVariation pinVariation = PinVariation.pinA,
    VoidCallback? onTap,
  }) {
    return YslLocationCard(
      location: YslLocationData(
        name: name,
        address: address,
        distance: distance,
        isOpen: isOpen,
        type: LocationType.store,
        pinVariation: pinVariation,
        imagePath: Assets.frame845083630,
      ),
      onTap: onTap,
      width: 320,
      height: 140,
      padding: const EdgeInsets.all(16),
    );
  }

  /// Figma exact variant - based on the exported component
  static YslLocationCard figmaExact({
    PinVariation pinVariation = PinVariation.pinA,
    bool showBorder = true,
    VoidCallback? onTap,
  }) {
    return YslLocationCard(
      location: YslLocationData(
        name: 'Jardin Majorelle',
        address: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut.',
        city: 'Marrakech',
        distance: '0.3 km',
        isOpen: true,
        type: LocationType.experience,
        pinVariation: pinVariation,
        imagePath: Assets.frame845083630,
      ),
      onTap: onTap,
      width: 363,
      height: 165,
      showBorder: showBorder,
    );
  }

  /// Full-width responsive variant
  static YslLocationCard fullWidth({
    required String name,
    required String address,
    String? city,
    String? distance,
    bool isOpen = true,
    PinVariation pinVariation = PinVariation.pinA,
    VoidCallback? onTap,
  }) {
    return YslLocationCard(
      location: YslLocationData(
        name: name,
        address: address,
        city: city,
        distance: distance,
        isOpen: isOpen,
        type: LocationType.store,
        pinVariation: pinVariation,
        imagePath: Assets.frame845083630,
      ),
      onTap: onTap,
      width: double.infinity,
      height: 180,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
    );
  }
}
