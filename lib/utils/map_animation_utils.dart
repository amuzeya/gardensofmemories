// YSL Beauty Experience - Map Animation Utilities
// Cinematic camera movements for Google Maps
// Following YSL principles: smooth, elegant, intentional animations

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../models/home_location.dart';

class MapAnimationUtils {
  /// Cinematic fly-to animation with multi-stage camera movement
  /// Creates a smooth, gamified experience with zoom out -> pan -> zoom in
  static Future<void> cinematicFlyToLocation(
    GoogleMapController controller,
    HomeLocation location, {
    double finalZoom = 17.0,
  }) async {
    try {
      print('🎬 Starting cinematic flight to ${location.name}');
      
      final targetLat = location.lat;
      final targetLng = location.lng;
      
      // Stage 1: Pull back to overview to see the journey (Marrakech overview)
      await controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: const LatLng(31.629472, -7.981084), // Marrakech center
            zoom: 11.5,
            tilt: 0.0,
            bearing: 0.0,
          ),
        ),
      );
      
      // Brief pause for dramatic overview
      await Future.delayed(const Duration(milliseconds: 400));
      
      // Stage 2: Start approach to target area with intermediate zoom
      await controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(targetLat, targetLng),
            zoom: 14.0,
            tilt: 5.0,
            bearing: 0.0,
          ),
        ),
      );
      
      // Brief pause
      await Future.delayed(const Duration(milliseconds: 300));
      
      // Stage 3: Final approach - smooth zoom to target with cinematic tilt
      await controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(targetLat, targetLng),
            zoom: finalZoom,
            tilt: 20.0, // Cinematic angle
            bearing: 0.0,
          ),
        ),
      );
      
      // Stage 4: Settle into perfect position (micro-adjustment)
      await Future.delayed(const Duration(milliseconds: 100));
      await controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(targetLat, targetLng),
            zoom: finalZoom,
            tilt: 15.0, // Subtle tilt for depth
            bearing: 0.0,
          ),
        ),
      );
      
      print('✨ Cinematic flight completed to ${location.name}');
      
    } catch (e) {
      print('❌ Error in cinematic flight: $e');
      // Fallback to simple animation
      await _fallbackAnimation(controller, location, finalZoom);
    }
  }
  
  /// Fallback simple animation if cinematic fails
  static Future<void> _fallbackAnimation(
    GoogleMapController controller,
    HomeLocation location,
    double zoom,
  ) async {
    try {
      await controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(location.lat, location.lng),
            zoom: zoom,
            tilt: 15.0,
          ),
        ),
      );
    } catch (e) {
      print('❌ Fallback animation failed: $e');
    }
  }

  /// Animate map to show all locations with proper bounds
  static Future<void> animateToShowAllLocations(
    GoogleMapController controller,
    List<HomeLocation> locations, {
    double padding = 100.0,
  }) async {
    if (locations.isEmpty) return;

    try {
      // Calculate bounds to include all locations
      double minLat = locations.first.lat;
      double maxLat = locations.first.lat;
      double minLng = locations.first.lng;
      double maxLng = locations.first.lng;

      for (final location in locations) {
        minLat = minLat < location.lat ? minLat : location.lat;
        maxLat = maxLat > location.lat ? maxLat : location.lat;
        minLng = minLng < location.lng ? minLng : location.lng;
        maxLng = maxLng > location.lng ? maxLng : location.lng;
      }

      final bounds = LatLngBounds(
        southwest: LatLng(minLat, minLng),
        northeast: LatLng(maxLat, maxLng),
      );

      await controller.animateCamera(
        CameraUpdate.newLatLngBounds(bounds, padding),
      );
    } catch (e) {
      print('Error animating to show all locations: $e');
    }
  }

  /// Get optimal zoom level based on number of nearby locations
  static double getOptimalZoom(int locationCount) {
    // More locations = zoom out a bit to provide context
    // Single location = zoom in close for detail
    switch (locationCount) {
      case 1:
        return 17.0; // Very close for single location
      case 2:
      case 3:
        return 16.0; // Close but show some context
      case 4:
      case 5:
        return 15.0; // Medium zoom for small clusters
      default:
        return 14.0; // Wider view for many locations
    }
  }

  /// Smooth zoom with easing for luxury feel
  static Future<void> smoothZoomTo(
    GoogleMapController controller,
    double targetZoom, {
    Duration duration = const Duration(milliseconds: 800),
  }) async {
    try {
      await controller.animateCamera(
        CameraUpdate.zoomTo(targetZoom),
      );
    } catch (e) {
      print('Error smooth zooming: $e');
    }
  }
}