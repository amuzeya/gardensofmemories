// YSL Beauty Experience - Google Maps Background with YSL Styling
// Real Google Maps with custom black and white style, perfectly on-brand
// Following YSL principles: minimal, elegant, black and white only

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:ui' as ui;

import '../models/home_location.dart';
import '../models/home_map_config.dart';
import '../constants/assets.dart';
import '../theme/app_colors.dart';

class YslGoogleMapBackground extends StatefulWidget {
  final HomeMapConfig config;
  final List<HomeLocation> locations;
  final void Function(HomeLocation)? onMarkerTap;
  final EdgeInsetsGeometry? padding;

  const YslGoogleMapBackground({
    super.key,
    required this.config,
    required this.locations,
    this.onMarkerTap,
    this.padding,
  });

  @override
  State<YslGoogleMapBackground> createState() => _YslGoogleMapBackgroundState();
}

class _YslGoogleMapBackgroundState extends State<YslGoogleMapBackground> {
  GoogleMapController? _controller;
  Set<Marker> _markers = {};
  final Map<String, BitmapDescriptor> _customMarkerIcons = {};

  // YSL Black & White Map Style JSON
  static const String _yslMapStyle = '''
[
  {
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#f5f5f5"
      }
    ]
  },
  {
    "elementType": "labels.icon",
    "stylers": [
      {
        "visibility": "off"
      }
    ]
  },
  {
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#616161"
      }
    ]
  },
  {
    "elementType": "labels.text.stroke",
    "stylers": [
      {
        "color": "#f5f5f5"
      }
    ]
  },
  {
    "featureType": "administrative.land_parcel",
    "elementType": "labels",
    "stylers": [
      {
        "visibility": "off"
      }
    ]
  },
  {
    "featureType": "poi",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#eeeeee"
      }
    ]
  },
  {
    "featureType": "poi",
    "elementType": "labels.text",
    "stylers": [
      {
        "visibility": "off"
      }
    ]
  },
  {
    "featureType": "poi.business",
    "stylers": [
      {
        "visibility": "off"
      }
    ]
  },
  {
    "featureType": "road",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#ffffff"
      }
    ]
  },
  {
    "featureType": "road.arterial",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#757575"
      }
    ]
  },
  {
    "featureType": "road.highway",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#dadada"
      }
    ]
  },
  {
    "featureType": "road.highway",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#616161"
      }
    ]
  },
  {
    "featureType": "road.local",
    "elementType": "labels",
    "stylers": [
      {
        "visibility": "off"
      }
    ]
  },
  {
    "featureType": "transit.line",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#e5e5e5"
      }
    ]
  },
  {
    "featureType": "transit.station",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#eeeeee"
      }
    ]
  },
  {
    "featureType": "water",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#c9c9c9"
      }
    ]
  },
  {
    "featureType": "water",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#9e9e9e"
      }
    ]
  }
]
''';

  @override
  void initState() {
    super.initState();
    _loadCustomMarkerIcons();
  }

  Future<void> _loadCustomMarkerIcons() async {
    // Create custom YSL-branded markers with different colors for each pin type
    _customMarkerIcons['pin_a'] = await _createYslCustomMarker(Colors.black, 'A');
    _customMarkerIcons['pin_b'] = await _createYslCustomMarker(Colors.grey[800]!, 'B');
    _customMarkerIcons['pin_c'] = await _createYslCustomMarker(Colors.grey[600]!, 'C');
    
    // Initialize markers after icons are loaded
    _initializeMarkers();
  }

  Future<BitmapDescriptor> _createYslCustomMarker(Color color, String letter) async {
    const double size = 60.0;
    
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    
    // Draw YSL-style pin background
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    
    // Draw pin shape (teardrop)
    final path = Path();
    const double radius = size * 0.3;
    const double centerX = size / 2;
    const double centerY = radius;
    
    // Circle part of the pin
    path.addOval(Rect.fromCircle(center: Offset(centerX, centerY), radius: radius));
    
    // Point part of the pin
    path.moveTo(centerX - radius * 0.6, centerY + radius * 0.6);
    path.lineTo(centerX, size - 5);
    path.lineTo(centerX + radius * 0.6, centerY + radius * 0.6);
    path.close();
    
    canvas.drawPath(path, paint);
    
    // Draw white letter in center
    final textPainter = TextPainter(
      text: TextSpan(
        text: letter,
        style: TextStyle(
          color: Colors.white,
          fontSize: radius * 0.8,
          fontWeight: FontWeight.bold,
          fontFamily: 'ITC Avant Garde Gothic Pro',
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        centerX - textPainter.width / 2,
        centerY - textPainter.height / 2,
      ),
    );
    
    // Convert to image
    final picture = recorder.endRecording();
    final img = await picture.toImage(size.toInt(), size.toInt());
    final byteData = await img.toByteData(format: ui.ImageByteFormat.png);
    final uint8List = byteData!.buffer.asUint8List();
    
    return BitmapDescriptor.bytes(uint8List);
  }

  void _initializeMarkers() {
    _markers = widget.locations.map((location) {
      final pinType = location.pin.name; // pin_a, pin_b, pin_c
      final customIcon = _customMarkerIcons[pinType];
      
      return Marker(
        markerId: MarkerId(location.id),
        position: LatLng(location.lat, location.lng),
        onTap: () => widget.onMarkerTap?.call(location),
        // Use custom YSL SVG marker or fallback to default
        icon: customIcon ?? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet),
        infoWindow: InfoWindow(
          title: location.name.toUpperCase(),
          snippet: location.address,
        ),
      );
    }).toSet();
    
    // Update state to show markers on map
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.yslWhite,
        borderRadius: BorderRadius.zero, // YSL hard-edged design
      ),
      child: GoogleMap(
        onMapCreated: (GoogleMapController controller) {
          _controller = controller;
        },
        style: _yslMapStyle, // Apply YSL black and white style directly
        initialCameraPosition: CameraPosition(
          target: LatLng(widget.config.lat, widget.config.lng),
          zoom: widget.config.zoom,
        ),
        markers: _markers,
        // YSL brand UI settings - minimal and clean
        compassEnabled: false, // Clean, minimal interface
        mapToolbarEnabled: false, // Remove Google branding toolbar
        zoomControlsEnabled: false, // Clean interface
        myLocationButtonEnabled: false, // No location button
        rotateGesturesEnabled: false, // Keep map oriented north
        tiltGesturesEnabled: false, // Flat view only
        mapType: MapType.normal,
        // Subtle zoom and scroll
        zoomGesturesEnabled: true,
        scrollGesturesEnabled: true,
        // Hide all POI labels and markers for clean look
        buildingsEnabled: false,
        trafficEnabled: false,
        indoorViewEnabled: false,
      ),
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }
}

/// Fallback widget when Google Maps is not available
class YslGoogleMapFallback extends StatelessWidget {
  final HomeMapConfig config;
  final List<HomeLocation> locations;
  final void Function(HomeLocation)? onMarkerTap;

  const YslGoogleMapFallback({
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
      color: const Color(0xFFF5F5F5), // YSL light grey
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
              'GOOGLE MAPS CONFIGURATION REQUIRED',
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
              'Please configure Google Maps API key\nfor web platform',
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