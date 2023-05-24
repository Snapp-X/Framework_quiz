import 'package:flutter/material.dart';

ThemeData buildCustomThemeData() {
  return ThemeData(
    scaffoldBackgroundColor: Colors.black,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.black,
      titleTextStyle: TextStyle(
        fontFamily: 'Switzer',
        fontWeight: FontWeight.w400,
        fontSize: 20,
        color: Colors.white.withOpacity(0.5),
      ),
    ),
    textTheme: TextTheme(
      bodyLarge: TextStyle(
        fontFamily: 'Switzer',
        fontWeight: FontWeight.w500,
        fontSize: 20,
        color: Colors.white,
      ),
      bodyMedium: TextStyle(
        fontFamily: 'Switzer',
        fontWeight: FontWeight.w500,
        fontSize: 20,
        color: Colors.white.withOpacity(0.5),
      ),
      displayLarge: TextStyle(
        fontFamily: 'Clash Grotesk Display',
        fontWeight: FontWeight.w600,
        fontSize: 60,
        color: Colors.white,
      ),
      labelLarge: TextStyle(
        fontFamily: 'SF Pro Text',
        fontWeight: FontWeight.w600,
        fontSize: 18,
        color: Colors.black,
      ),
    ),
    dividerColor: Colors.white.withOpacity(0.5),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.resolveWith<Color>(
          (Set<MaterialState> states) {
            if (states.contains(MaterialState.disabled)) {
              return Colors.white.withOpacity(0.5);
            }
            return Color(0xFF141414);
          },
        ),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
          ),
        ),
        backgroundColor: MaterialStateProperty.resolveWith<Color>(
          (Set<MaterialState> states) {
            if (states.contains(MaterialState.disabled)) {
              return Color(0xFF36343B);
            }
            return Color(0xFF78FCB0);
          },
        ),
      ),
    ),
    radioTheme: RadioThemeData(
      fillColor: MaterialStateProperty.resolveWith<Color>(
        (Set<MaterialState> states) {
          if (states.contains(MaterialState.selected)) {
            return Color(0xFF78FCB0);
          }
          return Colors.white.withOpacity(0.5);
        },
      ),
      overlayColor: MaterialStateProperty.all<Color>(
        Colors.white.withOpacity(0.5),
      ),
      splashRadius: 0,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      mouseCursor: MaterialStateProperty.resolveWith<MouseCursor?>(
        (Set<MaterialState> states) {
          return MaterialStateMouseCursor.clickable;
        },
      ),
    ),
  );
}
