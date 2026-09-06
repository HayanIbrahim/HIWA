import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import '../../core/constants/api_constants.dart';
import '../../core/network/dio_client.dart';
import '../../core/services/location_service.dart';
import '../models/location_dto.dart';

abstract class LocationDataSource {
  Future<PositionWithAddress> getDevicePosition();
  Future<List<LocationDto>> searchCities(String query);
  Future<List<LocationDto>> getSavedLocations();
  Future<void> saveLocation(LocationDto location);
  Future<void> removeLocation(LocationDto location);
}

class LocationDataSourceImpl implements LocationDataSource {
  final LocationService locationService;
  final DioClient dioClient;
  final Box locationsBox;

  LocationDataSourceImpl({
    required this.locationService,
    required this.dioClient,
    required this.locationsBox,
  });

  @override
  Future<PositionWithAddress> getDevicePosition() {
    return locationService.getCurrentPositionWithAddress();
  }

  @override
  Future<List<LocationDto>> searchCities(String query) async {
    if (query.trim().isEmpty) return [];

    try {
      final response = await dioClient.dio.get(
        ApiConstants.geoDirectEndpoint,
        queryParameters: {
          'q': query.trim(),
          'limit': 5,
        },
      );

      if (response.statusCode == 200 && response.data is List) {
        return (response.data as List)
            .map((item) => LocationDto.fromJson(item as Map<String, dynamic>))
            .toList();
      }
    } catch (_) {
      // Fallback search suggestions for common global cities if offline
      final normalized = query.toLowerCase();
      final sampleCities = [
        LocationDto(latitude: 30.0444, longitude: 31.2357, cityName: 'Cairo', countryName: 'Egypt'),
        LocationDto(latitude: 25.2048, longitude: 55.2708, cityName: 'Dubai', countryName: 'UAE'),
        LocationDto(latitude: 24.7136, longitude: 46.6753, cityName: 'Riyadh', countryName: 'Saudi Arabia'),
        LocationDto(latitude: 51.5074, longitude: -0.1278, cityName: 'London', countryName: 'UK'),
        LocationDto(latitude: 40.7128, longitude: -74.0060, cityName: 'New York', countryName: 'USA'),
        LocationDto(latitude: 35.6762, longitude: 139.6503, cityName: 'Tokyo', countryName: 'Japan'),
        LocationDto(latitude: 48.8566, longitude: 2.3522, cityName: 'Paris', countryName: 'France'),
      ];

      return sampleCities
          .where((city) =>
              city.cityName.toLowerCase().contains(normalized) ||
              city.countryName.toLowerCase().contains(normalized))
          .toList();
    }

    return [];
  }

  @override
  Future<List<LocationDto>> getSavedLocations() async {
    final List<LocationDto> results = [];
    for (var key in locationsBox.keys) {
      final jsonStr = locationsBox.get(key) as String?;
      if (jsonStr != null) {
        try {
          final map = jsonDecode(jsonStr) as Map<String, dynamic>;
          results.add(LocationDto.fromJson(map));
        } catch (_) {}
      }
    }
    return results;
  }

  @override
  Future<void> saveLocation(LocationDto location) async {
    final key = '${location.cityName}_${location.countryName}';
    final jsonStr = jsonEncode(location.toJson());
    await locationsBox.put(key, jsonStr);
  }

  @override
  Future<void> removeLocation(LocationDto location) async {
    final key = '${location.cityName}_${location.countryName}';
    await locationsBox.delete(key);
  }
}
