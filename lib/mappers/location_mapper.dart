// Mapper to convert HomeLocation -> YslLocationData used by widgets

import '../models/home_location.dart';
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
