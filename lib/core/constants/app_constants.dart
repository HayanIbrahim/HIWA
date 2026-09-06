class AppConstants {
  static const String appName = 'HiWeather';

  // Hive Box Names
  static const String weatherBoxName = 'weather_cache_box';
  static const String locationsBoxName = 'saved_locations_box';
  static const String settingsBoxName = 'app_settings_box';

  // Settings Keys
  static const String keyThemeMode = 'settings_theme_mode';
  static const String keyLocale = 'settings_locale';
  static const String keyUnits = 'settings_units';

  // Cache duration in minutes
  static const int cacheDurationMinutes = 30;

  // Default Fallback Coordinates (Cairo, Egypt)
  static const double defaultLatitude = 30.0444;
  static const double defaultLongitude = 31.2357;
  static const String defaultCityName = 'Cairo';
  static const String defaultCountryName = 'Egypt';
}
