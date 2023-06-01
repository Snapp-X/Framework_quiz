import 'package:flutter/material.dart';

ThemeData buildCustomThemeData(BuildContext context) {
  return ThemeData(
    scaffoldBackgroundColor: Colors.black,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.black,
      titleTextStyle: TextStyle(
        fontFamily: 'Switzer',
        fontWeight: FontWeight.w400,
        fontSize: MediaQuery.of(context).size.height * 0.015,
        color: Colors.white.withOpacity(0.5),
      ),
    ),
    textTheme: TextTheme(
      bodyLarge: TextStyle(
        fontFamily: 'Switzer',
        fontWeight: FontWeight.w500,
        fontSize: MediaQuery.of(context).size.width * 0.015,
        color: Colors.white,
      ),
      bodyMedium: TextStyle(
        fontFamily: 'Switzer',
        fontWeight: FontWeight.w500,
        fontSize: MediaQuery.of(context).size.width * 0.015,
        color: Colors.white.withOpacity(0.5),
      ),
      displayLarge: TextStyle(
        fontFamily: 'Clash Grotesk Display',
        fontWeight: FontWeight.w600,
        fontSize: MediaQuery.of(context).size.width * 0.05,
        color: Colors.white,
      ),
      labelLarge: TextStyle(
        fontFamily: 'SF Pro Text',
        fontWeight: FontWeight.w600,
        fontSize: MediaQuery.of(context).size.width * 0.015,
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
            return const Color(0xFF141414);
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
              return const Color(0xFF36343B);
            }
            return const Color(0xFF78FCB0);
          },
        ),
      ),
    ),
    checkboxTheme: CheckboxThemeData(
      fillColor: MaterialStateProperty.resolveWith<Color>(
        (Set<MaterialState> states) {
          if (states.contains(MaterialState.selected)) {
            return const Color(0xFF78FCB0);
          }
          return Colors.white.withOpacity(0.5);
        },
      ),
      overlayColor: MaterialStateProperty.all<Color>(
        Colors.white.withOpacity(0.5),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
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
