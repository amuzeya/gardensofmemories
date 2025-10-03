// YSL Beauty Experience - Google Maps Background with YSL Styling
// Real Google Maps with custom black and white style, perfectly on-brand
// Following YSL principles: minimal, elegant, black and white only

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:ui' as ui;
import 'dart:typed_data';

import '../models/home_location.dart';
import '../models/home_map_config.dart';
import '../constants/assets.dart';
import '../theme/app_colors.dart';

class YslGoogleMapBackground extends StatefulWidget {
  final HomeMapConfig config;
  final List<HomeLocation> locations;
  final void Function(HomeLocation)? onMarkerTap;
  final void Function(GoogleMapController)? onMapReady;
  final EdgeInsetsGeometry? padding;
  final int? selectedLocationIndex;
  final bool interactionEnabled;

  const YslGoogleMapBackground({
    super.key,
    required this.config,
    required this.locations,
    this.onMarkerTap,
    this.onMapReady,
    this.padding,
    this.selectedLocationIndex,
    this.interactionEnabled = true,
  });

  @override
  State<YslGoogleMapBackground> createState() => _YslGoogleMapBackgroundState();
}

class _YslGoogleMapBackgroundState extends State<YslGoogleMapBackground> {
  GoogleMapController? _controller;
  Set<Marker> _markers = {};
  final Map<String, BitmapDescriptor> _customMarkerIcons = {};
  final Map<String, BitmapDescriptor> _customMarkerIconsWhite = {};
  bool _isMapReady = false;

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
    "featureType": "poi",
    "stylers": [
      { "visibility": "off" }
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadCustomMarkerIcons();
    });
  }
  
  @override
  void didUpdateWidget(YslGoogleMapBackground oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    // Refresh markers if selected location changed
    if (widget.selectedLocationIndex != oldWidget.selectedLocationIndex) {
      print('🔄 Selected location changed from ${oldWidget.selectedLocationIndex} to ${widget.selectedLocationIndex}');
      _initializeMarkers();
    }
  }

  Future<void> _loadCustomMarkerIcons() async {
    try {
      print('Loading PNG marker icons (black and white versions)...');
      
      final ImageConfiguration imageConfig = const ImageConfiguration();
      
      // Load black markers (selected state)
      _customMarkerIcons['pinA'] = await BitmapDescriptor.fromAssetImage(
        imageConfig,
        Assets.pinA,
      );
      _customMarkerIcons['pinB'] = await BitmapDescriptor.fromAssetImage(
        imageConfig,
        Assets.pinB,
      );
      _customMarkerIcons['pinC'] = await BitmapDescriptor.fromAssetImage(
        imageConfig,
        Assets.pinC,
      );
      // Use bigger Pin D PNG asset for better visual impact
      _customMarkerIcons['pinD'] = await BitmapDescriptor.fromAssetImage(
        imageConfig,
        Assets.pinDOld, // Bigger version for better visibility on map
      );
      
      // Load white markers (inactive state)
      _customMarkerIconsWhite['pinA'] = await BitmapDescriptor.fromAssetImage(
        imageConfig,
        Assets.pinAWhite,
      );
      _customMarkerIconsWhite['pinB'] = await BitmapDescriptor.fromAssetImage(
        imageConfig,
        Assets.pinBWhite,
      );
      _customMarkerIconsWhite['pinC'] = await BitmapDescriptor.fromAssetImage(
        imageConfig,
        Assets.pinCWhite,
      );
      _customMarkerIconsWhite['pinD'] = await BitmapDescriptor.fromAssetImage(
        imageConfig,
        Assets.pinDWhite, // White version matches the size
      );
      
      // Load exclusive offer pin icon
      _customMarkerIcons['offer'] = await BitmapDescriptor.fromAssetImage(
        imageConfig,
        Assets.iconPinOffer,
      );
      
      print('PNG marker icons loaded - Black: ${_customMarkerIcons.keys}, White: ${_customMarkerIconsWhite.keys}');
      
      // Initialize markers after icons are loaded
      _initializeMarkers();
    } catch (e) {
      print('Error loading PNG marker icons: $e');
      // Initialize markers with default icons as fallback
      _initializeMarkers();
    }
  }

  

  void _initializeMarkers() {
    print('Initializing markers for ${widget.locations.length} locations...');
    
    // Create location markers
    final locationMarkers = widget.locations.asMap().entries.map((entry) {
      final index = entry.key;
      final location = entry.value;
      // Assign pin type by index order: A, B, C, D, then repeat
      final pinType = switch (index % 4) {
        0 => 'pinA',
        1 => 'pinB',
        2 => 'pinC',
        _ => 'pinD',
      };
      
      // Determine if this marker should be selected (black) or inactive (white)
      final isSelected = widget.selectedLocationIndex != null && 
                        widget.selectedLocationIndex == index;
      
      // Choose appropriate marker color
      final customIcon = isSelected 
          ? _customMarkerIcons[pinType] 
          : _customMarkerIconsWhite[pinType];
      
      final markerState = isSelected ? 'SELECTED (BLACK)' : 'INACTIVE (WHITE)';
      print('Location: ${location.name}, Pin: $pinType, State: $markerState');
      
      return Marker(
        markerId: MarkerId(location.id),
        position: LatLng(location.lat, location.lng),
        onTap: () => widget.onMarkerTap?.call(location),
        // Use custom YSL marker (black or white) or fallback to colored default
        icon: customIcon ?? BitmapDescriptor.defaultMarkerWithHue(
          pinType == 'pinA' ? BitmapDescriptor.hueRed :
          pinType == 'pinB' ? BitmapDescriptor.hueBlue :
          BitmapDescriptor.hueViolet
        ),
        // Disable default Google Maps info window / tooltips
        infoWindow: const InfoWindow(title: '', snippet: ''),
      );
    });

    // Create exclusive offer markers for reward locations (Pin D locations)
    final offerMarkers = widget.locations.asMap().entries.where((entry) {
      final index = entry.key;
      return index % 4 == 3; // Pin D locations
    }).map((entry) {
      final location = entry.value;
      
      return Marker(
        markerId: MarkerId('${location.id}_offer'),
        position: LatLng(
          location.lat + 0.0005, // Slight offset to position near main pin
          location.lng + 0.0005,
        ),
        onTap: () => widget.onMarkerTap?.call(location),
        icon: _customMarkerIcons['offer'] ?? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),
        infoWindow: const InfoWindow(title: '', snippet: ''),
      );
    });
    
    // Combine location markers and offer markers
    _markers = {...locationMarkers, ...offerMarkers};
    
    print('Created ${_markers.length} markers (${locationMarkers.length} location + ${offerMarkers.length} offer)');
    
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
          _isMapReady = true;
          // Notify parent widget that map is ready
          widget.onMapReady?.call(controller);
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
        myLocationEnabled: false, // Hide user location dot
        rotateGesturesEnabled: false, // Keep map oriented north
        tiltGesturesEnabled: false, // Flat view only
        mapType: MapType.normal,
        liteModeEnabled: false, // Ensure full map functionality
        fortyFiveDegreeImageryEnabled: false, // No 3D buildings
        // Enable map interactions outside of slider area
        zoomGesturesEnabled: widget.interactionEnabled, // Allow zoom when not blocked
        scrollGesturesEnabled: widget.interactionEnabled, // Allow pan when not blocked
        // Hide all POI labels and markers for clean look
        buildingsEnabled: false,
        trafficEnabled: false,
        indoorViewEnabled: false,
        // Disable all info windows/tooltips
        onTap: (_) {}, // Consume tap events to prevent default tooltips
        onLongPress: (_) {}, // Disable long press tooltips
      ),
    );
  }

  @override
  void dispose() {
    // Skip controller disposal to prevent web crashes - this is a known issue with google_maps_flutter_web
    // The controller will be cleaned up automatically by the Flutter framework
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