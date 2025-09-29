// Repository to load home page JSON data from assets
// Files: offers.json, map.json, locations.json, carousel.json, content.json, products.json, quotes.json

import 'dart:convert';
import 'package:flutter/services.dart' show AssetBundle, rootBundle;

import '../models/home_offer.dart';
import '../models/home_map_config.dart';
import '../models/home_location.dart';
import '../models/home_carousel_item.dart';
import '../models/home_content_card.dart';
import '../models/home_product.dart';
import '../models/home_quote.dart';
import '../models/location_details.dart';

class HomeRepository {
  final AssetBundle bundle;
  final String basePath;

  HomeRepository({AssetBundle? bundle, this.basePath = 'assets/data/home'})
      : bundle = bundle ?? rootBundle;

  Future<Map<String, dynamic>> _loadObject(String fileName) async {
    try {
      final raw = await bundle.loadString('$basePath/$fileName');
      final decoded = json.decode(raw);
      if (decoded is Map<String, dynamic>) return decoded;
      throw const FormatException('Expected a JSON object at root');
    } catch (e) {
      throw FormatException('Failed to load $fileName: $e');
    }
  }

  Future<HomeMapConfig> loadMapConfig() async {
    final obj = await _loadObject('map.json');
    return HomeMapConfig.fromJson(obj);
  }

  Future<List<HomeOffer>> loadOffers() async {
    final obj = await _loadObject('offers.json');
    final list = (obj['offers'] as List? ?? const []);
    return list
        .whereType<Map<String, dynamic>>()
        .map(HomeOffer.fromJson)
        .toList(growable: false);
  }

  Future<List<HomeLocation>> loadLocations() async {
    final obj = await _loadObject('locations.json');
    final list = (obj['locations'] as List? ?? const []);
    return list
        .whereType<Map<String, dynamic>>()
        .map(HomeLocation.fromJson)
        .toList(growable: false);
  }

  Future<List<HomeCarouselItem>> loadCarousel() async {
    final obj = await _loadObject('carousel.json');
    final list = (obj['items'] as List? ?? const []);
    return list
        .whereType<Map<String, dynamic>>()
        .map(HomeCarouselItem.fromJson)
        .toList(growable: false);
  }

  Future<List<HomeContentCard>> loadContentCards() async {
    final obj = await _loadObject('content.json');
    final list = (obj['cards'] as List? ?? const []);
    return list
        .whereType<Map<String, dynamic>>()
        .map(HomeContentCard.fromJson)
        .toList(growable: false);
  }

  Future<List<HomeProduct>> loadProducts() async {
    final obj = await _loadObject('products.json');
    final list = (obj['products'] as List? ?? const []);
    return list
        .whereType<Map<String, dynamic>>()
        .map(HomeProduct.fromJson)
        .toList(growable: false);
  }

  Future<List<HomeQuote>> loadQuotes() async {
    final obj = await _loadObject('quotes.json');
    final list = (obj['quotes'] as List? ?? const []);
    return list
        .whereType<Map<String, dynamic>>()
        .map(HomeQuote.fromJson)
        .toList(growable: false);
  }

  Future<Map<String, LocationDetails>> loadLocationDetails({String fileName = 'location_details.prod.json'}) async {
    final obj = await _loadObject(fileName);
    final list = (obj['locations'] as List? ?? const []);
    final detailsList = list
        .whereType<Map<String, dynamic>>()
        .map(LocationDetails.fromJson)
        .toList(growable: false);
    final map = <String, LocationDetails>{};
    for (final d in detailsList) {
      map[d.id] = d;
    }
    return map;
  }
}
