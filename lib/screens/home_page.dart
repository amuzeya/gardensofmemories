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

import '../widgets/ysl_app_bar.dart';
import '../widgets/ysl_exclusive_offer_banner.dart';
import '../widgets/ysl_carousel.dart';
import '../widgets/ysl_location_slider.dart';
import '../widgets/ysl_content_card.dart';
import '../widgets/ysl_offer_card.dart';
import '../widgets/ysl_map_background.dart';

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
      appBar: YslAppBarVariants.version5(),
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
    final firstOffer = data.offers.isNotEmpty ? data.offers.first : null;

    // Map home carousel items into the widget items
    final carouselItems = data.carousel.map((c) {
      return YslCarouselItem(
        imagePath: c.type == HomeCarouselItemType.image ? c.imagePath : null,
        videoPath: c.type == HomeCarouselItemType.video ? c.videoPath : null,
        introText: c.introText,
        title: c.title,
        subtitle: c.subtitle,
        paragraph: c.paragraph,
      );
    }).toList(growable: false);

    // Map locations to widget data
    final yslLocations = data.locations.map(toYslLocationData).toList(growable: false);

    return ListView(
      padding: EdgeInsets.zero,
      children: [
        if (firstOffer != null)
          YslExclusiveOfferBanner(
            text: firstOffer.text,
            subText: null,
            onTap: () {},
          ),

        // Hero Carousel (fixed height)
        SizedBox(
          height: 372,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: YslCarousel(
              items: carouselItems,
              height: 360,
              layout: YslCarouselLayout.videoFocused,
              backgroundColor: AppColors.yslWhite,
            ),
          ),
        ),

        // Map background area with Location Slider overlay
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.9,
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Real OSM map background
              YslMapBackground(config: data.map, locations: data.locations),

              // Slider aligned to bottom
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  color: Colors.transparent,
                  padding: const EdgeInsets.only(bottom: 8),
                  child: YslLocationSlider(
                    locations: yslLocations,
                    height: 165,
                    cardWidth: 300,
                    cardSpacing: 12,
                    showNavigationArrows: true,
                    backgroundColor: Colors.transparent,
                    showCardBorders: true,
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Content section (first card if any)
        if (data.cards.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: YslContentCard(
              subtitle: data.cards.first.subtitle,
              title: data.cards.first.title,
              buttonText: data.cards.first.buttonText,
              onButtonPressed: () {},
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
            ),
          ),

        const SizedBox(height: 16),

        // Product highlight using YslOfferCard
        if (data.products.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: YslOfferCard(
              title: 'FEATURED PRODUCT',
              subtitle: data.products.first.name.toUpperCase(),
              description: data.products.first.description,
              buttonText: 'SHOP NOW',
              onButtonPressed: () {},
              isExclusive: true,
              padding: const EdgeInsets.all(16),
            ),
          ),

        const SizedBox(height: 24),
      ],
    );
  }
}
