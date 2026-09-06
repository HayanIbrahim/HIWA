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

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final weatherTheme = Theme.of(context).extension<WeatherThemeExtension>() ??
        WeatherThemeExtension.forCondition(
          conditionCode: '800',
          isDark: Theme.of(context).brightness == Brightness.dark,
        );

    return AnimatedBuilder(
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

            // Particle / Atmospheric Painter
            CustomPaint(
              painter: _AtmosphericPainter(
                progress: _controller.value,
                weatherType: widget.weatherType,
              ),
            ),

            // Child content
            widget.child,
          ],
        );
      },
    );
  }
}

class _AtmosphericPainter extends CustomPainter {
  final double progress;
  final WeatherType weatherType;
  final Random _random = Random(42);

  _AtmosphericPainter({
    required this.progress,
    required this.weatherType,
  });

  @override
  void paint(Canvas canvas, Size size) {
    switch (weatherType) {
      case WeatherType.rain:
      case WeatherType.thunderstorm:
        _drawRain(canvas, size);
        break;
      case WeatherType.snow:
        _drawSnow(canvas, size);
        break;
      case WeatherType.clearNight:
        _drawStars(canvas, size);
        break;
      case WeatherType.clearDay:
        _drawSunRays(canvas, size);
        break;
      default:
        _drawClouds(canvas, size);
        break;
    }
  }

  void _drawRain(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.35)
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;

    const count = 45;
    for (int i = 0; i < count; i++) {
      final x = (_random.nextDouble() * size.width);
      final speed = 0.8 + (_random.nextDouble() * 0.4);
      final y = ((_random.nextDouble() + progress * speed) % 1.0) * size.height;
      canvas.drawLine(
        Offset(x, y),
        Offset(x - 3, y + 15),
        paint,
      );
    }
  }

  void _drawSnow(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white.withOpacity(0.55);
    const count = 40;
    for (int i = 0; i < count; i++) {
      final x = (_random.nextDouble() * size.width) + sin(progress * 2 * pi + i) * 10;
      final speed = 0.3 + (_random.nextDouble() * 0.3);
      final y = ((_random.nextDouble() + progress * speed) % 1.0) * size.height;
      final radius = 1.5 + (_random.nextDouble() * 2.5);
      canvas.drawCircle(Offset(x, y), radius, paint);
    }
  }

  void _drawStars(Canvas canvas, Size size) {
    const count = 50;
    for (int i = 0; i < count; i++) {
      final x = _random.nextDouble() * size.width;
      final y = _random.nextDouble() * (size.height * 0.65);
      final opacity = (0.2 + 0.8 * sin(progress * 2 * pi + i).abs()).clamp(0.1, 0.9);
      final paint = Paint()..color = Colors.white.withOpacity(opacity);
      canvas.drawCircle(Offset(x, y), 1.2, paint);
    }
  }

  void _drawSunRays(Canvas canvas, Size size) {
    final center = Offset(size.width * 0.85, size.height * 0.15);
    final paint = Paint()
      ..shader = RadialGradient(
        colors: [
          Colors.amberAccent.withOpacity(0.25 + 0.1 * sin(progress * 2 * pi)),
          Colors.amber.withOpacity(0.0),
        ],
      ).createShader(Rect.fromCircle(center: center, radius: size.width * 0.55));

    canvas.drawCircle(center, size.width * 0.55, paint);
  }

  void _drawClouds(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white.withOpacity(0.06);
    final offset = (progress * size.width * 0.2);
    canvas.drawCircle(Offset(size.width * 0.3 + offset, size.height * 0.12), 90, paint);
    canvas.drawCircle(Offset(size.width * 0.7 - offset, size.height * 0.18), 120, paint);
  }

  @override
  bool shouldRepaint(covariant _AtmosphericPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.weatherType != weatherType;
  }
}
