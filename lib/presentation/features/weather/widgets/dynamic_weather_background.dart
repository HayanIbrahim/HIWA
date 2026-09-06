import 'dart:math';
import 'package:flutter/material.dart';
import '../../../../core/theme/weather_theme_extension.dart';
import '../../../../core/utils/weather_mapper.dart';

class DynamicWeatherBackground extends StatefulWidget {
  final WeatherType weatherType;
  final Widget child;

  const DynamicWeatherBackground({
    super.key,
    required this.weatherType,
    required this.child,
  });

  @override
  State<DynamicWeatherBackground> createState() => _DynamicWeatherBackgroundState();
}

class _DynamicWeatherBackgroundState extends State<DynamicWeatherBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  double _windDeflection = 0.0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handlePanUpdate(DragUpdateDetails details) {
    setState(() {
      _windDeflection = (_windDeflection + details.delta.dx * 0.05).clamp(-20.0, 20.0);
    });
  }

  void _handlePanEnd(DragEndDetails details) {
    // Smoothly return deflection to zero
    setState(() {
      _windDeflection = 0.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final weatherTheme = Theme.of(context).extension<WeatherThemeExtension>() ??
        WeatherThemeExtension.forCondition(
          conditionCode: '800',
          isDark: Theme.of(context).brightness == Brightness.dark,
        );

    return GestureDetector(
      onHorizontalDragUpdate: _handlePanUpdate,
      onHorizontalDragEnd: _handlePanEnd,
      behavior: HitTestBehavior.translucent,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Stack(
            fit: StackFit.expand,
            children: [
              // Dynamic Gradient Layer
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: weatherTheme.backgroundGradient,
                  ),
                ),
              ),

              // Living Atmospheric Canvas
              CustomPaint(
                painter: _AtmosphericPainter(
                  progress: _controller.value,
                  weatherType: widget.weatherType,
                  windDeflection: _windDeflection,
                ),
              ),

              // Main Child Content
              widget.child,
            ],
          );
        },
      ),
    );
  }
}

class _AtmosphericPainter extends CustomPainter {
  final double progress;
  final WeatherType weatherType;
  final double windDeflection;
  final Random _random = Random(1337);

  _AtmosphericPainter({
    required this.progress,
    required this.weatherType,
    this.windDeflection = 0.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    switch (weatherType) {
      case WeatherType.thunderstorm:
        _drawThunderstorm(canvas, size);
        break;
      case WeatherType.rain:
        _drawRain(canvas, size, heavy: true);
        break;
      case WeatherType.snow:
        _drawSnow(canvas, size);
        break;
      case WeatherType.clearNight:
        _drawNightSky(canvas, size);
        break;
      case WeatherType.clearDay:
        _drawSunnyDay(canvas, size);
        break;
      case WeatherType.mist:
        _drawMist(canvas, size);
        break;
      case WeatherType.cloudy:
        _drawClouds(canvas, size);
        break;
    }
  }

  void _drawThunderstorm(Canvas canvas, Size size) {
    // 1. Draw lightning flash cycle
    final flashCycle = (progress * 5.0) % 1.0;
    if (flashCycle > 0.88 && flashCycle < 0.94) {
      final flashIntensity = sin((flashCycle - 0.88) / 0.06 * pi);
      final flashPaint = Paint()
        ..color = const Color(0xFFE0E7FF).withOpacity(flashIntensity * 0.35);
      canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), flashPaint);

      // Branching lightning bolt
      _drawLightningBolt(canvas, size, flashIntensity);
    }

    // 2. Heavy angled rain with splash ripples
    _drawRain(canvas, size, heavy: true);
  }

  void _drawLightningBolt(Canvas canvas, Size size, double intensity) {
    final boltPaint = Paint()
      ..color = Colors.white.withOpacity(intensity.clamp(0.0, 1.0))
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final glowPaint = Paint()
      ..color = const Color(0xFFA5B4FC).withOpacity(intensity * 0.4)
      ..strokeWidth = 8.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final startX = size.width * 0.45;
    final path = Path()..moveTo(startX, 0);

    double currentX = startX;
    double currentY = 0;
    final segments = 8;
    final segmentHeight = (size.height * 0.55) / segments;

    for (int i = 0; i < segments; i++) {
      currentY += segmentHeight;
      currentX += (i % 2 == 0 ? 18.0 : -14.0);
      path.lineTo(currentX, currentY);
    }

    canvas.drawPath(path, glowPaint);
    canvas.drawPath(path, boltPaint);
  }

  void _drawRain(Canvas canvas, Size size, {bool heavy = false}) {
    final dropPaint = Paint()
      ..color = Colors.white.withOpacity(heavy ? 0.42 : 0.30)
      ..strokeWidth = heavy ? 1.8 : 1.2
      ..strokeCap = StrokeCap.round;

    final count = heavy ? 65 : 45;
    final angleOffset = windDeflection + (heavy ? -8.0 : -4.0);

    for (int i = 0; i < count; i++) {
      final xBase = (_random.nextDouble() * size.width);
      final speed = 0.9 + (_random.nextDouble() * 0.5);
      final y = ((_random.nextDouble() + progress * speed) % 1.0) * size.height;
      final x = xBase + (y / size.height) * angleOffset;
      final length = 14.0 + (_random.nextDouble() * 12.0);

      canvas.drawLine(
        Offset(x, y),
        Offset(x + angleOffset * 0.3, y + length),
        dropPaint,
      );

      // Splash ripples near bottom
      if (y > size.height * 0.85 && i % 3 == 0) {
        final rippleProgress = (y - size.height * 0.85) / (size.height * 0.15);
        final ripplePaint = Paint()
          ..color = Colors.white.withOpacity((1.0 - rippleProgress) * 0.25)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.0;
        canvas.drawOval(
          Rect.fromCenter(
            center: Offset(x, size.height - 4),
            width: 12.0 * rippleProgress + 4,
            height: 3.5 * rippleProgress + 1,
          ),
          ripplePaint,
        );
      }
    }
  }

  void _drawSnow(Canvas canvas, Size size) {
    const count = 55;
    for (int i = 0; i < count; i++) {
      final speed = 0.2 + (_random.nextDouble() * 0.3);
      final radius = 1.4 + (_random.nextDouble() * 2.8);
      final opacity = 0.35 + (_random.nextDouble() * 0.5);
      final paint = Paint()..color = Colors.white.withOpacity(opacity);

      final sway = sin(progress * 2 * pi * 1.5 + i) * (14.0 + windDeflection);
      final x = ((_random.nextDouble() * size.width) + sway) % size.width;
      final y = ((_random.nextDouble() + progress * speed) % 1.0) * size.height;

      canvas.drawCircle(Offset(x, y), radius, paint);
    }
  }

  void _drawNightSky(Canvas canvas, Size size) {
    // 1. Twinkling Stars
    const starCount = 65;
    for (int i = 0; i < starCount; i++) {
      final x = _random.nextDouble() * size.width;
      final y = _random.nextDouble() * (size.height * 0.75);
      final twinkleSpeed = 1.0 + (_random.nextDouble() * 2.5);
      final opacity =
          (0.2 + 0.8 * sin(progress * 2 * pi * twinkleSpeed + i).abs()).clamp(0.15, 0.95);
      final radius = 0.8 + (_random.nextDouble() * 1.6);

      final paint = Paint()..color = Colors.white.withOpacity(opacity);
      canvas.drawCircle(Offset(x, y), radius, paint);
    }

    // 2. High-speed Shooting Star (Meteor streak)
    final meteorCycle = (progress * 2.5) % 1.0;
    if (meteorCycle > 0.70 && meteorCycle < 0.82) {
      final meteorProgress = (meteorCycle - 0.70) / 0.12;
      final startX = size.width * 0.85 - (meteorProgress * size.width * 0.6);
      final startY = size.height * 0.08 + (meteorProgress * size.height * 0.25);
      final tailLength = 45.0;

      final meteorPaint = Paint()
        ..shader = LinearGradient(
          colors: [
            Colors.white.withOpacity((1.0 - meteorProgress) * 0.9),
            Colors.white.withOpacity(0.0),
          ],
        ).createShader(Rect.fromPoints(
          Offset(startX, startY),
          Offset(startX + tailLength, startY - tailLength * 0.5),
        ))
        ..strokeWidth = 1.8
        ..strokeCap = StrokeCap.round;

      canvas.drawLine(
        Offset(startX, startY),
        Offset(startX + tailLength, startY - tailLength * 0.5),
        meteorPaint,
      );
    }
  }

  void _drawSunnyDay(Canvas canvas, Size size) {
    final sunCenter = Offset(size.width * 0.82, size.height * 0.14);

    // 1. Radiant breathing halo
    final breath = sin(progress * 2 * pi) * 0.08;
    final haloPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0xFFFDE047).withOpacity(0.28 + breath),
          const Color(0xFFF59E0B).withOpacity(0.10),
          Colors.transparent,
        ],
        stops: const [0.0, 0.5, 1.0],
      ).createShader(Rect.fromCircle(center: sunCenter, radius: size.width * 0.65));

    canvas.drawCircle(sunCenter, size.width * 0.65, haloPaint);

    // 2. Rotating light beams / solar corona
    final rayPaint = Paint()
      ..color = const Color(0xFFFEF08A).withOpacity(0.07 + breath * 0.5)
      ..style = PaintingStyle.fill;

    canvas.save();
    canvas.translate(sunCenter.dx, sunCenter.dy);
    canvas.rotate(progress * 2 * pi * 0.3);

    const rayCount = 8;
    for (int i = 0; i < rayCount; i++) {
      final angle = (i * 2 * pi) / rayCount;
      final rayPath = Path()
        ..moveTo(0, 0)
        ..lineTo(cos(angle - 0.12) * size.width * 0.7, sin(angle - 0.12) * size.width * 0.7)
        ..lineTo(cos(angle + 0.12) * size.width * 0.7, sin(angle + 0.12) * size.width * 0.7)
        ..close();
      canvas.drawPath(rayPath, rayPaint);
    }
    canvas.restore();

    // 3. Floating warm sun motes
    const moteCount = 18;
    for (int i = 0; i < moteCount; i++) {
      final x = (_random.nextDouble() * size.width + windDeflection) % size.width;
      final y = ((_random.nextDouble() - progress * 0.2) % 1.0) * size.height;
      final motePaint = Paint()
        ..color = const Color(0xFFFEF9C3).withOpacity(0.25 + 0.2 * sin(progress * 4 * pi + i).abs());
      canvas.drawCircle(Offset(x, y), 2.0, motePaint);
    }
  }

  void _drawClouds(Canvas canvas, Size size) {
    final cloudPaint1 = Paint()..color = Colors.white.withOpacity(0.07);
    final cloudPaint2 = Paint()..color = Colors.white.withOpacity(0.05);

    final offset1 = (progress * size.width * 0.18) % (size.width + 200);
    final offset2 = (progress * size.width * 0.10) % (size.width + 200);

    // Layer 1 - Fore clouds
    canvas.drawCircle(Offset(size.width * 0.2 + offset1 - 100, size.height * 0.12), 110, cloudPaint1);
    canvas.drawCircle(Offset(size.width * 0.55 + offset1 - 100, size.height * 0.15), 140, cloudPaint1);
    canvas.drawCircle(Offset(size.width * 0.85 + offset1 - 100, size.height * 0.11), 95, cloudPaint1);

    // Layer 2 - Back clouds
    canvas.drawCircle(Offset(size.width * 0.35 + offset2 - 80, size.height * 0.20), 130, cloudPaint2);
    canvas.drawCircle(Offset(size.width * 0.75 + offset2 - 80, size.height * 0.22), 160, cloudPaint2);
  }

  void _drawMist(Canvas canvas, Size size) {
    final mistPaint = Paint()
      ..color = Colors.white.withOpacity(0.08)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 30);

    for (int i = 0; i < 4; i++) {
      final y = size.height * (0.2 + i * 0.18);
      final offset = sin(progress * 2 * pi + i) * 30;
      canvas.drawOval(
        Rect.fromCenter(center: Offset(size.width * 0.5 + offset, y), width: size.width * 1.2, height: 90),
        mistPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _AtmosphericPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.weatherType != weatherType ||
        oldDelegate.windDeflection != windDeflection;
  }
}
