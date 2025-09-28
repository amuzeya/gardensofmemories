// YSL Map Background using OpenStreetMap tiles
// Large background map with markers for locations

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as ll;

import '../models/home_location.dart';
import '../models/home_map_config.dart';
import '../constants/assets.dart';

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
    return FlutterMap(
      options: MapOptions(
        initialCenter: ll.LatLng(config.lat, config.lng),
        initialZoom: config.zoom,
        interactionOptions: const InteractionOptions(
          flags: InteractiveFlag.drag | InteractiveFlag.pinchZoom,
        ),
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'ysl_beauty_experience',
        ),
        MarkerLayer(
          markers: locations.map(_toMarker).toList(growable: false),
        ),
      ],
    );
  }

  Marker _toMarker(HomeLocation l) {
    final iconPath = _pinAsset(l.pin);
    return Marker(
      point: ll.LatLng(l.lat, l.lng),
      width: 48,
      height: 60,
      child: GestureDetector(
        onTap: () => onMarkerTap?.call(l),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: SvgPicture.asset(
            iconPath,
            width: 36,
            height: 36,
          ),
        ),
      ),
    );
  }

  String _pinAsset(HomePinVariation p) {
    switch (p) {
      case HomePinVariation.pinA:
        return Assets.iconPinA;
      case HomePinVariation.pinB:
        return Assets.iconPinB;
      case HomePinVariation.pinC:
        return Assets.iconPinC;
    }
  }
}