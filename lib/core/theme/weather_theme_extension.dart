import 'package:flutter/material.dart';
import 'app_colors.dart';

class WeatherThemeExtension extends ThemeExtension<WeatherThemeExtension> {
  final List<Color> backgroundGradient;
  final Color cardBackground;
  final Color cardBorder;
  final Color accentColor;

  const WeatherThemeExtension({
    required this.backgroundGradient,
    required this.cardBackground,
    required this.cardBorder,
    required this.accentColor,
  });

  factory WeatherThemeExtension.forCondition({
    required String conditionCode,
    required bool isDark,
  }) {
    List<Color> gradient;
    Color accent;

    // Condition mapping based on OpenWeather condition strings or codes
    final code = conditionCode.toLowerCase();

    if (code.contains('thunder') || code.startsWith('2')) {
      gradient = AppColors.thunderstormGradient;
      accent = AppColors.accentPurple;
    } else if (code.contains('drizzle') || code.contains('rain') || code.startsWith('3') || code.startsWith('5')) {
      gradient = AppColors.rainGradient;
      accent = AppColors.accentCyan;
    } else if (code.contains('snow') || code.startsWith('6')) {
      gradient = AppColors.snowGradient;
      accent = AppColors.accentCyan;
    } else if (code.contains('cloud') || code.startsWith('80')) {
      gradient = AppColors.cloudyGradient;
      accent = AppColors.accentAmber;
    } else if (code.contains('night') || code.contains('n')) {
      gradient = AppColors.clearNightGradient;
      accent = AppColors.accentPurple;
    } else {
      // Clear day / Sunny
      gradient = AppColors.sunnyGradient;
      accent = AppColors.accentAmber;
    }

    return WeatherThemeExtension(
      backgroundGradient: gradient,
      cardBackground: isDark
          ? Colors.black.withOpacity(0.35)
          : Colors.white.withOpacity(0.45),
      cardBorder: isDark
          ? Colors.white.withOpacity(0.12)
          : Colors.black.withOpacity(0.08),
      accentColor: accent,
    );
  }

  @override
  ThemeExtension<WeatherThemeExtension> copyWith({
    List<Color>? backgroundGradient,
    Color? cardBackground,
    Color? cardBorder,
    Color? accentColor,
  }) {
    return WeatherThemeExtension(
      backgroundGradient: backgroundGradient ?? this.backgroundGradient,
      cardBackground: cardBackground ?? this.cardBackground,
      cardBorder: cardBorder ?? this.cardBorder,
      accentColor: accentColor ?? this.accentColor,
    );
  }

  @override
  ThemeExtension<WeatherThemeExtension> lerp(
    covariant ThemeExtension<WeatherThemeExtension>? other,
    double t,
  ) {
    if (other is! WeatherThemeExtension) return this;
    return WeatherThemeExtension(
      backgroundGradient: backgroundGradient,
      cardBackground: Color.lerp(cardBackground, other.cardBackground, t) ?? cardBackground,
      cardBorder: Color.lerp(cardBorder, other.cardBorder, t) ?? cardBorder,
      accentColor: Color.lerp(accentColor, other.accentColor, t) ?? accentColor,
    );
  }
}
