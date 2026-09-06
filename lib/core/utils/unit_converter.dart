enum UnitSystem { metric, imperial }

class UnitConverter {
  static String formatTemperature(double temp, UnitSystem system) {
    if (system == UnitSystem.imperial) {
      // If imperial, convert Celsius to Fahrenheit
      final fahrenheit = (temp * 9 / 5) + 32;
      return '${fahrenheit.round()}°';
    }
    return '${temp.round()}°';
  }

  static String formatWindSpeed(double speedMps, UnitSystem system) {
    if (system == UnitSystem.imperial) {
      final mph = speedMps * 2.23694;
      return '${mph.toStringAsFixed(1)} mph';
    }
    final kmh = speedMps * 3.6;
    return '${kmh.toStringAsFixed(1)} km/h';
  }

  static String formatPressure(int hPa) {
    return '$hPa hPa';
  }

  static String formatHumidity(int humidity) {
    return '$humidity%';
  }

  static String formatVisibility(int meters, UnitSystem system) {
    if (system == UnitSystem.imperial) {
      final miles = meters / 1609.34;
      return '${miles.toStringAsFixed(1)} mi';
    }
    final km = meters / 1000.0;
    return '${km.toStringAsFixed(1)} km';
  }
}
