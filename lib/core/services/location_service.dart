import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import '../constants/app_constants.dart';
import '../error/exceptions.dart';

class PositionWithAddress {
  final double latitude;
  final double longitude;
  final String cityName;
  final String countryName;

  const PositionWithAddress({
    required this.latitude,
    required this.longitude,
    required this.cityName,
    required this.countryName,
  });
}

class LocationService {
  Future<PositionWithAddress> getCurrentPositionWithAddress() async {
    bool serviceEnabled;
    LocationPermission permission;

    try {
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        // Return default location if services disabled
        return const PositionWithAddress(
          latitude: AppConstants.defaultLatitude,
          longitude: AppConstants.defaultLongitude,
          cityName: AppConstants.defaultCityName,
          countryName: AppConstants.defaultCountryName,
        );
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return const PositionWithAddress(
            latitude: AppConstants.defaultLatitude,
            longitude: AppConstants.defaultLongitude,
            cityName: AppConstants.defaultCityName,
            countryName: AppConstants.defaultCountryName,
          );
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return const PositionWithAddress(
          latitude: AppConstants.defaultLatitude,
          longitude: AppConstants.defaultLongitude,
          cityName: AppConstants.defaultCityName,
          countryName: AppConstants.defaultCountryName,
        );
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium,
        timeLimit: const Duration(seconds: 10),
      );

      String cityName = AppConstants.defaultCityName;
      String countryName = AppConstants.defaultCountryName;

      try {
        final placemarks = await placemarkFromCoordinates(
          position.latitude,
          position.longitude,
        );

        if (placemarks.isNotEmpty) {
          final place = placemarks.first;
          cityName = place.locality ??
              place.subAdministrativeArea ??
              place.administrativeArea ??
              place.name ??
              AppConstants.defaultCityName;
          countryName = place.country ?? AppConstants.defaultCountryName;
        }
      } catch (_) {
        // Geocoding can fail in emulators/offline; keep coordinates
      }

      return PositionWithAddress(
        latitude: position.latitude,
        longitude: position.longitude,
        cityName: cityName,
        countryName: countryName,
      );
    } catch (e) {
      // Graceful fallback to default location on any platform exception
      return const PositionWithAddress(
        latitude: AppConstants.defaultLatitude,
        longitude: AppConstants.defaultLongitude,
        cityName: AppConstants.defaultCityName,
        countryName: AppConstants.defaultCountryName,
      );
    }
  }

  Future<List<Location>> getCoordinatesFromCityName(String cityName) async {
    try {
      return await locationFromAddress(cityName);
    } catch (e) {
      throw LocationException(message: 'Could not find coordinates for $cityName');
    }
  }
}
