import 'package:flutter_riverpod/flutter_riverpod.dart';

final questionsProvider = Provider<List<String>>((ref) => [
      'What type of App are you interested in building?',
      'What is the primary purpose of the App?',
      'Who is your target audience for the App?',
      'What features do you want your App to have?',
      'How important is user experience to you?',
      'How important is security to you?',
      'What platforms do you want your App to be available on?',
      'What is your budget for developing the App?',
      'Do you have any specific design preferences or requirements for the App?',
      'What is your expected timeline for the App development?'
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
      [
        'Messaging',
        'Search functionality',
        'Push Notifications',
        'User Profiles',
        'Other'
      ],
      [
        'Very important',
        'Somewhat important',
        'Not important',
        'I don’t know / don’t care'
      ],
      [
        'Very important',
        'Somewhat important',
        'Not important',
        'I don’t know / don’t care'
      ],
      ['iOS', 'Android', 'Web', 'Embedded', 'Other'],
      [
        'less than \$10,000',
        '\$10,000-\$50,000',
        '\$50,000-\$100,000',
        'more than \$100,000'
      ],
      ['minimalist', 'colorful', 'easy-to-use', 'Other'],
      ['3 months or less', '6 months', '1 year', 'more than 1 year'],
    ]);

final currentQuestionIndexProvider = StateProvider<int>((ref) => 0);

final selectedAnswerProvider = StateProvider<List<int>>((ref) {
  final questions = ref.watch(questionsProvider);
  return List<int>.filled(questions.length, -1);
});
