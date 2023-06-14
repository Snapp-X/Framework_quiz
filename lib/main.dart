import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:snappx_quiz/routing/app_routes.dart';
import 'package:snappx_quiz/styling/custom_themedata.dart';
import 'package:universal_html/html.dart' as html;

void main() => runApp(const ProviderScope(child: MyApp()));

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String userAgent = html.window.navigator.userAgent;
    bool isMobileDevice = userAgent.contains('Mobile');

    return MaterialApp.router(
      builder: (context, child) {
        return Theme(
          data: buildCustomThemeData(context, isMobileDevice),
          child: child!,
        );
      },
      routerConfig: AppRouter.router,
    );
  }
}
