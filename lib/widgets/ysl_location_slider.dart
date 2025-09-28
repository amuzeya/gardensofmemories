// YSL Beauty Experience - Location Slider Component
// Based on Figma designs: Horizontal location slider with manual navigation
// Following YSL brand principles: clean layouts, manual control, structured navigation
// Now with full responsive support and overflow protection

import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../constants/assets.dart';
import '../utils/responsive_utils.dart';
import 'ysl_location_card.dart';
import 'ysl_home_location_card.dart';

/// YSL Location Slider Widget
/// Features:
/// - Horizontal scrollable location cards
/// - Manual navigation with left/right arrows
/// - Multiple location support with pin variations
/// - YSL brand styling throughout
/// - Fully responsive design with automatic overflow protection
/// - Smooth scrolling animations
/// - Selected location highlighting and tracking
class YslLocationSlider extends StatefulWidget {
  final List<YslLocationData> locations;
  final double? height;
  final double cardWidth;
  final double cardSpacing;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final bool showNavigationArrows;
  final Color? backgroundColor;
  final VoidCallback? onLocationTap;
  final bool showCardBorders;
  final bool useHomeStyle;
  final bool usePageView;
  final double viewportFraction;
  final bool enableResponsive;
  final int? selectedLocationIndex;
  final Function(int index)? onLocationSelected;

  const YslLocationSlider({
    super.key,
    required this.locations,
    this.height = 165,
    this.cardWidth = 300,
    this.cardSpacing = 15,
    this.padding,
    this.margin,
    this.showNavigationArrows = true,
    this.backgroundColor,
    this.onLocationTap,
    this.showCardBorders = true,
    this.useHomeStyle = false,
    this.usePageView = false,
    this.viewportFraction = 0.9,
    this.enableResponsive = true,
    this.selectedLocationIndex,
    this.onLocationSelected,
  });

  @override
  State<YslLocationSlider> createState() => _YslLocationSliderState();
}

class _YslLocationSliderState extends State<YslLocationSlider> {
  late ScrollController _scrollController;
  PageController? _pageController; // when using PageView
  bool _canScrollLeft = false;
  bool _canScrollRight = true;
  
  // Responsive state
  YslLocationSliderResponsive? _responsiveParams;
  YslDeviceType? _deviceType;
  int _currentSelectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _currentSelectedIndex = widget.selectedLocationIndex ?? 0;
    _scrollController = ScrollController();
    _scrollController.addListener(_updateScrollState);
  }
  
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateResponsiveParams();
    _initializePageController();
  }
  
  void _updateResponsiveParams() {
    if (widget.enableResponsive) {
      final screenWidth = MediaQuery.of(context).size.width;
      _deviceType = YslResponsiveUtils.getDeviceType(screenWidth);
      _responsiveParams = YslResponsiveUtils.getLocationSliderParams(
        context,
        _deviceType!,
        widget.useHomeStyle, // Assuming useHomeStyle indicates map view
      );
    }
  }
  
  void _initializePageController() {
    if (widget.usePageView) {
      final viewportFraction = _responsiveParams?.viewportFraction ?? widget.viewportFraction;
      _pageController?.dispose();
      _pageController = PageController(
        viewportFraction: viewportFraction,
        initialPage: _currentSelectedIndex,
      );
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_updateScrollState);
    _scrollController.dispose();
    _pageController?.dispose();
    super.dispose();
  }

  void _updateScrollState() {
    if (mounted) {
      setState(() {
        _canScrollLeft = _scrollController.offset > 0;
        _canScrollRight = _scrollController.offset < _scrollController.position.maxScrollExtent;
      });
    }
  }

  void _scrollLeft() {
    final scrollDistance = widget.cardWidth + widget.cardSpacing;
    final targetOffset = (_scrollController.offset - scrollDistance).clamp(0.0, _scrollController.position.maxScrollExtent);
    
    _scrollController.animateTo(
      targetOffset,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _scrollRight() {
    final scrollDistance = widget.cardWidth + widget.cardSpacing;
    final targetOffset = (_scrollController.offset + scrollDistance).clamp(0.0, _scrollController.position.maxScrollExtent);
    
    _scrollController.animateTo(
      targetOffset,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    // Use responsive parameters if available
    final height = _responsiveParams?.height ?? widget.height;
    final padding = _responsiveParams?.padding ?? widget.padding ?? const EdgeInsets.symmetric(horizontal: 20);
    final showArrows = _responsiveParams?.showArrows ?? widget.showNavigationArrows;
    
    return Container(
      height: height,
      margin: widget.margin ?? const EdgeInsets.symmetric(vertical: 16),
      padding: padding,
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Overflow protection
          if (widget.enableResponsive) {
            _validateAndAdjustLayout(constraints);
          }
          
          return Row(
            children: [
              // Left Navigation Arrow
              if (showArrows && !widget.usePageView)
                _buildNavigationButton(
                  icon: Icons.arrow_back_ios,
                  onPressed: _canScrollLeft ? _scrollLeft : null,
                  isLeft: true,
                ),

              // Location Cards Slider
              Expanded(
                child: widget.usePageView ? _buildPageViewSlider() : _buildLocationSlider(),
              ),

              // Right Navigation Arrow
              if (showArrows && !widget.usePageView)
                _buildNavigationButton(
                  icon: Icons.arrow_forward_ios,
                  onPressed: _canScrollRight ? _scrollRight : null,
                  isLeft: false,
                ),
            ],
          );
        },
      ),
    );
  }
  
  void _validateAndAdjustLayout(BoxConstraints constraints) {
    final cardWidth = _responsiveParams?.cardWidth ?? widget.cardWidth;
    final cardSpacing = _responsiveParams?.cardSpacing ?? widget.cardSpacing;
    
    // Check for potential overflow and log warnings (development only)
    if (YslResponsiveUtils.willOverflow(
      containerWidth: constraints.maxWidth,
      cardWidth: cardWidth,
      cardSpacing: cardSpacing,
      cardCount: widget.locations.length,
    )) {
      // In development, we could show a warning
      // In production, the responsive params should prevent this
      assert(() {
        debugPrint('YslLocationSlider: Potential overflow detected for screen width ${constraints.maxWidth}');
        return true;
      }());
    }
  }

  Widget _buildNavigationButton({
    required IconData icon,
    required VoidCallback? onPressed,
    required bool isLeft,
  }) {
    return Container(
      margin: EdgeInsets.only(
        right: isLeft ? 16 : 0,
        left: isLeft ? 0 : 16,
      ),
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: onPressed != null ? AppColors.yslBlack : Colors.grey.shade300,
            borderRadius: BorderRadius.zero, // YSL hard-edged design
          ),
          child: Center(
            child: Icon(
              icon,
              color: onPressed != null ? AppColors.yslWhite : Colors.grey.shade500,
              size: 16,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLocationSlider() {
    return Container(
      height: widget.height,
      decoration: BoxDecoration(
        color: widget.backgroundColor ?? Colors.transparent,
        borderRadius: BorderRadius.zero,
      ),
      child: ListView.separated(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        itemCount: widget.locations.length,
        separatorBuilder: (context, index) => SizedBox(width: widget.cardSpacing),
        itemBuilder: (context, index) {
          return _buildLocationCard(widget.locations[index], index);
        },
      ),
    );
  }

  Widget _buildPageViewSlider() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final cardW = constraints.maxWidth * widget.viewportFraction;
        return PageView.builder(
          controller: _pageController,
          padEnds: false,
          itemCount: widget.locations.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: EdgeInsets.only(right: widget.cardSpacing),
              child: Align(
                alignment: Alignment.centerLeft,
                child: SizedBox(
                  width: cardW,
                  height: widget.height,
                  child: _buildLocationCard(widget.locations[index], index),
                ),
              ),
            );
          },
        );
      },
    );
  }
  
  Widget _buildLocationCard(YslLocationData location, int index) {
    // Use responsive parameters if available
    final cardWidth = _responsiveParams?.cardWidth ?? widget.cardWidth;
    final height = _responsiveParams?.height ?? widget.height;
    
    return GestureDetector(
      onTap: () {
        _onCardTapped(index);
        widget.onLocationTap?.call();
      },
      child: SizedBox(
        width: cardWidth,
        height: height,
        child: widget.useHomeStyle
            ? YslHomeLocationCard(
                location: location,
                width: cardWidth,
                height: height ?? 180,
                viewType: YslCardViewType.mapView, // Compact for slider
                onTap: () => _onCardTapped(index),
                margin: EdgeInsets.zero,
              )
            : YslLocationCard(
                location: location,
                width: cardWidth,
                height: height,
                onTap: () => _onCardTapped(index),
                margin: EdgeInsets.zero,
                showBorder: widget.showCardBorders,
              ),
      ),
    );
  }
  
  void _onCardTapped(int index) {
    setState(() {
      _currentSelectedIndex = index;
    });
    widget.onLocationSelected?.call(index);
    
    // Auto-scroll to center the selected card if using PageView
    if (widget.usePageView && _pageController != null) {
      _pageController!.animateToPage(
        index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }
}

/// Predefined YSL Location Slider variants
class YslLocationSliderVariants {
  YslLocationSliderVariants._();

  /// Standard location slider with 3 distinct locations using different pins
  static YslLocationSlider standard({
    VoidCallback? onLocationTap,
  }) {
    return YslLocationSlider(
      locations: _getStandardLocations(),
      onLocationTap: onLocationTap,
    );
  }

  /// Compact location slider with smaller cards
  static YslLocationSlider compact({
    VoidCallback? onLocationTap,
  }) {
    return YslLocationSlider(
      locations: _getStandardLocations(),
      height: 140,
      cardWidth: 280,
      cardSpacing: 12,
      onLocationTap: onLocationTap,
    );
  }

  /// Wide location slider with larger cards
  static YslLocationSlider wide({
    VoidCallback? onLocationTap,
  }) {
    return YslLocationSlider(
      locations: _getStandardLocations(),
      height: 180,
      cardWidth: 350,
      cardSpacing: 20,
      onLocationTap: onLocationTap,
    );
  }

  /// Figma exact variant - matches the design specifications
  static YslLocationSlider figmaExact({
    VoidCallback? onLocationTap,
  }) {
    return YslLocationSlider(
      locations: _getFigmaExactLocations(),
      height: 100, // As per Figma spec
      cardWidth: 300, // As per Figma spec
      cardSpacing: 15,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      onLocationTap: onLocationTap,
    );
  }

  /// Premium location slider with YSL luxury locations
  static YslLocationSlider premium({
    VoidCallback? onLocationTap,
  }) {
    return YslLocationSlider(
      locations: _getPremiumLocations(),
      height: 165,
      cardWidth: 320,
      cardSpacing: 18,
      backgroundColor: Colors.grey.shade50,
      onLocationTap: onLocationTap,
    );
  }

  /// Borderless location slider - clean look without card borders
  static YslLocationSlider borderless({
    VoidCallback? onLocationTap,
  }) {
    return YslLocationSlider(
      locations: _getStandardLocations(),
      height: 165,
      cardWidth: 300,
      cardSpacing: 20,
      showCardBorders: false,
      backgroundColor: Colors.transparent,
      onLocationTap: onLocationTap,
    );
  }

  /// Borderless compact - smaller cards without borders
  static YslLocationSlider borderlessCompact({
    VoidCallback? onLocationTap,
  }) {
    return YslLocationSlider(
      locations: _getStandardLocations(),
      height: 140,
      cardWidth: 280,
      cardSpacing: 15,
      showCardBorders: false,
      backgroundColor: Colors.transparent,
      onLocationTap: onLocationTap,
    );
  }

  /// Get standard 3 locations with different pin variations
  static List<YslLocationData> _getStandardLocations() {
    return [
      const YslLocationData(
        name: 'Jardin Majorelle',
        address: 'Discover the iconic blue garden that inspired YSL\'s most memorable collections and find exclusive Marrakech-inspired beauty products.',
        city: 'Marrakech',
        distance: '0.3 km',
        isOpen: true,
        type: LocationType.experience,
        pinVariation: PinVariation.pinA,
        imagePath: Assets.frame845083630,
      ),
      const YslLocationData(
        name: 'YSL Beauty Boutique',
        address: 'Experience personalized beauty consultations and discover the full range of YSL Beauty products in our flagship boutique.',
        city: 'Paris',
        distance: '1.2 km',
        isOpen: true,
        type: LocationType.boutique,
        pinVariation: PinVariation.pinB,
        imagePath: Assets.frame845083630,
      ),
      const YslLocationData(
        name: 'Gardens of Memories',
        address: 'Immerse yourself in a sensory journey through YSL\'s heritage with limited edition fragrances and exclusive experiences.',
        city: 'Casablanca',
        distance: '2.8 km',
        isOpen: false,
        type: LocationType.popup,
        pinVariation: PinVariation.pinC,
        imagePath: Assets.frame845083630,
      ),
    ];
  }

  /// Get Figma exact locations (matching the design)
  static List<YslLocationData> _getFigmaExactLocations() {
    return [
      const YslLocationData(
        name: 'YSL Store Marrakech',
        address: 'Premium YSL Beauty destination with expert consultations and exclusive collections in the heart of Marrakech.',
        city: 'Marrakech',
        distance: '0.5 km',
        isOpen: true,
        type: LocationType.store,
        pinVariation: PinVariation.pinA,
        imagePath: Assets.frame845083630,
      ),
      const YslLocationData(
        name: 'Libre Experience Center',
        address: 'Dedicated YSL Libre fragrance experience with personalized scent consultations and exclusive limited editions.',
        city: 'Rabat',
        distance: '15 km',
        isOpen: true,
        type: LocationType.boutique,
        pinVariation: PinVariation.pinB,
        imagePath: Assets.frame845083630,
      ),
      const YslLocationData(
        name: 'Beauty Workshop',
        address: 'Interactive beauty workshop featuring YSL makeup masterclasses and personalized color matching sessions.',
        city: 'Fès',
        distance: '45 km',
        isOpen: false,
        type: LocationType.experience,
        pinVariation: PinVariation.pinC,
        imagePath: Assets.frame845083630,
      ),
      const YslLocationData(
        name: 'YSL Pop-up Store',
        address: 'Limited-time pop-up featuring the latest YSL Beauty launches and exclusive Moroccan-inspired collections.',
        city: 'Agadir',
        distance: '120 km',
        isOpen: true,
        type: LocationType.popup,
        pinVariation: PinVariation.pinA,
        imagePath: Assets.frame845083630,
      ),
      const YslLocationData(
        name: 'Heritage Boutique',
        address: 'Explore YSL\'s rich heritage through curated collections and vintage-inspired beauty products.',
        city: 'Tangier',
        distance: '200 km',
        isOpen: true,
        type: LocationType.boutique,
        pinVariation: PinVariation.pinB,
        imagePath: Assets.frame845083630,
      ),
    ];
  }

  /// Get premium luxury locations
  static List<YslLocationData> _getPremiumLocations() {
    return [
      const YslLocationData(
        name: 'YSL Couture Salon',
        address: 'Exclusive high-fashion beauty salon offering couture makeup services and luxury skincare treatments.',
        city: 'Paris',
        distance: '0.8 km',
        isOpen: true,
        type: LocationType.boutique,
        pinVariation: PinVariation.pinB,
        imagePath: Assets.frame845083630,
      ),
      const YslLocationData(
        name: 'Opium Experience',
        address: 'Immersive fragrance journey celebrating YSL\'s iconic Opium with rare vintage collections and expert curation.',
        city: 'Milan',
        distance: '3.2 km',
        isOpen: true,
        type: LocationType.experience,
        pinVariation: PinVariation.pinC,
        imagePath: Assets.frame845083630,
      ),
      const YslLocationData(
        name: 'Le Smoking Atelier',
        address: 'Avant-garde beauty atelier inspired by YSL\'s revolutionary Le Smoking with bold, statement looks.',
        city: 'New York',
        distance: '5.7 km',
        isOpen: false,
        type: LocationType.store,
        pinVariation: PinVariation.pinA,
        imagePath: Assets.frame845083630,
      ),
    ];
  }
}