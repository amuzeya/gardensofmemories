// Mapbox Configuration for YSL Beauty Experience
// Custom styling and configuration for on-brand mapping

class MapboxConfig {
  // Mapbox Access Token (should be stored securely in production)
  // For now, using a placeholder - you'll need to get your own token from Mapbox
  static const String accessToken = 'YOUR_MAPBOX_ACCESS_TOKEN_HERE';
  
  // Custom YSL Beauty Map Style URL
  // This will be a custom minimal grey style without POIs
  static const String yslMapStyleUrl = 'mapbox://styles/mapbox/light-v11';
  
  // Temporary fallback - we'll create a custom style later
  static const String fallbackStyleUrl = 'mapbox://styles/mapbox/light-v11';
  
  // YSL Brand Color Palette for Maps
  static const String yslBlack = '#000000';
  static const String yslWhite = '#FFFFFF';
  static const String yslGrey = '#F5F5F5';
  static const String yslGreyDark = '#E0E0E0';
  
  // Map Configuration
  static const double defaultZoom = 13.0;
  static const double minZoom = 10.0;
  static const double maxZoom = 18.0;
  
  // Marker Configuration
  static const double markerSize = 40.0;
  static const double markerIconSize = 24.0;
  
  // Animation Configuration
  static const int animationDuration = 1000; // milliseconds
  static const String easingType = 'easeInOutCubic';
}

// Custom Mapbox Style Definition (Minimal Grey Theme)
// This creates a YSL-branded minimal map style
class YslMapStyle {
  static Map<String, dynamic> get customStyle => {
    "version": 8,
    "name": "YSL Beauty Minimal",
    "metadata": {
      "mapbox:autocomposite": true,
      "mapbox:type": "template"
    },
    "sources": {
      "mapbox": {
        "type": "vector",
        "url": "mapbox://mapbox.mapbox-streets-v8"
      }
    },
    "layers": [
      // Background - Light grey
      {
        "id": "background",
        "type": "background",
        "paint": {
          "background-color": "#F8F8F8" // Very light grey background
        }
      },
      // Water - Slightly darker grey
      {
        "id": "water",
        "type": "fill",
        "source": "mapbox",
        "source-layer": "water",
        "paint": {
          "fill-color": "#E8E8E8" // Light grey for water
        }
      },
      // Land areas
      {
        "id": "land",
        "type": "fill",
        "source": "mapbox",
        "source-layer": "landuse",
        "paint": {
          "fill-color": "#F0F0F0" // Slightly darker grey for land
        }
      },
      // Roads - minimal styling
      {
        "id": "roads",
        "type": "line",
        "source": "mapbox",
        "source-layer": "road",
        "paint": {
          "line-color": "#D0D0D0", // Medium grey for roads
          "line-width": {
            "base": 1.2,
            "stops": [[12, 0.5], [20, 8]]
          }
        }
      },
      // Buildings - very subtle
      {
        "id": "buildings",
        "type": "fill",
        "source": "mapbox",
        "source-layer": "building",
        "paint": {
          "fill-color": "#ECECEC", // Very light grey for buildings
          "fill-opacity": 0.6
        }
      }
      // Note: Intentionally excluding POI layers, labels, and other distracting elements
    ]
  };
}