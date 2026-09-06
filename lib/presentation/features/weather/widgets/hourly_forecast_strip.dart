import 'package:flutter/material.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../core/utils/unit_converter.dart';
import '../../../../core/utils/weather_mapper.dart';
import '../../../../domain/entities/hourly_forecast_entity.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../common_widgets/glass_card.dart';

class HourlyForecastStrip extends StatelessWidget {
  final List<HourlyForecastEntity> hourlyForecasts;
  final UnitSystem unitSystem;

  const HourlyForecastStrip({
    super.key,
    required this.hourlyForecasts,
    required this.unitSystem,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).languageCode;

    return GlassCard(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                const Icon(Icons.schedule_rounded, size: 18, color: Colors.white70),
                const SizedBox(width: 8),
                Text(
                  l10n?.hourlyForecast ?? '48-Hour Forecast',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            height: 116,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              itemCount: hourlyForecasts.length,
              separatorBuilder: (_, _) => const SizedBox(width: 14),
              itemBuilder: (context, index) {
                final item = hourlyForecasts[index];
                final weatherType = WeatherMapper.getWeatherType(item.iconCode, item.weatherId);
                final iconData = WeatherMapper.getIconData(weatherType);
                final conditionColor = WeatherMapper.getConditionColor(weatherType);
                final temp = UnitConverter.formatTemperature(item.temp, unitSystem);
                final hourStr = index == 0
                    ? (locale == 'ar' ? 'الآن' : 'Now')
                    : AppDateFormatter.formatHour(item.dt, locale: locale);

                return Container(
                  width: 66,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: index == 0 ? Colors.white.withOpacity(0.15) : Colors.transparent,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Hour
                      Text(
                        hourStr,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: index == 0 ? FontWeight.bold : FontWeight.w500,
                          color: Colors.white.withOpacity(0.85),
                        ),
                      ),

                      // Icon & Pop
                      Column(
                        children: [
                          Icon(iconData, size: 26, color: conditionColor),
                          if (item.pop > 0.05) ...[
                            const SizedBox(height: 2),
                            Text(
                              '${(item.pop * 100).round()}%',
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF38BDF8),
                              ),
                            ),
                          ],
                        ],
                      ),

                      // Temperature
                      Text(
                        temp,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
