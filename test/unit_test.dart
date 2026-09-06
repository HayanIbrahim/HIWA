import 'package:flutter_test/flutter_test.dart';
import 'package:hi_weather_app/core/utils/unit_converter.dart';
import 'package:hi_weather_app/core/utils/weather_mapper.dart';
import 'package:hi_weather_app/data/fixtures/weather_mock_data.dart';

void main() {
  group('UnitConverter Tests', () {
    test('formatTemperature converts Celsius and Fahrenheit correctly', () {
      expect(UnitConverter.formatTemperature(25.0, UnitSystem.metric), '25°');
      expect(UnitConverter.formatTemperature(25.0, UnitSystem.imperial), '77°');
    });

    test('formatWindSpeed converts metric m/s and imperial mph correctly', () {
      expect(UnitConverter.formatWindSpeed(10.0, UnitSystem.metric), '36.0 km/h');
      expect(UnitConverter.formatWindSpeed(10.0, UnitSystem.imperial), '22.4 mph');
    });

    test('formatPressure formats hPa correctly', () {
      expect(UnitConverter.formatPressure(1013), '1013 hPa');
    });

    test('formatHumidity formats percentage correctly', () {
      expect(UnitConverter.formatHumidity(65), '65%');
    });
  });

  group('WeatherMapper Tests', () {
    test('maps thunderstorm weather id 200 to thunderstorm', () {
      final type = WeatherMapper.getWeatherType('11d', 200);
      expect(type, WeatherType.thunderstorm);
    });

    test('maps rain weather id 500 to rain', () {
      final type = WeatherMapper.getWeatherType('10d', 500);
      expect(type, WeatherType.rain);
    });

    test('maps clear sky 800 with night icon to clearNight', () {
      final type = WeatherMapper.getWeatherType('01n', 800);
      expect(type, WeatherType.clearNight);
    });

    test('maps clear sky 800 with day icon to clearDay', () {
      final type = WeatherMapper.getWeatherType('01d', 800);
      expect(type, WeatherType.clearDay);
    });
  });

  group('WeatherMockData Tests', () {
    test('generates valid mock data with 48 hourly and 8 daily items', () {
      final mock = WeatherMockData.getMockOneCallData(
        lat: 30.0444,
        lon: 31.2357,
        cityName: 'Cairo',
      );

      final domain = mock.toDomain(cityName: 'Cairo', countryName: 'Egypt');

      expect(domain.current.cityName, 'Cairo');
      expect(domain.hourly.length, 48);
      expect(domain.daily.length, 8);
      expect(domain.alerts.isNotEmpty, true);
      expect(domain.minutely.length, 60);
    });
  });
}
