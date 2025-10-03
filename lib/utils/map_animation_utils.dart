// YSL Beauty Experience - Map Animation Utilities
// Cinematic camera movements for Google Maps
// Following YSL principles: smooth, elegant, intentional animations

import 'dart:math';
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
    LatLng? origin, // Optional starting point for the flight
  }) async {
    try {
      print('🎬 Starting cinematic flight to ${location.name}');
      
      final targetLat = location.lat;
      final targetLng = location.lng;
      
      // Stage 1: Pull back to overview starting from origin (user location) if provided
      final LatLng overviewTarget = origin ?? const LatLng(31.629472, -7.981084); // Marrakech center fallback
      await controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: overviewTarget,
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
  
  /// Cinematic fly-to animation with callback after completion
  static Future<void> cinematicFlyToLocationWithCallback(
    GoogleMapController controller,
    HomeLocation location, {
    double finalZoom = 17.0,
    VoidCallback? onCompleted,
    LatLng? origin,
  }) async {
    await cinematicFlyToLocation(controller, location, finalZoom: finalZoom, origin: origin);
    // Trigger callback after animation completes
    onCompleted?.call();
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

  /// Smooth direct animation from current camera position to target location
  /// Creates a seamless experience for nearby location transitions
  static Future<void> smoothFlyToLocation(
    GoogleMapController controller,
    HomeLocation location, {
    double finalZoom = 17.0,
    Duration duration = const Duration(milliseconds: 2000), // Much slower, more elegant
  }) async {
    try {
      print('✨ Starting elegant flight to ${location.name}');
      
      final targetLat = location.lat;
      final targetLng = location.lng;
      
      // Elegant smooth animation with easing
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
      
      // Small pause to let animation settle elegantly
      await Future.delayed(const Duration(milliseconds: 300));
      
      print('✨ Elegant flight completed to ${location.name}');
      
    } catch (e) {
      print('❌ Error in smooth flight: $e');
      // Fallback to simple animation
      await _fallbackAnimation(controller, location, finalZoom);
    }
  }

  /// Smooth direct animation with callback after completion
  static Future<void> smoothFlyToLocationWithCallback(
    GoogleMapController controller,
    HomeLocation location, {
    double finalZoom = 17.0,
    Duration duration = const Duration(milliseconds: 2000), // Match main animation duration
    VoidCallback? onCompleted,
  }) async {
    await smoothFlyToLocation(controller, location, finalZoom: finalZoom, duration: duration);
    // Trigger callback after animation completes
    onCompleted?.call();
  }
  
  /// Elegant two-stage animation for location selection with smooth transitions
  static Future<void> elegantFlyToLocationWithCallback(
    GoogleMapController controller,
    HomeLocation location, {
    double finalZoom = 17.0,
    VoidCallback? onCompleted,
  }) async {
    try {
      print('✨ Starting elegant two-stage flight to ${location.name}');
      
      final targetLat = location.lat;
      final targetLng = location.lng;
      
      // Stage 1: Gentle zoom and pan to location (slower, more elegant)
      await controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(targetLat, targetLng),
            zoom: finalZoom - 1.0, // Slightly less zoom first
            tilt: 5.0, // Gentle tilt
            bearing: 0.0,
          ),
        ),
      );
      
      // Brief elegant pause
      await Future.delayed(const Duration(milliseconds: 400));
      
      // Stage 2: Final positioning with perfect zoom and tilt
      await controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(targetLat, targetLng),
            zoom: finalZoom,
            tilt: 15.0, // Final elegant tilt
            bearing: 0.0,
          ),
        ),
      );
      
      // Final pause to let everything settle
      await Future.delayed(const Duration(milliseconds: 200));
      
      print('✨ Elegant two-stage flight completed to ${location.name}');
      
      // Trigger callback after animation completes
      onCompleted?.call();
      
    } catch (e) {
      print('❌ Error in elegant flight: $e');
      // Fallback to simple animation
      await _fallbackAnimation(controller, location, finalZoom);
      onCompleted?.call();
    }
  }

  /// Calculate distance between two geographic points in kilometers
  static double calculateDistance(double lat1, double lng1, double lat2, double lng2) {
    // Simple distance calculation using Haversine formula approximation
    const double earthRadiusKm = 6371.0;
    final double dLat = _toRadians(lat2 - lat1);
    final double dLng = _toRadians(lng2 - lng1);
    
    final double a = (sin(dLat / 2) * sin(dLat / 2)) +
        (cos(_toRadians(lat1)) * cos(_toRadians(lat2)) * sin(dLng / 2) * sin(dLng / 2));
    
    final double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return earthRadiusKm * c;
  }
  
  static double _toRadians(double degrees) {
    return degrees * (pi / 180);
  }

}
