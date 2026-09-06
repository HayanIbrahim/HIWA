import 'package:flutter/material.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../core/utils/unit_converter.dart';
import '../../../../core/utils/weather_mapper.dart';
import '../../../../domain/entities/weather_entity.dart';
import '../../../../l10n/generated/app_localizations.dart';

class CurrentWeatherCard extends StatelessWidget {
  final WeatherEntity weather;
  final UnitSystem unitSystem;

  const CurrentWeatherCard({
    super.key,
    required this.weather,
    required this.unitSystem,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final weatherType = WeatherMapper.getWeatherType(weather.iconCode, weather.weatherId);
    final iconData = WeatherMapper.getIconData(weatherType);
    final conditionColor = WeatherMapper.getConditionColor(weatherType);

    final tempString = UnitConverter.formatTemperature(weather.temp, unitSystem);
    final feelsLikeString = UnitConverter.formatTemperature(weather.feelsLike, unitSystem);
    final highString = UnitConverter.formatTemperature(weather.tempMax, unitSystem);
    final lowString = UnitConverter.formatTemperature(weather.tempMin, unitSystem);

    return Column(
      children: [
        const SizedBox(height: 10),
        // City Name
        Text(
          weather.cityName,
          textAlign: TextAlign.center,
          style: AppTypography.cityTitleStyle(
            context: context,
            isArabic: isArabic,
            color: Colors.white,
          ),
        ),

        // Date and Country
        const SizedBox(height: 4),
        Text(
          '${weather.countryName.isNotEmpty ? "${weather.countryName} • " : ""}${AppDateFormatter.formatFullDate(weather.dt, locale: isArabic ? "ar" : "en")}',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Colors.white.withOpacity(0.85),
          ),
        ),

        const SizedBox(height: 24),

        // Big Icon & Temperature
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              iconData,
              size: 64,
              color: conditionColor,
            ),
            const SizedBox(width: 16),
            Text(
              tempString,
              style: AppTypography.heroTempStyle(
                context: context,
                isArabic: isArabic,
                color: Colors.white,
              ),
            ),
          ],
        ),

        // Condition Description
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.18),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            weather.description.toUpperCase(),
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
              color: Colors.white,
            ),
          ),
        ),

        const SizedBox(height: 12),

        // High / Low & Feels Like
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              l10n?.highLow(highString, lowString) ?? 'H: $highString  L: $lowString',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.white.withOpacity(0.9),
              ),
            ),
            const SizedBox(width: 16),
            Text(
              '•',
              style: TextStyle(color: Colors.white.withOpacity(0.6)),
            ),
            const SizedBox(width: 16),
            Text(
              l10n?.feelsLike(feelsLikeString) ?? 'Feels like $feelsLikeString',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.white.withOpacity(0.9),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
