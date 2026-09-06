class DailyForecastEntity {
  final int dt;
  final int sunrise;
  final int sunset;
  final double tempDay;
  final double tempNight;
  final double tempMin;
  final double tempMax;
  final int pressure;
  final int humidity;
  final double windSpeed;
  final double pop; // probability of precipitation
  final double uvi;
  final String summary;
  final int weatherId;
  final String condition;
  final String description;
  final String iconCode;

  const DailyForecastEntity({
    required this.dt,
    required this.sunrise,
    required this.sunset,
    required this.tempDay,
    required this.tempNight,
    required this.tempMin,
    required this.tempMax,
    required this.pressure,
    required this.humidity,
    required this.windSpeed,
    required this.pop,
    required this.uvi,
    required this.summary,
    required this.weatherId,
    required this.condition,
    required this.description,
    required this.iconCode,
  });
}
