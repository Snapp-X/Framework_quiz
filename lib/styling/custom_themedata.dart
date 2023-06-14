import 'package:flutter/material.dart';
import 'package:snappx_quiz/styling/colors.dart';

ThemeData buildCustomThemeData(BuildContext context, bool isMobileDevice) {
  return ThemeData(
    scaffoldBackgroundColor: FunnyWebAppColors.background,
    appBarTheme: AppBarTheme(
      backgroundColor: FunnyWebAppColors.background,
      titleTextStyle: TextStyle(
        fontFamily: 'Switzer',
        fontWeight: FontWeight.w400,
        fontSize: MediaQuery.of(context).size.height * 0.017,
        color: Colors.white.withOpacity(0.5),
      ),
    ),
    textTheme: TextTheme(
      headlineMedium: TextStyle(
        fontFamily: 'Switzer',
        fontWeight: FontWeight.w500,
        fontSize: MediaQuery.of(context).size.height * 0.013,
        color: Colors.white.withOpacity(0.5),
      ),
      headlineSmall: TextStyle(
        fontFamily: 'Switzer',
        fontWeight: FontWeight.w300,
        fontSize: isMobileDevice ? 16 : 18,
        color: Colors.white.withOpacity(0.3),
      ),
      bodyLarge: TextStyle(
        fontFamily: 'Switzer',
        fontWeight: FontWeight.w500,
        fontSize: MediaQuery.of(context).size.width * 0.013,
        color: Colors.white,
      ),
      bodyMedium: TextStyle(
        fontFamily: 'Switzer',
        fontWeight: FontWeight.w500,
        fontSize: isMobileDevice ? 16 : 18,
        color: Colors.white.withOpacity(0.5),
      ),
      bodySmall: TextStyle(
        fontFamily: 'Switzer',
        fontWeight: FontWeight.w300,
        fontSize: MediaQuery.of(context).size.width * 0.013,
        color: Colors.white.withOpacity(0.3),
      ),
      displayMedium: TextStyle(
        fontFamily: 'Switzer',
        fontWeight: FontWeight.w500,
        fontSize: isMobileDevice ? 18 : 35,
        color: Colors.white,
      ),
      displaySmall: const TextStyle(
        fontFamily: 'Switzer',
        fontWeight: FontWeight.w500,
        fontSize: 20.0,
        color: Colors.white,
      ),
      displayLarge: const TextStyle(
        fontFamily: 'Clash Grotesk Display',
        fontWeight: FontWeight.w600,
        fontSize: 47,
        color: Colors.white,
      ),
      labelSmall: const TextStyle(
        fontFamily: 'Clash Grotesk Display',
        fontWeight: FontWeight.w600,
        fontSize: 12.0,
        color: Colors.black,
      ),
      labelMedium: const TextStyle(
        fontFamily: 'Clash Grotesk Display',
        fontWeight: FontWeight.w600,
        fontSize: 14.0,
        color: Colors.white,
      ),
      labelLarge: const TextStyle(
        fontFamily: 'Clash Grotesk Display',
        fontWeight: FontWeight.w600,
        fontSize: 18.0,
        color: Colors.black,
      ),
    ),
    dividerColor: const Color(0xFF36343B).withOpacity(0.5),
    scrollbarTheme: ScrollbarThemeData(
      trackVisibility: MaterialStateProperty.all<bool>(false),
      thumbVisibility: MaterialStateProperty.all<bool>(true),
      interactive: true,
      radius: const Radius.circular(10.0),
      thumbColor: MaterialStateProperty.all<Color>(
        const Color(0xFF36343B),
      ),
      thickness: MaterialStateProperty.all(5.0),
      minThumbLength: 10,
      trackColor: MaterialStateProperty.all<Color>(
        const Color(0xFF36343B).withOpacity(0.5),
      ),
      trackBorderColor: MaterialStateProperty.all<Color>(
        const Color(0xFF36343B),
      ),
    ),
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
        fixedSize: MaterialStateProperty.all<Size>(
          const Size(
            300,
            75,
          ),
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
      checkColor: MaterialStateProperty.resolveWith<Color>(
        (Set<MaterialState> states) {
          if (states.contains(MaterialState.selected)) {
            return Colors.black;
          }
          return Colors.black;
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
