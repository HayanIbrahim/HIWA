import '../models/one_call_response_dto.dart';

class WeatherMockData {
  static OneCallResponseDto getMockOneCallData({
    required double lat,
    required double lon,
    String cityName = 'Cairo',
    String countryName = 'Egypt',
  }) {
    final now = DateTime.now();
    final nowEpoch = now.millisecondsSinceEpoch ~/ 1000;

    // Generate 48 hours of realistic forecasts
    final hourlyList = List.generate(48, (index) {
      final hourDt = nowEpoch + (index * 3600);
      final hourOfDay = (now.hour + index) % 24;
      final isNight = hourOfDay < 6 || hourOfDay > 19;

      // Realistic diurnal temperature curve
      final tempVariation = 4.0 * -(((hourOfDay - 14).abs() / 7.0) - 1.0);
      final temp = 25.0 + tempVariation;
      final pop = (index % 7 == 0) ? 0.35 : (index % 5 == 0 ? 0.15 : 0.0);

      return HourlyForecastDto(
        dt: hourDt,
        temp: double.parse(temp.toStringAsFixed(1)),
        feelsLike: double.parse((temp + 1.2).toStringAsFixed(1)),
        pressure: 1014 + (index % 3),
        humidity: 45 + (index % 25),
        pop: pop,
        weather: [
          WeatherDescriptionDto(
            id: pop > 0.3 ? 500 : (index % 4 == 0 ? 802 : 800),
            main: pop > 0.3 ? 'Rain' : (index % 4 == 0 ? 'Clouds' : 'Clear'),
            description: pop > 0.3
                ? 'Light rain'
                : (index % 4 == 0 ? 'Scattered clouds' : 'Clear sky'),
            icon: pop > 0.3
                ? '10d'
                : (index % 4 == 0
                    ? (isNight ? '03n' : '03d')
                    : (isNight ? '01n' : '01d')),
          ),
        ],
      );
    });

    // Generate 8 days of realistic daily forecasts
    final dailyList = List.generate(8, (index) {
      final dayDt = nowEpoch + (index * 86400);
      final minTemp = 18.0 + (index % 3);
      final maxTemp = 28.0 + (index % 4);
      final dayTemp = 26.0 + (index % 2);

      return DailyForecastDto(
        dt: dayDt,
        sunrise: dayDt + (6 * 3600) + 1200,
        sunset: dayDt + (18 * 3600) + 2400,
        temp: {
          'day': dayTemp,
          'min': minTemp,
          'max': maxTemp,
          'night': minTemp + 2.0,
        },
        pressure: 1013,
        humidity: 48 + index,
        windSpeed: 4.2 + (index * 0.4),
        pop: index == 2 ? 0.65 : 0.10,
        uvi: 6.5,
        summary: index == 0
            ? 'Clear and sunny throughout the day.'
            : (index == 2
                ? 'Scattered rain showers expected in the afternoon.'
                : 'Partly cloudy with pleasant breezes.'),
        weather: [
          WeatherDescriptionDto(
            id: index == 2 ? 501 : (index % 2 == 0 ? 800 : 801),
            main: index == 2 ? 'Rain' : (index % 2 == 0 ? 'Clear' : 'Clouds'),
            description: index == 2 ? 'Moderate rain' : 'Sunny with light clouds',
            icon: index == 2 ? '10d' : (index % 2 == 0 ? '01d' : '02d'),
          ),
        ],
      );
    });

    // Generate 60 minutes of precipitation data
    final minutelyList = List.generate(60, (index) {
      return MinutelyDto(
        dt: nowEpoch + (index * 60),
        precipitation: index > 20 && index < 35 ? (index - 20) * 0.08 : 0.0,
      );
    });

    return OneCallResponseDto(
      lat: lat,
      lon: lon,
      timezone: 'Africa/Cairo',
      current: CurrentWeatherDto(
        dt: nowEpoch,
        temp: 27.4,
        feelsLike: 28.1,
        pressure: 1014,
        humidity: 42,
        dewPoint: 13.5,
        uvi: 6.2,
        clouds: 15,
        visibility: 10000,
        windSpeed: 4.8,
        windDeg: 340,
        weather: [
          WeatherDescriptionDto(
            id: 800,
            main: 'Clear',
            description: 'Clear sky',
            icon: '01d',
          ),
        ],
      ),
      minutely: minutelyList,
      hourly: hourlyList,
      daily: dailyList,
      alerts: [
        WeatherAlertDto(
          senderName: 'National Meteorological Authority',
          event: 'High UV Advisory',
          start: nowEpoch,
          end: nowEpoch + (8 * 3600),
          description:
              'Moderate to high ultraviolet radiation expected around mid-day. Protective eyewear and hydration recommended.',
        ),
      ],
    );
  }
}
