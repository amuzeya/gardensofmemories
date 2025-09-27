// Home page map configuration model
// Parses assets/data/home/map.json

class HomeMapConfig {
  final double lat;
  final double lng;
  final double zoom;
  final String tile;
  final String? note;

  const HomeMapConfig({
    required this.lat,
    required this.lng,
    required this.zoom,
    required this.tile,
    this.note,
  });

  factory HomeMapConfig.fromJson(Map<String, dynamic> json) {
    final center = (json['center'] ?? const {}) as Map<String, dynamic>;
    return HomeMapConfig(
      lat: (center['lat'] as num).toDouble(),
      lng: (center['lng'] as num).toDouble(),
      zoom: (json['zoom'] as num).toDouble(),
      tile: (json['tile'] as String?) ?? 'osm',
      note: json['note'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'center': {
          'lat': lat,
          'lng': lng,
        },
        'zoom': zoom,
        'tile': tile,
        if (note != null) 'note': note,
      };
}
