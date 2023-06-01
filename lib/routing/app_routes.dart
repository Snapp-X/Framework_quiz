import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../screens/questions_screen.dart';
import '../screens/results_screen.dart';

class AppRouter {
  static final GoRouter _router = GoRouter(
    routes: <GoRoute>[
      GoRoute(
        path: '/',
        pageBuilder: (context, state) => MaterialPage(child: QuestionsScreen()),
      ),
      GoRoute(
        path: '/results',
        pageBuilder: (context, state) => MaterialPage(child: ResultsScreen()),
      ),
    ],
  );
  static GoRouter get router => _router;
}
