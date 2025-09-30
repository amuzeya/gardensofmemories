// YSL Beauty Experience - Home Page Screen (mobile-first)
// Wires JSON data (assets/data/home) to built components

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

import '../data/home_repository.dart';
import '../mappers/location_mapper.dart';
import '../models/home_carousel_item.dart';
import '../models/home_content_card.dart';
import '../models/home_location.dart';
import '../models/home_map_config.dart';
import '../models/home_offer.dart';
import '../models/home_product.dart';
import '../models/home_quote.dart';

import '../theme/app_colors.dart';
import '../theme/app_text.dart';
import '../utils/responsive_utils.dart';
import '../utils/map_animation_utils.dart';

import '../widgets/ysl_exclusive_offer_banner.dart';
import '../widgets/ysl_location_slider.dart';
import '../widgets/ysl_location_card.dart';
import '../widgets/ysl_home_location_card.dart';
import '../widgets/ysl_google_map_background.dart';
import '../widgets/ysl_location_bottom_sheet.dart';
import '../models/location_details.dart';
import '../widgets/ysl_flight_path_animation.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../widgets/ysl_toggle_switch.dart';

class HomePageScreen extends StatefulWidget {
  const HomePageScreen({super.key});

  @override
  State<HomePageScreen> createState() => _HomePageScreenState();
}

class _HomeData {
  final HomeMapConfig map;
  final List<HomeOffer> offers;
  final List<HomeCarouselItem> carousel;
  final List<HomeLocation> locations;
  final List<HomeContentCard> cards;
  final List<HomeProduct> products;
  final List<HomeQuote> quotes;
  final Map<String, LocationDetails> detailsById;

  const _HomeData({
    required this.map,
    required this.offers,
    required this.carousel,
    required this.locations,
    required this.cards,
    required this.products,
    required this.quotes,
    required this.detailsById,
  });
}

class _HomePageScreenState extends State<HomePageScreen> with TickerProviderStateMixin {
  final _repo = HomeRepository();
  late Future<_HomeData> _future;
  YslToggleOption _viewToggle = YslToggleOption.map;
  int _selectedLocationIndex = 0;
  int _unlockedCount = 0; // number of unlocked regular locations (progression)
  late int _rewardIndex; // index of reward card in slider list
  bool _pulseFirstExplore = true;
  YslDeviceType? _deviceType;
  
  // Animation controllers for immersive map experience
  late AnimationController _heroFadeController;
  late AnimationController _toggleTransitionController;
  late AnimationController _viewModeTransitionController;
  late Animation<double> _heroSubtitleFade;
  late Animation<Offset> _heroSubtitleSlide;
  late Animation<double> _heroDescriptionFade;
  late Animation<Offset> _heroDescriptionSlide;
  late Animation<double> _toggleFadeOut;
  late Animation<Offset> _toggleSlideOut;
  late Animation<double> _compactToggleFadeIn;
  late Animation<Offset> _compactToggleSlideIn;
  late Animation<double> _heroHeightScale;
  late Animation<double> _titleSizeScale;
  late Animation<double> _viewModeFadeOut;
  late Animation<double> _viewModeFadeIn;
  late Animation<Offset> _viewModeSlideOut;
  late Animation<Offset> _viewModeSlideIn;
  
  // Unlock toast animation
  late AnimationController _unlockToastController;
  late Animation<double> _unlockToastOpacity;
  late Animation<Offset> _unlockToastSlide;
  bool _showUnlockToast = false;
  String _unlockToastText = 'NEW LOCATION UNLOCKED!';
  
  bool _isImmersiveMode = false;
  bool _hasInteracted = false;
  
  // Timer for automatic immersive transition
  Timer? _immersiveTimer;
  
  // Google Maps controller for cinematic animations
  GoogleMapController? _mapController;
  
  // User location (for starting flight from user's position)
  LatLng? _userLatLng;
  
  // Bottom sheet state
  bool _showBottomSheet = false;
  
  // Gamified flight path animation state
  bool _showFlightPath = true;
  bool _flightCompleted = false;
  
  // Hero content entrance animation controllers
  late AnimationController _heroEntranceController;
  late Animation<double> _heroContentFadeIn;
  late Animation<Offset> _heroContentSlideIn;
  late Animation<double> _subtitleEntranceFade;
  late Animation<double> _descriptionEntranceFade;
  bool _heroContentVisible = false;

  @override
  void initState() {
    super.initState();
    _future = _load();
    _setupAnimations();
    _startImmersiveTimer();
    // Kick off user location request
    _initUserLocation();
  }
  
  void _setupAnimations() {
    // Hero content fade animations - smoother and longer
    _heroFadeController = AnimationController(
      duration: const Duration(milliseconds: 2000), // Longer duration
      vsync: this,
    );
    
    // Toggle transition animations
    _toggleTransitionController = AnimationController(
      duration: const Duration(milliseconds: 1000), // Slightly longer
      vsync: this,
    );
    
    // View mode transition controller for smooth view switching
    _viewModeTransitionController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    // Unlock toast animations
    _unlockToastController = AnimationController(
      duration: const Duration(milliseconds: 800), // slower, more immersive
      vsync: this,
    );
    
    // Hero content entrance animations (for post-flight transition)
    _heroEntranceController = AnimationController(
      duration: const Duration(milliseconds: 2500), // Elegant, slow entrance
      vsync: this,
    );
    
    // Main hero content fade and slide
    _heroContentFadeIn = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _heroEntranceController,
      curve: const Interval(0.0, 0.8, curve: Curves.easeOutCubic),
    ));
    
    _heroContentSlideIn = Tween<Offset>(
      begin: const Offset(0.0, 0.3), // Start slightly below
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _heroEntranceController,
      curve: const Interval(0.0, 0.8, curve: Curves.easeOutQuart),
    ));
    
    // Staggered subtitle entrance
    _subtitleEntranceFade = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _heroEntranceController,
      curve: const Interval(0.3, 0.9, curve: Curves.easeOut),
    ));
    
    // Staggered description entrance
    _descriptionEntranceFade = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _heroEntranceController,
      curve: const Interval(0.5, 1.0, curve: Curves.easeOut),
    ));
    _unlockToastOpacity = CurvedAnimation(
      parent: _unlockToastController,
      curve: Curves.easeOut,
    );
    _unlockToastSlide = Tween<Offset>(begin: const Offset(0, -0.1), end: Offset.zero).animate(
      CurvedAnimation(parent: _unlockToastController, curve: Curves.easeOutCubic),
    );
    
    // Enhanced hero subtitle fade and slide animations
    _heroSubtitleFade = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _heroFadeController,
      curve: const Interval(0.0, 0.5, curve: Curves.easeInCubic), // Smoother curve
    ));
    
    _heroSubtitleSlide = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0.0, -0.8), // Subtle upward slide
    ).animate(CurvedAnimation(
      parent: _heroFadeController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeInOutCubic),
    ));
    
    // Enhanced description fade and slide animations
    _heroDescriptionFade = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _heroFadeController,
      curve: const Interval(0.1, 0.6, curve: Curves.easeInCubic), // Slightly delayed start
    ));
    
    _heroDescriptionSlide = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0.0, -1.2), // More pronounced upward slide
    ).animate(CurvedAnimation(
      parent: _heroFadeController,
      curve: const Interval(0.1, 0.7, curve: Curves.easeInOutCubic),
    ));
    
    // Original toggle fade out and slide animations with better curves
    _toggleFadeOut = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _toggleTransitionController,
      curve: const Interval(0.0, 0.4, curve: Curves.easeInCubic),
    ));
    
    _toggleSlideOut = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0.0, 2.0), // More dramatic slide
    ).animate(CurvedAnimation(
      parent: _toggleTransitionController,
      curve: const Interval(0.0, 0.5, curve: Curves.easeInQuart),
    ));
    
    // Compact toggle fade in and slide animations with refined timing
    _compactToggleFadeIn = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _toggleTransitionController,
      curve: const Interval(0.6, 1.0, curve: Curves.easeOutCubic), // Delayed entrance
    ));
    
    _compactToggleSlideIn = Tween<Offset>(
      begin: const Offset(2.0, 0.0), // Start further right
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _toggleTransitionController,
      curve: const Interval(0.6, 1.0, curve: Curves.easeOutQuart),
    ));
    
    // Hero header height scaling animation with smoother curve
    _heroHeightScale = Tween<double>(
      begin: 1.0,
      end: 0.5, // Cut in half
    ).animate(CurvedAnimation(
      parent: _heroFadeController,
      curve: const Interval(0.4, 1.0, curve: Curves.easeInOutCubic),
    ));
    
    // Title size scaling animation
    _titleSizeScale = Tween<double>(
      begin: 1.0,
      end: 0.7, // Smaller title
    ).animate(CurvedAnimation(
      parent: _heroFadeController,
      curve: const Interval(0.3, 1.0, curve: Curves.easeInOutCubic),
    ));
    
    // View mode transition animations for elegant view switching
    _viewModeFadeOut = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _viewModeTransitionController,
      curve: const Interval(0.0, 0.5, curve: Curves.easeInCubic),
    ));
    
    _viewModeFadeIn = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _viewModeTransitionController,
      curve: const Interval(0.5, 1.0, curve: Curves.easeOutCubic),
    ));
    
    _viewModeSlideOut = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(-1.0, 0.0), // Slide left
    ).animate(CurvedAnimation(
      parent: _viewModeTransitionController,
      curve: const Interval(0.0, 0.5, curve: Curves.easeInQuart),
    ));
    
    _viewModeSlideIn = Tween<Offset>(
      begin: const Offset(1.0, 0.0), // Start from right
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _viewModeTransitionController,
      curve: const Interval(0.5, 1.0, curve: Curves.easeOutQuart),
    ));
  }
  
  void _startImmersiveTimer() {
    // Start the immersive transition after 8 seconds if no interaction (longer for better UX)
    _immersiveTimer = Timer(const Duration(seconds: 8), () {
      if (!_hasInteracted && mounted && _viewToggle == YslToggleOption.map) {
        _triggerImmersiveMode();
      }
    });
  }
  
  void _resetImmersiveCycle() {
    // Only reset if we haven't entered immersive mode yet
    // Once immersive, it should persist across view switches
    if (!_isImmersiveMode) {
      _hasInteracted = false;
      _immersiveTimer?.cancel();
      
      // Reset animations only if not in immersive mode
      _heroFadeController.reset();
      _toggleTransitionController.reset();
    }
    
    _viewModeTransitionController.reset();
    
    // Restart timer for map view only if not already immersive
    if (_viewToggle == YslToggleOption.map && !_isImmersiveMode) {
      _startImmersiveTimer();
    }
  }
  
  void _triggerImmersiveMode() {
    if (!_isImmersiveMode && mounted) {
      setState(() {
        _isImmersiveMode = true;
      });
      
      // Start the elegant fade-out sequence
      _heroFadeController.forward();
      
      // Delay the toggle transition for a more elegant sequence
      Future.delayed(const Duration(milliseconds: 800), () {
        if (mounted) {
          _toggleTransitionController.forward();
        }
      });
    }
  }
  
  void _onMapInteraction() {
    // Mark as interacted and trigger immersive mode immediately
    if (!_hasInteracted) {
      _hasInteracted = true;
      _immersiveTimer?.cancel();
      _triggerImmersiveMode();
    }
  }
  
  void _transitionToView(YslToggleOption newView) {
    if (_viewToggle == newView) return;
    
    // Start the view mode transition animation
    _viewModeTransitionController.forward().then((_) {
      // Change the view when the fade-out is complete
      setState(() {
        _viewToggle = newView;
        _selectedLocationIndex = 0;
        _resetImmersiveCycle();
      });
      
      // Reset and reverse the animation to fade the new view in
      _viewModeTransitionController.reset();
      _viewModeTransitionController.reverse();
    });
  }
  
  Future<void> _initUserLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        print('Location services are disabled.');
        return;
      }
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
        print('Location permission denied.');
        return;
      }
      final pos = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.low);
      setState(() {
        _userLatLng = LatLng(pos.latitude, pos.longitude);
      });
      print('📍 User location: ${_userLatLng!.latitude}, ${_userLatLng!.longitude}');
    } catch (e) {
      print('Error getting user location: $e');
    }
  }

  void _forceResetImmersiveMode() {
    // Method to completely reset immersive mode (for debugging or special interactions)
    setState(() {
      _hasInteracted = false;
      _isImmersiveMode = false;
    });
    _immersiveTimer?.cancel();
    
    // Reset all animations
    _heroFadeController.reset();
    _toggleTransitionController.reset();
    _viewModeTransitionController.reset();
    
    // Restart timer for map view
    if (_viewToggle == YslToggleOption.map) {
      _startImmersiveTimer();
    }
  }
  
  void _onFlightCompleted() {
    // Called when the gamified flight animation completes with elegant transition
    setState(() {
      _showFlightPath = false;
      _flightCompleted = true;
    });
    
    // Start hero content with elegant entrance animations
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        // First show the hero content with staggered animations
        _showHeroContentWithStagger();
        // Then start the immersive timer
        _startImmersiveTimer();
      }
    });
  }
  
  void _showHeroContentWithStagger() {
    // Elegant staggered entrance for hero content after flight animation
    if (!_heroContentVisible) {
      setState(() {
        _heroContentVisible = true;
      });
      _heroEntranceController.forward();
    }
  }
  
  void _animateMapToLocation(List<HomeLocation> locations, int index) {
    // Do not move map while bottom sheet is open - keep state exactly as user left it
    if (_showBottomSheet) {
      print('⏸️ Map frozen: bottom sheet open, skipping camera animation');
      return;
    }

    // Only animate if we have a map controller and valid index
    if (_mapController == null || 
        index < 0 || 
        index >= locations.length) {
      return;
    }
    
    final selectedLocation = locations[index];
    
    print('🎯 Initiating cinematic flight to: ${selectedLocation.name}');
    
    // Hide bottom sheet during animation
    setState(() {
      _showBottomSheet = false;
    });
    
    // Use cinematic multi-stage animation with callback for bottom sheet
    MapAnimationUtils.cinematicFlyToLocationWithCallback(
      _mapController!,
      selectedLocation,
      finalZoom: 17.0,
      origin: _userLatLng, // Start from user's location when available
      onCompleted: () {
        // Let user appreciate the location for a moment before showing details
        Future.delayed(const Duration(milliseconds: 1200), () {
          if (!mounted) return;
          // Do not auto-open for first location; pulse Explore instead
          if (index == 0 && _unlockedCount == 0) {
            setState(() { _pulseFirstExplore = true; });
            return;
          }
          print('📝 Elegantly showing bottom sheet for: ${selectedLocation.name}');
          setState(() { _showBottomSheet = true; });
        });
      },
    );
  }
  
  @override
  void dispose() {
    _immersiveTimer?.cancel();
    _heroFadeController.dispose();
    _heroEntranceController.dispose();
    _toggleTransitionController.dispose();
    _viewModeTransitionController.dispose();
    _unlockToastController.dispose();
    super.dispose();
  }

  Future<_HomeData> _load() async {
    final map = await _repo.loadMapConfig();
    final offers = await _repo.loadOffers();
    final carousel = await _repo.loadCarousel();
    final locations = await _repo.loadLocations();
    final cards = await _repo.loadContentCards();
    final products = await _repo.loadProducts();
    final quotes = await _repo.loadQuotes();
    final detailsById = await _repo.loadLocationDetails();
    return _HomeData(
      map: map,
      offers: offers,
      carousel: carousel,
      locations: locations,
      cards: cards,
      products: products,
      quotes: quotes,
      detailsById: detailsById,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.yslWhite,
      appBar: null,
      body: FutureBuilder<_HomeData>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError || !snapshot.hasData) {
            return Center(
              child: Text(
                'Failed to load home: ${snapshot.error}',
                style: AppText.bodyMedium.copyWith(color: AppColors.yslBlack),
              ),
            );
          }
          final data = snapshot.data!;
          return _buildBody(context, data);
        },
      ),
    );
  }

  Widget _buildBody(BuildContext context, _HomeData data) {
    // Determine device type and responsive parameters
    final screenWidth = MediaQuery.of(context).size.width;
    _deviceType = YslResponsiveUtils.getDeviceType(screenWidth);
    
    // Map locations to widget data with listing descriptions from details
    final baseLocations = data.locations
        .asMap()
        .entries
        .map((e) => toYslLocationDataWithDetails(e.value, data.detailsById[e.value.id], index: e.key))
        .toList(growable: false);

    // Append reward as a pseudo-location at the end
    final reward = YslLocationData(
      name: 'YSL LIBRE FRAGRANCE',
      address: 'Complete the journey to unlock your reward.',
      listingDescription: 'Complete the journey to unlock your reward.',
      city: null,
      distance: null,
      hours: null,
      phone: null,
      imagePath: 'assets/images/exclusive_offer/main_banner.png',
      isOpen: true,
      type: LocationType.experience,
      pinVariation: PinVariation.pinA,
    );
    final yslLocations = [...baseLocations, reward];
    _rewardIndex = yslLocations.length - 1;

    return Stack(
      children: [
        // Main app content
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          switchInCurve: Curves.easeOutCubic,
          switchOutCurve: Curves.easeInCubic,
          transitionBuilder: (child, animation) {
            // Fade + horizontal slide for elegance
            final inFromRight = Tween<Offset>(begin: const Offset(0.2, 0), end: Offset.zero)
                .animate(CurvedAnimation(parent: animation, curve: Curves.easeOutQuart));
            return FadeTransition(
              opacity: animation,
              child: SlideTransition(position: inFromRight, child: child),
            );
          },
          child: _viewToggle == YslToggleOption.map
              ? KeyedSubtree(
                  key: const ValueKey('mapView'),
                  child: _buildMapView(context, data, yslLocations),
                )
              : KeyedSubtree(
                  key: const ValueKey('listView'),
                  child: _buildListView(context, data, yslLocations),
                ),
        ),
        
        // Gamified flight path animation overlay
        if (_showFlightPath && !_flightCompleted)
          Positioned.fill(
            child: YslFlightPathAnimation(
              onFlightCompleted: _onFlightCompleted,
              showAnimation: _showFlightPath,
            ),
          ),
      ],
    );
  }

  Widget _buildMapView(BuildContext context, _HomeData data, List<YslLocationData> yslLocations) {
    final sliderParams = YslResponsiveUtils.getLocationSliderParams(
      context,
      _deviceType!,
      true, // isMapView
    );
    final heroParams = YslResponsiveUtils.getHeroHeaderParams(context, _deviceType!);
    
    return Stack(
      children: [
        // Full-screen YSL-branded Google Maps background with interaction tracking
        Positioned.fill(
          child: Stack(
            children: [
              // Google Maps
              IgnorePointer(
                ignoring: _showBottomSheet,
                child: YslGoogleMapBackground(
                  config: data.map, 
                  locations: data.locations,
                  selectedLocationIndex: _selectedLocationIndex,
                  interactionEnabled: !_showBottomSheet,
                  onMapReady: (controller) {
                    _mapController = controller;
                    print('Map controller ready for animations');
                    // Try to start after obtaining user location (or timeout)
                    Future(() async {
                      try {
                        await _initUserLocation();
                      } catch (_) {}
                      await Future.delayed(const Duration(milliseconds: 800));
                      if (!mounted) return;
                      if (_showBottomSheet) return; // Do not move map while sheet is open
                      if (data.locations.isNotEmpty) {
                        print('🚀 Auto-flying to first location: ${data.locations.first.name}');
                        _animateMapToLocation(data.locations, 0);
                      }
                    });
                  },
                  onMarkerTap: _showBottomSheet ? null : (location) {
                    _onMapInteraction();
                    final locationIndex = data.locations.indexWhere((loc) => loc.id == location.id);
                    if (locationIndex != -1) {
                      if (locationIndex > _unlockedCount) return;
                      setState(() {
                        _selectedLocationIndex = locationIndex;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Selected ${location.name} - ${location.type.name.toUpperCase()}'),
                          backgroundColor: AppColors.yslBlack,
                          duration: const Duration(seconds: 1),
                        ),
                      );
                    }
                  },
                ),
              ),
              
              // Complete interaction blocker when bottom sheet is open
              if (_showBottomSheet)
                Positioned.fill(
                  child: Container(
                    color: Colors.transparent,
                    child: AbsorbPointer(
                      absorbing: true,
                      child: Container(),
                    ),
                  ),
                ),
            ],
          ),
        ),

        // Floating UI overlay - scrollable content on top of map
        SafeArea(
          child: Column(
            children: [
              // Figma-exact Offer Banner at very top
              YslExclusiveOfferBannerVariants.figmaOffer(
                offerText: 'UNLOCK THE LOVE STORY FOR AN EXCLUSIVE OFFER',
              ),
              
              // Hero header - switches between full and minimalistic versions
              AnimatedBuilder(
                animation: _heroFadeController,
                builder: (context, child) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                    padding: EdgeInsets.symmetric(
                      horizontal: heroParams.padding.horizontal,
                      vertical: 16.0, // Always use compact padding
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.yslWhite.withValues(alpha: 0.85),
                      border: Border.all(color: Colors.black12, width: 1),
                      borderRadius: BorderRadius.zero,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: _buildMinimalisticHeader(context),
                  );
                },
              ),

              // Spacer to push location slider to bottom
              const Spacer(),
            ],
          ),
        ),

        // Unlock toast overlay (above header and slider)
        if (_showUnlockToast)
          Positioned(
            bottom: (sliderParams.height ?? 165) + 16,
            left: 0,
            right: 0,
            child: SlideTransition(
              position: _unlockToastSlide,
              child: FadeTransition(
                opacity: _unlockToastOpacity,
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: AppColors.yslWhite,
                      border: Border.all(color: AppColors.yslBlack, width: 1),
                      borderRadius: BorderRadius.zero,
                      boxShadow: [
                        BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8, offset: const Offset(0, 2)),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.lock_open, color: AppColors.yslBlack, size: 16),
                        const SizedBox(width: 8),
                        Text(
                          _unlockToastText,
                          style: AppText.bodyMedium.copyWith(
                            color: AppColors.yslBlack,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.0,
                            fontFamily: 'ITC Avant Garde Gothic Pro',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        SizedBox(height: 15,),
        // Sticky floating location slider at bottom
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: SafeArea(
            top: false,
            child: YslLocationSlider(
              locations: yslLocations,
              height: sliderParams.height,
              cardWidth: sliderParams.cardWidth,
              cardSpacing: sliderParams.cardSpacing,
              padding: sliderParams.padding,
              showNavigationArrows: sliderParams.showArrows,
              backgroundColor: Colors.transparent,
              showCardBorders: false,
              useHomeStyle: true,
              usePageView: true,
              viewportFraction: sliderParams.viewportFraction,
              enableResponsive: true,
              selectedLocationIndex: _selectedLocationIndex,
              unlockedCount: _unlockedCount,
              rewardIndex: _rewardIndex,
              onExplore: (index) => _onExploreFromCard(index),
              pulseIndex: (_unlockedCount == 0 && _selectedLocationIndex == 0 && _pulseFirstExplore) ? 0 : null,
              onLocationSelected: (index) {
                print('🎯 Slider changed to index: $index');
                final isReward = index == _rewardIndex;
final rewardLocked = _unlockedCount < data.locations.length;
                final isLocked = (!isReward && index > _unlockedCount) || (isReward && rewardLocked);
                if (isLocked) return;

                // Only update selection without auto-zooming - let user control navigation
                setState(() { _selectedLocationIndex = index; });
                
                if (isReward) {
                  setState(() {
                    _showBottomSheet = true;
                  });
                }
              },
            ),
          ),
        ),
        
        // Compact toggle positioned under header (appears after immersive mode)
        if (_viewToggle == YslToggleOption.map && _isImmersiveMode)
          Positioned(
            top: 140, // Brought down a bit more from the minimalistic header
            right: 20,
            child: AnimatedBuilder(
              animation: _compactToggleFadeIn,
              builder: (context, child) {
                return SlideTransition(
                  position: _compactToggleSlideIn,
                  child: Opacity(
                    opacity: _compactToggleFadeIn.value,
                    child: _buildIconsOnlyToggle(),
                  ),
                );
              },
            ),
          ),
          
        // Location bottom sheet overlay for regular locations
          if (_selectedLocationIndex < _rewardIndex)
          YslLocationBottomSheet(
            location: data.locations[_selectedLocationIndex],
            details: data.detailsById[data.locations[_selectedLocationIndex].id],
            isVisible: _showBottomSheet,
            onClose: () {
              // Smooth sequence: close -> unlock -> toast -> focus next
              setState(() { _showBottomSheet = false; });
              if (_unlockedCount == _selectedLocationIndex) {
                _unlockedCount++;
                _runUnlockSequence(data, _unlockedCount);
              }
            },
          ),
        // Reward bottom sheet (black)
        if (_showBottomSheet && _selectedLocationIndex == _rewardIndex)
          _buildRewardBottomSheet(),
      ],
    );
  }
  
  Widget _buildCompactToggle() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.yslWhite.withValues(alpha: 0.95),
        borderRadius: BorderRadius.zero, // YSL hard edges
        border: Border.all(
          color: AppColors.yslBlack,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: YslToggleSwitch(
        selectedOption: _viewToggle,
        onToggle: (opt) => _transitionToView(opt),
      ),
    );
  }
  
  Widget _buildIconsOnlyToggle() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.yslWhite.withValues(alpha: 0.95),
        borderRadius: BorderRadius.zero, // YSL hard edges
        border: Border.all(
          color: AppColors.yslBlack,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildIconToggleButton(
            icon: Icons.map_outlined,
            isSelected: _viewToggle == YslToggleOption.map,
            onTap: () => _transitionToView(YslToggleOption.map),
          ),
          Container(
            width: 1,
            height: 40,
            color: AppColors.yslBlack.withValues(alpha: 0.2),
          ),
          _buildIconToggleButton(
            icon: Icons.list,
            isSelected: _viewToggle == YslToggleOption.list,
            onTap: () => _transitionToView(YslToggleOption.list),
          ),
        ],
      ),
    );
  }
  
  Widget _buildIconToggleButton({
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: isSelected 
              ? AppColors.yslBlack 
              : Colors.transparent,
          borderRadius: BorderRadius.zero,
        ),
        child: Center(
          child: Icon(
            icon,
            color: isSelected 
                ? AppColors.yslWhite 
                : AppColors.yslBlack,
            size: 18,
          ),
        ),
      ),
    );
  }
  
  Widget _buildMinimalisticHeader(BuildContext context) {
    return SizedBox(
      width: double.infinity, // Take full width
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // YSL logo only - double tap to reset immersive mode
          GestureDetector(
            onDoubleTap: () {
              // Double-tap logo to reset immersive mode (hidden feature)
              _forceResetImmersiveMode();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Immersive mode reset'),
                  backgroundColor: AppColors.yslBlack,
                  duration: Duration(seconds: 1),
                ),
              );
            },
            child: SvgPicture.asset(
              'assets/svgs/logos/state_logo_beaut_on.svg',
              height: 32, // Smaller logo
              colorFilter: const ColorFilter.mode(
                AppColors.yslBlack,
                BlendMode.srcIn,
              ),
            ),
          ),
          const SizedBox(height: 8),
          
          // Title only with lighter font weight
          Text(
            'GARDENS OF MEMORIES',
            style: TextStyle(
              color: AppColors.yslBlack,
              fontSize: 16, // Smaller size
              letterSpacing: 1.2,
              fontFamily: 'ITC Avant Garde Gothic Pro',
              fontWeight: FontWeight.w400, // Regular weight, not bold
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
  
  Widget _buildListView(BuildContext context, _HomeData data, List<YslLocationData> yslLocations) {
    final listParams = YslResponsiveUtils.getListViewParams(context, _deviceType!);
    final heroParams = YslResponsiveUtils.getHeroHeaderParams(context, _deviceType!);
    
    return SafeArea(
      child: Stack(
        children: [
          Column(
            children: [
              // Figma-exact Offer Banner at very top
              YslExclusiveOfferBannerVariants.figmaOffer(
                offerText: 'UNLOCK THE LOVE STORY FOR AN EXCLUSIVE OFFER',
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Figma offer banner tapped!'),
                      backgroundColor: AppColors.yslBlack,
                    ),
                  );
                },
              ),
              
              // Hero header - switches between full and minimalistic versions based on immersive state
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                padding: EdgeInsets.symmetric(
                  horizontal: heroParams.padding.horizontal,
                  vertical: 16.0, // Always compact padding
                ),
                decoration: BoxDecoration(
                  color: AppColors.yslWhite.withValues(alpha: 0.95),
                  border: Border.all(color: Colors.black12, width: 1),
                  borderRadius: BorderRadius.zero,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: _buildMinimalisticHeader(context)
              ),

              // Add spacing to prevent toggle overlap when in immersive mode
              if (_isImmersiveMode) const SizedBox(height: 60),
              
              // Scrollable list/grid of locations using responsive layout
              Expanded(
                child: listParams.crossAxisCount > 1
                    ? _buildResponsiveGrid(yslLocations, listParams)
                    : _buildResponsiveList(yslLocations, listParams),
              ),
            ],
          ),
          
          // Icons-only toggle positioned at top-right when in immersive mode
          if (_isImmersiveMode)
            Positioned(
              top: 140, // Same position as in map view
              right: 20,
              child: AnimatedBuilder(
                animation: _compactToggleFadeIn,
                builder: (context, child) {
                  return SlideTransition(
                    position: _compactToggleSlideIn,
                    child: Opacity(
                      opacity: _compactToggleFadeIn.value,
                      child: _buildIconsOnlyToggle(),
                    ),
                  );
                },
              ),
            ),
            
          // Location bottom sheet overlay (same as map view)
          if (data.locations.isNotEmpty && _selectedLocationIndex < data.locations.length)
            YslLocationBottomSheet(
              location: data.locations[_selectedLocationIndex],
              details: data.detailsById[data.locations[_selectedLocationIndex].id],
              isVisible: _showBottomSheet,
              onClose: () {
                // Close and unlock next location (same logic as map view)
                setState(() { _showBottomSheet = false; });
                if (_selectedLocationIndex < _rewardIndex &&
                    _unlockedCount == _selectedLocationIndex) {
                  _unlockedCount++;
                  _runUnlockSequence(data, _unlockedCount);
                }
              },
            ),
        ],
      ),
    );
  }

  Widget _buildHeroHeaderContent(BuildContext context) {
    final heroParams = YslResponsiveUtils.getHeroHeaderParams(context, _deviceType!);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // YSL logo
        SvgPicture.asset(
          'assets/svgs/logos/state_logo_beaut_on.svg',
          height: heroParams.logoHeight,
          colorFilter: const ColorFilter.mode(
            AppColors.yslBlack,
            BlendMode.srcIn,
          ),
        ),
        SizedBox(height: heroParams.spacing),

        // Small subtitle with entrance and immersive fade animations
        AnimatedBuilder(
          animation: Listenable.merge([
            _heroSubtitleFade, 
            _heroSubtitleSlide, 
            _subtitleEntranceFade,
            _heroContentFadeIn,
            _heroContentSlideIn
          ]),
          builder: (context, child) {
            // Use entrance animation if coming from flight, otherwise use immersive fade
            final opacity = _heroContentVisible 
                ? _subtitleEntranceFade.value * _heroSubtitleFade.value
                : _heroSubtitleFade.value;
            final slideOffset = _heroContentVisible
                ? Offset(_heroContentSlideIn.value.dx, _heroSubtitleSlide.value.dy + _heroContentSlideIn.value.dy)
                : _heroSubtitleSlide.value;
                
            return Transform.translate(
              offset: Offset(slideOffset.dx * MediaQuery.of(context).size.width, 
                           slideOffset.dy * MediaQuery.of(context).size.height),
              child: Opacity(
                opacity: opacity.clamp(0.0, 1.0),
                child: Text(
                  'YVES THROUGH MARRAKECH',
                  style: AppText.bodyLarge.copyWith(
                    color: AppColors.yslBlack,
                    fontSize: heroParams.subtitleFontSize,
                    letterSpacing: 1.5,
                    fontWeight: FontWeight.w300,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          },
        ),

        AnimatedBuilder(
          animation: _heroSubtitleFade,
          builder: (context, child) {
            return SizedBox(
              height: heroParams.spacing * 0.8 * _heroSubtitleFade.value,
            );
          },
        ),

        // Main hero title with animated scaling and YSL font
        AnimatedBuilder(
          animation: _titleSizeScale,
          builder: (context, child) {
            return Text(
              'GARDENS OF MEMORIES',
              style: AppText.heroDisplay.copyWith(
                color: AppColors.yslBlack,
                fontSize: heroParams.titleFontSize * _titleSizeScale.value,
                letterSpacing: 1.2,
                fontFamily: 'ITC Avant Garde Gothic Pro', // YSL main font
                fontWeight: FontWeight.w700, // Bold weight
              ),
              textAlign: TextAlign.center,
            );
          },
        ),

        AnimatedBuilder(
          animation: _heroDescriptionFade,
          builder: (context, child) {
            return SizedBox(
              height: heroParams.spacing * _heroDescriptionFade.value,
            );
          },
        ),

        // Description paragraph with entrance and immersive fade animations
        AnimatedBuilder(
          animation: Listenable.merge([
            _heroDescriptionFade, 
            _heroDescriptionSlide, 
            _descriptionEntranceFade,
            _heroContentFadeIn,
            _heroContentSlideIn
          ]),
          builder: (context, child) {
            // Use entrance animation if coming from flight, otherwise use immersive fade
            final opacity = _heroContentVisible 
                ? _descriptionEntranceFade.value * _heroDescriptionFade.value
                : _heroDescriptionFade.value;
            final slideOffset = _heroContentVisible
                ? Offset(_heroContentSlideIn.value.dx, _heroDescriptionSlide.value.dy + _heroContentSlideIn.value.dy)
                : _heroDescriptionSlide.value;
                
            return Transform.translate(
              offset: Offset(slideOffset.dx * MediaQuery.of(context).size.width, 
                           slideOffset.dy * MediaQuery.of(context).size.height),
              child: Opacity(
                opacity: opacity.clamp(0.0, 1.0),
                child: Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: heroParams.maxDescriptionWidth),
                    child: Text(
                      'In Marrakech, Yves Saint Laurent found refuge and inspiration—where freedom burns and memory lingers like perfume.',
                      style: AppText.bodyMedium.copyWith(
                        color: AppColors.yslBlack.withValues(alpha: 0.75), // Slightly more visible
                        fontSize: heroParams.descriptionFontSize,
                        height: 1.5,
                        fontWeight: FontWeight.w300, // Light weight for elegance
                        fontFamily: 'ITC Avant Garde Gothic Pro',
                      ),
                      textAlign: TextAlign.center,
                      maxLines: _deviceType == YslDeviceType.mobile ? 4 : 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ),
            );
          },
        ),

        AnimatedBuilder(
          animation: _heroDescriptionFade,
          builder: (context, child) {
            return SizedBox(
              height: heroParams.spacing * _heroDescriptionFade.value,
            );
          },
        ),

        // Original toggle switch with fade-out animation
        AnimatedBuilder(
          animation: _toggleFadeOut,
          builder: (context, child) {
            return SlideTransition(
              position: _toggleSlideOut,
              child: Opacity(
                opacity: _toggleFadeOut.value,
                child: Center(
                  child: YslToggleSwitch(
                    selectedOption: _viewToggle,
                    onToggle: (opt) => _transitionToView(opt),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
  
  Widget _buildResponsiveList(List<YslLocationData> yslLocations, YslListViewResponsive listParams) {
    return ListView.separated(
      padding: listParams.padding,
      itemCount: yslLocations.length,
      separatorBuilder: (context, index) => SizedBox(height: listParams.itemSpacing),
      itemBuilder: (context, index) {
        final location = yslLocations[index];
        final isReward = index == _rewardIndex;
        final rewardLocked = _unlockedCount < _rewardIndex;
        final isLocked = (!isReward && index > _unlockedCount) || (isReward && rewardLocked);
        
        return YslHomeLocationCard(
          location: location,
          isVertical: false,
          viewType: YslCardViewType.listView, // Spacious list view
          height: listParams.itemHeight,
          width: listParams.maxWidth,
          margin: EdgeInsets.zero,
          isLocked: isLocked,
          isReward: isReward,
          onTap: () {
            if (isLocked) return;
            _onLocationCardTapped(index, location);
          },
          onExplore: () {
            if (isLocked) return;
            _onLocationCardTapped(index, location);
          },
        );
      },
    );
  }
  
  Widget _buildResponsiveGrid(List<YslLocationData> yslLocations, YslListViewResponsive listParams) {
    return GridView.builder(
      padding: listParams.padding,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: listParams.crossAxisCount,
        crossAxisSpacing: listParams.itemSpacing,
        mainAxisSpacing: listParams.itemSpacing,
        childAspectRatio: listParams.maxWidth / listParams.itemHeight,
      ),
      itemCount: yslLocations.length,
      itemBuilder: (context, index) {
        final location = yslLocations[index];
        final isReward = index == _rewardIndex;
        final rewardLocked = _unlockedCount < _rewardIndex;
        final isLocked = (!isReward && index > _unlockedCount) || (isReward && rewardLocked);
        
        return YslHomeLocationCard(
          location: location,
          isVertical: false,
          viewType: YslCardViewType.listView,
          height: listParams.itemHeight,
          width: listParams.maxWidth,
          margin: EdgeInsets.zero,
          isLocked: isLocked,
          isReward: isReward,
          onTap: () {
            if (isLocked) return;
            _onLocationCardTapped(index, location);
          },
          onExplore: () {
            if (isLocked) return;
            _onLocationCardTapped(index, location);
          },
        );
      },
    );
  }
  
  void _onLocationCardTapped(int index, YslLocationData location) {
    setState(() {
      _selectedLocationIndex = index;
    });
    
    // Get the _HomeData from the FutureBuilder context
    _future.then((data) {
      if (_viewToggle == YslToggleOption.list) {
        // In list view: show bottom sheet immediately for quick access
        setState(() {
          _showBottomSheet = true;
        });
        
        // Optional: Also transition to map view after showing bottom sheet
        // User can tap "Explore" again or close the sheet to see map
        // Uncomment below lines if you want auto-transition to map:
        // Future.delayed(const Duration(milliseconds: 2000), () {
        //   if (mounted) {
        //     _transitionToView(YslToggleOption.map);
        //     Future.delayed(const Duration(milliseconds: 600), () {
        //       if (mounted && index < data.locations.length) {
        //         _animateMapToLocation(data.locations, index);
        //       }
        //     });
        //   }
        // });
      } else {
        // Already in map view, animate directly
        if (index < data.locations.length) {
          _animateMapToLocation(data.locations, index);
        }
      }
    }).catchError((error) {
      // Fallback: just show a snackbar if data loading fails
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Explore ${location.name}!'),
          backgroundColor: AppColors.yslBlack,
          duration: const Duration(seconds: 2),
        ),
      );
    });
  }

  void _runUnlockSequence(_HomeData data, int nextIndex) async {
    if (nextIndex >= _rewardIndex) {
      // Reward unlocked
      _unlockToastText = 'REWARD UNLOCKED!';
    } else {
      _unlockToastText = 'NEW LOCATION UNLOCKED!';
    }
    setState(() { _showUnlockToast = true; });
    _unlockToastController.forward(from: 0);

    // Give the toast more time before focusing the next location
    await Future.delayed(const Duration(milliseconds: 1200));

    // Removed forced navigation - let users control their own journey
    // if (mounted) {
    //   // Update selected index to next and animate map
    //   setState(() { _selectedLocationIndex = nextIndex; });
    //   if (nextIndex < data.locations.length) {
    //     _animateMapToLocation(data.locations, nextIndex);
    //   }
    // }

    // Let the toast stay visible longer, then fade out slowly
    await Future.delayed(const Duration(milliseconds: 2400));
    if (mounted) {
      _unlockToastController.reverse();
      await Future.delayed(const Duration(milliseconds: 700));
      if (mounted) setState(() { _showUnlockToast = false; });
    }
  }

  // Simple black reward bottom sheet
  Widget _buildRewardBottomSheet() {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.6,
        decoration: const BoxDecoration(
          color: AppColors.yslBlack,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Spacer(),
                GestureDetector(
                  onTap: () { setState(() { _showBottomSheet = false; }); },
                  child: const Icon(Icons.close, color: AppColors.yslWhite, size: 20),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'YSL LIBRE FRAGRANCE',
              style: AppText.titleLarge.copyWith(
                color: AppColors.yslWhite,
                fontWeight: FontWeight.w700,
                fontSize: 22,
                fontFamily: 'ITC Avant Garde Gothic Pro',
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Complete the journey to unlock your reward.',
              style: AppText.bodyMedium.copyWith(
                color: AppColors.yslWhite.withOpacity(0.7),
                fontSize: 14,
                fontFamily: 'ITC Avant Garde Gothic Pro',
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: Container(
                height: 44,
                color: AppColors.yslWhite,
                child: Center(
                  child: Text(
                    'UNLOCK MY REWARD',
                    style: AppText.bodyMedium.copyWith(
                      color: AppColors.yslBlack,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.0,
                      fontFamily: 'ITC Avant Garde Gothic Pro',
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onExploreFromCard(int index) {
    // Ignore if locked - fixed logic to allow newly unlocked locations
    final isReward = index == _rewardIndex;
    final rewardLocked = _unlockedCount < _rewardIndex;
    // Fix: Allow current location to be explored (use >= instead of >)
    final isLocked = (!isReward && index > _unlockedCount) || (isReward && rewardLocked);
    
    print('🔒 Explore check: index=$index, isReward=$isReward, unlockedCount=$_unlockedCount, isLocked=$isLocked');
    
    if (isLocked) {
      print('❌ Explore blocked - location is locked');
      return;
    }

    setState(() {
      _selectedLocationIndex = index;
      _showBottomSheet = true;
      if (index == 0) _pulseFirstExplore = false;
    });
  }
}
