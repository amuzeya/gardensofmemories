import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

import '../data/home_repository.dart';
import '../models/home_carousel_item.dart';
import '../mappers/location_mapper.dart';

class DataValidationScreen extends StatefulWidget {
  const DataValidationScreen({super.key});

  @override
  State<DataValidationScreen> createState() => _DataValidationScreenState();
}

class _ValidationItem {
  final String title;
  final String details;
  final bool ok;

  const _ValidationItem(this.title, this.details, this.ok);
}

class _DataValidationScreenState extends State<DataValidationScreen> {
  final _repo = HomeRepository();
  bool _running = false;
  List<_ValidationItem> _results = const [];

  @override
  void initState() {
    super.initState();
    _run();
  }

  Future<bool> _assetExists(String key) async {
    try {
      await rootBundle.load(key);
      return true;
    } catch (_) {
      return false;
    }
  }

  bool _inMarrakechBounds(double lat, double lng) {
    // Rough bounding box around Marrakech city
    return lat >= 31.55 && lat <= 31.70 && lng >= -8.05 && lng <= -7.90;
  }

  Future<void> _run() async {
    setState(() => _running = true);
    final results = <_ValidationItem>[];

    try {
      // Map config
      final map = await _repo.loadMapConfig();
      final mapOk = _inMarrakechBounds(map.lat, map.lng);
      results.add(_ValidationItem(
        'Map config',
        'center=(${map.lat.toStringAsFixed(5)}, ${map.lng.toStringAsFixed(5)}), zoom=${map.zoom}',
        mapOk,
      ));

      // Offers
      final offers = await _repo.loadOffers();
      results.add(_ValidationItem('Offers', 'count=${offers.length}', true));

      // Carousel
      final carousel = await _repo.loadCarousel();
      var carouselOk = true;
      for (final c in carousel) {
        if (c.type == HomeCarouselItemType.image) {
          final ok = c.imagePath != null && await _assetExists(c.imagePath!);
          if (!ok) carouselOk = false;
        } else if (c.type == HomeCarouselItemType.video) {
          final ok = c.videoPath != null && await _assetExists(c.videoPath!);
          if (!ok) carouselOk = false;
        }
      }
      results.add(_ValidationItem('Carousel', 'count=${carousel.length}', carouselOk));

      // Content cards
      final cards = await _repo.loadContentCards();
      results.add(_ValidationItem('Content cards', 'count=${cards.length}', true));

      // Products
      final products = await _repo.loadProducts();
      var productsOk = true;
      for (final p in products) {
        if (p.image.isNotEmpty) {
          final ok = await _assetExists(p.image);
          if (!ok) productsOk = false;
        }
      }
      results.add(_ValidationItem('Products', 'count=${products.length}', productsOk));

      // Quotes
      final quotes = await _repo.loadQuotes();
      results.add(_ValidationItem('Quotes', 'count=${quotes.length}', true));

      // Locations
      final locations = await _repo.loadLocations();
      var locationsOk = true;
      for (final l in locations) {
        final inBounds = _inMarrakechBounds(l.lat, l.lng);
        if (!inBounds) locationsOk = false;
        if (l.image.isNotEmpty) {
          final ok = await _assetExists(l.image);
          if (!ok) locationsOk = false;
        }
        // Also verify we can map to YslLocationData without errors
        toYslLocationData(l);
      }
      results.add(_ValidationItem('Locations', 'count=${locations.length}', locationsOk));
    } catch (e) {
      results.add(_ValidationItem('Validation error', e.toString(), false));
    }

    if (!mounted) return;
    setState(() {
      _results = results;
      _running = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DATA VALIDATION'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ElevatedButton(
                  onPressed: _running ? null : _run,
                  child: Text(_running ? 'Running…' : 'Run validation'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.separated(
                itemCount: _results.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final item = _results[index];
                  return ListTile(
                    leading: Icon(
                      item.ok ? Icons.check_circle_outline : Icons.error_outline,
                      color: item.ok ? Colors.green : Colors.red,
                    ),
                    title: Text(item.title),
                    subtitle: Text(item.details),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}