import '../../domain/entities/daily_forecast_entity.dart';
import '../../domain/entities/hourly_forecast_entity.dart';
import '../../domain/entities/minutely_precipitation_entity.dart';
import '../../domain/entities/weather_alert_entity.dart';
import '../../domain/entities/weather_entity.dart';
import '../../domain/repositories/i_weather_repository.dart';

class OneCallResponseDto {
  final double lat;
  final double lon;
  final String timezone;
  final CurrentWeatherDto current;
  final List<MinutelyDto> minutely;
  final List<HourlyForecastDto> hourly;
  final List<DailyForecastDto> daily;
  final List<WeatherAlertDto> alerts;

  OneCallResponseDto({
    required this.lat,
    required this.lon,
    required this.timezone,
    required this.current,
    required this.minutely,
    required this.hourly,
    required this.daily,
    required this.alerts,
  });

  factory OneCallResponseDto.fromJson(Map<String, dynamic> json) {
    return OneCallResponseDto(
      lat: (json['lat'] as num?)?.toDouble() ?? 0.0,
      lon: (json['lon'] as num?)?.toDouble() ?? 0.0,
      timezone: json['timezone'] as String? ?? 'UTC',
      current: CurrentWeatherDto.fromJson(json['current'] as Map<String, dynamic>? ?? {}),
      minutely: (json['minutely'] as List<dynamic>?)
              ?.map((e) => MinutelyDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      hourly: (json['hourly'] as List<dynamic>?)
              ?.map((e) => HourlyForecastDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      daily: (json['daily'] as List<dynamic>?)
              ?.map((e) => DailyForecastDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      alerts: (json['alerts'] as List<dynamic>?)
              ?.map((e) => WeatherAlertDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'lat': lat,
      'lon': lon,
      'timezone': timezone,
      'current': current.toJson(),
      'minutely': minutely.map((e) => e.toJson()).toList(),
      'hourly': hourly.map((e) => e.toJson()).toList(),
      'daily': daily.map((e) => e.toJson()).toList(),
      'alerts': alerts.map((e) => e.toJson()).toList(),
    };
  }

  FullWeatherData toDomain({
    String cityName = 'Unknown Location',
    String countryName = '',
    DateTime? cachedAt,
  }) {
    final dailyFirst = daily.isNotEmpty ? daily.first : null;
    return FullWeatherData(
      current: current.toDomain(
        cityName: cityName,
        countryName: countryName,
        cachedAt: cachedAt,
        fallbackSunrise: dailyFirst?.sunrise,
        fallbackSunset: dailyFirst?.sunset,
      ),
      hourly: hourly.map((e) => e.toDomain()).toList(),
      daily: daily.map((e) => e.toDomain()).toList(),
      alerts: alerts.map((e) => e.toDomain()).toList(),
      minutely: minutely.map((e) => e.toDomain()).toList(),
    );
  }
}

class CurrentWeatherDto {
  final int dt;
  final int? sunrise;
  final int? sunset;
  final double temp;
  final double feelsLike;
  final int pressure;
  final int humidity;
  final double dewPoint;
  final double uvi;
  final int clouds;
  final int visibility;
  final double windSpeed;
  final int windDeg;
  final List<WeatherDescriptionDto> weather;

  CurrentWeatherDto({
    required this.dt,
    this.sunrise,
    this.sunset,
    required this.temp,
    required this.feelsLike,
    required this.pressure,
    required this.humidity,
    required this.dewPoint,
    required this.uvi,
    required this.clouds,
    required this.visibility,
    required this.windSpeed,
    required this.windDeg,
    required this.weather,
  });

  factory CurrentWeatherDto.fromJson(Map<String, dynamic> json) {
    return CurrentWeatherDto(
      dt: json['dt'] as int? ?? DateTime.now().millisecondsSinceEpoch ~/ 1000,
      sunrise: json['sunrise'] as int?,
      sunset: json['sunset'] as int?,
      temp: (json['temp'] as num?)?.toDouble() ?? 0.0,
      feelsLike: (json['feels_like'] as num?)?.toDouble() ?? 0.0,
      pressure: json['pressure'] as int? ?? 1013,
      humidity: json['humidity'] as int? ?? 50,
      dewPoint: (json['dew_point'] as num?)?.toDouble() ?? 0.0,
      uvi: (json['uvi'] as num?)?.toDouble() ?? 0.0,
      clouds: json['clouds'] as int? ?? 0,
      visibility: json['visibility'] as int? ?? 10000,
      windSpeed: (json['wind_speed'] as num?)?.toDouble() ?? 0.0,
      windDeg: json['wind_deg'] as int? ?? 0,
      weather: (json['weather'] as List<dynamic>?)
              ?.map((e) => WeatherDescriptionDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'dt': dt,
      'sunrise': sunrise,
      'sunset': sunset,
      'temp': temp,
      'feels_like': feelsLike,
      'pressure': pressure,
      'humidity': humidity,
      'dew_point': dewPoint,
      'uvi': uvi,
      'clouds': clouds,
      'visibility': visibility,
      'wind_speed': windSpeed,
      'wind_deg': windDeg,
      'weather': weather.map((e) => e.toJson()).toList(),
    };
  }

  WeatherEntity toDomain({
    required String cityName,
    required String countryName,
    DateTime? cachedAt,
    int? fallbackSunrise,
    int? fallbackSunset,
  }) {
    final firstWeather = weather.isNotEmpty
        ? weather.first
        : WeatherDescriptionDto(id: 800, main: 'Clear', description: 'Clear sky', icon: '01d');

    return WeatherEntity(
      temp: temp,
      feelsLike: feelsLike,
      tempMin: temp - 2.0,
      tempMax: temp + 2.0,
      pressure: pressure,
      humidity: humidity,
      dewPoint: dewPoint,
      uvi: uvi,
      clouds: clouds,
      visibility: visibility,
      windSpeed: windSpeed,
      windDeg: windDeg,
      weatherId: firstWeather.id,
      condition: firstWeather.main,
      description: firstWeather.description,
      iconCode: firstWeather.icon,
      dt: dt,
      sunrise: sunrise ?? fallbackSunrise,
      sunset: sunset ?? fallbackSunset,
      cityName: cityName,
      countryName: countryName,
      cachedAt: cachedAt,
    );
  }
}

class HourlyForecastDto {
  final int dt;
  final double temp;
  final double feelsLike;
  final int pressure;
  final int humidity;
  final double pop;
  final List<WeatherDescriptionDto> weather;

  HourlyForecastDto({
    required this.dt,
    required this.temp,
    required this.feelsLike,
    required this.pressure,
    required this.humidity,
    required this.pop,
    required this.weather,
  });

  factory HourlyForecastDto.fromJson(Map<String, dynamic> json) {
    return HourlyForecastDto(
      dt: json['dt'] as int? ?? 0,
      temp: (json['temp'] as num?)?.toDouble() ?? 0.0,
      feelsLike: (json['feels_like'] as num?)?.toDouble() ?? 0.0,
      pressure: json['pressure'] as int? ?? 1013,
      humidity: json['humidity'] as int? ?? 50,
      pop: (json['pop'] as num?)?.toDouble() ?? 0.0,
      weather: (json['weather'] as List<dynamic>?)
              ?.map((e) => WeatherDescriptionDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'dt': dt,
      'temp': temp,
      'feels_like': feelsLike,
      'pressure': pressure,
      'humidity': humidity,
      'pop': pop,
      'weather': weather.map((e) => e.toJson()).toList(),
    };
  }

  HourlyForecastEntity toDomain() {
    final firstWeather = weather.isNotEmpty
        ? weather.first
        : WeatherDescriptionDto(id: 800, main: 'Clear', description: 'Clear sky', icon: '01d');

    return HourlyForecastEntity(
      dt: dt,
      temp: temp,
      feelsLike: feelsLike,
      pressure: pressure,
      humidity: humidity,
      pop: pop,
      weatherId: firstWeather.id,
      condition: firstWeather.main,
      description: firstWeather.description,
      iconCode: firstWeather.icon,
    );
  }
}

class DailyForecastDto {
  final int dt;
  final int sunrise;
  final int sunset;
  final Map<String, dynamic> temp;
  final int pressure;
  final int humidity;
  final double windSpeed;
  final double pop;
  final double uvi;
  final String? summary;
  final List<WeatherDescriptionDto> weather;

  DailyForecastDto({
    required this.dt,
    required this.sunrise,
    required this.sunset,
    required this.temp,
    required this.pressure,
    required this.humidity,
    required this.windSpeed,
    required this.pop,
    required this.uvi,
    this.summary,
    required this.weather,
  });

  factory DailyForecastDto.fromJson(Map<String, dynamic> json) {
    return DailyForecastDto(
      dt: json['dt'] as int? ?? 0,
      sunrise: json['sunrise'] as int? ?? 0,
      sunset: json['sunset'] as int? ?? 0,
      temp: json['temp'] as Map<String, dynamic>? ?? {},
      pressure: json['pressure'] as int? ?? 1013,
      humidity: json['humidity'] as int? ?? 50,
      windSpeed: (json['wind_speed'] as num?)?.toDouble() ?? 0.0,
      pop: (json['pop'] as num?)?.toDouble() ?? 0.0,
      uvi: (json['uvi'] as num?)?.toDouble() ?? 0.0,
      summary: json['summary'] as String?,
      weather: (json['weather'] as List<dynamic>?)
              ?.map((e) => WeatherDescriptionDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'dt': dt,
      'sunrise': sunrise,
      'sunset': sunset,
      'temp': temp,
      'pressure': pressure,
      'humidity': humidity,
      'wind_speed': windSpeed,
      'pop': pop,
      'uvi': uvi,
      'summary': summary,
      'weather': weather.map((e) => e.toJson()).toList(),
    };
  }

  DailyForecastEntity toDomain() {
    final firstWeather = weather.isNotEmpty
        ? weather.first
        : WeatherDescriptionDto(id: 800, main: 'Clear', description: 'Clear sky', icon: '01d');

    final dayTemp = (temp['day'] as num?)?.toDouble() ?? 0.0;
    final minTemp = (temp['min'] as num?)?.toDouble() ?? dayTemp - 4.0;
    final maxTemp = (temp['max'] as num?)?.toDouble() ?? dayTemp + 4.0;
    final nightTemp = (temp['night'] as num?)?.toDouble() ?? minTemp;

    return DailyForecastEntity(
      dt: dt,
      sunrise: sunrise,
      sunset: sunset,
      tempDay: dayTemp,
      tempNight: nightTemp,
      tempMin: minTemp,
      tempMax: maxTemp,
      pressure: pressure,
      humidity: humidity,
      windSpeed: windSpeed,
      pop: pop,
      uvi: uvi,
      summary: summary ?? firstWeather.description,
      weatherId: firstWeather.id,
      condition: firstWeather.main,
      description: firstWeather.description,
      iconCode: firstWeather.icon,
    );
  }
}

class WeatherDescriptionDto {
  final int id;
  final String main;
  final String description;
  final String icon;

  WeatherDescriptionDto({
    required this.id,
    required this.main,
    required this.description,
    required this.icon,
  });

  factory WeatherDescriptionDto.fromJson(Map<String, dynamic> json) {
    return WeatherDescriptionDto(
      id: json['id'] as int? ?? 800,
      main: json['main'] as String? ?? 'Clear',
      description: json['description'] as String? ?? 'Clear sky',
      icon: json['icon'] as String? ?? '01d',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'main': main,
      'description': description,
      'icon': icon,
    };
  }
}

class WeatherAlertDto {
  final String senderName;
  final String event;
  final int start;
  final int end;
  final String description;

  WeatherAlertDto({
    required this.senderName,
    required this.event,
    required this.start,
    required this.end,
    required this.description,
  });

  factory WeatherAlertDto.fromJson(Map<String, dynamic> json) {
    return WeatherAlertDto(
      senderName: json['sender_name'] as String? ?? 'Meteorological Agency',
      event: json['event'] as String? ?? 'Weather Advisory',
      start: json['start'] as int? ?? 0,
      end: json['end'] as int? ?? 0,
      description: json['description'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sender_name': senderName,
      'event': event,
      'start': start,
      'end': end,
      'description': description,
    };
  }

  WeatherAlertEntity toDomain() {
    return WeatherAlertEntity(
      senderName: senderName,
      event: event,
      start: start,
      end: end,
      description: description,
    );
  }
}

class MinutelyDto {
  final int dt;
  final double precipitation;

  MinutelyDto({
    required this.dt,
    required this.precipitation,
  });

  factory MinutelyDto.fromJson(Map<String, dynamic> json) {
    return MinutelyDto(
      dt: json['dt'] as int? ?? 0,
      precipitation: (json['precipitation'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'dt': dt,
      'precipitation': precipitation,
    };
  }

  MinutelyPrecipitationEntity toDomain() {
    return MinutelyPrecipitationEntity(
      dt: dt,
      precipitation: precipitation,
    );
  }
}
