import 'package:flutter/material.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../core/utils/unit_converter.dart';
import '../../../../core/utils/weather_mapper.dart';
import '../../../../domain/entities/daily_forecast_entity.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../common_widgets/glass_card.dart';

class DailyForecastList extends StatefulWidget {
  final List<DailyForecastEntity> dailyForecasts;
  final UnitSystem unitSystem;

  const DailyForecastList({
    super.key,
    required this.dailyForecasts,
    required this.unitSystem,
  });

  @override
  State<DailyForecastList> createState() => _DailyForecastListState();
}

class _DailyForecastListState extends State<DailyForecastList> {
  int? _expandedIndex;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).languageCode;
    final forecasts = widget.dailyForecasts;

    // Find global min and max for temperature bar normalization
    double globalMin = 100.0;
    double globalMax = -100.0;
    for (var d in forecasts) {
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
              Text(
                'Tap to inspect',
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.white.withOpacity(0.5),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: forecasts.length,
            separatorBuilder: (_, _) => Divider(
              height: 14,
              color: Colors.white.withOpacity(0.08),
            ),
            itemBuilder: (context, index) {
              final day = forecasts[index];
              final isExpanded = _expandedIndex == index;
              final weatherType = WeatherMapper.getWeatherType(day.iconCode, day.weatherId);
              final iconData = WeatherMapper.getIconData(weatherType);
              final conditionColor = WeatherMapper.getConditionColor(weatherType);

              final weekday = AppDateFormatter.formatWeekday(day.dt, locale: locale);
              final minTemp = UnitConverter.formatTemperature(day.tempMin, widget.unitSystem);
              final maxTemp = UnitConverter.formatTemperature(day.tempMax, widget.unitSystem);
              final dayTemp = UnitConverter.formatTemperature(day.tempDay, widget.unitSystem);
              final nightTemp = UnitConverter.formatTemperature(day.tempNight, widget.unitSystem);
              final windStr = UnitConverter.formatWindSpeed(day.windSpeed, widget.unitSystem);

              // Relative bar proportions
              final leftFraction = ((day.tempMin - globalMin) / range).clamp(0.0, 0.7);
              final barWidthFraction = ((day.tempMax - day.tempMin) / range).clamp(0.15, 0.8);

              return InkWell(
                onTap: () {
                  setState(() {
                    _expandedIndex = isExpanded ? null : index;
                  });
                },
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Column(
                    children: [
                      // Main Row
                      Row(
                        children: [
                          // Weekday Name
                          SizedBox(
                            width: 68,
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
                            width: 52,
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

                          const SizedBox(width: 6),

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

                          const SizedBox(width: 8),

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

                          const SizedBox(width: 8),

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

                          // Expand Indicator Chevron
                          Icon(
                            isExpanded ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
                            size: 16,
                            color: Colors.white54,
                          ),
                        ],
                      ),

                      // Animated Expandable Detail Sub-Panel
                      AnimatedCrossFade(
                        firstChild: const SizedBox.shrink(),
                        secondChild: Container(
                          margin: const EdgeInsets.only(top: 10),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.22),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.white.withOpacity(0.08)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Summary Text
                              if (day.summary.isNotEmpty) ...[
                                Text(
                                  day.summary,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white.withOpacity(0.9),
                                  ),
                                ),
                                const SizedBox(height: 8),
                              ],

                              // Metrics Row
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  _buildDetailStat(
                                    icon: Icons.wb_sunny_outlined,
                                    label: 'Day',
                                    value: dayTemp,
                                  ),
                                  _buildDetailStat(
                                    icon: Icons.nightlight_outlined,
                                    label: 'Night',
                                    value: nightTemp,
                                  ),
                                  _buildDetailStat(
                                    icon: Icons.water_drop_outlined,
                                    label: 'Humidity',
                                    value: '${day.humidity}%',
                                  ),
                                  _buildDetailStat(
                                    icon: Icons.air_rounded,
                                    label: 'Wind',
                                    value: windStr,
                                  ),
                                  _buildDetailStat(
                                    icon: Icons.wb_iridescent_rounded,
                                    label: 'UV',
                                    value: day.uvi.toStringAsFixed(1),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        crossFadeState: isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                        duration: const Duration(milliseconds: 250),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDetailStat({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Column(
      children: [
        Icon(icon, size: 14, color: Colors.white60),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.w600,
            color: Colors.white.withOpacity(0.55),
          ),
        ),
        const SizedBox(height: 1),
        Text(
          value,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
