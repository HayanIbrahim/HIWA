import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../domain/entities/location_entity.dart';
import '../../../../domain/usecases/location_usecases.dart';

// Events
abstract class LocationEvent extends Equatable {
  const LocationEvent();
  @override
  List<Object?> get props => [];
}

class LoadSavedLocationsEvent extends LocationEvent {}

class SearchCitiesEvent extends LocationEvent {
  final String query;
  const SearchCitiesEvent(this.query);
  @override
  List<Object?> get props => [query];
}

class ToggleSaveLocationEvent extends LocationEvent {
  final LocationEntity location;
  const ToggleSaveLocationEvent(this.location);
  @override
  List<Object?> get props => [location];
}

class DeleteLocationEvent extends LocationEvent {
  final LocationEntity location;
  const DeleteLocationEvent(this.location);
  @override
  List<Object?> get props => [location];
}

class SelectLocationEvent extends LocationEvent {
  final LocationEntity location;
  const SelectLocationEvent(this.location);
  @override
  List<Object?> get props => [location];
}

// State
class LocationState extends Equatable {
  final List<LocationEntity> savedLocations;
  final List<LocationEntity> searchResults;
  final LocationEntity? selectedLocation;
  final bool isSearching;
  final String? errorMessage;

  const LocationState({
    this.savedLocations = const [],
    this.searchResults = const [],
    this.selectedLocation,
    this.isSearching = false,
    this.errorMessage,
  });

  LocationState copyWith({
    List<LocationEntity>? savedLocations,
    List<LocationEntity>? searchResults,
    LocationEntity? selectedLocation,
    bool? isSearching,
    String? errorMessage,
  }) {
    return LocationState(
      savedLocations: savedLocations ?? this.savedLocations,
      searchResults: searchResults ?? this.searchResults,
      selectedLocation: selectedLocation ?? this.selectedLocation,
      isSearching: isSearching ?? this.isSearching,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        savedLocations,
        searchResults,
        selectedLocation,
        isSearching,
        errorMessage,
      ];
}

// BLoC
class LocationBloc extends Bloc<LocationEvent, LocationState> {
  final GetSavedLocationsUseCase getSavedLocationsUseCase;
  final SearchLocationsUseCase searchLocationsUseCase;
  final SaveLocationUseCase saveLocationUseCase;
  final RemoveLocationUseCase removeLocationUseCase;
  final GetCurrentLocationUseCase getCurrentLocationUseCase;

  LocationBloc({
    required this.getSavedLocationsUseCase,
    required this.searchLocationsUseCase,
    required this.saveLocationUseCase,
    required this.removeLocationUseCase,
    required this.getCurrentLocationUseCase,
  }) : super(const LocationState()) {
    on<LoadSavedLocationsEvent>((event, emit) async {
      try {
        final locations = await getSavedLocationsUseCase();
        emit(state.copyWith(savedLocations: locations));
      } catch (e) {
        emit(state.copyWith(errorMessage: e.toString()));
      }
    });

    on<SearchCitiesEvent>((event, emit) async {
      if (event.query.trim().isEmpty) {
        emit(state.copyWith(searchResults: [], isSearching: false));
        return;
      }

      emit(state.copyWith(isSearching: true));
      try {
        final results = await searchLocationsUseCase(event.query);
        emit(state.copyWith(searchResults: results, isSearching: false));
      } catch (e) {
        emit(state.copyWith(searchResults: [], isSearching: false));
      }
    });

    on<ToggleSaveLocationEvent>((event, emit) async {
      try {
        final exists = state.savedLocations.any((loc) =>
            loc.cityName.toLowerCase() == event.location.cityName.toLowerCase() &&
            loc.countryName.toLowerCase() == event.location.countryName.toLowerCase());

        if (exists) {
          await removeLocationUseCase(event.location);
        } else {
          await saveLocationUseCase(event.location.copyWith(isFavorite: true));
        }

        final updated = await getSavedLocationsUseCase();
        emit(state.copyWith(savedLocations: updated));
      } catch (e) {
        emit(state.copyWith(errorMessage: e.toString()));
      }
    });

    on<DeleteLocationEvent>((event, emit) async {
      try {
        await removeLocationUseCase(event.location);
        final updated = await getSavedLocationsUseCase();
        emit(state.copyWith(savedLocations: updated));
      } catch (e) {
        emit(state.copyWith(errorMessage: e.toString()));
      }
    });

    on<SelectLocationEvent>((event, emit) {
      emit(state.copyWith(selectedLocation: event.location));
    });
  }
}
