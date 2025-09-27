// YSL Beauty Experience - Location Slider Component
// Based on Figma designs: Horizontal location slider with manual navigation
// Following YSL brand principles: clean layouts, manual control, structured navigation

import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../constants/assets.dart';
import 'ysl_location_card.dart';

/// YSL Location Slider Widget
/// Features:
/// - Horizontal scrollable location cards
/// - Manual navigation with left/right arrows
/// - Multiple location support with pin variations
/// - YSL brand styling throughout
/// - Responsive design with flexible card sizing
/// - Smooth scrolling animations
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
  });

  @override
  State<YslLocationSlider> createState() => _YslLocationSliderState();
}

class _YslLocationSliderState extends State<YslLocationSlider> {
  late ScrollController _scrollController;
  bool _canScrollLeft = false;
  bool _canScrollRight = true;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_updateScrollState);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_updateScrollState);
    _scrollController.dispose();
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
    return Container(
      height: widget.height,
      margin: widget.margin ?? const EdgeInsets.symmetric(vertical: 16),
      padding: widget.padding ?? const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          // Left Navigation Arrow
          if (widget.showNavigationArrows)
            _buildNavigationButton(
              icon: Icons.arrow_back_ios,
              onPressed: _canScrollLeft ? _scrollLeft : null,
              isLeft: true,
            ),

          // Location Cards Slider
          Expanded(
            child: _buildLocationSlider(),
          ),

          // Right Navigation Arrow
          if (widget.showNavigationArrows)
            _buildNavigationButton(
              icon: Icons.arrow_forward_ios,
              onPressed: _canScrollRight ? _scrollRight : null,
              isLeft: false,
            ),
        ],
      ),
    );
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
          return _buildLocationCard(widget.locations[index]);
        },
      ),
    );
  }

  Widget _buildLocationCard(YslLocationData location) {
    return SizedBox(
      width: widget.cardWidth,
      height: widget.height,
      child: YslLocationCard(
        location: location,
        width: widget.cardWidth,
        height: widget.height,
        onTap: widget.onLocationTap,
        margin: EdgeInsets.zero, // Remove individual card margins
        showBorder: widget.showCardBorders,
      ),
    );
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