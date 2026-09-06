import '../entities/location_entity.dart';
import '../repositories/i_location_repository.dart';

class GetCurrentLocationUseCase {
  final ILocationRepository repository;

  GetCurrentLocationUseCase(this.repository);

  Future<LocationEntity> call() => repository.getCurrentLocation();
}

class SearchLocationsUseCase {
  final ILocationRepository repository;

  SearchLocationsUseCase(this.repository);

  Future<List<LocationEntity>> call(String query) => repository.searchLocations(query);
}

class GetSavedLocationsUseCase {
  final ILocationRepository repository;

  GetSavedLocationsUseCase(this.repository);

  Future<List<LocationEntity>> call() => repository.getSavedLocations();
}

class SaveLocationUseCase {
  final ILocationRepository repository;

  SaveLocationUseCase(this.repository);

  Future<void> call(LocationEntity location) => repository.saveLocation(location);
}

class RemoveLocationUseCase {
  final ILocationRepository repository;

  RemoveLocationUseCase(this.repository);

  Future<void> call(LocationEntity location) => repository.removeLocation(location);
}
