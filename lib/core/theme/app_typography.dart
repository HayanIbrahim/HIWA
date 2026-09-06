import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTypography {
  static TextTheme getTextTheme({required String locale}) {
    final bool isArabic = locale.toLowerCase().startsWith('ar');

    if (isArabic) {
      return GoogleFonts.cairoTextTheme();
    } else {
      return GoogleFonts.outfitTextTheme();
    }
  }

  // Hero temperature typography
  static TextStyle heroTempStyle({
    required BuildContext context,
    required bool isArabic,
    Color? color,
  }) {
    final fontFunction = isArabic ? GoogleFonts.cairo : GoogleFonts.outfit;
    return fontFunction(
      fontSize: 84,
      fontWeight: FontWeight.w200,
      letterSpacing: -2.0,
      color: color ?? Theme.of(context).colorScheme.onSurface,
      height: 1.0,
    );
  }

  // City headline style
  static TextStyle cityTitleStyle({
    required BuildContext context,
    required bool isArabic,
    Color? color,
  }) {
    final fontFunction = isArabic ? GoogleFonts.cairo : GoogleFonts.outfit;
    return fontFunction(
      fontSize: 32,
      fontWeight: FontWeight.w700,
      letterSpacing: -0.5,
      color: color ?? Theme.of(context).colorScheme.onSurface,
    );
  }
}
