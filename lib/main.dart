import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:snappx_quiz/routing/app_routes.dart';
import 'package:snappx_quiz/styling/custom_themedata.dart';

void main() => runApp(const ProviderScope(child: MyApp()));

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      builder: (context, child) {
        return Theme(
          data: buildCustomThemeData(context),
          child: child!,
        );
      },
      routerConfig: AppRouter.router,
    );
  }
}
