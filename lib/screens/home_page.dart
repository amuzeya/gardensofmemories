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

import '../widgets/ysl_exclusive_offer_banner.dart';
import '../widgets/ysl_location_slider.dart';
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
    // Map locations to widget data
    final yslLocations = data.locations
        .map(toYslLocationData)
        .toList(growable: false);

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
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                padding: const EdgeInsets.all(20),
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
                child: _buildHeroHeaderContent(),
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
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.95),
                border: Border.all(color: Colors.black12, width: 1),
                borderRadius: BorderRadius.zero,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: YslLocationSlider(
                locations: yslLocations,
                height: 100,
                cardWidth: 200,
                cardSpacing: 12,
                showNavigationArrows: false,
                backgroundColor: Colors.transparent,
                showCardBorders: false,
                useHomeStyle: true,
                usePageView: true,
                viewportFraction: 0.86,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeroHeaderContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // YSL logo
        SvgPicture.asset(
          'assets/svgs/logos/state_logo_beaut_on.svg',
          height: 40,
          colorFilter: const ColorFilter.mode(
            AppColors.yslBlack,
            BlendMode.srcIn,
          ),
        ),
        const SizedBox(height: 16),

        // Small subtitle
        Text(
          'YVES THROUGH MARRAKECH',
          style: AppText.bodySmallLight.copyWith(
            color: AppColors.yslBlack,
            letterSpacing: 1.5,
          ),
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: 12),

        // Main hero title
        Text(
          'GARDENS OF MEMORIES',
          style: AppText.heroDisplay.copyWith(
            color: AppColors.yslBlack,
            letterSpacing: 1.2,
          ),
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: 16),

        // Description paragraph
        Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Text(
              'In Marrakech, Yves Saint Laurent found refuge and inspiration—where freedom burns and memory lingers like perfume.',
              style: AppText.bodyLarge.copyWith(
                color: AppColors.yslBlack,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),

        const SizedBox(height: 14),

        // Toggle switch
        Center(
          child: YslToggleSwitch(
            selectedOption: _viewToggle,
            onToggle: (opt) {
              setState(() {
                _viewToggle = opt;
              });
            },
          ),
        ),
      ],
    );
  }
}
