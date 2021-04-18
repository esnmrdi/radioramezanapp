// loading required packages
import 'package:flutter/material.dart';

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
  static const MaterialColor darky = MaterialColor(
    0xFF323232,
    <int, Color>{
      500: Color(0xFF323232),
    }
  );
}

final lightTheme = ThemeData(
  primaryColor: RadioRamezanColors.ramady,
  accentColor: RadioRamezanColors.ramady,
  scaffoldBackgroundColor: RadioRamezanColors.ramady.withOpacity(.1),
  fontFamily: 'Sans',
  brightness: Brightness.light,
);

final darkTheme = ThemeData(
  primaryColor: RadioRamezanColors.darky,
  accentColor: RadioRamezanColors.darky,
  scaffoldBackgroundColor: RadioRamezanColors.darky.withOpacity(.1),
  fontFamily: 'Sans',
  brightness: Brightness.light,
);
