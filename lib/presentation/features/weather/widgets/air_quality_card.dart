import 'package:flutter/material.dart';
import '../../../../domain/entities/weather_entity.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../common_widgets/glass_card.dart';

class AirQualityCard extends StatelessWidget {
  final WeatherEntity weather;

  const AirQualityCard({
    super.key,
    required this.weather,
  });

  // Calculate approximate AQI based on visibility and humidity
  int _calculateAqi(WeatherEntity weather) {
    if (weather.visibility >= 10000) {
      return 28; // Good
    } else if (weather.visibility >= 8000) {
      return 62; // Moderate
    } else if (weather.visibility >= 5000) {
      return 112; // Unhealthy for sensitive
    } else if (weather.visibility >= 2000) {
      return 165; // Unhealthy
    } else {
      return 240; // Very Unhealthy
    }
  }

  Color _getAqiColor(int aqi) {
    if (aqi <= 50) return const Color(0xFF10B981); // Emerald
    if (aqi <= 100) return const Color(0xFFF59E0B); // Amber
    if (aqi <= 150) return const Color(0xFFFB923C); // Orange
    if (aqi <= 200) return const Color(0xFFEF4444); // Red
    if (aqi <= 300) return const Color(0xFF8B5CF6); // Purple
    return const Color(0xFF881337); // Maroon
  }

  String _getAqiLabel(int aqi, AppLocalizations? l10n) {
    if (aqi <= 50) return l10n?.airQualityGood ?? 'Good';
    if (aqi <= 100) return l10n?.airQualityModerate ?? 'Moderate';
    if (aqi <= 150) return l10n?.airQualityUnhealthySensitive ?? 'Unhealthy for Sensitive';
    if (aqi <= 200) return l10n?.airQualityUnhealthy ?? 'Unhealthy';
    if (aqi <= 300) return l10n?.airQualityVeryUnhealthy ?? 'Very Unhealthy';
    return l10n?.airQualityHazardous ?? 'Hazardous';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final aqi = _calculateAqi(weather);
    final aqiColor = _getAqiColor(aqi);
    final aqiLabel = _getAqiLabel(aqi, l10n);

    // Simulated pollutants
    final pm25 = (aqi * 0.28).toStringAsFixed(1);
    final pm10 = (aqi * 0.45).toStringAsFixed(1);
    final o3 = (aqi * 0.35).toStringAsFixed(1);
    final no2 = (aqi * 0.18).toStringAsFixed(1);

    return GlassCard(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.masks_rounded, size: 18, color: Color(0xFF10B981)),
                  const SizedBox(width: 8),
                  Text(
                    l10n?.airQuality ?? 'Air Quality',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: aqiColor.withOpacity(0.20),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: aqiColor.withOpacity(0.4)),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 7,
                      height: 7,
                      decoration: BoxDecoration(
                        color: aqiColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '$aqi • $aqiLabel',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: aqiColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Multi-color Spectrum Progress Bar
          LayoutBuilder(
            builder: (context, constraints) {
              final progress = (aqi / 250.0).clamp(0.0, 1.0);
              final indicatorX = (constraints.maxWidth * progress - 5).clamp(0.0, constraints.maxWidth - 10);

              return Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    height: 8,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFF10B981), // Good
                          Color(0xFFF59E0B), // Moderate
                          Color(0xFFFB923C), // Sensitive
                          Color(0xFFEF4444), // Unhealthy
                          Color(0xFF8B5CF6), // Hazardous
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    left: indicatorX,
                    top: -1,
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.black45, width: 1.5),
                        boxShadow: const [
                          BoxShadow(color: Colors.black26, blurRadius: 4, spreadRadius: 1),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),

          const SizedBox(height: 16),

          // Pollutant Metrics Chips
          Row(
            children: [
              Expanded(child: _buildPollutantChip('PM2.5', pm25, 'µg/m³')),
              const SizedBox(width: 8),
              Expanded(child: _buildPollutantChip('PM10', pm10, 'µg/m³')),
              const SizedBox(width: 8),
              Expanded(child: _buildPollutantChip('O3', o3, 'ppb')),
              const SizedBox(width: 8),
              Expanded(child: _buildPollutantChip('NO2', no2, 'ppb')),
            ],
          ),

          const SizedBox(height: 14),

          // Health Recommendation Highlights
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.16),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(
                  aqi <= 50 ? Icons.check_circle_outline_rounded : Icons.info_outline_rounded,
                  size: 16,
                  color: aqiColor,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    aqi <= 50
                        ? 'Air quality is ideal for outdoor activities, sports, and window ventilation.'
                        : 'Air quality is acceptable; however, very sensitive individuals should limit prolonged exertion.',
                    style: TextStyle(
                      fontSize: 11,
                      height: 1.3,
                      color: Colors.white.withOpacity(0.85),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPollutantChip(String name, String value, String unit) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.06),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text(
            name,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: Colors.white.withOpacity(0.6),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Text(
            unit,
            style: TextStyle(
              fontSize: 8,
              color: Colors.white.withOpacity(0.5),
            ),
          ),
        ],
      ),
    );
  }
}
