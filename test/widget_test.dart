import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hi_weather_app/core/utils/unit_converter.dart';
import 'package:hi_weather_app/domain/entities/daily_forecast_entity.dart';
import 'package:hi_weather_app/domain/entities/hourly_forecast_entity.dart';
import 'package:hi_weather_app/domain/entities/weather_entity.dart';
import 'package:hi_weather_app/l10n/generated/app_localizations.dart';
import 'package:hi_weather_app/presentation/common_widgets/glass_card.dart';
import 'package:hi_weather_app/presentation/features/weather/widgets/air_quality_card.dart';
import 'package:hi_weather_app/presentation/features/weather/widgets/current_weather_card.dart';
import 'package:hi_weather_app/presentation/features/weather/widgets/daily_forecast_list.dart';
import 'package:hi_weather_app/presentation/features/weather/widgets/hourly_forecast_strip.dart';
import 'package:hi_weather_app/presentation/features/weather/widgets/sun_moon_arc_widget.dart';
import 'package:hi_weather_app/presentation/features/weather/widgets/weather_metrics_grid.dart';
import 'package:hi_weather_app/presentation/features/weather/widgets/wind_compass_widget.dart';
import 'package:hi_weather_app/presentation/shell/widgets/floating_glass_nav_bar.dart';

void main() {
  testWidgets('CurrentWeatherCard renders city and temperature', (WidgetTester tester) async {
    const testWeather = WeatherEntity(
      temp: 24.5,
      feelsLike: 25.0,
      tempMin: 20.0,
      tempMax: 28.0,
      pressure: 1013,
      humidity: 50,
      dewPoint: 14.0,
      uvi: 5.0,
      clouds: 10,
      visibility: 10000,
      windSpeed: 4.5,
      windDeg: 180,
      weatherId: 800,
      condition: 'Clear',
      description: 'Clear sky',
      iconCode: '01d',
      dt: 1700000000,
      cityName: 'Cairo',
      countryName: 'Egypt',
    );

    await tester.pumpWidget(
      const MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: Locale('en'),
        home: Scaffold(
          body: CurrentWeatherCard(
            weather: testWeather,
            unitSystem: UnitSystem.metric,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Cairo'), findsOneWidget);
    expect(find.text('25°'), findsOneWidget);
    expect(find.text('CLEAR SKY'), findsOneWidget);
  });

  testWidgets('GlassCard renders child widget properly', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: GlassCard(
            child: Text('Glass Card Content'),
          ),
        ),
      ),
    );

    expect(find.text('Glass Card Content'), findsOneWidget);
  });

  testWidgets('AirQualityCard renders AQI and metrics chips', (WidgetTester tester) async {
    const testWeather = WeatherEntity(
      temp: 24.5,
      feelsLike: 25.0,
      tempMin: 20.0,
      tempMax: 28.0,
      pressure: 1013,
      humidity: 50,
      dewPoint: 14.0,
      uvi: 5.0,
      clouds: 10,
      visibility: 10000,
      windSpeed: 4.5,
      windDeg: 180,
      weatherId: 800,
      condition: 'Clear',
      description: 'Clear sky',
      iconCode: '01d',
      dt: 1700000000,
      cityName: 'Cairo',
      countryName: 'Egypt',
    );

    await tester.pumpWidget(
      const MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: Locale('en'),
        home: Scaffold(
          body: AirQualityCard(weather: testWeather),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Air Quality'), findsOneWidget);
    expect(find.text('PM2.5'), findsOneWidget);
    expect(find.text('PM10'), findsOneWidget);
  });

  testWidgets('WindCompassWidget renders compass and wind metrics', (WidgetTester tester) async {
    const testWeather = WeatherEntity(
      temp: 24.5,
      feelsLike: 25.0,
      tempMin: 20.0,
      tempMax: 28.0,
      pressure: 1013,
      humidity: 50,
      dewPoint: 14.0,
      uvi: 5.0,
      clouds: 10,
      visibility: 10000,
      windSpeed: 6.2,
      windDeg: 180,
      weatherId: 800,
      condition: 'Clear',
      description: 'Clear sky',
      iconCode: '01d',
      dt: 1700000000,
      cityName: 'Cairo',
      countryName: 'Egypt',
    );

    await tester.pumpWidget(
      const MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: Locale('en'),
        home: Scaffold(
          body: WindCompassWidget(
            weather: testWeather,
            unitSystem: UnitSystem.metric,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Wind & Direction'), findsOneWidget);
    expect(find.text('Moderate Breeze'), findsOneWidget);
    expect(find.text('S (180°)'), findsOneWidget);
  });

  testWidgets('HourlyForecastStrip toggles between Cards and Chart views', (WidgetTester tester) async {
    final hourly = [
      const HourlyForecastEntity(
        dt: 1700000000,
        temp: 24.0,
        feelsLike: 24.5,
        pressure: 1013,
        humidity: 50,
        pop: 0.2,
        weatherId: 800,
        condition: 'Clear',
        description: 'Clear sky',
        iconCode: '01d',
      ),
      const HourlyForecastEntity(
        dt: 1700003600,
        temp: 25.0,
        feelsLike: 25.5,
        pressure: 1013,
        humidity: 48,
        pop: 0.1,
        weatherId: 800,
        condition: 'Clear',
        description: 'Clear sky',
        iconCode: '01d',
      ),
    ];

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('en'),
        home: Scaffold(
          body: HourlyForecastStrip(
            hourlyForecasts: hourly,
            unitSystem: UnitSystem.metric,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('48-Hour Forecast'), findsOneWidget);
    expect(find.text('Cards'), findsOneWidget);
    expect(find.text('Trend Chart'), findsOneWidget);

    // Tap Chart toggle
    await tester.tap(find.text('Trend Chart'));
    await tester.pumpAndSettle();

    // Verify chart mode is activated
    expect(find.byType(CustomPaint), findsWidgets);
  });

  testWidgets('DailyForecastList expands on tap', (WidgetTester tester) async {
    final daily = [
      const DailyForecastEntity(
        dt: 1700000000,
        sunrise: 1700020000,
        sunset: 1700060000,
        tempDay: 26.0,
        tempNight: 18.0,
        tempMin: 17.0,
        tempMax: 27.0,
        pressure: 1013,
        humidity: 45,
        windSpeed: 4.2,
        pop: 0.15,
        uvi: 6.0,
        summary: 'Sunny day with gentle breezes',
        weatherId: 800,
        condition: 'Clear',
        description: 'Clear sky',
        iconCode: '01d',
      ),
    ];

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('en'),
        home: Scaffold(
          body: DailyForecastList(
            dailyForecasts: daily,
            unitSystem: UnitSystem.metric,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('8-Day Forecast'), findsOneWidget);

    // Tap the item to expand
    await tester.tap(find.byType(InkWell).first);
    await tester.pumpAndSettle();

    expect(find.text('Sunny day with gentle breezes'), findsOneWidget);
    expect(find.text('Humidity'), findsOneWidget);
  });

  testWidgets('SunMoonArcWidget renders celestial arc, sunrise, and sunset', (WidgetTester tester) async {
    const testWeather = WeatherEntity(
      temp: 24.5,
      feelsLike: 25.0,
      tempMin: 20.0,
      tempMax: 28.0,
      pressure: 1013,
      humidity: 50,
      dewPoint: 14.0,
      uvi: 5.0,
      clouds: 10,
      visibility: 10000,
      windSpeed: 4.5,
      windDeg: 180,
      weatherId: 800,
      condition: 'Clear',
      description: 'Clear sky',
      iconCode: '01d',
      dt: 1700030000,
      sunrise: 1700020000,
      sunset: 1700060000,
      cityName: 'Cairo',
      countryName: 'Egypt',
    );

    final daily = [
      const DailyForecastEntity(
        dt: 1700000000,
        sunrise: 1700020000,
        sunset: 1700060000,
        tempDay: 26.0,
        tempNight: 18.0,
        tempMin: 17.0,
        tempMax: 27.0,
        pressure: 1013,
        humidity: 45,
        windSpeed: 4.2,
        pop: 0.15,
        uvi: 6.0,
        summary: 'Sunny',
        weatherId: 800,
        condition: 'Clear',
        description: 'Clear sky',
        iconCode: '01d',
      ),
    ];

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('en'),
        home: Scaffold(
          body: SunMoonArcWidget(
            weather: testWeather,
            dailyForecasts: daily,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Sun & Moon'), findsOneWidget);
    expect(find.text('Sunrise'), findsOneWidget);
    expect(find.text('Sunset'), findsOneWidget);
  });

  testWidgets('WeatherMetricsGrid opens detail modal on tap', (WidgetTester tester) async {
    const testWeather = WeatherEntity(
      temp: 24.5,
      feelsLike: 25.0,
      tempMin: 20.0,
      tempMax: 28.0,
      pressure: 1013,
      humidity: 50,
      dewPoint: 14.0,
      uvi: 7.5,
      clouds: 15,
      visibility: 10000,
      windSpeed: 5.5,
      windDeg: 210,
      weatherId: 800,
      condition: 'Clear',
      description: 'Clear sky',
      iconCode: '01d',
      dt: 1700000000,
      sunrise: 1700020000,
      sunset: 1700060000,
      cityName: 'Cairo',
      countryName: 'Egypt',
    );

    await tester.pumpWidget(
      const MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: Locale('en'),
        home: Scaffold(
          body: SingleChildScrollView(
            child: WeatherMetricsGrid(
              weather: testWeather,
              unitSystem: UnitSystem.metric,
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Verify UV Index card is present
    expect(find.text('UV INDEX'), findsOneWidget);
    expect(find.text('7.5'), findsOneWidget);

    // Tap the UV Index card
    await tester.tap(find.text('UV INDEX'));
    await tester.pumpAndSettle();

    // Verify modal bottom sheet opened with detailed advice
    expect(find.text('The UV Index measures the strength of sunburn-producing ultraviolet radiation at solar noon.'), findsOneWidget);
  });

  testWidgets('FloatingGlassNavBar renders items and responds to tap', (WidgetTester tester) async {
    int tappedIndex = -1;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          bottomNavigationBar: FloatingGlassNavBar(
            currentIndex: 0,
            onTap: (index) {
              tappedIndex = index;
            },
            items: const [
              FloatingNavItem(icon: Icons.wb_sunny_outlined, activeIcon: Icons.wb_sunny_rounded, label: 'Weather'),
              FloatingNavItem(icon: Icons.radar_outlined, activeIcon: Icons.radar_rounded, label: 'Radar'),
              FloatingNavItem(icon: Icons.bookmark_border_rounded, activeIcon: Icons.bookmark_rounded, label: 'Locations'),
              FloatingNavItem(icon: Icons.tune_rounded, activeIcon: Icons.tune_rounded, label: 'Settings'),
            ],
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Weather'), findsOneWidget);
    expect(find.text('Radar'), findsOneWidget);
    expect(find.text('Locations'), findsOneWidget);
    expect(find.text('Settings'), findsOneWidget);

    // Tap Radar
    await tester.tap(find.text('Radar'));
    await tester.pumpAndSettle();

    expect(tappedIndex, 1);
  });
}
