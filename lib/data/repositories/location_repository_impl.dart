import '../../domain/entities/location_entity.dart';
import '../../domain/repositories/i_location_repository.dart';
import '../datasources/location_data_source.dart';
import '../models/location_dto.dart';

class LocationRepositoryImpl implements ILocationRepository {
  final LocationDataSource dataSource;

  LocationRepositoryImpl({required this.dataSource});

  @override
  Future<LocationEntity> getCurrentLocation() async {
    final posWithAddress = await dataSource.getDevicePosition();
    return LocationEntity(
      latitude: posWithAddress.latitude,
      longitude: posWithAddress.longitude,
      cityName: posWithAddress.cityName,
      countryName: posWithAddress.countryName,
      isCurrentLocation: true,
      isFavorite: false,
    );
  }

  @override
  Future<List<LocationEntity>> searchLocations(String query) async {
    final dtos = await dataSource.searchCities(query);
    return dtos.map((dto) => dto.toDomain()).toList();
  }

  @override
  Future<List<LocationEntity>> getSavedLocations() async {
    final dtos = await dataSource.getSavedLocations();
    return dtos.map((dto) => dto.toDomain()).toList();
  }

  @override
  Future<void> saveLocation(LocationEntity location) async {
    await dataSource.saveLocation(LocationDto.fromDomain(location));
  }

  @override
  Future<void> removeLocation(LocationEntity location) async {
    await dataSource.removeLocation(LocationDto.fromDomain(location));
  }
}
