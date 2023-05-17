import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../screens/questions_screen.dart';
import '../screens/results_screen.dart';

class AppRouter {
  static final GoRouter _router = GoRouter(
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
  static GoRouter get router => _router;
}
