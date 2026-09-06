import 'dart:math';
import 'package:flutter/material.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../core/utils/unit_converter.dart';
import '../../../../core/utils/weather_mapper.dart';
import '../../../../domain/entities/hourly_forecast_entity.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../common_widgets/glass_card.dart';

class HourlyForecastStrip extends StatefulWidget {
  final List<HourlyForecastEntity> hourlyForecasts;
  final UnitSystem unitSystem;

  const HourlyForecastStrip({
    super.key,
    required this.hourlyForecasts,
    required this.unitSystem,
  });

  @override
  State<HourlyForecastStrip> createState() => _HourlyForecastStripState();
}

class _HourlyForecastStripState extends State<HourlyForecastStrip> {
  bool _showChart = false;
  int? _scrubbedIndex;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).languageCode;
    final forecasts = widget.hourlyForecasts;

    return GlassCard(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with View Mode Switcher
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
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

                // Cards vs Chart Toggle Pill
                Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.20),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white.withOpacity(0.08)),
                  ),
                  child: Row(
                    children: [
                      _buildToggleBtn(
                        title: l10n?.hourlyCards ?? 'Cards',
                        icon: Icons.view_week_rounded,
                        isSelected: !_showChart,
                        onTap: () => setState(() => _showChart = false),
                      ),
                      _buildToggleBtn(
                        title: l10n?.hourlyChart ?? 'Chart',
                        icon: Icons.show_chart_rounded,
                        isSelected: _showChart,
                        onTap: () => setState(() => _showChart = true),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          // Main View (Cards vs Interactive Bezier Chart)
          AnimatedCrossFade(
            firstChild: _buildCardsView(context, forecasts, locale),
            secondChild: _buildInteractiveChartView(context, forecasts, locale),
            crossFadeState: _showChart ? CrossFadeState.showSecond : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 300),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleBtn({
    required String title,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white.withOpacity(0.22) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, size: 13, color: isSelected ? Colors.white : Colors.white60),
            const SizedBox(width: 4),
            Text(
              title,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected ? Colors.white : Colors.white60,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardsView(
    BuildContext context,
    List<HourlyForecastEntity> forecasts,
    String locale,
  ) {
    return SizedBox(
      height: 120,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: forecasts.length,
        separatorBuilder: (_, _) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final item = forecasts[index];
          final weatherType = WeatherMapper.getWeatherType(item.iconCode, item.weatherId);
          final iconData = WeatherMapper.getIconData(weatherType);
          final conditionColor = WeatherMapper.getConditionColor(weatherType);
          final temp = UnitConverter.formatTemperature(item.temp, widget.unitSystem);
          final hourStr = index == 0
              ? (locale == 'ar' ? 'الآن' : 'Now')
              : AppDateFormatter.formatHour(item.dt, locale: locale);

          return Container(
            width: 68,
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: index == 0 ? Colors.white.withOpacity(0.16) : Colors.white.withOpacity(0.04),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: index == 0 ? Colors.white.withOpacity(0.25) : Colors.transparent,
              ),
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

                // Icon & Rain Probability
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
    );
  }

  Widget _buildInteractiveChartView(
    BuildContext context,
    List<HourlyForecastEntity> forecasts,
    String locale,
  ) {
    // Show next 24 hours in the chart
    final displayItems = forecasts.take(24).toList();
    if (displayItems.isEmpty) return const SizedBox.shrink();

    final scrubbedItem = _scrubbedIndex != null && _scrubbedIndex! < displayItems.length
        ? displayItems[_scrubbedIndex!]
        : displayItems.first;

    final scrubbedTemp = UnitConverter.formatTemperature(scrubbedItem.temp, widget.unitSystem);
    final scrubbedHour = _scrubbedIndex == null || _scrubbedIndex == 0
        ? (locale == 'ar' ? 'الآن' : 'Now')
        : AppDateFormatter.formatHour(scrubbedItem.dt, locale: locale);

    return Column(
      children: [
        // Interactive Live Tooltip Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.25),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withOpacity(0.1)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      WeatherMapper.getIconData(
                        WeatherMapper.getWeatherType(scrubbedItem.iconCode, scrubbedItem.weatherId),
                      ),
                      size: 18,
                      color: WeatherMapper.getConditionColor(
                        WeatherMapper.getWeatherType(scrubbedItem.iconCode, scrubbedItem.weatherId),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '$scrubbedHour: $scrubbedTemp',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    if (scrubbedItem.pop > 0.05) ...[
                      const Icon(Icons.water_drop_rounded, size: 13, color: Color(0xFF38BDF8)),
                      const SizedBox(width: 2),
                      Text(
                        '${(scrubbedItem.pop * 100).round()}%',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF38BDF8),
                        ),
                      ),
                      const SizedBox(width: 10),
                    ],
                    Text(
                      scrubbedItem.description,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 12),

        // Interactive Canvas
        GestureDetector(
          onHorizontalDragUpdate: (details) {
            final box = context.findRenderObject() as RenderBox?;
            if (box != null) {
              final localX = details.localPosition.dx;
              final width = box.size.width - 32;
              final fraction = (localX / width).clamp(0.0, 1.0);
              final idx = (fraction * (displayItems.length - 1)).round();
              setState(() {
                _scrubbedIndex = idx.clamp(0, displayItems.length - 1);
              });
            }
          },
          onHorizontalDragEnd: (_) {
            setState(() => _scrubbedIndex = null);
          },
          child: SizedBox(
            height: 125,
            width: double.infinity,
            child: CustomPaint(
              painter: _HourlyBezierChartPainter(
                items: displayItems,
                selectedIndex: _scrubbedIndex,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _HourlyBezierChartPainter extends CustomPainter {
  final List<HourlyForecastEntity> items;
  final int? selectedIndex;

  _HourlyBezierChartPainter({
    required this.items,
    required this.selectedIndex,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (items.length < 2) return;

    const padLeft = 16.0;
    const padRight = 16.0;
    const padTop = 20.0;
    const padBottom = 24.0;

    final chartWidth = size.width - (padLeft + padRight);
    final chartHeight = size.height - (padTop + padBottom);

    double minTemp = 100.0;
    double maxTemp = -100.0;
    for (var it in items) {
      if (it.temp < minTemp) minTemp = it.temp;
      if (it.temp > maxTemp) maxTemp = it.temp;
    }
    final range = max(1.0, maxTemp - minTemp);

    final points = <Offset>[];
    for (int i = 0; i < items.length; i++) {
      final x = padLeft + (i / (items.length - 1)) * chartWidth;
      final y = padTop + chartHeight - ((items[i].temp - minTemp) / range) * chartHeight;
      points.add(Offset(x, y));
    }

    // 1. Spline Bezier Path
    final path = Path()..moveTo(points[0].dx, points[0].dy);
    final fillPath = Path()..moveTo(points[0].dx, points[0].dy);

    for (int i = 0; i < points.length - 1; i++) {
      final p0 = points[i];
      final p1 = points[i + 1];
      final controlX = (p0.dx + p1.dx) / 2;
      path.cubicTo(controlX, p0.dy, controlX, p1.dy, p1.dx, p1.dy);
      fillPath.cubicTo(controlX, p0.dy, controlX, p1.dy, p1.dx, p1.dy);
    }

    // Close fill path down to base
    fillPath.lineTo(points.last.dx, size.height - padBottom);
    fillPath.lineTo(points.first.dx, size.height - padBottom);
    fillPath.close();

    // 2. Draw Gradient Area Fill
    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          const Color(0xFF38BDF8).withOpacity(0.35),
          const Color(0xFF38BDF8).withOpacity(0.0),
        ],
      ).createShader(Rect.fromLTWH(0, padTop, size.width, chartHeight));
    canvas.drawPath(fillPath, fillPaint);

    // 3. Draw Spline Stroke
    final strokePaint = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFF38BDF8), Color(0xFFFBBF24)],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.8
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(path, strokePaint);

    // 4. Draw Rain Prob Bars at Bottom
    final rainPaint = Paint()..color = const Color(0xFF38BDF8).withOpacity(0.5);
    for (int i = 0; i < items.length; i++) {
      if (items[i].pop > 0.05) {
        final barH = items[i].pop * 16.0;
        final x = points[i].dx - 2.5;
        final y = size.height - padBottom;
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(x, y - barH, 5, barH),
            const Radius.circular(2),
          ),
          rainPaint,
        );
      }
    }

    // 5. Draw Scrubber Indicator if user is scrubbing
    if (selectedIndex != null && selectedIndex! < points.length) {
      final selectedPoint = points[selectedIndex!];

      // Vertical guideline
      final guidePaint = Paint()
        ..color = Colors.white.withOpacity(0.4)
        ..strokeWidth = 1.2
        ..style = PaintingStyle.stroke;
      canvas.drawLine(
        Offset(selectedPoint.dx, padTop),
        Offset(selectedPoint.dx, size.height - padBottom),
        guidePaint,
      );

      // Outer glowing ring
      final glowPaint = Paint()
        ..color = const Color(0xFF38BDF8).withOpacity(0.4)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(selectedPoint, 10, glowPaint);

      // Core point
      final pointPaint = Paint()..color = Colors.white;
      canvas.drawCircle(selectedPoint, 5, pointPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _HourlyBezierChartPainter oldDelegate) {
    return oldDelegate.selectedIndex != selectedIndex || oldDelegate.items != items;
  }
}
