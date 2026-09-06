import '../entities/location_entity.dart';

abstract class ILocationRepository {
  Future<LocationEntity> getCurrentLocation();
  Future<List<LocationEntity>> searchLocations(String query);
  Future<List<LocationEntity>> getSavedLocations();
  Future<void> saveLocation(LocationEntity location);
  Future<void> removeLocation(LocationEntity location);
}
