// loading required packages
import 'package:flutter/material.dart';
import 'package:dynamic_theme/dynamic_theme.dart';

class RadioRamezanColors {
  static const MaterialColor ramady = MaterialColor(
    0xFF822C61,
    <int, Color>{
      50: Color(0xFFC5B6D8),
      100: Color(0xFFB79AC7),
      200: Color(0xFFAD7EB7),
      300: Color(0xFFA562A5),
      400: Color(0xFF944785),
      500: Color(0xFF822C61),
      600: Color(0xFF732545),
      700: Color(0xFF641F2C),
      800: Color(0xFF541A19),
      900: Color(0xFF441E13),
    },
  );
  static const MaterialColor redy = MaterialColor(
    0xFFD01111,
    <int, Color>{
      50: Color(0xFFF9E2E2),
      100: Color(0xFFF1B8B8),
      200: Color(0xFFE88888),
      300: Color(0xFFDE5858),
      400: Color(0xFFD73535),
      500: Color(0xFFD01111),
      600: Color(0xFFCB0F0F),
      700: Color(0xFFC40C0C),
      800: Color(0xFFBE0A0A),
      900: Color(0xFFB30505),
    },
  );
  static const MaterialColor goldy = MaterialColor(
    0xFFFFC107,
    <int, Color>{
      50: Color(0xFFFFF8E1),
      100: Color(0xFFFFECB5),
      200: Color(0xFFFFE083),
      300: Color(0xFFFFD451),
      400: Color(0xFFFFCA2C),
      500: Color(0xFFFFC107),
      600: Color(0xFFFFBB06),
      700: Color(0xFFFFB305),
      800: Color(0xFFFFAB04),
      900: Color(0xFFFF9E02),
    },
  );
}

final lightTheme = ThemeData(
  primaryColor: RadioRamezanColors.ramady,
  accentColor: RadioRamezanColors.ramady,
  fontFamily: 'Sans',
  brightness: Brightness.light,
);

final darkTheme = ThemeData(
  primaryColor: RadioRamezanColors.ramady,
  accentColor: RadioRamezanColors.ramady,
  fontFamily: 'Sans',
  brightness: Brightness.dark,
);

void toggleBrightness(BuildContext context, bool value) {
  DynamicTheme.of(context).setBrightness(
    value ? Brightness.dark : Brightness.light,
  );
}
