class WeatherEntity {
  final double temp;
  final double feelsLike;
  final double tempMin;
  final double tempMax;
  final int pressure;
  final int humidity;
  final double dewPoint;
  final double uvi;
  final int clouds;
  final int visibility;
  final double windSpeed;
  final int windDeg;
  final int weatherId;
  final String condition;
  final String description;
  final String iconCode;
  final int dt;
  final int? sunrise;
  final int? sunset;
  final String cityName;
  final String countryName;
  final DateTime? cachedAt;

  const WeatherEntity({
    required this.temp,
    required this.feelsLike,
    required this.tempMin,
    required this.tempMax,
    required this.pressure,
    required this.humidity,
    required this.dewPoint,
    required this.uvi,
    required this.clouds,
    required this.visibility,
    required this.windSpeed,
    required this.windDeg,
    required this.weatherId,
    required this.condition,
    required this.description,
    required this.iconCode,
    required this.dt,
    this.sunrise,
    this.sunset,
    required this.cityName,
    required this.countryName,
    this.cachedAt,
  });
}
