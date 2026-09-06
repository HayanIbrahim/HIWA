import '../repositories/i_weather_repository.dart';

class GetFullWeatherUseCase {
  final IWeatherRepository repository;

  GetFullWeatherUseCase(this.repository);

  Future<FullWeatherData> call({
    required double latitude,
    required double longitude,
    String? cityName,
    String? countryName,
    String lang = 'en',
    String units = 'metric',
  }) {
    return repository.getFullWeather(
      latitude: latitude,
      longitude: longitude,
      cityName: cityName,
      countryName: countryName,
      lang: lang,
      units: units,
    );
  }
}

class GetCachedWeatherUseCase {
  final IWeatherRepository repository;

  GetCachedWeatherUseCase(this.repository);

  Future<FullWeatherData?> call({
    required double latitude,
    required double longitude,
  }) {
    return repository.getCachedWeather(
      latitude: latitude,
      longitude: longitude,
    );
  }
}
