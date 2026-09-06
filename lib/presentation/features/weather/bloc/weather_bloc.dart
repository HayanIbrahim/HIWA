import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../domain/repositories/i_weather_repository.dart';
import '../../../../domain/usecases/location_usecases.dart';
import '../../../../domain/usecases/weather_usecases.dart';

// Events
abstract class WeatherEvent extends Equatable {
  const WeatherEvent();
  @override
  List<Object?> get props => [];
}

class FetchWeatherEvent extends WeatherEvent {
  final double latitude;
  final double longitude;
  final String? cityName;
  final String? countryName;

  const FetchWeatherEvent({
    required this.latitude,
    required this.longitude,
    this.cityName,
    this.countryName,
  });

  @override
  List<Object?> get props => [latitude, longitude, cityName, countryName];
}

class FetchCurrentDeviceWeatherEvent extends WeatherEvent {}

class RefreshCurrentWeatherEvent extends WeatherEvent {}

// State
abstract class WeatherState extends Equatable {
  const WeatherState();
  @override
  List<Object?> get props => [];
}

class WeatherInitial extends WeatherState {}

class WeatherLoading extends WeatherState {}

class WeatherLoaded extends WeatherState {
  final FullWeatherData fullWeather;
  final bool isOffline;

  const WeatherLoaded({
    required this.fullWeather,
    this.isOffline = false,
  });

  @override
  List<Object?> get props => [fullWeather, isOffline];
}

class WeatherError extends WeatherState {
  final String message;
  const WeatherError({required this.message});

  @override
  List<Object?> get props => [message];
}

// BLoC
class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final GetFullWeatherUseCase getFullWeatherUseCase;
  final GetCurrentLocationUseCase getCurrentLocationUseCase;

  double _currentLat = AppConstants.defaultLatitude;
  double _currentLon = AppConstants.defaultLongitude;
  String _currentCity = AppConstants.defaultCityName;
  String _currentCountry = AppConstants.defaultCountryName;

  WeatherBloc({
    required this.getFullWeatherUseCase,
    required this.getCurrentLocationUseCase,
  }) : super(WeatherInitial()) {
    on<FetchWeatherEvent>((event, emit) async {
      emit(WeatherLoading());
      _currentLat = event.latitude;
      _currentLon = event.longitude;
      if (event.cityName != null) _currentCity = event.cityName!;
      if (event.countryName != null) _currentCountry = event.countryName!;

      try {
        final data = await getFullWeatherUseCase(
          latitude: _currentLat,
          longitude: _currentLon,
          cityName: _currentCity,
          countryName: _currentCountry,
        );
        emit(WeatherLoaded(
          fullWeather: data,
          isOffline: data.current.cachedAt != null,
        ));
      } catch (e) {
        emit(WeatherError(message: e.toString()));
      }
    });

    on<FetchCurrentDeviceWeatherEvent>((event, emit) async {
      emit(WeatherLoading());
      try {
        final location = await getCurrentLocationUseCase();
        _currentLat = location.latitude;
        _currentLon = location.longitude;
        _currentCity = location.cityName;
        _currentCountry = location.countryName;

        final data = await getFullWeatherUseCase(
          latitude: _currentLat,
          longitude: _currentLon,
          cityName: _currentCity,
          countryName: _currentCountry,
        );

        emit(WeatherLoaded(
          fullWeather: data,
          isOffline: data.current.cachedAt != null,
        ));
      } catch (e) {
        // Fallback to default coordinates on device location failure
        try {
          final data = await getFullWeatherUseCase(
            latitude: _currentLat,
            longitude: _currentLon,
            cityName: _currentCity,
            countryName: _currentCountry,
          );
          emit(WeatherLoaded(
            fullWeather: data,
            isOffline: true,
          ));
        } catch (err) {
          emit(WeatherError(message: err.toString()));
        }
      }
    });

    on<RefreshCurrentWeatherEvent>((event, emit) async {
      try {
        final data = await getFullWeatherUseCase(
          latitude: _currentLat,
          longitude: _currentLon,
          cityName: _currentCity,
          countryName: _currentCountry,
        );
        emit(WeatherLoaded(
          fullWeather: data,
          isOffline: data.current.cachedAt != null,
        ));
      } catch (e) {
        // Keep existing loaded state on silent refresh failure
      }
    });
  }
}
