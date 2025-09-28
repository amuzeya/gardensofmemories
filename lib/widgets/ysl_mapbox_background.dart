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
        // Clean YSL-branded background - let the custom painter handle the details
        color: const Color(0xFFF5F5F5), // Base light grey
        borderRadius: BorderRadius.zero, // YSL hard-edged design
      ),
      child: Stack(
        children: [
          // Map background with roads, features, and geography
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

/// Custom painter for YSL-branded map with geographical features
class YslMapGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    _drawMapBackground(canvas, size);
    _drawRoadNetwork(canvas, size);
    _drawGeographicalFeatures(canvas, size);
    _drawSubtleGrid(canvas, size);
  }

  void _drawMapBackground(Canvas canvas, Size size) {
    // Create a subtle terrain-like pattern
    final terrainPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0xFFF0F0F0), // Light grey center
          const Color(0xFFE8E8E8), // Slightly darker edges
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), terrainPaint);
  }

  void _drawRoadNetwork(Canvas canvas, Size size) {
    final roadPaint = Paint()
      ..color = AppColors.yslBlack.withValues(alpha: 0.15)
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    final thinRoadPaint = Paint()
      ..color = AppColors.yslBlack.withValues(alpha: 0.08)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    // Draw main roads (like major streets in Marrakech)
    final mainRoads = [
      // Horizontal main road
      [Offset(0, size.height * 0.4), Offset(size.width, size.height * 0.4)],
      [Offset(0, size.height * 0.7), Offset(size.width, size.height * 0.7)],
      // Vertical main road
      [Offset(size.width * 0.3, 0), Offset(size.width * 0.3, size.height)],
      [Offset(size.width * 0.7, 0), Offset(size.width * 0.7, size.height)],
    ];

    for (final road in mainRoads) {
      canvas.drawLine(road[0], road[1], roadPaint);
    }

    // Draw smaller connecting roads
    final smallRoads = [
      [Offset(size.width * 0.1, size.height * 0.2), Offset(size.width * 0.9, size.height * 0.3)],
      [Offset(size.width * 0.2, size.height * 0.5), Offset(size.width * 0.8, size.height * 0.6)],
      [Offset(size.width * 0.0, size.height * 0.8), Offset(size.width * 0.6, size.height * 0.9)],
      [Offset(size.width * 0.5, size.height * 0.1), Offset(size.width * 0.9, size.height * 0.2)],
    ];

    for (final road in smallRoads) {
      canvas.drawLine(road[0], road[1], thinRoadPaint);
    }
  }

  void _drawGeographicalFeatures(Canvas canvas, Size size) {
    // Draw water features (subtle)
    final waterPaint = Paint()
      ..color = AppColors.yslBlack.withValues(alpha: 0.05)
      ..style = PaintingStyle.fill;

    // Small water feature (like a fountain or small lake)
    final waterPath = Path()
      ..addOval(Rect.fromCenter(
        center: Offset(size.width * 0.2, size.height * 0.6),
        width: 60,
        height: 40,
      ))
      ..addOval(Rect.fromCenter(
        center: Offset(size.width * 0.8, size.height * 0.3),
        width: 80,
        height: 50,
      ));
    
    canvas.drawPath(waterPath, waterPaint);

    // Draw park/garden areas (subtle green-grey)
    final parkPaint = Paint()
      ..color = AppColors.yslBlack.withValues(alpha: 0.03)
      ..style = PaintingStyle.fill;

    final parkPath = Path()
      ..addRRect(RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(size.width * 0.5, size.height * 0.2),
          width: 120,
          height: 80,
        ),
        const Radius.circular(0), // YSL hard edges
      ))
      ..addRRect(RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(size.width * 0.7, size.height * 0.8),
          width: 100,
          height: 60,
        ),
        const Radius.circular(0),
      ));
    
    canvas.drawPath(parkPath, parkPaint);
  }

  void _drawSubtleGrid(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = AppColors.yslBlack.withValues(alpha: 0.02)
      ..strokeWidth = 0.3;

    const gridSpacing = 50.0;
    
    // Draw subtle background grid
    for (double x = gridSpacing; x < size.width; x += gridSpacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }
    
    for (double y = gridSpacing; y < size.height; y += gridSpacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
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