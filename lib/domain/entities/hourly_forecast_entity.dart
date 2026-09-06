class HourlyForecastEntity {
  final int dt;
  final double temp;
  final double feelsLike;
  final int pressure;
  final int humidity;
  final double pop; // 0.0 to 1.0 probability of precipitation
  final int weatherId;
  final String condition;
  final String description;
  final String iconCode;

  const HourlyForecastEntity({
    required this.dt,
    required this.temp,
    required this.feelsLike,
    required this.pressure,
    required this.humidity,
    required this.pop,
    required this.weatherId,
    required this.condition,
    required this.description,
    required this.iconCode,
  });
}
