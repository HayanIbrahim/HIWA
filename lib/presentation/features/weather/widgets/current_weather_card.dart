import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../core/utils/unit_converter.dart';
import '../../../../core/utils/weather_mapper.dart';
import '../../../../domain/entities/weather_entity.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../settings/bloc/settings_bloc.dart';

class CurrentWeatherCard extends StatelessWidget {
  final WeatherEntity weather;
  final UnitSystem unitSystem;

  const CurrentWeatherCard({
    super.key,
    required this.weather,
    required this.unitSystem,
  });

  String _getSmartWeatherInsight({
    required WeatherType weatherType,
    required double temp,
    required double uvi,
    required bool isArabic,
  }) {
    if (isArabic) {
      switch (weatherType) {
        case WeatherType.thunderstorm:
          return 'عواصف رعدية متوقعة. يُنصح بالبقاء في أماكن مغلقة.';
        case WeatherType.rain:
          return 'أجواء ماطرة. لا تنسَ اصطحاب مظلتك اليوم.';
        case WeatherType.snow:
          return 'تساقط للثلوج ودرجات حرارة منخفضة. ارتدِ ملابس دافئة.';
        case WeatherType.mist:
          return 'ضباب في الأجواء قد يؤثر على الرؤية الأفقية.';
        case WeatherType.clearNight:
          return 'سماء صافية وليلة لطيفة، مثالية لمشاهدة النجوم.';
        case WeatherType.clearDay:
          if (uvi >= 6) {
            return 'أجواء مشمسة مع مؤشر أشعة فوق بنفسجية مرتفع. استخدم واقي الشمس.';
          }
          return 'أجواء مشمسة ولطيفة، مناسبة جداً للأنشطة الخارجية.';
        case WeatherType.cloudy:
          return 'سماء غائمة جزئياً مع نسمات هواء منعشة.';
      }
    } else {
      switch (weatherType) {
        case WeatherType.thunderstorm:
          return 'Thunderstorm active in the area. Stay indoors safely.';
        case WeatherType.rain:
          return 'Precipitation expected. Carry an umbrella with you.';
        case WeatherType.snow:
          return 'Freezing temperatures and snow. Bundle up warmly.';
        case WeatherType.mist:
          return 'Misty conditions with reduced road visibility.';
        case WeatherType.clearNight:
          return 'Crisp, clear skies tonight. Great for stargazing.';
        case WeatherType.clearDay:
          if (uvi >= 6) {
            return 'Bright and sunny. High UV index, wear sun protection.';
          }
          return 'Clear, radiant weather. Ideal for outdoor activities.';
        case WeatherType.cloudy:
          return 'Partly cloudy skies with mild and pleasant breezes.';
      }
    }
  }

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

    final smartInsight = _getSmartWeatherInsight(
      weatherType: weatherType,
      temp: weather.temp,
      uvi: weather.uvi,
      isArabic: isArabic,
    );

    return Column(
      children: [
        const SizedBox(height: 8),

        // City Title
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.location_on_rounded, size: 20, color: Colors.white70),
            const SizedBox(width: 6),
            Text(
              weather.cityName,
              textAlign: TextAlign.center,
              style: AppTypography.cityTitleStyle(
                context: context,
                isArabic: isArabic,
                color: Colors.white,
              ),
            ),
          ],
        ).animate().fadeIn(duration: 400.ms).slideY(begin: -0.1, end: 0),

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
        ).animate().fadeIn(delay: 100.ms, duration: 400.ms),

        const SizedBox(height: 20),

        // Hero Weather Icon & Temperature with Interactive Bounce
        InkWell(
          onTap: () {
            // Quick unit toggle on tap
            final newUnit = unitSystem == UnitSystem.metric
                ? UnitSystem.imperial
                : UnitSystem.metric;
            context.read<SettingsBloc>().add(ChangeUnitSystemEvent(newUnit));
          },
          borderRadius: BorderRadius.circular(24),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Floating Glowing Weather Badge
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        conditionColor.withOpacity(0.35),
                        conditionColor.withOpacity(0.0),
                      ],
                    ),
                  ),
                  child: Icon(
                    iconData,
                    size: 68,
                    color: conditionColor,
                  ),
                )
                    .animate()
                    .fadeIn(duration: 500.ms)
                    .scale(begin: const Offset(0.85, 0.85), end: const Offset(1, 1), curve: Curves.easeOutBack)
                    .shimmer(delay: 300.ms, duration: 1200.ms),

                const SizedBox(width: 12),

                // Hero Temperature
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tempString,
                      style: AppTypography.heroTempStyle(
                        context: context,
                        isArabic: isArabic,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      l10n?.feelsLike(feelsLikeString) ?? 'Feels like $feelsLikeString',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Colors.white.withOpacity(0.85),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ).animate().fadeIn(delay: 150.ms, duration: 500.ms).scale(begin: const Offset(0.95, 0.95), end: const Offset(1, 1)),

        // Condition Description Badge
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 7),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.18),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withOpacity(0.22)),
          ),
          child: Text(
            weather.description.toUpperCase(),
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.2,
              color: Colors.white,
            ),
          ),
        ).animate().fadeIn(delay: 200.ms, duration: 400.ms),

        const SizedBox(height: 12),

        // High / Low Indicators
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                const Icon(Icons.arrow_upward_rounded, size: 14, color: Colors.amberAccent),
                const SizedBox(width: 2),
                Text(
                  highString,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 16),
            Row(
              children: [
                const Icon(Icons.arrow_downward_rounded, size: 14, color: Color(0xFF38BDF8)),
                const SizedBox(width: 2),
                Text(
                  lowString,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ).animate().fadeIn(delay: 250.ms, duration: 400.ms),

        const SizedBox(height: 14),

        // Smart Weather Insight Pill
        Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.18),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(0.12)),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.auto_awesome_rounded,
                color: Colors.amberAccent,
                size: 18,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  smartInsight,
                  style: TextStyle(
                    fontSize: 12,
                    height: 1.35,
                    fontWeight: FontWeight.w500,
                    color: Colors.white.withOpacity(0.92),
                  ),
                ),
              ),
            ],
          ),
        ).animate().fadeIn(delay: 300.ms, duration: 500.ms),
      ],
    );
  }
}
