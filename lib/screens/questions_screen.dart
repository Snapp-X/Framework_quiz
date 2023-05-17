import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/qa_providers.dart';

class QuestionsScreen extends ConsumerWidget {
  const QuestionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final questions = ref.watch(questionsProvider);
    final options = ref.watch(optionsProvider);
    final currentQuestionIndex = ref.watch(currentQuestionIndexProvider);
    final selectedOption = ref.watch(selectedOptionProvider);

    final isAnswerSelected = selectedOption[currentQuestionIndex] != -1;
    final isLastQuestion = currentQuestionIndex == questions.length - 1;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Questionnaire'),
        leading: currentQuestionIndex > 0
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  if (currentQuestionIndex > 0) {
                    ref.read(currentQuestionIndexProvider.notifier).state--;
                    context.go('/');
                  }
                },
              )
            : null,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              questions[currentQuestionIndex],
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          ...options[currentQuestionIndex]
              .asMap()
              .entries
              .map(
                (entry) => RadioListTile(
                  title: Text(entry.value),
                  value: entry.key,
                  groupValue: selectedOption[currentQuestionIndex],
                  onChanged: (value) {
                    ref.read(selectedOptionProvider.notifier).state =
                        List.from(selectedOption)
                          ..[currentQuestionIndex] = value as int;
                  },
                ),
              )
              .toList(),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: isAnswerSelected
                  ? () {
                      if (isLastQuestion) {
                        context.go('/results');
                      } else {
                        ref.read(currentQuestionIndexProvider.notifier).state++;
                      }
                    }
                  : null,
              child: Text(
                isLastQuestion ? 'Submit' : 'Next Question',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
