// YSL Flight Path Animation - Gamified Journey to Marrakech
// Shows user location, curved flight path, and animated plane
// Following YSL brand principles: elegant, minimalistic, intentional animations

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:math' as math;
import 'dart:ui' as ui;
import 'dart:typed_data';
import 'package:flutter/rendering.dart';

import '../theme/app_colors.dart';
import '../theme/app_text.dart';

class YslFlightPathAnimation extends StatefulWidget {
  final VoidCallback onFlightCompleted;
  final bool showAnimation;

  const YslFlightPathAnimation({
    super.key,
    required this.onFlightCompleted,
    this.showAnimation = true,
  });

  @override
  State<YslFlightPathAnimation> createState() => _YslFlightPathAnimationState();
}

class _YslFlightPathAnimationState extends State<YslFlightPathAnimation>
    with TickerProviderStateMixin {
  
  // Animation controllers and animations
  late AnimationController _planeController;
  late AnimationController _fadeInController;
  late AnimationController _pulseController;
  
  // Animations
  late Animation<double> _planeProgress;
  late Animation<double> _fadeIn;
  
  // Location data
  Position? _userPosition;
  bool _locationGranted = false;
  bool _locationDenied = false;
  bool _isRequestingPermission = true;
  
  // Map coordinates - Updated to mainland Marrakech location
  static const double _marrakechLat = 31.6295;
  static const double _marrakechLng = -7.9811;

  // Animation states
  bool _showFlightPath = false;
  bool _animationCompleted = false;

  // Google Map state
  final Set<Marker> _markers = <Marker>{};
  final Set<Polyline> _polylines = <Polyline>{};
  final Set<Circle> _circles = <Circle>{};
  GoogleMapController? _mapController;

  // Cached icons
  BitmapDescriptor? _planeIcon;
  BitmapDescriptor? _pinArriveIcon;
  BitmapDescriptor? _destPinIcon;

  // Hidden render keys to rasterize SVGs into PNGs for map markers
  final GlobalKey _planeIconKey = GlobalKey();
  final GlobalKey _pinIconKey = GlobalKey();
  bool _requestedIconCapture = false;

  // Route metrics
  double _routeDistanceMeters = 0;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _requestLocationPermission();
  }

  void _setupAnimations() {
    // Plane movement along path (8 seconds for elegant journey)
    _planeController = AnimationController(
      duration: const Duration(seconds: 8),
      vsync: this,
    );

    // Fade in animation (1 second)
    _fadeInController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    // Pulse animation for user location (repeats)
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();
    _pulseController.addListener(_onPulseTick);
    
    // Create animations with elegant curves
    _planeProgress = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _planeController,
      curve: Curves.easeInOutCubic, // Smooth acceleration and deceleration
    ));
    
    _fadeIn = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeInController,
      curve: Curves.easeOut,
    ));
    
    // Listen for animation completion
    _planeController.addStatusListener((status) {
      if (status == AnimationStatus.completed && !_animationCompleted) {
        _animationCompleted = true;
        // Delay before completing to let user appreciate the arrival
        Future.delayed(const Duration(milliseconds: 1000), () {
          if (mounted) {
            widget.onFlightCompleted();
          }
        });
      }
    });
  }

  void _onPulseTick() {
    if (_userPosition == null) return;
    final t = _pulseController.value; // 0..1
    final base = _routeDistanceMeters > 0 ? _routeDistanceMeters * 0.08 : 4000.0; // Reduced base size
    final radius = base * (0.5 + t); // expanding
    final alpha = (1.0 - t).clamp(0.0, 1.0);

    final userCenter = LatLng(_userPosition!.latitude, _userPosition!.longitude);

    final circles = <Circle>{
      Circle(
        circleId: const CircleId('pulse'),
        center: userCenter,
        radius: radius,
        strokeWidth: 2,
        strokeColor: AppColors.yslBlack.withValues(alpha: (0.4 * alpha)),
        fillColor: AppColors.yslBlack.withValues(alpha: (0.15 * alpha)),
        zIndex: 0,
      ),
      Circle(
        circleId: const CircleId('dot'),
        center: userCenter,
        radius: base * 0.05, // Smaller solid center
        strokeWidth: 0,
        fillColor: AppColors.yslBlack,
        zIndex: 1,
      ),
    };

    setState(() {
      _circles
        ..clear()
        ..addAll(circles);
    });
  }

  Future<void> _requestLocationPermission() async {
    print('📍 Starting location permission request...');
    
    try {
      // Check if location services are enabled
      print('📍 Checking if location services are enabled...');
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      print('📍 Location services enabled: $serviceEnabled');
      
      if (!serviceEnabled) {
        print('❌ Location services not enabled');
        setState(() {
          _locationDenied = true;
          _isRequestingPermission = false;
        });
        // Fall back to normal experience after brief delay
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) widget.onFlightCompleted();
        });
        return;
      }

      // Check location permission
      print('🔒 Checking location permission...');
      LocationPermission permission = await Geolocator.checkPermission();
      print('🔒 Current permission: $permission');
      
      if (permission == LocationPermission.denied) {
        print('🔒 Permission denied, requesting...');
        permission = await Geolocator.requestPermission();
        print('🔒 Permission after request: $permission');
        
        if (permission == LocationPermission.denied) {
          print('❌ Permission still denied after request');
          setState(() {
            _locationDenied = true;
            _isRequestingPermission = false;
          });
          // Fall back to normal experience
          Future.delayed(const Duration(seconds: 2), () {
            if (mounted) widget.onFlightCompleted();
          });
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() {
          _locationDenied = true;
          _isRequestingPermission = false;
        });
        // Fall back to normal experience
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) widget.onFlightCompleted();
        });
        return;
      }

      // Get current position with fallback
      print('🗺️ Getting current position...');
      Position position;
      
      try {
        position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.low,
          timeLimit: const Duration(seconds: 5),
        ).timeout(
          const Duration(seconds: 8),
        );
        print('🌍 Position obtained: ${position.latitude}, ${position.longitude}');
      } catch (e) {
        print('⚠️ Location failed (no fallback will be used): $e');
        setState(() {
          _locationDenied = true;
          _isRequestingPermission = false;
        });
        // Skip the flight animation if we cannot get real user location
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) widget.onFlightCompleted();
        });
        return;
      }

      setState(() {
        _userPosition = position;
        _locationGranted = true;
        _isRequestingPermission = false;
        _showFlightPath = true;
      });

      // Initialize route markers & polyline using REAL user coords
      await _setupMapRoute();
      
      print('🛩️ Location granted! User at: ${position.latitude}, ${position.longitude}');
      print('🎯 Starting flight animation sequence...');

      // Start the animation sequence
      _startFlightAnimation();
      
    } catch (e) {
      print('Location error: $e');
      setState(() {
        _locationDenied = true;
        _isRequestingPermission = false;
      });
      // Fall back to normal experience
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) widget.onFlightCompleted();
      });
    }
  }

  void _startFlightAnimation() {
    if (!mounted || !_locationGranted || _userPosition == null) {
      print('❌ Cannot start flight animation - mounted: $mounted, granted: $_locationGranted, position: $_userPosition');
      return;
    }
    
    print('🚀 Starting flight animation sequence');
    
    // Start with fade in
    _fadeInController.forward();
    print('✨ Started fade in animation');
    
    // Then reveal the path
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        print('🛤️ Starting path reveal animation');
        // Update plane marker position each frame along the great-circle route
        _planeController.addListener(() {
          if (!mounted) return;
          _updatePlaneMarkerAtProgress(_planeProgress.value);
        });
        _planeController.forward();
      }
    });
  }

  @override
  void dispose() {
    _planeController.dispose();
    _fadeInController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.showAnimation) {
      return const SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      height: double.infinity,
      color: AppColors.yslWhite,
      child: _buildContent(),
    );
  }

  Widget _buildContent() {
    print('🏯 Build content - requesting: $_isRequestingPermission, denied: $_locationDenied, granted: $_locationGranted, showPath: $_showFlightPath');
    
    if (_isRequestingPermission) {
      print('📱 Showing location permission request');
      return _buildLocationPermissionRequest();
    }
    
    if (_locationDenied) {
      print('❌ Showing permission denied screen');
      return _buildPermissionDenied();
    }
    
    if (_locationGranted && _userPosition != null && _showFlightPath) {
      print('🗺️ Showing flight path view');
      return _buildFlightPathView();
    }
    
    print('😶 Showing empty content');
    return const SizedBox.shrink();
  }

  Widget _buildLocationPermissionRequest() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            'assets/svgs/logos/state_logo_beaut_on.svg',
            height: 48,
            colorFilter: const ColorFilter.mode(
              AppColors.yslBlack,
              BlendMode.srcIn,
            ),
          ),
          const SizedBox(height: 32),
          Text(
            'DISCOVER YOUR JOURNEY',
            style: AppText.titleLarge.copyWith(
              color: AppColors.yslBlack,
              fontSize: 24,
              letterSpacing: 1.2,
              fontFamily: 'ITC Avant Garde Gothic Pro',
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            'Grant location access to see your\npersonal flight path to Marrakech',
            style: AppText.bodyMedium.copyWith(
              color: AppColors.yslBlack.withValues(alpha: 0.7),
              fontSize: 16,
              height: 1.4,
              fontFamily: 'ITC Avant Garde Gothic Pro',
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          const CircularProgressIndicator(
            color: AppColors.yslBlack,
            strokeWidth: 2.0,
          ),
        ],
      ),
    );
  }

  Widget _buildPermissionDenied() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            'assets/svgs/logos/state_logo_beaut_on.svg',
            height: 48,
            colorFilter: const ColorFilter.mode(
              AppColors.yslBlack,
              BlendMode.srcIn,
            ),
          ),
          const SizedBox(height: 32),
          Text(
            'CONTINUING YOUR JOURNEY',
            style: AppText.titleLarge.copyWith(
              color: AppColors.yslBlack,
              fontSize: 20,
              letterSpacing: 1.2,
              fontFamily: 'ITC Avant Garde Gothic Pro',
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            'Taking you directly to Marrakech...',
            style: AppText.bodyMedium.copyWith(
              color: AppColors.yslBlack.withValues(alpha: 0.7),
              fontSize: 16,
              fontFamily: 'ITC Avant Garde Gothic Pro',
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildFlightPathView() {
    if (_userPosition == null) return const SizedBox.shrink();
    
    return FadeTransition(
      opacity: _fadeIn,
      child: Stack(
        children: [
          // Map with pulsing circles and polylines
          _buildFlightPathMap(),


          // Invisible renderers to rasterize SVGs into marker PNGs (must paint!)
        ],
      ),
    );
  }

  Widget _buildDestinationMarker() {
    final screenSize = MediaQuery.of(context).size;

    // Get coordinates and calculate screen position using same logic as plane overlay
    final userLat = _userPosition!.latitude;
    final userLng = _userPosition!.longitude;
    const marrakechLat = 31.6295; // Updated coordinates
    const marrakechLng = -7.9811; // Updated coordinates

    // Calculate the map bounds and center (same as other components)
    final centerLat = (userLat + marrakechLat) / 2;
    final centerLng = (userLng + marrakechLng) / 2;

    // Calculate the span of the visible map area
    final latSpan = (userLat - marrakechLat).abs() * 1.5;
    final lngSpan = (userLng - marrakechLng).abs() * 1.5;

    // Convert lat/lng to screen coordinates
    double latToY(double lat) {
      final normalizedLat = (lat - (centerLat - latSpan/2)) / latSpan;
      return (1.0 - normalizedLat) * screenSize.height;
    }

    double lngToX(double lng) {
      final normalizedLng = (lng - (centerLng - lngSpan/2)) / lngSpan;
      return normalizedLng * screenSize.width;
    }

    final x = lngToX(marrakechLng);
    final y = latToY(marrakechLat);

    return Positioned(
      left: x - 32, // Center the 64px wide marker
      top: y - 64,  // Place bottom point at destination
      child: SvgPicture.asset(
        'assets/svgs/icons/pin_arrive.svg',
        width: 64,
        height: 64,
        colorFilter: const ColorFilter.mode(
          AppColors.yslBlack,
          BlendMode.srcIn,
        ),
      ),
    );
  }

  Widget _buildFlightPathMap() {
    if (_userPosition == null) return const SizedBox.shrink();
    
    // Calculate bounds to show both user location and Marrakech
    final userLat = _userPosition!.latitude;
    final userLng = _userPosition!.longitude;
    
    // Calculate center point between user and Marrakech
    final centerLat = (userLat + _marrakechLat) / 2;
    final centerLng = (userLng + _marrakechLng) / 2;
    
    return GoogleMap(
      onMapCreated: (controller) {
        _mapController = controller;
        // Fit bounds once the map is ready
        _fitMapToRoute();
      },
      initialCameraPosition: CameraPosition(
        target: LatLng(centerLat, centerLng),
        zoom: _calculateOptimalZoom(userLat, userLng, _marrakechLat, _marrakechLng),
      ),
      mapType: MapType.normal,
      myLocationEnabled: false,
      myLocationButtonEnabled: false,
      zoomControlsEnabled: false,
      scrollGesturesEnabled: false,
      zoomGesturesEnabled: false,
      tiltGesturesEnabled: false,
      rotateGesturesEnabled: false,
      mapToolbarEnabled: false,
      compassEnabled: false,
      // Native markers, dotted polyline path, and pulsing circles
      markers: _markers,
      polylines: _polylines,
      circles: _circles,
      // Use YSL branded map style (simplified, elegant)
      style: '''[
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
      ]''',
    );
  }
  
  double _calculateOptimalZoom(double lat1, double lng1, double lat2, double lng2) {
    // Calculate distance between points
    final distance = Geolocator.distanceBetween(lat1, lng1, lat2, lng2) / 1000; // Convert to km
    
    // Determine zoom level based on distance
    if (distance < 100) return 8.0;      // Close locations
    if (distance < 500) return 6.0;      // Medium distance
    if (distance < 1000) return 5.0;     // Long distance
    if (distance < 2000) return 4.0;     // Very long distance
    return 3.0;                          // Intercontinental
  }

  // Setup native markers and a geodesic polyline between user and Marrakech
  Future<void> _setupMapRoute() async {
    if (_userPosition == null) return;

    final start = LatLng(_userPosition!.latitude, _userPosition!.longitude);
    // Ensure destination is firmly on mainland Marrakech
    const end = LatLng(_marrakechLat, _marrakechLng); // 31.6295, -7.9811

    // Compute distance for pulse scaling
    _routeDistanceMeters = Geolocator.distanceBetween(
      start.latitude,
      start.longitude,
      end.latitude,
      end.longitude,
    );

    // Ensure plane and destination icons are ready from assets
    await _ensurePlaneIconFromAsset();
    await _ensureDestPinIconFromAsset();

    // Build dotted geodesic polyline segments
    final segments = _createDottedGeodesicSegments(start, end);

    // Build markers (use SVG icons if already captured; they will refresh later otherwise)
    final markers = <Marker>{
      Marker(
        markerId: const MarkerId('marrakech'),
        position: end,
        icon: _destPinIcon ?? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        anchor: const Offset(0.5, 1.0),
        zIndex: 1.0,
      ),
      Marker(
        markerId: const MarkerId('plane'),
        position: start,
        icon: _planeIcon ?? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
        flat: true,
        anchor: const Offset(0.5, 0.5),
        rotation: 0,
        zIndex: 2.0,
      ),
    };

    setState(() {
      _markers
        ..clear()
        ..addAll(markers);
      _polylines
        ..clear()
        ..addAll(segments);
    });

    // Fit map to route
    await _fitMapToRoute();
  }

  // Update the animated plane marker position along the route using great-circle interpolation
  void _updatePlaneMarkerAtProgress(double t) {
    if (_userPosition == null) return;
    final start = LatLng(_userPosition!.latitude, _userPosition!.longitude);
    const end = LatLng(_marrakechLat, _marrakechLng);

    final current = _slerpCoordinates(start, end, t.clamp(0.0, 1.0));
    final next = _slerpCoordinates(start, end, (t + 0.01).clamp(0.0, 1.0));
    final rot = _bearing(current, next);

    final updated = _markers.map((m) {
      if (m.markerId.value == 'plane') {
        return m.copyWith(
          positionParam: current,
          rotationParam: rot,
          iconParam: _planeIcon ?? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
          anchorParam: const Offset(0.5, 0.5),
        );
      }
      return m;
    }).toSet();

    setState(() {
      _markers
        ..clear()
        ..addAll(updated);
    });
  }

  // Great-circle interpolation between two LatLng points
  LatLng _slerpCoordinates(LatLng a, LatLng b, double t) {
    final lat1 = a.latitude * math.pi / 180.0;
    final lon1 = a.longitude * math.pi / 180.0;
    final lat2 = b.latitude * math.pi / 180.0;
    final lon2 = b.longitude * math.pi / 180.0;

    final d = 2 * math.asin(math.sqrt(
      math.pow(math.sin((lat2 - lat1) / 2), 2) +
      math.cos(lat1) * math.cos(lat2) * math.pow(math.sin((lon2 - lon1) / 2), 2),
    ));

    if (d == 0) return a;

    final A = math.sin((1 - t) * d) / math.sin(d);
    final B = math.sin(t * d) / math.sin(d);

    final x = A * math.cos(lat1) * math.cos(lon1) + B * math.cos(lat2) * math.cos(lon2);
    final y = A * math.cos(lat1) * math.sin(lon1) + B * math.cos(lat2) * math.sin(lon2);
    final z = A * math.sin(lat1) + B * math.sin(lat2);

    final lat = math.atan2(z, math.sqrt(x * x + y * y));
    final lon = math.atan2(y, x);

    return LatLng(lat * 180.0 / math.pi, lon * 180.0 / math.pi);
  }

  // Bearing between two coordinates in degrees (0-360)
  double _bearing(LatLng from, LatLng to) {
    final lat1 = from.latitude * math.pi / 180.0;
    final lon1 = from.longitude * math.pi / 180.0;
    final lat2 = to.latitude * math.pi / 180.0;
    final lon2 = to.longitude * math.pi / 180.0;

    final dLon = lon2 - lon1;
    final y = math.sin(dLon) * math.cos(lat2);
    final x = math.cos(lat1) * math.sin(lat2) - math.sin(lat1) * math.cos(lat2) * math.cos(dLon);
    var brng = math.atan2(y, x) * 180.0 / math.pi;
    brng = (brng + 360.0) % 360.0;
    return brng;
  }

  // Build multiple short geodesic polylines to simulate a dotted path from user to mainland Marrakech
  Set<Polyline> _createDottedGeodesicSegments(LatLng start, LatLng end) {
    const int segments = 160; // smoother curve
    const double dashPortion = 0.45; // 45% dash, 55% gap
    final Set<Polyline> lines = {};
    int id = 0;

    for (int i = 0; i < segments; i++) {
      final double t0 = i / segments;
      final double t1 = (i + 1) / segments;
      // Dash-gap pattern in cycles
      final double phase = (i % 10) / 10.0;
      final bool isDash = phase < dashPortion;
      if (!isDash) continue;

      final LatLng p0 = _slerpCoordinates(start, end, t0);
      final LatLng p1 = _slerpCoordinates(start, end, t1);

      lines.add(
        Polyline(
          polylineId: PolylineId('route_$id'),
          points: [p0, p1],
          color: AppColors.yslBlack,
          width: 2,
          geodesic: true,
        ),
      );
      id++;
    }
    return lines;
  }

  // Ensure the plane marker icon is loaded from a PNG asset
  Future<void> _ensurePlaneIconFromAsset() async {
    if (_planeIcon != null) return;
    try {
      final cfg = const ImageConfiguration(devicePixelRatio: 3.0);
      _planeIcon = await BitmapDescriptor.fromAssetImage(
        cfg,
        'assets/svgs/icons/Plane.png',
      );
    } catch (e) {
      print('⚠️ Failed to load plane icon from asset: $e');
    }
  }

  // Ensure the destination pin icon is loaded from a PNG asset
  Future<void> _ensureDestPinIconFromAsset() async {
    if (_destPinIcon != null) return;
    try {
      final cfg = const ImageConfiguration(devicePixelRatio: 3.0);
      _destPinIcon = await BitmapDescriptor.fromAssetImage(
        cfg,
        'assets/svgs/icons/dest_pin.png',
      );
    } catch (e) {
      print('⚠️ Failed to load destination pin icon from asset: $e');
    }
  }

  // Ensure marker icons are captured as PNG from hidden RepaintBoundary widgets
  Future<void> _ensureMarkerIconsCaptured() async {
    if (_planeIcon == null) {
      var planeBytes = await _capturePngFromKey(_planeIconKey, pixelRatio: 3.0);
      planeBytes ??= await Future.delayed(const Duration(milliseconds: 50)).then((_) => _capturePngFromKey(_planeIconKey, pixelRatio: 3.0));
      if (planeBytes != null) {
        _planeIcon = BitmapDescriptor.fromBytes(planeBytes);
      }
    }
    if (_pinArriveIcon == null) {
      var pinBytes = await _capturePngFromKey(_pinIconKey, pixelRatio: 3.0);
      pinBytes ??= await Future.delayed(const Duration(milliseconds: 50)).then((_) => _capturePngFromKey(_pinIconKey, pixelRatio: 3.0));
      if (pinBytes != null) {
        _pinArriveIcon = BitmapDescriptor.fromBytes(pinBytes);
      }
    }
  }

  Future<Uint8List?> _capturePngFromKey(GlobalKey key, {double pixelRatio = 3.0}) async {
    try {
      final context = key.currentContext;
      if (context == null) return null;
      final boundary = context.findRenderObject() as RenderRepaintBoundary?;
      if (boundary == null) return null;
      final image = await boundary.toImage(pixelRatio: pixelRatio);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      return byteData?.buffer.asUint8List();
    } catch (e) {
      print('⚠️ Failed to capture PNG for marker: $e');
      return null;
    }
  }

  void _refreshMarkerIconsIfAvailable() {
    bool changed = false;
    final updated = _markers.map((m) {
      if (m.markerId.value == 'plane' && _planeIcon != null) {
        changed = true;
        return m.copyWith(iconParam: _planeIcon);
      }
      if (m.markerId.value == 'marrakech' && (_destPinIcon != null || _pinArriveIcon != null)) {
        changed = true;
        return m.copyWith(iconParam: _destPinIcon ?? _pinArriveIcon, anchorParam: const Offset(0.5, 1.0));
      }
      return m;
    }).toSet();
    if (changed) {
      setState(() {
        _markers
          ..clear()
          ..addAll(updated);
      });
    }
  }

  Future<void> _fitMapToRoute() async {
    if (_userPosition == null || _mapController == null) return;
    final start = LatLng(_userPosition!.latitude, _userPosition!.longitude);
    const end = LatLng(_marrakechLat, _marrakechLng);

    final south = math.min(start.latitude, end.latitude);
    final north = math.max(start.latitude, end.latitude);
    final west = math.min(start.longitude, end.longitude);
    final east = math.max(start.longitude, end.longitude);

    final bounds = LatLngBounds(
      southwest: LatLng(south, west),
      northeast: LatLng(north, east),
    );

    // Slight delay to ensure map has a size
    await Future.delayed(const Duration(milliseconds: 250));
    try {
      await _mapController!.animateCamera(
        CameraUpdate.newLatLngBounds(bounds, 64.0), // padding
      );
    } catch (_) {
      // Retry once if it failed (common on web before layout)
      await Future.delayed(const Duration(milliseconds: 300));
      await _mapController!.animateCamera(
        CameraUpdate.newLatLngBounds(bounds, 64.0),
      );
    }
  }

  Widget _buildFlightPathLine() {
    if (_userPosition == null) {
      return const SizedBox.shrink();
    }

    return AnimatedBuilder(
      animation: _planeController,
      builder: (context, child) {
        return CustomPaint(
          painter: FlightPathLinePainter(
            userPosition: _userPosition!,
            pathProgress: _planeController.value,
            marrakechLat: 31.6295, // Updated coordinates
            marrakechLng: -7.9811, // Updated coordinates
          ),
          size: Size.infinite,
        );
      },
    );
  }

  Widget _buildAccuratePlaneOverlay() {
    if (!_planeController.isAnimating || _userPosition == null) {
      return const SizedBox.shrink();
    }

    return AnimatedBuilder(
      animation: _planeProgress,
      builder: (context, child) {
        final screenSize = MediaQuery.of(context).size;
        final progress = _planeProgress.value;

        // Get coordinates using same method as dotted line
        final start = LatLng(_userPosition!.latitude, _userPosition!.longitude);
        const end = LatLng(31.6295, -7.9811); // Updated coordinates

        // Use same coordinate conversion as dotted line
        final centerLat = (start.latitude + end.latitude) / 2;
        final centerLng = (start.longitude + end.longitude) / 2;
        final latSpan = (start.latitude - end.latitude).abs() * 1.5;
        final lngSpan = (start.longitude - end.longitude).abs() * 1.5;

        // Convert coordinates to screen space
        final startX = _lngToScreenX(start.longitude, centerLng, lngSpan, screenSize.width);
        final startY = _latToScreenY(start.latitude, centerLat, latSpan, screenSize.height);
        final endX = _lngToScreenX(end.longitude, centerLng, lngSpan, screenSize.width);
        final endY = _latToScreenY(end.latitude, centerLat, latSpan, screenSize.height);

        // Use same curve calculation as dotted line
        final controlX = (startX + endX) / 2;
        final controlY = math.min(startY, endY) - 80; // Same arc height as path

        // Calculate current point using quadratic bezier
        final t = progress;
        final x = (1 - t) * (1 - t) * startX + 2 * (1 - t) * t * controlX + t * t * endX;
        final y = (1 - t) * (1 - t) * startY + 2 * (1 - t) * t * controlY + t * t * endY;

        // Calculate next point for rotation
        final nextT = math.min(1.0, t + 0.01);
        final nextX = (1 - nextT) * (1 - nextT) * startX + 2 * (1 - nextT) * nextT * controlX + nextT * nextT * endX;
        final nextY = (1 - nextT) * (1 - nextT) * startY + 2 * (1 - nextT) * nextT * controlY + nextT * nextT * endY;

        final rotation = math.atan2(nextY - y, nextX - x) + math.pi / 2;

        return Positioned(
          left: x - 16, // Center the 32px wide marker
          top: y - 16, // Center the 32px tall marker
          child: Transform.rotate(
            angle: rotation,
            child: Container(
              width: 32, // Even smaller size
              height: 32, // Even smaller size
              decoration: BoxDecoration(
                color: AppColors.yslBlack,
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.yslWhite,
                  width: 1.0,
                ),
              ),
              child: const Icon(
                Icons.flight,
                color: AppColors.yslWhite,
                size: 20, // Smaller icon
              ),
            ),
          ),
        );
      },
    );
  }

  // Helper methods for coordinate conversion
  double _lngToScreenX(double lng, double centerLng, double lngSpan, double width) {
    final normalizedLng = (lng - (centerLng - lngSpan/2)) / lngSpan;
    return normalizedLng * width;
  }

  double _latToScreenY(double lat, double centerLat, double latSpan, double height) {
    final normalizedLat = (lat - (centerLat - latSpan/2)) / latSpan;
    return (1.0 - normalizedLat) * height;
  }
}

// Custom painter for flight path and location markers
class FlightPathLinePainter extends CustomPainter {
  final Position userPosition;
  final double pathProgress;
  final double marrakechLat;
  final double marrakechLng;

  FlightPathLinePainter({
    required this.userPosition,
    required this.pathProgress,
    required this.marrakechLat,
    required this.marrakechLng,
  });
  
  @override
  void paint(Canvas canvas, Size size) {
    if (pathProgress <= 0) return;
    
    final start = LatLng(userPosition.latitude, userPosition.longitude);
    final end = LatLng(marrakechLat, marrakechLng);

    // Calculate the map bounds and center
    final centerLat = (start.latitude + end.latitude) / 2;
    final centerLng = (start.longitude + end.longitude) / 2;

    // Calculate the span of the visible map area
    final latSpan = (start.latitude - end.latitude).abs() * 1.5;
    final lngSpan = (start.longitude - end.longitude).abs() * 1.5;

    // Convert lat/lng to screen coordinates
    double latToY(double lat) {
      final normalizedLat = (lat - (centerLat - latSpan/2)) / latSpan;
      return (1.0 - normalizedLat) * size.height;
    }

    double lngToX(double lng) {
      final normalizedLng = (lng - (centerLng - lngSpan/2)) / lngSpan;
      return normalizedLng * size.width;
    }
    
    // Calculate start and end points
    final startX = lngToX(start.longitude);
    final startY = latToY(start.latitude);
    final endX = lngToX(end.longitude);
    final endY = latToY(end.latitude);

    // Create curved path
    final path = Path();
    path.moveTo(startX, startY);

    // Create quadratic bezier curve
    final controlX = (startX + endX) / 2;
    final controlY = math.min(startY, endY) - 80; // Arc height

    path.quadraticBezierTo(controlX, controlY, endX, endY);

    // Create dotted effect
    final pathMetrics = path.computeMetrics();
    for (final metric in pathMetrics) {
      final totalLength = metric.length;
      final drawLength = totalLength * pathProgress;
      
      double distance = 0;
      const dashLength = 12.0;
      const gapLength = 8.0;
      
      while (distance < drawLength) {
        final dashEnd = (distance + dashLength).clamp(0.0, drawLength);
        final dashPath = metric.extractPath(distance, dashEnd);
        
        // Draw white outline first
        canvas.drawPath(
          dashPath,
          Paint()
            ..color = AppColors.yslWhite
            ..strokeWidth = 5.0
            ..style = PaintingStyle.stroke,
        );

        // Draw black path on top
        canvas.drawPath(
          dashPath,
          Paint()
            ..color = AppColors.yslBlack
            ..strokeWidth = 3.0
            ..style = PaintingStyle.stroke,
        );

        distance += dashLength + gapLength;
      }
    }
  }
  
  @override
  bool shouldRepaint(FlightPathLinePainter oldDelegate) {
    return pathProgress != oldDelegate.pathProgress;
  }
}
