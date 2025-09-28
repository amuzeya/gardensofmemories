// YSL Map Background - DEPRECATED
// This widget is replaced by YslMapboxBackground
// Kept for fallback purposes only

import 'package:flutter/material.dart';

import '../models/home_location.dart';
import '../models/home_map_config.dart';

/// DEPRECATED: Use YslMapboxBackground instead
/// Simple fallback widget for backwards compatibility
class YslMapBackground extends StatelessWidget {
  final HomeMapConfig config;
  final List<HomeLocation> locations;
  final void Function(HomeLocation)? onMarkerTap;

  const YslMapBackground({
    super.key,
    required this.config,
    required this.locations,
    this.onMarkerTap,
  });

  @override
  Widget build(BuildContext context) {
    // Simple fallback - shows locations as a list
    return Container(
      color: const Color(0xFFF8F8F8),
      child: const Center(
        child: Text(
          'MAP VIEW\n(DEPRECATED)',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
