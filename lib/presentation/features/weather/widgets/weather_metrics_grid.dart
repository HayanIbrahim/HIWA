import 'dart:ui';
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

  String _getUvDescription(double uvi, bool isAr) {
    if (isAr) {
      if (uvi <= 2) return 'منخفض';
      if (uvi <= 5) return 'متوسط';
      if (uvi <= 7) return 'مرتفع';
      if (uvi <= 10) return 'مرتفع جداً';
      return 'خطر شديد';
    }
    if (uvi <= 2) return 'Low';
    if (uvi <= 5) return 'Moderate';
    if (uvi <= 7) return 'High';
    if (uvi <= 10) return 'Very High';
    return 'Extreme';
  }

  void _showMetricDetailModal(
    BuildContext context, {
    required String title,
    required String value,
    required String status,
    required String explanation,
    required String advice,
    required IconData icon,
    required Color iconColor,
    required double progressFraction,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: isDark
                  ? const Color(0xFF1E293B).withValues(alpha: 0.92)
                  : Colors.white.withValues(alpha: 0.95),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  blurRadius: 24,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: SafeArea(
              top: false,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Drag Handle
                  Center(
                    child: Container(
                      width: 44,
                      height: 5,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.25),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Header with Icon
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: iconColor.withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(icon, color: iconColor, size: 28),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                            Text(
                              status,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: iconColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        value,
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Visual Progress Gauge
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: LinearProgressIndicator(
                      value: progressFraction.clamp(0.0, 1.0),
                      minHeight: 8,
                      backgroundColor: theme.colorScheme.onSurface.withValues(alpha: 0.1),
                      valueColor: AlwaysStoppedAnimation<Color>(iconColor),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Explanation
                  Text(
                    explanation,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
                      height: 1.45,
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Health / Action Advice Box
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: iconColor.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: iconColor.withValues(alpha: 0.25),
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.info_outline_rounded, size: 20, color: iconColor),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            advice,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              height: 1.4,
                              color: theme.colorScheme.onSurface.withValues(alpha: 0.9),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isAr = Localizations.localeOf(context).languageCode == 'ar';

    final windStr = UnitConverter.formatWindSpeed(weather.windSpeed, unitSystem);
    final pressureStr = UnitConverter.formatPressure(weather.pressure);
    final humidityStr = UnitConverter.formatHumidity(weather.humidity);
    final visibilityStr = UnitConverter.formatVisibility(weather.visibility, unitSystem);
    final uvLevel = _getUvDescription(weather.uvi, isAr);

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 14,
      mainAxisSpacing: 14,
      childAspectRatio: 1.28,
      children: [
        // 1. UV Index
        _buildMetricCard(
          context: context,
          icon: Icons.wb_sunny_outlined,
          iconColor: Colors.amberAccent,
          title: l10n?.uvIndex ?? 'UV INDEX',
          value: weather.uvi.toStringAsFixed(1),
          subtitle: uvLevel,
          onTap: () => _showMetricDetailModal(
            context,
            title: l10n?.uvIndex ?? 'UV Index',
            value: weather.uvi.toStringAsFixed(1),
            status: uvLevel,
            explanation: isAr
                ? 'مؤشر الأشعة فوق البنفسجية يقيس قوة الإشعاع الشمسي المسبب لحروق الجلد.'
                : 'The UV Index measures the strength of sunburn-producing ultraviolet radiation at solar noon.',
            advice: weather.uvi >= 6
                ? (isAr
                    ? 'ينصح بوضع واقي شمس، ارتداء نظارة شمسية، وتجنب التعرض المباشر للشمس في الظهيرة.'
                    : 'Wear SPF 30+ sunscreen, sunglasses, and seek shade during midday hours.')
                : (isAr
                    ? 'مستوى آمن من الأشعة فوق البنفسجية للأنشطة الخارجية العادية.'
                    : 'Low risk of UV harm for normal outdoor activities.'),
            icon: Icons.wb_sunny_outlined,
            iconColor: Colors.amberAccent,
            progressFraction: weather.uvi / 11.0,
          ),
        ),

        // 2. Wind Speed & Direction
        _buildMetricCard(
          context: context,
          icon: Icons.air_rounded,
          iconColor: const Color(0xFF38BDF8),
          title: l10n?.windSpeed ?? 'WIND',
          value: windStr,
          subtitle: '${weather.windDeg}° ${isAr ? "الاتجاه" : "Direction"}',
          onTap: () => _showMetricDetailModal(
            context,
            title: l10n?.windSpeed ?? 'Wind Dynamics',
            value: windStr,
            status: '${weather.windDeg}°',
            explanation: isAr
                ? 'سرعة تدفق الهواء في الغلاف الجوي والاتجاه الحقيقي لكتل الرياح.'
                : 'Current atmospheric wind speed and azimuth angle indicating the heading.',
            advice: isAr
                ? 'رياح مناسبة للتنقل والأنشطة الخارجية بدون عوائق.'
                : 'Favorable winds for daily commute and outdoor exercise.',
            icon: Icons.air_rounded,
            iconColor: const Color(0xFF38BDF8),
            progressFraction: (weather.windSpeed / 30.0).clamp(0.0, 1.0),
          ),
        ),

        // 3. Humidity
        _buildMetricCard(
          context: context,
          icon: Icons.water_drop_outlined,
          iconColor: const Color(0xFF60A5FA),
          title: l10n?.humidity ?? 'HUMIDITY',
          value: humidityStr,
          subtitle: isAr
              ? 'نقطة الندى ${weather.dewPoint.round()}°'
              : 'Dew point ${weather.dewPoint.round()}°',
          onTap: () => _showMetricDetailModal(
            context,
            title: l10n?.humidity ?? 'Humidity',
            value: humidityStr,
            status: isAr
                ? 'نقطة الندى: ${weather.dewPoint.round()}°'
                : 'Dew Point: ${weather.dewPoint.round()}°',
            explanation: isAr
                ? 'نسبة بخار الماء الحالية في الهواء مقارنة بالحد الأقصى للتشبع عند نفس درجة الحرارة.'
                : 'Relative humidity is the percentage of moisture in the atmosphere compared to maximum saturation.',
            advice: weather.humidity > 70
                ? (isAr
                    ? 'الرطوبة مرتفعة، قد تشعر بالأجواء أدفأ من الواقع.'
                    : 'High humidity makes ambient air feel warmer than actual temperature.')
                : (isAr
                    ? 'مستوى رطوبة متوازن ومريح للتنفس.'
                    : 'Optimal humidity level for indoor and outdoor comfort.'),
            icon: Icons.water_drop_outlined,
            iconColor: const Color(0xFF60A5FA),
            progressFraction: weather.humidity / 100.0,
          ),
        ),

        // 4. Pressure
        _buildMetricCard(
          context: context,
          icon: Icons.speed_rounded,
          iconColor: const Color(0xFFA78BFA),
          title: l10n?.pressure ?? 'PRESSURE',
          value: pressureStr,
          subtitle: isAr ? 'مستوى سطح البحر' : 'Sea-level',
          onTap: () => _showMetricDetailModal(
            context,
            title: l10n?.pressure ?? 'Barometric Pressure',
            value: pressureStr,
            status: weather.pressure >= 1013
                ? (isAr ? 'ضغط مرتفع (أجواء مستقرة)' : 'High Pressure (Fair Skies)')
                : (isAr ? 'ضغط منخفض (نشاط جوي)' : 'Low Pressure (Active Clouds)'),
            explanation: isAr
                ? 'الضغط الجوي هو وزن عمود الهواء فوق السطح، ويعتبر مؤشراً رئيسياً لتغيرات الطقس.'
                : 'Atmospheric barometric pressure indicates the weight of overlying air columns.',
            advice: weather.pressure >= 1013
                ? (isAr
                    ? 'الضغط المرتفع يشير عادة إلى استقرار الأجواء وصفاء السماء.'
                    : 'High pressure typically brings stable, clear conditions.')
                : (isAr
                    ? 'انخفاض الضغط قد يرتبط بتكون الغيوم أو تقلبات مناخية.'
                    : 'Falling pressure is often associated with cloud buildup and precipitation.'),
            icon: Icons.speed_rounded,
            iconColor: const Color(0xFFA78BFA),
            progressFraction: ((weather.pressure - 950) / 100.0).clamp(0.0, 1.0),
          ),
        ),

        // 5. Visibility
        _buildMetricCard(
          context: context,
          icon: Icons.visibility_outlined,
          iconColor: const Color(0xFF34D399),
          title: l10n?.visibility ?? 'VISIBILITY',
          value: visibilityStr,
          subtitle: weather.visibility >= 10000
              ? (isAr ? 'رؤية ممتازة' : 'Clear view')
              : (isAr ? 'رؤية محدودة' : 'Reduced view'),
          onTap: () => _showMetricDetailModal(
            context,
            title: l10n?.visibility ?? 'Visibility',
            value: visibilityStr,
            status: weather.visibility >= 10000
                ? (isAr ? 'ممتازة (> 10 كم)' : 'Excellent (> 10 km)')
                : (isAr ? 'محدودة' : 'Moderate / Reduced'),
            explanation: isAr
                ? 'المسافة القصوى التي يمكن عندها تمييز المعالم بوضوح في الأفق.'
                : 'The greatest horizontal distance at which prominent objects can be identified clearly.',
            advice: weather.visibility >= 10000
                ? (isAr
                    ? 'الرؤية واضحة تماماً ومثالية للقيادة والتنقل.'
                    : 'Perfect visibility for safe driving and aviation.')
                : (isAr
                    ? 'توخَ الحذر أثناء القيادة وخفف السرعة في مناطق الضباب أو الغبار.'
                    : 'Drive cautiously and use low beams if fog or haze is present.'),
            icon: Icons.visibility_outlined,
            iconColor: const Color(0xFF34D399),
            progressFraction: (weather.visibility / 10000.0).clamp(0.0, 1.0),
          ),
        ),

        // 6. Cloud Cover
        _buildMetricCard(
          context: context,
          icon: Icons.cloud_queue_rounded,
          iconColor: const Color(0xFFCBD5E1),
          title: isAr ? 'الغيوم' : 'CLOUDS',
          value: '${weather.clouds}%',
          subtitle: isAr ? 'تغطية السماء' : 'Sky coverage',
          onTap: () => _showMetricDetailModal(
            context,
            title: isAr ? 'نسبة تغطية الغيوم' : 'Cloud Coverage',
            value: '${weather.clouds}%',
            status: weather.clouds > 60
                ? (isAr ? 'غائم جزئياً إلى كلياً' : 'Mostly Overcast')
                : (isAr ? 'سماء صافية أو غيوم متفرقة' : 'Clear / Scattered'),
            explanation: isAr
                ? 'نسبة قبة السماء المغطاة بالغيوم بمختلف طبقاتها.'
                : 'Fraction of the celestial dome obscured by cloud formations.',
            advice: isAr
                ? 'تؤثر الغيوم على كمية الأشعة الشمسية المباشرة ودرجة حرارة المساء.'
                : 'Cloud cover regulates daytime solar heating and nocturnal heat retention.',
            icon: Icons.cloud_queue_rounded,
            iconColor: const Color(0xFFCBD5E1),
            progressFraction: weather.clouds / 100.0,
          ),
        ),
      ],
    );
  }

  Widget _buildMetricCard({
    required BuildContext context,
    required IconData icon,
    required Color iconColor,
    required String title,
    required String value,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: GlassCard(
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
                        color: Colors.white.withValues(alpha: 0.75),
                      ),
                    ),
                  ),
                  Icon(
                    Icons.info_outline_rounded,
                    size: 13,
                    color: Colors.white.withValues(alpha: 0.4),
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
                  color: Colors.white.withValues(alpha: 0.75),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
