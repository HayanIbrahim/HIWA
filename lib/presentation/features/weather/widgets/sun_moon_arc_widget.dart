import 'dart:math';
import 'package:flutter/material.dart';
import '../../../../domain/entities/daily_forecast_entity.dart';
import '../../../../domain/entities/weather_entity.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../common_widgets/glass_card.dart';

class SunMoonArcWidget extends StatefulWidget {
  final WeatherEntity weather;
  final List<DailyForecastEntity> dailyForecasts;

  const SunMoonArcWidget({
    super.key,
    required this.weather,
    required this.dailyForecasts,
  });

  @override
  State<SunMoonArcWidget> createState() => _SunMoonArcWidgetState();
}

class _SunMoonArcWidgetState extends State<SunMoonArcWidget> {
  double? _scrubProgress;

  String _formatTime(int epochSeconds) {
    final dt = DateTime.fromMillisecondsSinceEpoch(epochSeconds * 1000);
    final hour = dt.hour.toString().padLeft(2, '0');
    final minute = dt.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  // Calculate moon phase based on epoch date (0.0 to 1.0)
  // 0.0 = New Moon, 0.25 = First Quarter, 0.5 = Full Moon, 0.75 = Last Quarter
  double _calculateMoonPhase(DateTime date) {
    // Known new moon reference: Jan 11 2024
    final knownNewMoon = DateTime.utc(2024, 1, 11, 11, 57);
    final diffDays = date.toUtc().difference(knownNewMoon).inSeconds / 86400.0;
    const synodicMonth = 29.53058867;
    final phase = (diffDays % synodicMonth) / synodicMonth;
    return phase < 0 ? phase + 1.0 : phase;
  }

  String _getMoonPhaseName(double phase, bool isArabic) {
    if (phase < 0.03 || phase > 0.97) {
      return isArabic ? 'محاق' : 'New Moon';
    } else if (phase < 0.22) {
      return isArabic ? 'هلال متزايد' : 'Waxing Crescent';
    } else if (phase < 0.28) {
      return isArabic ? 'تربيع أول' : 'First Quarter';
    } else if (phase < 0.47) {
      return isArabic ? 'أحدب متزايد' : 'Waxing Gibbous';
    } else if (phase < 0.53) {
      return isArabic ? 'بدر' : 'Full Moon';
    } else if (phase < 0.72) {
      return isArabic ? 'أحدب متناقص' : 'Waning Gibbous';
    } else if (phase < 0.78) {
      return isArabic ? 'تربيع ثانٍ' : 'Last Quarter';
    } else {
      return isArabic ? 'هلال متناقص' : 'Waning Crescent';
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    final nowSec = widget.weather.dt;
    final firstDaily = widget.dailyForecasts.isNotEmpty ? widget.dailyForecasts.first : null;

    final sunriseSec = widget.weather.sunrise ?? firstDaily?.sunrise ?? (nowSec - 6 * 3600);
    final sunsetSec = widget.weather.sunset ?? firstDaily?.sunset ?? (nowSec + 6 * 3600);

    final totalDaylight = max(1, sunsetSec - sunriseSec);
    final isDaytime = nowSec >= sunriseSec && nowSec <= sunsetSec;

    // Progression: 0.0 at sunrise, 1.0 at sunset
    final naturalProgress = isDaytime
        ? ((nowSec - sunriseSec) / totalDaylight).clamp(0.0, 1.0)
        : (nowSec > sunsetSec ? 1.0 : 0.0);

    final displayProgress = _scrubProgress ?? naturalProgress;

    // Remaining daylight calculation
    final remainingSec = max(0, sunsetSec - nowSec);
    final remainingHours = remainingSec ~/ 3600;
    final remainingMins = (remainingSec % 3600) ~/ 60;

    final moonPhase = _calculateMoonPhase(
      DateTime.fromMillisecondsSinceEpoch(nowSec * 1000),
    );
    final moonPhaseName = _getMoonPhaseName(moonPhase, isArabic);
    final illuminationPercent = ((0.5 - (moonPhase - 0.5).abs()) * 200).round();

    return GlassCard(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.wb_twilight_rounded, size: 18, color: Colors.amberAccent),
                  const SizedBox(width: 8),
                  Text(
                    l10n?.sunAndMoon ?? 'Sun & Moon',
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
                  color: Colors.white.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  isDaytime
                      ? (l10n?.daylightRemaining(remainingHours, remainingMins) ??
                          '${remainingHours}h ${remainingMins}m daylight remaining')
                      : (l10n?.nightRemaining(12 - remainingHours, 60 - remainingMins) ??
                          'Night time'),
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Colors.white70,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          // Arc Painter Canvas
          GestureDetector(
            onHorizontalDragUpdate: (details) {
              final box = context.findRenderObject() as RenderBox?;
              if (box != null) {
                final localX = details.localPosition.dx;
                final width = box.size.width - 36;
                setState(() {
                  _scrubProgress = (localX / width).clamp(0.0, 1.0);
                });
              }
            },
            onHorizontalDragEnd: (_) {
              setState(() {
                _scrubProgress = null;
              });
            },
            child: SizedBox(
              height: 120,
              width: double.infinity,
              child: CustomPaint(
                painter: _SunArcPainter(
                  progress: displayProgress,
                  isDaytime: isDaytime,
                ),
              ),
            ),
          ),

          // Sunrise & Sunset Labels
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.vertical_align_top_rounded, size: 14, color: Colors.amberAccent),
                      const SizedBox(width: 4),
                      Text(
                        l10n?.sunrise ?? 'Sunrise',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _formatTime(sunriseSec),
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),

              // Moon Phase Pill in Center
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.20),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white.withOpacity(0.1)),
                ),
                child: Row(
                  children: [
                    Icon(
                      moonPhase < 0.1 || moonPhase > 0.9
                          ? Icons.circle_outlined
                          : (moonPhase > 0.45 && moonPhase < 0.55
                              ? Icons.brightness_1_rounded
                              : Icons.nightlight_round),
                      size: 15,
                      color: const Color(0xFFBAE6FD),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '$moonPhaseName • $illuminationPercent%',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),

              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      Text(
                        l10n?.sunset ?? 'Sunset',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white.withOpacity(0.7),
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(Icons.vertical_align_bottom_rounded, size: 14, color: Color(0xFFFB923C)),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _formatTime(sunsetSec),
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SunArcPainter extends CustomPainter {
  final double progress;
  final bool isDaytime;

  _SunArcPainter({
    required this.progress,
    required this.isDaytime,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final horizonY = size.height * 0.82;
    const paddingX = 24.0;
    final arcWidth = size.width - (paddingX * 2);

    // 1. Draw Horizon Baseline
    final horizonPaint = Paint()
      ..color = Colors.white.withOpacity(0.18)
      ..strokeWidth = 1.5;
    canvas.drawLine(Offset(0, horizonY), Offset(size.width, horizonY), horizonPaint);

    // 2. Parabolic Arc Path
    final arcPath = Path();
    arcPath.moveTo(paddingX, horizonY);
    arcPath.quadraticBezierTo(
      size.width * 0.5,
      12.0,
      size.width - paddingX,
      horizonY,
    );

    // Dotted / Dashed Arc Line
    final arcPaint = Paint()
      ..color = Colors.white.withOpacity(0.25)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    canvas.drawPath(arcPath, arcPaint);

    // 3. Highlighted Passed Arc
    // Quadratic bezier position formula: B(t) = (1-t)^2 P0 + 2(1-t)t P1 + t^2 P2
    final t = progress.clamp(0.0, 1.0);
    final p0 = Offset(paddingX, horizonY);
    final p1 = Offset(size.width * 0.5, 12.0);
    final p2 = Offset(size.width - paddingX, horizonY);

    final sunX = (1 - t) * (1 - t) * p0.dx + 2 * (1 - t) * t * p1.dx + t * t * p2.dx;
    final sunY = (1 - t) * (1 - t) * p0.dy + 2 * (1 - t) * t * p1.dy + t * t * p2.dy;

    // Glowing Day Zone under passed path
    final passedPath = Path();
    passedPath.moveTo(paddingX, horizonY);
    for (double step = 0; step <= t; step += 0.04) {
      final x = (1 - step) * (1 - step) * p0.dx + 2 * (1 - step) * step * p1.dx + step * step * p2.dx;
      final y = (1 - step) * (1 - step) * p0.dy + 2 * (1 - step) * step * p1.dy + step * step * p2.dy;
      passedPath.lineTo(x, y);
    }
    final passedStrokePaint = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFFFBBF24), Color(0xFFF59E0B)],
      ).createShader(Rect.fromLTWH(paddingX, 0, arcWidth, size.height))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;

    canvas.drawPath(passedPath, passedStrokePaint);

    // 4. Glowing Sun / Moon Orb at Current Position
    final orbCenter = Offset(sunX, sunY);

    // Outer Glow
    final glowPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          (isDaytime ? Colors.amberAccent : const Color(0xFF93C5FD)).withOpacity(0.55),
          Colors.transparent,
        ],
      ).createShader(Rect.fromCircle(center: orbCenter, radius: 24));
    canvas.drawCircle(orbCenter, 24, glowPaint);

    // Core Orb
    final corePaint = Paint()
      ..color = isDaytime ? const Color(0xFFFBBF24) : const Color(0xFFE0F2FE);
    canvas.drawCircle(orbCenter, 7.5, corePaint);

    // Sun center highlight
    final centerGlint = Paint()..color = Colors.white;
    canvas.drawCircle(orbCenter, 3.5, centerGlint);
  }

  @override
  bool shouldRepaint(covariant _SunArcPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.isDaytime != isDaytime;
  }
}
