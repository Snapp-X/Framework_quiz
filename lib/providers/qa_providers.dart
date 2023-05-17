import 'package:flutter_riverpod/flutter_riverpod.dart';

final questionsProvider = Provider<List<String>>((ref) => [
      'What type of App are you interested in building?',
      'What is the primary purpose of the App?',
      'Who is your target audience for the App?',
    ]);

final answersProvider = Provider<List<List<String>>>((ref) => [
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

final selectedAnswerProvider = StateProvider<List<int>>((ref) {
  final questions = ref.watch(questionsProvider);
  return List<int>.filled(questions.length, -1);
});
