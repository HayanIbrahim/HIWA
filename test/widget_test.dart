import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hi_weather_app/core/utils/unit_converter.dart';
import 'package:hi_weather_app/domain/entities/weather_entity.dart';
import 'package:hi_weather_app/l10n/generated/app_localizations.dart';
import 'package:hi_weather_app/presentation/common_widgets/glass_card.dart';
import 'package:hi_weather_app/presentation/features/weather/widgets/current_weather_card.dart';

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
}
