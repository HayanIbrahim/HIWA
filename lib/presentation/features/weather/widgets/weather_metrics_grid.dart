import 'package:flutter/material.dart';
import '../../../../core/utils/unit_converter.dart';
import '../../../../domain/entities/weather_entity.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../common_widgets/glass_card.dart';

class WeatherMetricsGrid extends StatelessWidget {
  final WeatherEntity weather;
  final UnitSystem unitSystem;

  const WeatherMetricsGrid({
    super.key,
    required this.weather,
    required this.unitSystem,
  });

  String _getUvDescription(double uvi) {
    if (uvi <= 2) return 'Low';
    if (uvi <= 5) return 'Moderate';
    if (uvi <= 7) return 'High';
    if (uvi <= 10) return 'Very High';
    return 'Extreme';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    final windStr = UnitConverter.formatWindSpeed(weather.windSpeed, unitSystem);
    final pressureStr = UnitConverter.formatPressure(weather.pressure);
    final humidityStr = UnitConverter.formatHumidity(weather.humidity);
    final visibilityStr = UnitConverter.formatVisibility(weather.visibility, unitSystem);
    final uvLevel = _getUvDescription(weather.uvi);

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 14,
      mainAxisSpacing: 14,
      childAspectRatio: 1.28,
      children: [
        // UV Index
        _buildMetricCard(
          icon: Icons.wb_sunny_outlined,
          iconColor: Colors.amberAccent,
          title: l10n?.uvIndex ?? 'UV INDEX',
          value: weather.uvi.toStringAsFixed(1),
          subtitle: uvLevel,
        ),

        // Wind Speed & Direction
        _buildMetricCard(
          icon: Icons.air_rounded,
          iconColor: const Color(0xFF38BDF8),
          title: l10n?.windSpeed ?? 'WIND',
          value: windStr,
          subtitle: '${weather.windDeg}° Direction',
        ),

        // Humidity
        _buildMetricCard(
          icon: Icons.water_drop_outlined,
          iconColor: const Color(0xFF60A5FA),
          title: l10n?.humidity ?? 'HUMIDITY',
          value: humidityStr,
          subtitle: 'The dew point is ${weather.dewPoint.round()}°',
        ),

        // Pressure
        _buildMetricCard(
          icon: Icons.speed_rounded,
          iconColor: const Color(0xFFA78BFA),
          title: l10n?.pressure ?? 'PRESSURE',
          value: pressureStr,
          subtitle: 'Standard sea-level',
        ),

        // Visibility
        _buildMetricCard(
          icon: Icons.visibility_outlined,
          iconColor: const Color(0xFF34D399),
          title: l10n?.visibility ?? 'VISIBILITY',
          value: visibilityStr,
          subtitle: weather.visibility >= 10000 ? 'Clear view' : 'Reduced view',
        ),

        // Cloud Cover
        _buildMetricCard(
          icon: Icons.cloud_queue_rounded,
          iconColor: const Color(0xFFCBD5E1),
          title: 'CLOUDS',
          value: '${weather.clouds}%',
          subtitle: 'Total sky coverage',
        ),
      ],
    );
  }

  Widget _buildMetricCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String value,
    required String subtitle,
  }) {
    return GlassCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: iconColor),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title.toUpperCase(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.8,
                    color: Colors.white.withOpacity(0.7),
                  ),
                ),
              ),
            ],
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Text(
            subtitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w400,
              color: Colors.white.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }
}
