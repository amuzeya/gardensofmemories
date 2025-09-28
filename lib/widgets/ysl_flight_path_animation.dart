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
  
  // Animation controllers
  late AnimationController _planeController;
  late AnimationController _pathRevealController;
  late AnimationController _fadeInController;
  late AnimationController _pulseController;
  
  // Animations
  late Animation<double> _planeProgress;
  late Animation<double> _pathReveal;
  late Animation<double> _fadeIn;
  
  // Location data
  Position? _userPosition;
  bool _locationGranted = false;
  bool _locationDenied = false;
  bool _isRequestingPermission = true;
  
  // Map coordinates
  static const double _marrakechLat = 31.629472;
  static const double _marrakechLng = -7.981084;
  
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
    
    // Path reveal animation (1.5 seconds)
    _pathRevealController = AnimationController(
      duration: const Duration(milliseconds: 1500),
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
    
    _pathReveal = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _pathRevealController,
      curve: Curves.easeOutQuart,
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
    final base = _routeDistanceMeters > 0 ? _routeDistanceMeters * 0.01 : 5000.0; // meters
    final radius = base * (0.5 + t); // expanding
    final alpha = (1.0 - t).clamp(0.0, 1.0);

    final userCenter = LatLng(_userPosition!.latitude, _userPosition!.longitude);

    final circles = <Circle>{
      Circle(
        circleId: const CircleId('pulse'),
        center: userCenter,
        radius: radius,
        strokeWidth: 2,
        strokeColor: AppColors.yslBlack.withValues(alpha: (0.3 * alpha)),
        fillColor: AppColors.yslBlack.withValues(alpha: (0.1 * alpha)),
        zIndex: 0,
      ),
      Circle(
        circleId: const CircleId('dot'),
        center: userCenter,
        radius: base * 0.05, // small solid center
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
        _pathRevealController.forward();
      }
    });
    
    // Finally start the plane animation
    Future.delayed(const Duration(milliseconds: 2000), () {
      if (mounted) {
        print('✈️ Starting plane animation');
        
        // Move the plane marker along the route every frame
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
    _pathRevealController.dispose();
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
          // Map with native markers, polyline path, and pulsing circles
          _buildFlightPathMap(),

          // Offstage renderers to rasterize SVGs into marker PNGs
          Offstage(
            offstage: true,
            child: RepaintBoundary(
              key: _planeIconKey,
              child: SizedBox(
                width: 64,
                height: 64,
                child: Center(
                  child: SvgPicture.asset(
                    'assets/svgs/icons/plane.svg',
                    width: 56,
                    height: 56,
                    colorFilter: const ColorFilter.mode(AppColors.yslBlack, BlendMode.srcIn),
                  ),
                ),
              ),
            ),
          ),
          Offstage(
            offstage: true,
            child: RepaintBoundary(
              key: _pinIconKey,
              child: SizedBox(
                width: 64,
                height: 64,
                child: Center(
                  child: SvgPicture.asset(
                    'assets/svgs/icons/pin_arrive.svg',
                    width: 56,
                    height: 56,
                    colorFilter: const ColorFilter.mode(AppColors.yslBlack, BlendMode.srcIn),
                  ),
                ),
              ),
            ),
          ),

          // Trigger one-time capture after first frame
          Builder(builder: (context) {
            if (!_requestedIconCapture) {
              _requestedIconCapture = true;
              WidgetsBinding.instance.addPostFrameCallback((_) async {
                await _ensureMarkerIconsCaptured();
                _refreshMarkerIconsIfAvailable();
              });
            }
            return const SizedBox.shrink();
          }),
        ],
      ),
    );
  }

  Widget _buildOverlayContent() {
    return Stack(
      children: [
        // Title overlay
        Positioned(
          top: MediaQuery.of(context).padding.top + 40,
          left: 20,
          right: 20,
          child: Column(
            children: [
              SvgPicture.asset(
                'assets/svgs/logos/state_logo_beaut_on.svg',
                height: 32,
                colorFilter: const ColorFilter.mode(
                  AppColors.yslBlack,
                  BlendMode.srcIn,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'YOUR JOURNEY TO MARRAKECH',
                style: AppText.titleLarge.copyWith(
                  color: AppColors.yslBlack,
                  fontSize: 18,
                  letterSpacing: 1.2,
                  fontFamily: 'ITC Avant Garde Gothic Pro',
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        
        // Animated airplane
        if (_planeController.isAnimating)
          AnimatedBuilder(
            animation: _planeProgress,
            builder: (context, child) {
              final planePosition = _calculatePlanePosition(_planeProgress.value);
              print('✈️ Plane at progress ${_planeProgress.value}: (${planePosition.dx}, ${planePosition.dy})');
              return Positioned(
                left: planePosition.dx - 40, // Center the plane (80px wide)
                top: planePosition.dy - 40, // Center the plane (80px tall)
                child: Transform.rotate(
                  angle: _calculatePlaneRotation(_planeProgress.value),
                  child: Container(
                    width: 80, // MUCH LARGER
                    height: 80, // MUCH LARGER
                    decoration: const BoxDecoration(
                      color: AppColors.yslBlack,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.flight,
                      color: AppColors.yslWhite,
                      size: 50, // MUCH LARGER ICON
                    ),
                  ),
                ),
              );
            },
          ),
      ],
    );
  }

  Offset _calculatePlanePosition(double progress) {
    if (_userPosition == null) return Offset.zero;
    
    final size = MediaQuery.of(context).size;
    
    // Use the same coordinate conversion as the custom painter
    final userLat = _userPosition!.latitude;
    final userLng = _userPosition!.longitude;
    
    // Calculate bounds (same logic as in CustomPainter)
    final minLat = math.min(userLat, _marrakechLat);
    final maxLat = math.max(userLat, _marrakechLat);
    final minLng = math.min(userLng, _marrakechLng);
    final maxLng = math.max(userLng, _marrakechLng);
    
    final latRange = maxLat - minLat;
    final lngRange = maxLng - minLng;
    final paddedMinLat = minLat - latRange * 0.1;
    final paddedMaxLat = maxLat + latRange * 0.1;
    final paddedMinLng = minLng - lngRange * 0.1;
    final paddedMaxLng = maxLng + lngRange * 0.1;
    
    // Convert start and end to screen coordinates
    final startX = ((userLng - paddedMinLng) / (paddedMaxLng - paddedMinLng)) * size.width;
    final startY = ((paddedMaxLat - userLat) / (paddedMaxLat - paddedMinLat)) * size.height;
    
    final endX = ((_marrakechLng - paddedMinLng) / (paddedMaxLng - paddedMinLng)) * size.width;
    final endY = ((paddedMaxLat - _marrakechLat) / (paddedMaxLat - paddedMinLat)) * size.height;
    
    // Create curved path using quadratic bezier
    final controlX = (startX + endX) / 2; // Midpoint X
    final controlY = math.min(startY, endY) - 100; // High arc above both points
    
    // Quadratic Bezier curve calculation
    final t = progress;
    final x = (1 - t) * (1 - t) * startX + 2 * (1 - t) * t * controlX + t * t * endX;
    final y = (1 - t) * (1 - t) * startY + 2 * (1 - t) * t * controlY + t * t * endY;
    
    return Offset(x, y);
  }

  double _calculatePlaneRotation(double progress) {
    // Calculate rotation based on flight direction
    final currentPos = _calculatePlanePosition(progress);
    final nextPos = _calculatePlanePosition((progress + 0.01).clamp(0.0, 1.0));
    
    final dx = nextPos.dx - currentPos.dx;
    final dy = nextPos.dy - currentPos.dy;
    
    return math.atan2(dy, dx) + math.pi / 2; // Adjust for plane orientation
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
        
        // Get actual coordinates
        final userLat = _userPosition!.latitude;
        final userLng = _userPosition!.longitude;
        const marrakechLat = 31.6295;
        const marrakechLng = -7.9811;
        
        print('🗺️ User position: $userLat, $userLng');
        print('🗺️ Marrakech position: $marrakechLat, $marrakechLng');
        
        // Calculate the map bounds and center (same as Google Map)
        final centerLat = (userLat + marrakechLat) / 2;
        final centerLng = (userLng + marrakechLng) / 2;
        
        // Calculate the span of the visible map area
        final latSpan = (userLat - marrakechLat).abs() * 1.5; // Add padding
        final lngSpan = (userLng - marrakechLng).abs() * 1.5; // Add padding
        
        // Convert lat/lng to screen coordinates using Web Mercator-like projection
        // This approximates how Google Maps projects coordinates to screen space
        double latToY(double lat) {
          final normalizedLat = (lat - (centerLat - latSpan/2)) / latSpan;
          return (1.0 - normalizedLat) * screenSize.height; // Flip Y axis
        }
        
        double lngToX(double lng) {
          final normalizedLng = (lng - (centerLng - lngSpan/2)) / lngSpan;
          return normalizedLng * screenSize.width;
        }
        
        // Calculate start and end positions on screen
        final startX = lngToX(userLng);
        final startY = latToY(userLat);
        final endX = lngToX(marrakechLng);
        final endY = latToY(marrakechLat);
        
        print('🛫 Start screen pos: ($startX, $startY)');
        print('🛬 End screen pos: ($endX, $endY)');
        
        // Create curved flight path
        final controlX = (startX + endX) / 2;
        final controlY = math.min(startY, endY) - 80; // Arc above
        
        // Quadratic bezier curve
        final t = progress;
        final x = (1 - t) * (1 - t) * startX + 2 * (1 - t) * t * controlX + t * t * endX;
        final y = (1 - t) * (1 - t) * startY + 2 * (1 - t) * t * controlY + t * t * endY;
        
        print('✈️ Plane at progress $progress: ($x, $y)');
        
        // Calculate rotation based on direction
        final nextT = math.min(1.0, t + 0.01);
        final nextX = (1 - nextT) * (1 - nextT) * startX + 2 * (1 - nextT) * nextT * controlX + nextT * nextT * endX;
        final nextY = (1 - nextT) * (1 - nextT) * startY + 2 * (1 - nextT) * nextT * controlY + nextT * nextT * endY;
        final rotation = math.atan2(nextY - y, nextX - x) + math.pi / 2;
        
        return Positioned(
          left: x - 40,
          top: y - 40,
          child: Transform.rotate(
            angle: rotation,
            child: Container(
              width: 80,
              height: 80,
              decoration: const BoxDecoration(
                color: AppColors.yslBlack,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.flight,
                color: AppColors.yslWhite,
                size: 50,
              ),
            ),
          ),
        );
      },
    );
  }
  
  Widget _buildFlightPathLine() {
    if (_userPosition == null) {
      return const SizedBox.shrink();
    }
    
    return AnimatedBuilder(
      animation: _pathReveal,
      builder: (context, child) {
        return CustomPaint(
          painter: FlightPathLinePainter(
            userPosition: _userPosition!,
            pathProgress: _pathReveal.value,
          ),
          size: Size.infinite,
        );
      },
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
    const end = LatLng(_marrakechLat, _marrakechLng);

    // Icons are captured post-frame from hidden widgets; markers will update when ready

    // Compute distance for pulse scaling
    _routeDistanceMeters = Geolocator.distanceBetween(
      start.latitude,
      start.longitude,
      end.latitude,
      end.longitude,
    );

    final markers = <Marker>{
      // Marrakech destination pin
      Marker(
        markerId: const MarkerId('marrakech'),
        position: end,
        infoWindow: const InfoWindow(title: 'Marrakech'),
        icon: _pinArriveIcon ?? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        anchor: const Offset(0.5, 1.0),
        zIndex: 1.0,
      ),
      // Plane marker (animated)
      Marker(
        markerId: const MarkerId('plane'),
        position: start,
        icon: _planeIcon ?? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
        anchor: const Offset(0.5, 0.5),
        rotation: 0,
        zIndex: 2.0,
      ),
    };

    // Dotted geodesic polyline as segments
    final polylines = _createDottedGeodesicSegments(start, end);

    setState(() {
      _markers
        ..clear()
        ..addAll(markers);
      _polylines
        ..clear()
        ..addAll(polylines);
    });

    // Fit map to route once markers/polylines are set
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

  // Build multiple short geodesic polylines to simulate a dotted path
  Set<Polyline> _createDottedGeodesicSegments(LatLng start, LatLng end) {
    const int segments = 120; // higher = smoother
    const double dashPortion = 0.4; // 40% dash, 60% gap
    final Set<Polyline> lines = {};
    int id = 0;

    for (int i = 0; i < segments; i++) {
      final double t0 = i / segments;
      final double t1 = (i + 1) / segments;
      // Determine if this segment is part of a dash or a gap
      final double phase = (i % 10) / 10.0; // cycles of 10 segments
      final bool isDash = phase < dashPortion;
      if (!isDash) continue;

      final LatLng p0 = _slerpCoordinates(start, end, t0);
      final LatLng p1 = _slerpCoordinates(start, end, t1);

      lines.add(
        Polyline(
          polylineId: PolylineId('route_$id'),
          points: [p0, p1],
          color: AppColors.yslBlack,
          width: 2, // thin
          geodesic: true,
        ),
      );
      id++;
    }
    return lines;
  }

  // Ensure marker icons are captured as PNG from hidden RepaintBoundary widgets
  Future<void> _ensureMarkerIconsCaptured() async {
    if (_planeIcon == null) {
      final planeBytes = await _capturePngFromKey(_planeIconKey, pixelRatio: 3.0);
      if (planeBytes != null) {
        _planeIcon = BitmapDescriptor.fromBytes(planeBytes);
      }
    }
    if (_pinArriveIcon == null) {
      final pinBytes = await _capturePngFromKey(_pinIconKey, pixelRatio: 3.0);
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
      if (m.markerId.value == 'marrakech' && _pinArriveIcon != null) {
        changed = true;
        return m.copyWith(iconParam: _pinArriveIcon, anchorParam: const Offset(0.5, 1.0));
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
}

// Custom painter for flight path and location markers
class FlightPathPainter extends CustomPainter {
  final double userLat;
  final double userLng;
  final double destinationLat;
  final double destinationLng;
  final double pathProgress;
  final double planeProgress;

  FlightPathPainter({
    required this.userLat,
    required this.userLng,
    required this.destinationLat,
    required this.destinationLng,
    required this.pathProgress,
    required this.planeProgress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    print('🎨 CustomPainter paint called - Size: ${size.width}x${size.height}');
    print('🗺️ Path progress: $pathProgress, Plane progress: $planeProgress');
    
    // No background - transparent to show map underneath
    // (Removed background paint for transparency)
    
    // Convert geographic coordinates to screen coordinates
    final userPosition = _geoToScreen(userLat, userLng, size);
    final destPosition = _geoToScreen(destinationLat, destinationLng, size);
    
    print('🗺️ User screen position: $userPosition');
    print('🗺️ Dest screen position: $destPosition');
    
    // Draw BOTH Google markers AND CustomPaint dots for visibility
    // Google markers are accurate, CustomPaint shows flight path endpoints
    
    // Draw user location with white border for visibility - LARGE for debugging
    final userBorderPaint = Paint()
      ..color = AppColors.yslWhite
      ..style = PaintingStyle.fill;
    canvas.drawCircle(userPosition, 35, userBorderPaint);
    
    final userPaint = Paint()
      ..color = AppColors.yslBlack
      ..style = PaintingStyle.fill;
    canvas.drawCircle(userPosition, 25, userPaint);
    
    // Add text label for user location
    final userTextPainter = TextPainter(
      text: TextSpan(
        text: 'YOU',
        style: TextStyle(
          color: AppColors.yslWhite,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    userTextPainter.layout();
    userTextPainter.paint(
      canvas,
      Offset(
        userPosition.dx - userTextPainter.width / 2,
        userPosition.dy - userTextPainter.height / 2,
      ),
    );
    
    // Draw destination with white border - LARGE for debugging
    final destBorderPaint = Paint()
      ..color = AppColors.yslWhite
      ..style = PaintingStyle.fill;
    canvas.drawCircle(destPosition, 35, destBorderPaint);
    
    final destPaint = Paint()
      ..color = AppColors.yslBlack
      ..style = PaintingStyle.fill;
    canvas.drawCircle(destPosition, 25, destPaint);
    
    // Add text label for destination
    final destTextPainter = TextPainter(
      text: TextSpan(
        text: 'MRK',
        style: TextStyle(
          color: AppColors.yslWhite,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    destTextPainter.layout();
    destTextPainter.paint(
      canvas,
      Offset(
        destPosition.dx - destTextPainter.width / 2,
        destPosition.dy - destTextPainter.height / 2,
      ),
    );
    
    // Flight path (dotted curved line)
    print('🎨 Drawing flight path - pathProgress: $pathProgress');
    if (pathProgress > 0) {
      print('✍️ Drawing flight path from ${userPosition} to ${destPosition}');
      _drawFlightPath(canvas, size, userPosition, destPosition);
    } else {
      print('⏸️ Skipping flight path - progress is 0');
    }
  }

  void _drawFlightPath(Canvas canvas, Size size, Offset start, Offset end) {
    print('🎨 _drawFlightPath called - start: $start, end: $end, progress: $pathProgress');
    print('🗺️ Real coordinates - User: ($userLat, $userLng), Dest: ($destinationLat, $destinationLng)');
    
    // Verify we're using the REAL coordinates, not example ones
    if (start.dx.round() != _geoToScreen(userLat, userLng, size).dx.round()) {
      print('⚠️ WARNING: Start position mismatch! Using wrong coordinates!');
    }
    if (end.dx.round() != _geoToScreen(destinationLat, destinationLng, size).dx.round()) {
      print('⚠️ WARNING: End position mismatch! Using wrong coordinates!');
    }
    
    // White outline paint for visibility - MUCH THICKER
    final outlinePaint = Paint()
      ..color = AppColors.yslWhite
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12;
    
    // Black path paint - MUCH THICKER
    final pathPaint = Paint()
      ..color = AppColors.yslBlack
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8;
      
    print('🎨 Paint config - black path with white outline');

    final path = Path();
    
    // Create curved path using same logic as plane calculation
    final controlPoint = Offset(
      (start.dx + end.dx) / 2, // Midpoint X
      math.min(start.dy, end.dy) - 100, // High arc above both points
    );
    path.moveTo(start.dx, start.dy);
    path.quadraticBezierTo(controlPoint.dx, controlPoint.dy, end.dx, end.dy);
    
    print('🗺️ Path created from $start via $controlPoint to $end');
    
    // Create dotted line effect
    final pathMetrics = path.computeMetrics();
    for (final metric in pathMetrics) {
      final totalLength = metric.length;
      final drawLength = totalLength * pathProgress;
      
      print('📏 Path length: $totalLength, drawing: $drawLength (${(pathProgress * 100).toStringAsFixed(1)}%)');
      
      double distance = 0;
      const dashLength = 10.0; // Made longer
      const gapLength = 6.0; // Made shorter
      int dashCount = 0;
      
      while (distance < drawLength) {
        final dashEnd = (distance + dashLength).clamp(0.0, drawLength);
        final dashPath = metric.extractPath(distance, dashEnd);
        
        // Draw white outline first (for visibility against map)
        canvas.drawPath(dashPath, outlinePaint);
        // Draw black path on top
        canvas.drawPath(dashPath, pathPaint);
        
        distance += dashLength + gapLength;
        dashCount++;
      }
      
      print('📏 Drew $dashCount dashes');
    }
  }

  @override
  bool shouldRepaint(FlightPathPainter oldDelegate) {
    return pathProgress != oldDelegate.pathProgress ||
           planeProgress != oldDelegate.planeProgress;
  }
  
  // Convert geographic coordinates to screen coordinates
  Offset _geoToScreen(double lat, double lng, Size size) {
    print('🔄 Converting coords: ($lat, $lng) with size ${size.width}x${size.height}');
    
    // Calculate bounds - user location and Marrakech
    final minLat = math.min(userLat, destinationLat);
    final maxLat = math.max(userLat, destinationLat);
    final minLng = math.min(userLng, destinationLng);
    final maxLng = math.max(userLng, destinationLng);
    
    print('📏 Bounds - Lat: $minLat to $maxLat, Lng: $minLng to $maxLng');
    
    // Add padding to bounds (10%)
    final latRange = maxLat - minLat;
    final lngRange = maxLng - minLng;
    final paddedMinLat = minLat - latRange * 0.1;
    final paddedMaxLat = maxLat + latRange * 0.1;
    final paddedMinLng = minLng - lngRange * 0.1;
    final paddedMaxLng = maxLng + lngRange * 0.1;
    
    print('📏 Padded bounds - Lat: $paddedMinLat to $paddedMaxLat, Lng: $paddedMinLng to $paddedMaxLng');
    
    // Convert to screen coordinates
    final x = ((lng - paddedMinLng) / (paddedMaxLng - paddedMinLng)) * size.width;
    final y = ((paddedMaxLat - lat) / (paddedMaxLat - paddedMinLat)) * size.height; // Flip Y axis
    
    print('🎯 Converted ($lat, $lng) to ($x, $y)');
    
    return Offset(x, y);
  }
}

// Simplified flight path line painter that matches the accurate plane overlay coordinates
class FlightPathLinePainter extends CustomPainter {
  final Position userPosition;
  final double pathProgress;
  
  FlightPathLinePainter({
    required this.userPosition,
    required this.pathProgress,
  });
  
  @override
  void paint(Canvas canvas, Size size) {
    if (pathProgress <= 0) return;
    
    // Use the same coordinate conversion as the accurate plane overlay
    final userLat = userPosition.latitude;
    final userLng = userPosition.longitude;
    const marrakechLat = 31.6295;
    const marrakechLng = -7.9811;
    
    // Calculate the map bounds and center (same as Google Map)
    final centerLat = (userLat + marrakechLat) / 2;
    final centerLng = (userLng + marrakechLng) / 2;
    
    // Calculate the span of the visible map area
    final latSpan = (userLat - marrakechLat).abs() * 1.5; // Add padding
    final lngSpan = (userLng - marrakechLng).abs() * 1.5; // Add padding
    
    // Convert lat/lng to screen coordinates
    double latToY(double lat) {
      final normalizedLat = (lat - (centerLat - latSpan/2)) / latSpan;
      return (1.0 - normalizedLat) * size.height; // Flip Y axis
    }
    
    double lngToX(double lng) {
      final normalizedLng = (lng - (centerLng - lngSpan/2)) / lngSpan;
      return normalizedLng * size.width;
    }
    
    // Calculate start and end positions on screen
    final startX = lngToX(userLng);
    final startY = latToY(userLat);
    final endX = lngToX(marrakechLng);
    final endY = latToY(marrakechLat);
    
    // Create curved path
    final controlX = (startX + endX) / 2;
    final controlY = math.min(startY, endY) - 80; // Arc above
    
    // Create the path
    final path = Path();
    path.moveTo(startX, startY);
    path.quadraticBezierTo(controlX, controlY, endX, endY);
    
    // Paint for the flight path line
    final pathPaint = Paint()
      ..color = AppColors.yslBlack
      ..strokeWidth = 3.0
      ..style = PaintingStyle.stroke;
      
    final outlinePaint = Paint()
      ..color = AppColors.yslWhite
      ..strokeWidth = 5.0
      ..style = PaintingStyle.stroke;
    
    // Draw the path up to the current progress
    final pathMetrics = path.computeMetrics();
    for (final metric in pathMetrics) {
      final totalLength = metric.length;
      final drawLength = totalLength * pathProgress;
      
      // Create dotted line effect
      double distance = 0;
      const dashLength = 12.0;
      const gapLength = 8.0;
      
      while (distance < drawLength) {
        final dashEnd = (distance + dashLength).clamp(0.0, drawLength);
        final dashPath = metric.extractPath(distance, dashEnd);
        
        // Draw white outline first
        canvas.drawPath(dashPath, outlinePaint);
        // Draw black path on top
        canvas.drawPath(dashPath, pathPaint);
        
        distance += dashLength + gapLength;
      }
    }
  }
  
  @override
  bool shouldRepaint(FlightPathLinePainter oldDelegate) {
    return pathProgress != oldDelegate.pathProgress;
  }
}
