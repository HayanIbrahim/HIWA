import '../entities/weather_entity.dart';
import '../entities/hourly_forecast_entity.dart';
import '../entities/daily_forecast_entity.dart';
import '../entities/weather_alert_entity.dart';
import '../entities/minutely_precipitation_entity.dart';

class FullWeatherData {
  final WeatherEntity current;
  final List<HourlyForecastEntity> hourly;
  final List<DailyForecastEntity> daily;
  final List<WeatherAlertEntity> alerts;
  final List<MinutelyPrecipitationEntity> minutely;

  const FullWeatherData({
    required this.current,
    required this.hourly,
    required this.daily,
    required this.alerts,
    required this.minutely,
  });
}

abstract class IWeatherRepository {
  Future<FullWeatherData> getFullWeather({
    required double latitude,
    required double longitude,
    String? cityName,
    String? countryName,
    String lang = 'en',
    String units = 'metric',
  });

  Future<FullWeatherData?> getCachedWeather({
    required double latitude,
    required double longitude,
  });
}
