// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'HiWeather';

  @override
  String get navWeather => 'Weather';

  @override
  String get navRadar => 'Radar';

  @override
  String get navLocations => 'Locations';

  @override
  String get navSettings => 'Settings';

  @override
  String get currentWeather => 'Current Weather';

  @override
  String feelsLike(String temp) {
    return 'Feels like $temp';
  }

  @override
  String highLow(String high, String low) {
    return 'H: $high  L: $low';
  }

  @override
  String get hourlyForecast => '48-Hour Forecast';

  @override
  String get dailyForecast => '8-Day Forecast';

  @override
  String get weatherAlerts => 'Weather Alerts';

  @override
  String get rainChance => 'Chance of Rain';

  @override
  String get noAlerts => 'No active weather alerts';

  @override
  String get humidity => 'Humidity';

  @override
  String get windSpeed => 'Wind Speed';

  @override
  String get pressure => 'Pressure';

  @override
  String get uvIndex => 'UV Index';

  @override
  String get visibility => 'Visibility';

  @override
  String get dewPoint => 'Dew Point';

  @override
  String get sunrise => 'Sunrise';

  @override
  String get sunset => 'Sunset';

  @override
  String get searchLocationHint => 'Search city or region...';

  @override
  String get savedLocations => 'Saved Locations';

  @override
  String get noSavedLocations =>
      'No saved locations yet. Search and tap bookmark to add one.';

  @override
  String get useCurrentLocation => 'Use Current Location';

  @override
  String get locationPermissionDenied =>
      'Location permission was denied. Please enable it in Settings.';

  @override
  String get locationServicesDisabled =>
      'Location services are disabled on your device.';

  @override
  String get radarLayers => 'Radar Layers';

  @override
  String get layerPrecipitation => 'Precipitation';

  @override
  String get layerTemperature => 'Temperature';

  @override
  String get layerWind => 'Wind Speed';

  @override
  String get layerClouds => 'Clouds';

  @override
  String get settings => 'Settings';

  @override
  String get appearance => 'Appearance';

  @override
  String get themeSystem => 'System Default';

  @override
  String get themeLight => 'Light Mode';

  @override
  String get themeDark => 'Dark Mode';

  @override
  String get language => 'Language';

  @override
  String get languageEn => 'English';

  @override
  String get languageAr => 'العربية';

  @override
  String get units => 'Units of Measurement';

  @override
  String get unitMetric => 'Metric (°C, m/s)';

  @override
  String get unitImperial => 'Imperial (°F, mph)';

  @override
  String get offlineNotice => 'Showing cached weather data';

  @override
  String get retry => 'Retry';

  @override
  String get errorOccurred => 'An error occurred while loading weather data.';

  @override
  String get pullToRefresh => 'Pull down to refresh';
}
