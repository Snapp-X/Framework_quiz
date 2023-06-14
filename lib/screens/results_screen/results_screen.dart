import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:snappx_quiz/providers/qa_provider.dart';
import 'package:snappx_quiz/providers/results_provider.dart';
import 'package:snappx_quiz/screens/results_screen/reults_container.dart';
import 'package:universal_html/html.dart' as html;

class ResultsScreen extends ConsumerWidget {
  const ResultsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;
    final results = ref.watch(resultProvider);
    final selectedAnswer = ref.watch(selectedAnswerProvider.notifier).state;
    String userAgent = html.window.navigator.userAgent;
    bool isMobileDevice = userAgent.contains('Mobile');

    return ResultsContainer(
      isMobileDevice: isMobileDevice,
      selectedAnswer: selectedAnswer,
      screenWidth: screenWidth,
      results: results,
      screenHeight: screenHeight,
      onClosePressed: () {
        ref.read(currentQuestionIndexProvider.notifier).state = 0;
        ref.read(selectedAnswerProvider.notifier).state =
            List<Set<int>>.filled(selectedAnswer.length, <int>{});
        context.push('/');
      },
    );
  }
}
