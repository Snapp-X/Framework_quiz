import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final questionsProvider = Provider<List<String>>((ref) => [
      'What type of App are you interested in building?',
      'What is the primary purpose of the App?',
      'Who is your target audience for the App?',
    ]);

final optionsProvider = Provider<List<List<String>>>((ref) => [
      [
        'Social Media App',
        'E-Commerce App',
        'Productivity App',
        'Fitness App',
        'Other'
      ],
      [
        'To sell Products',
        'Customer-Engagement',
        'Creating a Platform',
        'Other'
      ],
      [
        'Teenagers',
        'Working Professionals',
        'Adults (Hobby, Fitness etc.)',
        'Other'
      ],
    ]);

final currentQuestionIndexProvider = StateProvider<int>((ref) => 0);

final selectedOptionProvider = StateProvider<List<int>>((ref) {
  final questions = ref.watch(questionsProvider);
  return List<int>.filled(questions.length, -1);
});

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
