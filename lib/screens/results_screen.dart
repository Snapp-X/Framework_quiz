import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/qa_providers.dart';

class ResultsScreen extends ConsumerWidget {
  const ResultsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final questions = ref.watch(questionsProvider);
    final selectedAnswer = ref.watch(selectedAnswerProvider.notifier).state;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Results'),
      ),
      body: ListView.builder(
        itemCount: questions.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(questions[index]),
            subtitle:
                Text(ref.read(answersProvider)[index][selectedAnswer[index]]),
          );
        },
      ),
    );
  }
}
