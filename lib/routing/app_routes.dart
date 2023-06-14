import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:snappx_quiz/screens/oss_licenses_page.dart';

import '../screens/questions_screen/questions_screen.dart';
import '../screens/results_screen/results_screen.dart';
import '../styling/custom_transition.dart';

class AppRouter {
  static final GoRouter _router = GoRouter(
    routes: <GoRoute>[
      GoRoute(
        path: '/',
        pageBuilder: (context, state) =>
            const MaterialPage(child: QuestionsScreen()),
      ),
      GoRoute(
        path: '/results',
        pageBuilder: (_, state) {
          return CustomTransitionPage(
            key: state.pageKey,
            child: const ResultsScreen(),
            transitionDuration: const Duration(milliseconds: 3300),
            transitionsBuilder: (_, animation, __, child) {
              return LottieTransition(
                animation: animation,
                child: child,
              );
            },
          );
        },
      ),
      GoRoute(
        path: '/results_direct',
        pageBuilder: (context, state) =>
            const MaterialPage(child: ResultsScreen()),
      ),
      GoRoute(
        path: '/licenses',
        pageBuilder: (context, state) =>
            const MaterialPage(child: OssLicensesPage()),
      ),
    ],
  );

  static GoRouter get router => _router;
}
