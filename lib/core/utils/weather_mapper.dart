import 'package:flutter/material.dart';

enum WeatherType {
  clearDay,
  clearNight,
  cloudy,
  rain,
  thunderstorm,
  snow,
  mist,
}

class WeatherMapper {
  static WeatherType getWeatherType(String iconCode, int weatherId) {
    final isNight = iconCode.endsWith('n');

    if (weatherId >= 200 && weatherId < 300) {
      return WeatherType.thunderstorm;
    } else if (weatherId >= 300 && weatherId < 600) {
      return WeatherType.rain;
    } else if (weatherId >= 600 && weatherId < 700) {
      return WeatherType.snow;
    } else if (weatherId >= 700 && weatherId < 800) {
      return WeatherType.mist;
    } else if (weatherId == 800) {
      return isNight ? WeatherType.clearNight : WeatherType.clearDay;
    } else {
      return WeatherType.cloudy;
    }
  }

  static IconData getIconData(WeatherType type) {
    switch (type) {
      case WeatherType.clearDay:
        return Icons.wb_sunny_rounded;
      case WeatherType.clearNight:
        return Icons.nightlight_round;
      case WeatherType.cloudy:
        return Icons.cloud_rounded;
      case WeatherType.rain:
        return Icons.water_drop_rounded;
      case WeatherType.thunderstorm:
        return Icons.thunderstorm_rounded;
      case WeatherType.snow:
        return Icons.ac_unit_rounded;
      case WeatherType.mist:
        return Icons.blur_on_rounded;
    }
  }

  static Color getConditionColor(WeatherType type) {
    switch (type) {
      case WeatherType.clearDay:
        return const Color(0xFFF59E0B);
      case WeatherType.clearNight:
        return const Color(0xFF818CF8);
      case WeatherType.cloudy:
        return const Color(0xFF94A3B8);
      case WeatherType.rain:
        return const Color(0xFF38BDF8);
      case WeatherType.thunderstorm:
        return const Color(0xFFA855F7);
      case WeatherType.snow:
        return const Color(0xFFBAE6FD);
      case WeatherType.mist:
        return const Color(0xFFCBD5E1);
    }
  }
}
