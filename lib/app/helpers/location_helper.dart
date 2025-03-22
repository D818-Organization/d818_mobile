// ignore_for_file: avoid_print

import 'package:d818_mobile_app/app/models/location/location_model.dart';
import 'package:d818_mobile_app/app/resources/app.logger.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

var log = getLogger('LocationHelper');

class LocationHelper {
  Position? _currentPosition;
  double? longitude, latitude;
  String? postalCode, city, country, name, street;

  Future _getAddressFromLatLng() async {
    try {
      log.w("Referencing location ---");
      List<Placemark> placemarks = await placemarkFromCoordinates(
        latitude!,
        longitude!,
      );

      Placemark place = placemarks[0];

      postalCode = place.postalCode;
      city = place.locality;
      country = place.country;
      name = place.name;
      street = place.street;
    } catch (e) {
      log.d(e);
    }
  }

  Future getCurrentLocation() async {
    await Geolocator.requestPermission();
    await Geolocator.checkPermission();
    log.w("Getting Location >>>");

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    log.d('Position determined: $position');
    _currentPosition = position;
    if (_currentPosition != null) {
      longitude = _currentPosition!.longitude;
      latitude = _currentPosition!.latitude;
      await _getAddressFromLatLng();

      LocationModel locationData = LocationModel(
        latitude: latitude,
        longitude: longitude,
        city: city,
        country: country,
        postalCode: postalCode,
      );
      log.wtf("Location Data: ${locationData.toJson()}");
      return locationData;
    } else {
      log.d("Error getting location");
      return null;
    }
  }
}
