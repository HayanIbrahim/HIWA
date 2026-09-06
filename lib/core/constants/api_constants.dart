class ApiConstants {
  static const String defaultBaseUrl = 'https://api.openweathermap.org';
  static const String oneCallEndpoint = '/data/3.0/onecall';
  static const String oneCall25Endpoint = '/data/2.5/onecall';
  static const String weatherEndpoint = '/data/2.5/weather';
  static const String forecastEndpoint = '/data/2.5/forecast';
  static const String geoDirectEndpoint = '/geo/1.0/direct';
  static const String geoReverseEndpoint = '/geo/1.0/reverse';

  // OpenWeatherMap Tile Layer URL template
  // Options: precipitation_new, clouds_new, temp_new, wind_new, pressure_new
  static String tileUrl({
    required String layer,
    required int z,
    required int x,
    required int y,
    required String apiKey,
  }) {
    return 'https://tile.openweathermap.org/map/$layer/$z/$x/$y.png?appid=$apiKey';
  }

  // OpenWeather Condition Icon URL
  static String iconUrl(String iconCode, {bool is2x = true}) {
    final scale = is2x ? '@2x' : '';
    return 'https://openweathermap.org/img/wn/$iconCode$scale.png';
  }
}

class MapTileLayers {
  static const String precipitation = 'precipitation_new';
  static const String clouds = 'clouds_new';
  static const String temperature = 'temp_new';
  static const String wind = 'wind_new';
  static const String pressure = 'pressure_new';

  static const List<String> all = [
    precipitation,
    clouds,
    temperature,
    wind,
    pressure,
  ];
}
