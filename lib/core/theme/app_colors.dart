import 'package:flutter/material.dart';

class AppColors {
  // Brand / Primary
  static const Color primary = Color(0xFF2563EB); // Royal Blue
  static const Color primaryLight = Color(0xFF60A5FA);
  static const Color primaryDark = Color(0xFF1E40AF);

  // Backgrounds - Dark
  static const Color darkBg = Color(0xFF0F172A); // Slate 900
  static const Color darkSurface = Color(0xFF1E293B); // Slate 800
  static const Color darkCard = Color(0xFF334155); // Slate 700
  static const Color darkBorder = Color(0xFF475569);

  // Backgrounds - Light
  static const Color lightBg = Color(0xFFF8FAFC); // Slate 50
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightCard = Color(0xFFF1F5F9);
  static const Color lightBorder = Color(0xFFE2E8F0);

  // Text
  static const Color textPrimaryLight = Color(0xFF0F172A);
  static const Color textSecondaryLight = Color(0xFF64748B);
  static const Color textPrimaryDark = Color(0xFFF8FAFC);
  static const Color textSecondaryDark = Color(0xFF94A3B8);

  // Accents & Semantics
  static const Color accentCyan = Color(0xFF06B6D4);
  static const Color accentAmber = Color(0xFFF59E0B);
  static const Color accentEmerald = Color(0xFF10B981);
  static const Color accentRose = Color(0xFFF43F5E);
  static const Color accentPurple = Color(0xFF8B5CF6);

  // Weather Condition Gradients
  static const List<Color> sunnyGradient = [
    Color(0xFFF59E0B), // Warm Amber
    Color(0xFF3B82F6), // Azure Blue
    Color(0xFF1D4ED8), // Deep Blue
  ];

  static const List<Color> clearNightGradient = [
    Color(0xFF0F172A), // Dark Slate
    Color(0xFF1E1B4B), // Midnight Indigo
    Color(0xFF311042), // Deep Violet
  ];

  static const List<Color> cloudyGradient = [
    Color(0xFF475569), // Slate Gray
    Color(0xFF334155), // Steel
    Color(0xFF1E293B), // Dark Navy
  ];

  static const List<Color> rainGradient = [
    Color(0xFF1E3A8A), // Navy
    Color(0xFF0E7490), // Deep Cyan
    Color(0xFF0F172A), // Slate
  ];

  static const List<Color> thunderstormGradient = [
    Color(0xFF311042), // Midnight Violet
    Color(0xFF1E293B), // Dark Slate
    Color(0xFF090D16), // Pitch Black
  ];

  static const List<Color> snowGradient = [
    Color(0xFF93C5FD), // Ice Blue
    Color(0xFF60A5FA), // Sky Blue
    Color(0xFF1E3A8A), // Deep Frost
  ];
}
