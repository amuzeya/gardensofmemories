// Location data for home page (with lat/lng)
// Parses assets/data/home/locations.json

enum HomeLocationType { store, boutique, experience, popup }

enum HomePinVariation { pinA, pinB, pinC }

String homeLocationTypeToString(HomeLocationType t) {
  switch (t) {
    case HomeLocationType.store:
      return 'store';
    case HomeLocationType.boutique:
      return 'boutique';
    case HomeLocationType.experience:
      return 'experience';
    case HomeLocationType.popup:
      return 'popup';
  }
}

HomeLocationType homeLocationTypeFromString(String? s) {
  switch ((s ?? '').toLowerCase()) {
    case 'store':
      return HomeLocationType.store;
    case 'boutique':
      return HomeLocationType.boutique;
    case 'experience':
      return HomeLocationType.experience;
    case 'popup':
      return HomeLocationType.popup;
    default:
      return HomeLocationType.experience;
  }
}

String homePinToString(HomePinVariation p) {
  switch (p) {
    case HomePinVariation.pinA:
      return 'pin_a';
    case HomePinVariation.pinB:
      return 'pin_b';
    case HomePinVariation.pinC:
      return 'pin_c';
  }
}

HomePinVariation homePinFromString(String? s) {
  switch ((s ?? '').toLowerCase()) {
    case 'pin_a':
      return HomePinVariation.pinA;
    case 'pin_b':
      return HomePinVariation.pinB;
    case 'pin_c':
      return HomePinVariation.pinC;
    default:
      return HomePinVariation.pinA;
  }
}

class HomeLocation {
  final String id;
  final String name;
  final String address;
  final String? city;
  final String? distance;
  final bool isOpen;
  final HomeLocationType type;
  final HomePinVariation pin;
  final double lat;
  final double lng;
  final String image;
  final String? phone;
  final String? hours;

  const HomeLocation({
    required this.id,
    required this.name,
    required this.address,
    this.city,
    this.distance,
    this.isOpen = true,
    this.type = HomeLocationType.experience,
    this.pin = HomePinVariation.pinA,
    required this.lat,
    required this.lng,
    required this.image,
    this.phone,
    this.hours,
  });

  factory HomeLocation.fromJson(Map<String, dynamic> json) {
    return HomeLocation(
      id: json['id'] as String,
      name: json['name'] as String,
      address: json['address'] as String? ?? '',
      city: json['city'] as String?,
      distance: json['distance'] as String?,
      isOpen: (json['isOpen'] as bool?) ?? true,
      type: homeLocationTypeFromString(json['type'] as String?),
      pin: homePinFromString(json['pin'] as String?),
      lat: (json['lat'] as num).toDouble(),
      lng: (json['lng'] as num).toDouble(),
      image: json['image'] as String? ?? '',
      phone: json['phone'] as String?,
      hours: json['hours'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'address': address,
        if (city != null) 'city': city,
        if (distance != null) 'distance': distance,
        'isOpen': isOpen,
        'type': homeLocationTypeToString(type),
        'pin': homePinToString(pin),
        'lat': lat,
        'lng': lng,
        'image': image,
        if (phone != null) 'phone': phone,
        if (hours != null) 'hours': hours,
      };
}
