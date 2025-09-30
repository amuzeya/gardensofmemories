// Mapper to convert HomeLocation -> YslLocationData used by widgets

import '../models/home_location.dart';
import '../models/location_details.dart';
import '../widgets/ysl_location_card.dart';

LocationType _mapType(HomeLocationType t) {
  switch (t) {
    case HomeLocationType.store:
      return LocationType.store;
    case HomeLocationType.boutique:
      return LocationType.boutique;
    case HomeLocationType.experience:
      return LocationType.experience;
    case HomeLocationType.popup:
      return LocationType.popup;
  }
}

PinVariation _mapPin(HomePinVariation p) {
  switch (p) {
    case HomePinVariation.pinA:
      return PinVariation.pinA;
    case HomePinVariation.pinB:
      return PinVariation.pinB;
    case HomePinVariation.pinC:
      return PinVariation.pinC;
  }
}

YslLocationData toYslLocationData(HomeLocation src) {
  return YslLocationData(
    name: src.name,
    address: src.address,
    city: src.city,
    distance: src.distance,
    isOpen: src.isOpen,
    type: _mapType(src.type),
    pinVariation: _mapPin(src.pin),
    imagePath: src.image,
  );
}

/// Enhanced mapper that includes listing description from LocationDetails
YslLocationData toYslLocationDataWithDetails(HomeLocation src, LocationDetails? details, {int? index}) {
  // Assign pin by JSON order if index provided; else map from source
  PinVariation pin;
  if (index != null) {
    switch (index % 4) {
      case 0:
        pin = PinVariation.pinA;
        break;
      case 1:
        pin = PinVariation.pinB;
        break;
      case 2:
        pin = PinVariation.pinC;
        break;
      default:
        pin = PinVariation.pinD;
    }
  } else {
    pin = _mapPin(src.pin);
  }

  return YslLocationData(
    name: src.name,
    address: src.address,
    listingDescription: details?.listingDescription,
    city: src.city,
    distance: src.distance,
    isOpen: src.isOpen,
    type: _mapType(src.type),
    pinVariation: pin,
    imagePath: src.image,
  );
}
