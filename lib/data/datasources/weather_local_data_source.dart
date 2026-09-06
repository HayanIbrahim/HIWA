import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import '../../core/error/exceptions.dart';
import '../models/one_call_response_dto.dart';

abstract class WeatherLocalDataSource {
  Future<void> cacheWeather({
    required double lat,
    required double lon,
    required OneCallResponseDto weatherDto,
  });

  Future<OneCallResponseDto?> getCachedWeather({
    required double lat,
    required double lon,
  });

  Future<DateTime?> getCacheTimestamp({
    required double lat,
    required double lon,
  });
}

class WeatherLocalDataSourceImpl implements WeatherLocalDataSource {
  final Box weatherBox;

  WeatherLocalDataSourceImpl({required this.weatherBox});

  String _cacheKey(double lat, double lon) =>
      'weather_${lat.toStringAsFixed(2)}_${lon.toStringAsFixed(2)}';

  String _timestampKey(double lat, double lon) =>
      'timestamp_${lat.toStringAsFixed(2)}_${lon.toStringAsFixed(2)}';

  @override
  Future<void> cacheWeather({
    required double lat,
    required double lon,
    required OneCallResponseDto weatherDto,
  }) async {
    try {
      final key = _cacheKey(lat, lon);
      final jsonStr = jsonEncode(weatherDto.toJson());
      await weatherBox.put(key, jsonStr);
      await weatherBox.put(_timestampKey(lat, lon), DateTime.now().toIso8601String());
    } catch (e) {
      throw CacheException(message: 'Failed to write weather to Hive cache: $e');
    }
  }

  @override
  Future<OneCallResponseDto?> getCachedWeather({
    required double lat,
    required double lon,
  }) async {
    try {
      final key = _cacheKey(lat, lon);
      final jsonStr = weatherBox.get(key) as String?;
      if (jsonStr == null) return null;

      final map = jsonDecode(jsonStr) as Map<String, dynamic>;
      return OneCallResponseDto.fromJson(map);
    } catch (e) {
      throw CacheException(message: 'Failed to read weather from Hive cache: $e');
    }
  }

  @override
  Future<DateTime?> getCacheTimestamp({
    required double lat,
    required double lon,
  }) async {
    final str = weatherBox.get(_timestampKey(lat, lon)) as String?;
    if (str != null) {
      return DateTime.tryParse(str);
    }
    return null;
  }
}
