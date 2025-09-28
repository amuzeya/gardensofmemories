// YSL Beauty Experience - Home Page Screen (mobile-first)
// Wires JSON data (assets/data/home) to built components

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
import '../widgets/ysl_map_background.dart';
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

class _HomePageScreenState extends State<HomePageScreen> {
  final _repo = HomeRepository();
  late Future<_HomeData> _future;
  YslToggleOption _viewToggle = YslToggleOption.map;
  int _selectedLocationIndex = 0;
  YslDeviceType? _deviceType;

  @override
  void initState() {
    super.initState();
    _future = _load();
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
    if (_viewToggle == YslToggleOption.map) {
      return _buildMapView(context, data, yslLocations);
    } else {
      return _buildListView(context, data, yslLocations);
    }
  }

  Widget _buildMapView(BuildContext context, _HomeData data, List<YslLocationData> yslLocations) {
    final sliderParams = YslResponsiveUtils.getLocationSliderParams(
      context,
      _deviceType!,
      true, // isMapView
    );
    
    return Stack(
      children: [
        // Full-screen interactive map background
        Positioned.fill(
          child: YslMapBackground(
            config: data.map, 
            locations: data.locations,
            onMarkerTap: (location) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Tapped ${location.name} - ${location.type.name.toUpperCase()}'),
                  backgroundColor: AppColors.yslBlack,
                  duration: const Duration(seconds: 2),
                ),
              );
            },
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
              
              // Hero header with semi-transparent background
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                padding: sliderParams.padding,
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
                child: _buildHeroHeaderContent(context),
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
      ],
    );
  }

  Widget _buildListView(BuildContext context, _HomeData data, List<YslLocationData> yslLocations) {
    final listParams = YslResponsiveUtils.getListViewParams(context, _deviceType!);
    final heroParams = YslResponsiveUtils.getHeroHeaderParams(context, _deviceType!);
    
    return SafeArea(
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
          
          // Hero header (no background since no map)
          Container(
            padding: heroParams.padding,
            child: _buildHeroHeaderContent(context),
          ),

          // Scrollable list/grid of locations using responsive layout
          Expanded(
            child: listParams.crossAxisCount > 1
                ? _buildResponsiveGrid(yslLocations, listParams)
                : _buildResponsiveList(yslLocations, listParams),
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

        // Small subtitle
        Text(
          'YVES THROUGH MARRAKECH',
          style: AppText.bodySmallLight.copyWith(
            color: AppColors.yslBlack,
            fontSize: heroParams.subtitleFontSize,
            letterSpacing: 1.5,
          ),
          textAlign: TextAlign.center,
        ),

        SizedBox(height: heroParams.spacing * 0.8),

        // Main hero title
        Text(
          'GARDENS OF MEMORIES',
          style: AppText.heroDisplay.copyWith(
            color: AppColors.yslBlack,
            fontSize: heroParams.titleFontSize,
            letterSpacing: 1.2,
          ),
          textAlign: TextAlign.center,
        ),

        SizedBox(height: heroParams.spacing),

        // Description paragraph
        Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: heroParams.maxDescriptionWidth),
            child: Text(
              'In Marrakech, Yves Saint Laurent found refuge and inspiration—where freedom burns and memory lingers like perfume.',
              style: AppText.bodyLarge.copyWith(
                color: AppColors.yslBlack,
                fontSize: heroParams.descriptionFontSize,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
              maxLines: _deviceType == YslDeviceType.mobile ? 4 : 3, // Prevent overflow on small screens
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),

        SizedBox(height: heroParams.spacing),

        // Toggle switch
        Center(
          child: YslToggleSwitch(
            selectedOption: _viewToggle,
            onToggle: (opt) {
              setState(() {
                _viewToggle = opt;
                _selectedLocationIndex = 0; // Reset selection when switching views
              });
            },
          ),
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
