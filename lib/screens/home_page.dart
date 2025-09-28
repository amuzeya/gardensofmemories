// YSL Beauty Experience - Home Page Screen (mobile-first)
// Wires JSON data (assets/data/home) to built components

import 'dart:async';
import 'package:flutter/material.dart';

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

import '../widgets/ysl_exclusive_offer_banner.dart';
import '../widgets/ysl_location_slider.dart';
import '../widgets/ysl_location_card.dart';
import '../widgets/ysl_home_location_card.dart';
import '../widgets/ysl_google_map_background.dart';
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

  const _HomeData({
    required this.map,
    required this.offers,
    required this.carousel,
    required this.locations,
    required this.cards,
    required this.products,
    required this.quotes,
  });
}

class _HomePageScreenState extends State<HomePageScreen> with TickerProviderStateMixin {
  final _repo = HomeRepository();
  late Future<_HomeData> _future;
  YslToggleOption _viewToggle = YslToggleOption.map;
  int _selectedLocationIndex = 0;
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
  
  bool _isImmersiveMode = false;
  bool _hasInteracted = false;
  
  // Timer for automatic immersive transition
  Timer? _immersiveTimer;

  @override
  void initState() {
    super.initState();
    _future = _load();
    _setupAnimations();
    _startImmersiveTimer();
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
    // Start the immersive transition after 6 seconds if no interaction
    _immersiveTimer = Timer(const Duration(seconds: 6), () {
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
  
  @override
  void dispose() {
    _immersiveTimer?.cancel();
    _heroFadeController.dispose();
    _toggleTransitionController.dispose();
    _viewModeTransitionController.dispose();
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
    return _HomeData(
      map: map,
      offers: offers,
      carousel: carousel,
      locations: locations,
      cards: cards,
      products: products,
      quotes: quotes,
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
    
    // Map locations to widget data
    final yslLocations = data.locations
        .map(toYslLocationData)
        .toList(growable: false);

    // Conditional rendering based on toggle state
    return AnimatedSwitcher(
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
          child: GestureDetector(
            onTap: _onMapInteraction,
            onPanStart: (_) => _onMapInteraction(),
            child: YslGoogleMapBackground(
              config: data.map, 
              locations: data.locations,
              onMarkerTap: (location) {
                _onMapInteraction(); // Track interaction
                
                // Find the index of the tapped location in our data
                final locationIndex = data.locations.indexWhere((loc) => loc.id == location.id);
                
                if (locationIndex != -1) {
                  // Update the selected location index to sync the slider
                  setState(() {
                    _selectedLocationIndex = locationIndex;
                  });
                  
                  // Show feedback with location info
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
        ),

        // Floating UI overlay - scrollable content on top of map
        SafeArea(
          child: Column(
            children: [
              // Figma-exact Offer Banner at very top
              YslExclusiveOfferBannerVariants.figmaOffer(
                offerText: 'EXCLUSIVE OFFER AVAILABLE',
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Figma offer banner tapped!'),
                      backgroundColor: AppColors.yslBlack,
                    ),
                  );
                },
              ),
              
              // Hero header - switches between full and minimalistic versions
              AnimatedBuilder(
                animation: _heroFadeController,
                builder: (context, child) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                    padding: EdgeInsets.symmetric(
                      horizontal: heroParams.padding.horizontal,
                      vertical: _isImmersiveMode ? 16.0 : heroParams.padding.vertical,
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
                    child: _isImmersiveMode 
                        ? _buildMinimalisticHeader(context)
                        : _buildHeroHeaderContent(context),
                  );
                },
              ),

              // Spacer to push location slider to bottom
              const Spacer(),
            ],
          ),
        ),

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
              onLocationSelected: (index) {
                setState(() {
                  _selectedLocationIndex = index;
                });
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
                offerText: 'EXCLUSIVE OFFER AVAILABLE',
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
                  vertical: _isImmersiveMode ? 16.0 : heroParams.padding.vertical,
                ),
                decoration: _isImmersiveMode ? BoxDecoration(
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
                ) : null,
                child: _isImmersiveMode 
                    ? _buildMinimalisticHeader(context)
                    : _buildHeroHeaderContent(context),
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

        // Small subtitle with fade and slide animation
        AnimatedBuilder(
          animation: Listenable.merge([_heroSubtitleFade, _heroSubtitleSlide]),
          builder: (context, child) {
            return SlideTransition(
              position: _heroSubtitleSlide,
              child: FadeTransition(
                opacity: _heroSubtitleFade,
                child: Text(
                  'YVES THROUGH MARRAKECH',
                  style: AppText.bodySmallLight.copyWith(
                    color: AppColors.yslBlack,
                    fontSize: heroParams.subtitleFontSize,
                    letterSpacing: 1.5,
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

        // Description paragraph with fade and slide animation
        AnimatedBuilder(
          animation: Listenable.merge([_heroDescriptionFade, _heroDescriptionSlide]),
          builder: (context, child) {
            return SlideTransition(
              position: _heroDescriptionSlide,
              child: FadeTransition(
                opacity: _heroDescriptionFade,
                child: Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: heroParams.maxDescriptionWidth),
                    child: Text(
                      'In Marrakech, Yves Saint Laurent found refuge and inspiration—where freedom burns and memory lingers like perfume.',
                      style: AppText.bodyLarge.copyWith(
                        color: AppColors.yslBlack.withValues(alpha: 0.7), // Lighter text
                        fontSize: heroParams.descriptionFontSize,
                        height: 1.4,
                        fontWeight: FontWeight.w400, // Lighter font weight
                      ),
                      textAlign: TextAlign.center,
                      maxLines: _deviceType == YslDeviceType.mobile ? 4 : 3, // Prevent overflow on small screens
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
        
        return YslHomeLocationCard(
          location: location,
          isVertical: false,
          viewType: YslCardViewType.listView, // Spacious list view
          height: listParams.itemHeight,
          width: listParams.maxWidth,
          margin: EdgeInsets.zero,
          onTap: () => _onLocationCardTapped(index, location),
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
        
        return YslHomeLocationCard(
          location: location,
          isVertical: false,
          viewType: YslCardViewType.listView,
          height: listParams.itemHeight,
          width: listParams.maxWidth,
          margin: EdgeInsets.zero,
          onTap: () => _onLocationCardTapped(index, location),
        );
      },
    );
  }
  
  void _onLocationCardTapped(int index, YslLocationData location) {
    setState(() {
      _selectedLocationIndex = index;
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Explore ${location.name}!'),
        backgroundColor: AppColors.yslBlack,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
