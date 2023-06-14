import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:snappx_quiz/providers/qa_provider.dart';
import 'package:snappx_quiz/screens/questions_screen/question_container.dart';
import 'package:snappx_quiz/styling/constants.dart';
import 'package:universal_html/html.dart' as html;

class QuestionsScreen extends ConsumerStatefulWidget {
  const QuestionsScreen({super.key});

  @override
  ConsumerState<QuestionsScreen> createState() => _QuestionsScreenState();
}

class _QuestionsScreenState extends ConsumerState<QuestionsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => showDialogOnAppStart());
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;
    final questions = ref.watch(questionsProvider);
    final answers = ref.watch(answersProvider);
    final currentQuestionIndex = ref.watch(currentQuestionIndexProvider);
    final selectedAnswer = ref.watch(selectedAnswerProvider);
    final ScrollController scrollController = ScrollController();

    final isAnswerSelected = selectedAnswer[currentQuestionIndex].isNotEmpty;
    final isLastQuestion = currentQuestionIndex == questions.length - 1;

    String userAgent = html.window.navigator.userAgent;
    bool isMobileDevice = userAgent.contains('Mobile');

    return QuestionContainer(
      currentQuestionIndex: currentQuestionIndex,
      questions: questions,
      isMobileDevice: isMobileDevice,
      screenWidth: screenWidth,
      screenHeight: screenHeight,
      scrollController: scrollController,
      answers: answers,
      selectedAnswer: selectedAnswer,
      isAnswerSelected: isAnswerSelected,
      isLastQuestion: isLastQuestion,
      answerPressed: (newSelectedAnswers) => ref
          .read(selectedAnswerProvider.notifier)
          .state = List.from(selectedAnswer)
        ..[currentQuestionIndex] = newSelectedAnswers,
      backPressed: () =>
          ref.read(currentQuestionIndexProvider.notifier).state--,
      nextPressed: () =>
          ref.read(currentQuestionIndexProvider.notifier).state++,
    );
  }

  void showDialogOnAppStart() {
    String userAgent = html.window.navigator.userAgent;
    bool isMobileDevice = userAgent.contains('Mobile');
    final cornerRadius =
        isMobileDevice ? FunnyWebAppConstants.m : FunnyWebAppConstants.xxxl;
    showDialog(
      barrierColor: const Color(0xFF141414),
      barrierDismissible: false,
      context: context,
      builder: (_) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: AlertDialog(
          scrollable: true,
          insetPadding: EdgeInsets.zero,
          contentPadding: EdgeInsets.zero,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          backgroundColor: Colors.grey.withOpacity(0.2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(cornerRadius)),
          ),
          content: Builder(
            builder: (context) {
              return SizedBox(
                height: MediaQuery.of(context).size.height -
                    (MediaQuery.of(context).size.height * 0.1),
                width: MediaQuery.of(context).size.width -
                    (MediaQuery.of(context).size.width * 0.07),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).size.width * 0.1),
                      child: Text(
                        'Which technology is\nbest for your x-platform-app?',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.displayLarge,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('Find it out',
                          style: Theme.of(context).textTheme.labelLarge),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
