import 'dart:math';
import 'package:flutter/material.dart';
import '../../../../core/utils/unit_converter.dart';
import '../../../../domain/entities/weather_entity.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../common_widgets/glass_card.dart';

class WindCompassWidget extends StatelessWidget {
  final WeatherEntity weather;
  final UnitSystem unitSystem;

  const WindCompassWidget({
    super.key,
    required this.weather,
    required this.unitSystem,
  });

  String _getBeaufortScale(double speedMps, bool isArabic) {
    if (speedMps < 0.5) {
      return isArabic ? 'هدوء تام' : 'Calm';
    } else if (speedMps < 1.5) {
      return isArabic ? 'هواء خفيف' : 'Light Air';
    } else if (speedMps < 3.3) {
      return isArabic ? 'نسيم خفيف' : 'Light Breeze';
    } else if (speedMps < 5.5) {
      return isArabic ? 'نسيم لطيف' : 'Gentle Breeze';
    } else if (speedMps < 8.0) {
      return isArabic ? 'نسيم معتدل' : 'Moderate Breeze';
    } else if (speedMps < 10.8) {
      return isArabic ? 'نسيم منعش' : 'Fresh Breeze';
    } else if (speedMps < 13.9) {
      return isArabic ? 'رياح قوية' : 'Strong Breeze';
    } else if (speedMps < 17.2) {
      return isArabic ? 'رياح عاتية' : 'Near Gale';
    } else if (speedMps < 20.7) {
      return isArabic ? 'عاصفة' : 'Gale';
    } else {
      return isArabic ? 'عاصفة شديدة' : 'Severe Storm';
    }
  }

  String _getCardinalDirection(int deg, bool isArabic) {
    const directionsEn = ['N', 'NE', 'E', 'SE', 'S', 'SW', 'W', 'NW'];
    const directionsAr = ['شمال', 'شمال شرق', 'شرق', 'جنوب شرق', 'جنوب', 'جنوب غرب', 'غرب', 'شمال غرب'];
    final index = ((deg + 22.5) % 360 ~/ 45);
    return isArabic ? directionsAr[index] : directionsEn[index];
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    final windStr = UnitConverter.formatWindSpeed(weather.windSpeed, unitSystem);
    final beaufortDesc = _getBeaufortScale(weather.windSpeed, isArabic);
    final cardinal = _getCardinalDirection(weather.windDeg, isArabic);
    final gustSpeed = (weather.windSpeed * 1.35);
    final gustStr = UnitConverter.formatWindSpeed(gustSpeed, unitSystem);

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
                  const Icon(Icons.air_rounded, size: 18, color: Color(0xFF38BDF8)),
                  const SizedBox(width: 8),
                  Text(
                    l10n?.windCompass ?? 'Wind & Direction',
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
                  beaufortDesc,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF38BDF8),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Compass Dial & Stats Row
          Row(
            children: [
              // Circular Compass Rose
              SizedBox(
                width: 115,
                height: 115,
                child: CustomPaint(
                  painter: _CompassPainter(
                    degrees: weather.windDeg.toDouble(),
                  ),
                ),
              ),

              const SizedBox(width: 20),

              // Wind Stats
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      windStr,
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$cardinal (${weather.windDeg}°)',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        l10n?.windGust(gustStr) ?? 'Gusts up to $gustStr',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white.withOpacity(0.75),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CompassPainter extends CustomPainter {
  final double degrees;

  _CompassPainter({required this.degrees});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // 1. Dial Ring Background
    final dialBg = Paint()
      ..color = Colors.black.withOpacity(0.25)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius, dialBg);

    // 2. Outer Ring Stroke
    final ringPaint = Paint()
      ..color = Colors.white.withOpacity(0.18)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    canvas.drawCircle(center, radius - 2, ringPaint);

    // 3. Cardinal Direction Ticks & Letters
    final tickPaint = Paint()
      ..color = Colors.white.withOpacity(0.4)
      ..strokeWidth = 1.5;

    const cardinals = ['N', 'E', 'S', 'W'];
    for (int i = 0; i < 16; i++) {
      final angle = (i * 2 * pi) / 16;
      final isCardinal = i % 4 == 0;
      final inner = radius - (isCardinal ? 9.0 : 5.0);
      final outer = radius - 3.0;

      final start = Offset(center.dx + cos(angle) * inner, center.dy + sin(angle) * inner);
      final end = Offset(center.dx + cos(angle) * outer, center.dy + sin(angle) * outer);
      canvas.drawLine(start, end, tickPaint);

      if (isCardinal) {
        final letter = cardinals[i ~/ 4];
        final textPainter = TextPainter(
          text: TextSpan(
            text: letter,
            style: TextStyle(
              color: letter == 'N' ? const Color(0xFFF43F5E) : Colors.white70,
              fontSize: 9,
              fontWeight: FontWeight.bold,
            ),
          ),
          textDirection: TextDirection.ltr,
        )..layout();

        final textRadius = radius - 16;
        final textPos = Offset(
          center.dx + cos(angle - pi / 2) * textRadius - textPainter.width / 2,
          center.dy + sin(angle - pi / 2) * textRadius - textPainter.height / 2,
        );
        textPainter.paint(canvas, textPos);
      }
    }

    // 4. Rotating Aerodynamic Compass Arrow
    final rad = (degrees - 90) * (pi / 180);
    final needleLength = radius * 0.72;

    // North Tip (Pointed towards wind)
    final northTip = Offset(center.dx + cos(rad) * needleLength, center.dy + sin(rad) * needleLength);
    final southTip = Offset(center.dx - cos(rad) * (needleLength * 0.75), center.dy - sin(rad) * (needleLength * 0.75));
    final leftWing = Offset(center.dx + cos(rad + pi / 2) * 8.0, center.dy + sin(rad + pi / 2) * 8.0);
    final rightWing = Offset(center.dx + cos(rad - pi / 2) * 8.0, center.dy + sin(rad - pi / 2) * 8.0);

    // North Wing (Cyan / Blue)
    final northPath = Path()
      ..moveTo(northTip.dx, northTip.dy)
      ..lineTo(leftWing.dx, leftWing.dy)
      ..lineTo(center.dx, center.dy)
      ..close();
    final northPaint = Paint()..color = const Color(0xFF38BDF8);
    canvas.drawPath(northPath, northPaint);

    final northPath2 = Path()
      ..moveTo(northTip.dx, northTip.dy)
      ..lineTo(rightWing.dx, rightWing.dy)
      ..lineTo(center.dx, center.dy)
      ..close();
    final northPaint2 = Paint()..color = const Color(0xFF0284C7);
    canvas.drawPath(northPath2, northPaint2);

    // South Wing (White / Light)
    final southPath = Path()
      ..moveTo(southTip.dx, southTip.dy)
      ..lineTo(leftWing.dx, leftWing.dy)
      ..lineTo(center.dx, center.dy)
      ..close();
    final southPaint = Paint()..color = Colors.white.withOpacity(0.5);
    canvas.drawPath(southPath, southPaint);

    final southPath2 = Path()
      ..moveTo(southTip.dx, southTip.dy)
      ..lineTo(rightWing.dx, rightWing.dy)
      ..lineTo(center.dx, center.dy)
      ..close();
    final southPaint2 = Paint()..color = Colors.white.withOpacity(0.3);
    canvas.drawPath(southPath2, southPaint2);

    // Center Cap
    final centerCap = Paint()..color = Colors.white;
    canvas.drawCircle(center, 4, centerCap);
  }

  @override
  bool shouldRepaint(covariant _CompassPainter oldDelegate) {
    return oldDelegate.degrees != degrees;
  }
}
