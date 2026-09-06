import 'package:flutter/material.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../core/utils/unit_converter.dart';
import '../../../../core/utils/weather_mapper.dart';
import '../../../../domain/entities/daily_forecast_entity.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../common_widgets/glass_card.dart';

class DailyForecastList extends StatelessWidget {
  final List<DailyForecastEntity> dailyForecasts;
  final UnitSystem unitSystem;

  const DailyForecastList({
    super.key,
    required this.dailyForecasts,
    required this.unitSystem,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).languageCode;

    // Find global min and max for temperature bar normalization
    double globalMin = 100.0;
    double globalMax = -100.0;
    for (var d in dailyForecasts) {
      if (d.tempMin < globalMin) globalMin = d.tempMin;
      if (d.tempMax > globalMax) globalMax = d.tempMax;
    }
    final range = (globalMax - globalMin).clamp(1.0, 50.0);

    return GlassCard(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.calendar_month_rounded, size: 18, color: Colors.white70),
              const SizedBox(width: 8),
              Text(
                l10n?.dailyForecast ?? '8-Day Forecast',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: dailyForecasts.length,
            separatorBuilder: (_, _) => Divider(
              height: 16,
              color: Colors.white.withOpacity(0.08),
            ),
            itemBuilder: (context, index) {
              final day = dailyForecasts[index];
              final weatherType = WeatherMapper.getWeatherType(day.iconCode, day.weatherId);
              final iconData = WeatherMapper.getIconData(weatherType);
              final conditionColor = WeatherMapper.getConditionColor(weatherType);

              final weekday = AppDateFormatter.formatWeekday(day.dt, locale: locale);
              final minTemp = UnitConverter.formatTemperature(day.tempMin, unitSystem);
              final maxTemp = UnitConverter.formatTemperature(day.tempMax, unitSystem);

              // Relative bar proportions
              final leftFraction = ((day.tempMin - globalMin) / range).clamp(0.0, 0.7);
              final barWidthFraction = ((day.tempMax - day.tempMin) / range).clamp(0.15, 0.8);

              return Row(
                children: [
                  // Weekday Name
                  SizedBox(
                    width: 70,
                    child: Text(
                      weekday,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),

                  // Icon & Pop
                  SizedBox(
                    width: 44,
                    child: Row(
                      children: [
                        Icon(iconData, size: 20, color: conditionColor),
                        if (day.pop > 0.1) ...[
                          const SizedBox(width: 2),
                          Text(
                            '${(day.pop * 100).round()}%',
                            style: const TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF38BDF8),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),

                  const SizedBox(width: 8),

                  // Min Temp
                  SizedBox(
                    width: 32,
                    child: Text(
                      minTemp,
                      textAlign: TextAlign.end,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.white.withOpacity(0.65),
                      ),
                    ),
                  ),

                  const SizedBox(width: 10),

                  // Temperature Gradient Range Bar
                  Expanded(
                    child: Container(
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          final totalWidth = constraints.maxWidth;
                          final leftMargin = totalWidth * leftFraction;
                          final barWidth = totalWidth * barWidthFraction;

                          return Stack(
                            children: [
                              Positioned(
                                left: leftMargin,
                                width: barWidth.clamp(12.0, totalWidth),
                                top: 0,
                                bottom: 0,
                                child: Container(
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [
                                        Color(0xFF38BDF8), // Cyan
                                        Color(0xFFF59E0B), // Amber
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),

                  const SizedBox(width: 10),

                  // Max Temp
                  SizedBox(
                    width: 32,
                    child: Text(
                      maxTemp,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
