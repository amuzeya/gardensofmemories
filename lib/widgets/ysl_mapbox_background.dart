// YSL Beauty Experience - YSL-Branded Map Background  
// Custom minimal grey map with YSL location pins, perfectly on-brand
// Following YSL principles: minimal, elegant, distraction-free, no unrelated markers

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../models/home_location.dart';
import '../models/home_map_config.dart';
import '../constants/assets.dart';
import '../theme/app_colors.dart';

/// YSL-Branded Map Background
/// Elegant minimal representation of locations without third-party dependencies
/// Shows YSL locations on a beautiful branded map interface
class YslMapboxBackground extends StatelessWidget {
  final HomeMapConfig config;
  final List<HomeLocation> locations;
  final void Function(HomeLocation)? onMarkerTap;
  final EdgeInsetsGeometry? padding;

  const YslMapboxBackground({
    super.key,
    required this.config,
    required this.locations,
    this.onMarkerTap,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        // YSL-branded grey gradient background
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color(0xFFF8F8F8), // Very light grey at top
            const Color(0xFFECECEC), // Slightly darker grey at bottom
          ],
        ),
        borderRadius: BorderRadius.zero, // YSL hard-edged design
      ),
      child: Stack(
        children: [
          // Subtle grid pattern for map-like appearance
          _buildMapGrid(),
          // YSL location markers positioned elegantly
          ..._buildLocationMarkers(context),
          // YSL branding overlay
          _buildYslMapBranding(context),
        ],
      ),
    );
  }

  Widget _buildMapGrid() {
    return CustomPaint(
      size: Size.infinite,
      painter: YslMapGridPainter(),
    );
  }

  List<Widget> _buildLocationMarkers(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    
    return locations.asMap().entries.map((entry) {
      final index = entry.key;
      final location = entry.value;
      
      // Calculate position based on index for elegant layout
      final positions = _calculateMarkerPositions(screenSize, locations.length);
      final position = positions[index % positions.length];
      
      return Positioned(
        left: position.dx,
        top: position.dy,
        child: _buildLocationMarker(location),
      );
    }).toList();
  }

  Widget _buildLocationMarker(HomeLocation location) {
    final iconPath = _pinAsset(location.pin);
    
    return GestureDetector(
      onTap: () => onMarkerTap?.call(location),
      child: Container(
        width: 48,
        height: 64, // Slightly taller to accommodate content
        decoration: BoxDecoration(
          borderRadius: BorderRadius.zero,
          boxShadow: [
            BoxShadow(
              color: AppColors.yslBlack.withValues(alpha: 0.15),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min, // Use minimum space
          children: [
            // Location pin icon
            SvgPicture.asset(
              iconPath,
              width: 32, // Slightly smaller
              height: 32,
            ),
            const SizedBox(height: 2), // Reduced spacing
            // Location name badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
              decoration: BoxDecoration(
                color: AppColors.yslBlack,
                borderRadius: BorderRadius.zero,
              ),
              child: Text(
                location.name.split(' ').first.toUpperCase(), // First word only
                style: const TextStyle(
                  color: AppColors.yslWhite,
                  fontSize: 7, // Slightly smaller text
                  fontWeight: FontWeight.w600,
                  fontFamily: 'ITC Avant Garde Gothic Pro',
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildYslMapBranding(BuildContext context) {
    return Positioned(
      bottom: 16,
      right: 16,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.yslWhite.withValues(alpha: 0.9),
          borderRadius: BorderRadius.zero,
          border: Border.all(color: AppColors.yslBlack, width: 1),
        ),
        child: Text(
          'YSL BEAUTY LOCATIONS',
          style: TextStyle(
            color: AppColors.yslBlack,
            fontSize: 10,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.2,
            fontFamily: 'ITC Avant Garde Gothic Pro',
          ),
        ),
      ),
    );
  }

  List<Offset> _calculateMarkerPositions(Size screenSize, int locationCount) {
    // Create elegant scattered positions for YSL locations
    final padding = 80.0;
    final availableWidth = screenSize.width - (padding * 2);
    final availableHeight = screenSize.height - (padding * 2);
    
    // Predefined elegant positions that work well visually
    final elegantPositions = [
      Offset(availableWidth * 0.2 + padding, availableHeight * 0.3 + padding), // Top left area
      Offset(availableWidth * 0.7 + padding, availableHeight * 0.2 + padding), // Top right area  
      Offset(availableWidth * 0.3 + padding, availableHeight * 0.6 + padding), // Bottom left area
      Offset(availableWidth * 0.8 + padding, availableHeight * 0.7 + padding), // Bottom right area
      Offset(availableWidth * 0.5 + padding, availableHeight * 0.4 + padding), // Center area
      Offset(availableWidth * 0.1 + padding, availableHeight * 0.8 + padding), // Bottom left corner
      Offset(availableWidth * 0.9 + padding, availableHeight * 0.5 + padding), // Right side
    ];
    
    return elegantPositions;
  }

  String _pinAsset(HomePinVariation p) {
    switch (p) {
      case HomePinVariation.pinA:
        return Assets.iconPinA;
      case HomePinVariation.pinB:
        return Assets.iconPinB;
      case HomePinVariation.pinC:
        return Assets.iconPinC;
    }
  }
}

/// Custom painter for subtle grid pattern background
class YslMapGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.yslBlack.withValues(alpha: 0.03)
      ..strokeWidth = 0.5;

    const gridSpacing = 40.0;
    
    // Draw vertical lines
    for (double x = 0; x < size.width; x += gridSpacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    
    // Draw horizontal lines  
    for (double y = 0; y < size.height; y += gridSpacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Fallback widget when Mapbox token is not configured
class YslMapboxPlaceholder extends StatelessWidget {
  final HomeMapConfig config;
  final List<HomeLocation> locations;
  final void Function(HomeLocation)? onMarkerTap;

  const YslMapboxPlaceholder({
    super.key,
    required this.config,
    required this.locations,
    this.onMarkerTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: const Color(0xFFF8F8F8), // YSL light grey
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.yslBlack.withValues(alpha: 0.1),
                borderRadius: BorderRadius.zero,
              ),
              child: Icon(
                Icons.map_outlined,
                size: 40,
                color: AppColors.yslBlack.withValues(alpha: 0.6),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'MAPBOX CONFIGURATION REQUIRED',
              style: TextStyle(
                color: AppColors.yslBlack.withValues(alpha: 0.7),
                fontSize: 14,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.2,
                fontFamily: 'ITC Avant Garde Gothic Pro',
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Please configure your Mapbox access token\nin lib/config/mapbox_config.dart',
              style: TextStyle(
                color: AppColors.yslBlack.withValues(alpha: 0.5),
                fontSize: 12,
                fontWeight: FontWeight.w300,
                fontFamily: 'ITC Avant Garde Gothic Pro',
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            // Show location pins as static elements for preview
            ...locations.take(3).map((location) => _buildStaticLocationPin(location)),
          ],
        ),
      ),
    );
  }

  Widget _buildStaticLocationPin(HomeLocation location) {
    final iconPath = _pinAsset(location.pin);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            iconPath,
            width: 24,
            height: 24,
          ),
          const SizedBox(width: 12),
          Text(
            location.name.toUpperCase(),
            style: TextStyle(
              color: AppColors.yslBlack.withValues(alpha: 0.7),
              fontSize: 12,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.0,
              fontFamily: 'ITC Avant Garde Gothic Pro',
            ),
          ),
        ],
      ),
    );
  }

  String _pinAsset(HomePinVariation p) {
    switch (p) {
      case HomePinVariation.pinA:
        return Assets.iconPinA;
      case HomePinVariation.pinB:
        return Assets.iconPinB;
      case HomePinVariation.pinC:
        return Assets.iconPinC;
    }
  }
}