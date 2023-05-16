import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:snappx_quiz/questions_screen.dart';
import 'package:snappx_quiz/results_screen.dart';

void main() => runApp(const ProviderScope(child: MyApp()));

final GoRouter _router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const QuestionsScreen();
      },
      routes: <RouteBase>[
        GoRoute(
          path: 'results',
          builder: (BuildContext context, GoRouterState state) {
            return const ResultsScreen();
          },
        ),
      ],
    ),
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
    );
  }
}
