import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:universal_html/html.dart' as html;

import '../providers/qa_provider.dart';

class QuestionsScreen extends ConsumerStatefulWidget {
  const QuestionsScreen({super.key});

  @override
  ConsumerState<QuestionsScreen> createState() => _QuestionsScreenState();
}

class _QuestionsScreenState extends ConsumerState<QuestionsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => checkFirstRun());
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

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Align(
          alignment: Alignment.topCenter,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 20, left: 26, right: 26),
                child: buildCustomAppBar(
                    context, currentQuestionIndex, questions, ref),
              ),
              Container(
                width: isMobileDevice ? screenWidth * 0.8 : screenWidth * 0.4,
                padding: EdgeInsets.all(screenWidth * 0.04),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.white.withOpacity(0.5),
                    width: 3.0,
                  ),
                  borderRadius: BorderRadius.circular(60),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(bottom: screenHeight * 0.02),
                      child: SizedBox(
                        height: screenHeight * 0.07,
                        child: Text(
                          questions[currentQuestionIndex],
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: isMobileDevice
                          ? screenHeight * 0.75
                          : screenHeight * 0.35,
                      child: ListView.separated(
                        controller: scrollController,
                        shrinkWrap: true,
                        itemCount: answers[currentQuestionIndex].length,
                        separatorBuilder: (context, index) => Divider(
                          color: Theme.of(context).dividerColor,
                        ),
                        itemBuilder: (context, index) {
                          final answer = answers[currentQuestionIndex][index];
                          final isSelected =
                              selectedAnswer[currentQuestionIndex]
                                  .contains(index);

                          return CheckboxListTile(
                            activeColor: const Color(0xFF78FCB0),
                            title: Text(
                              answer,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            controlAffinity: ListTileControlAffinity.trailing,
                            value: isSelected,
                            onChanged: (value) {
                              final newSelectedAnswers = Set<int>.from(
                                  selectedAnswer[currentQuestionIndex]);

                              if (value == true) {
                                newSelectedAnswers.add(index);
                              } else {
                                newSelectedAnswers.remove(index);
                              }

                              ref
                                  .read(selectedAnswerProvider.notifier)
                                  .state = List.from(selectedAnswer)
                                ..[currentQuestionIndex] = newSelectedAnswers;
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              buildBottomButton(isAnswerSelected, isLastQuestion, context),
              const SizedBox(
                height: 20,
              )
            ],
          ),
        ),
      ),
    );
  }

  Padding buildBottomButton(
      bool isAnswerSelected, bool isLastQuestion, BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;
    String userAgent = html.window.navigator.userAgent;
    bool isMobileDevice = userAgent.contains('Mobile');
    return Padding(
      padding: const EdgeInsets.only(top: 28.0),
      child: SizedBox(
        width: isMobileDevice ? screenWidth * 0.8 : screenWidth * 0.4,
        height: screenHeight * 0.1,
        child: ElevatedButton(
          onPressed: isAnswerSelected
              ? () {
                  if (isLastQuestion) {
                    context.push('/results');
                  } else {
                    ref.read(currentQuestionIndexProvider.notifier).state++;
                  }
                }
              : null,
          child: Text(
            isLastQuestion ? 'See result' : 'Next Question',
            style: TextStyle(
                fontFamily: 'SF Pro Text',
                fontWeight: FontWeight.w600,
                fontSize: screenWidth * 0.013),
          ),
        ),
      ),
    );
  }

  AppBar buildCustomAppBar(BuildContext context, int currentQuestionIndex,
      List<String> questions, WidgetRef ref) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;
    final totalQuestions = questions.length;
    final firstHalfLength = totalQuestions ~/ 2;
    final secondHalfLength = totalQuestions - firstHalfLength;
    return AppBar(
      automaticallyImplyLeading: false,
      centerTitle: true,
      leading: currentQuestionIndex > 0
          ? Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF36343B).withOpacity(0.5),
              ),
              child: IconButton(
                onPressed: () {
                  if (currentQuestionIndex > 0) {
                    ref.read(currentQuestionIndexProvider.notifier).state--;
                    context.go('/');
                  }
                },
                icon: const Icon(
                  Icons.arrow_back,
                  color: Color(0xFF78FCB0),
                ),
              ),
            )
          : null,
      title: SizedBox(
        height: screenHeight * 0.03,
        width: screenWidth * 0.4,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: LinearProgressIndicator(
                minHeight: 4,
                value: (currentQuestionIndex + 1) / firstHalfLength,
                backgroundColor: const Color(0xFF36343B),
                valueColor:
                    const AlwaysStoppedAnimation<Color>(Color(0xFF78FCB0)),
              ),
            ),
            Container(
              color: Colors.black,
              width: screenWidth * 0.05,
              alignment: Alignment.center,
              child: Text(
                '${currentQuestionIndex + 1}/${questions.length}',
                style: Theme.of(context).appBarTheme.titleTextStyle,
              ),
            ),
            Expanded(
              child: LinearProgressIndicator(
                minHeight: 4,
                value: (currentQuestionIndex - firstHalfLength + 1) /
                    secondHalfLength,
                backgroundColor: const Color(0xFF36343B),
                valueColor:
                    const AlwaysStoppedAnimation<Color>(Color(0xFF78FCB0)),
              ),
            )
          ],
        ),
      ),
      backgroundColor: Colors.black,
    );
  }

  void showDialogOnAppStart() {
    showDialog(
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
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(100)),
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
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.4,
                      height: MediaQuery.of(context).size.height * 0.1,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          'Find it out',
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                      ),
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

  Future<void> checkFirstRun() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isFirstRun = prefs.getBool('isFirstRun') ?? true;
    if (isFirstRun) {
      showDialogOnAppStart();
      prefs.setBool('isFirstRun', false);
    }
  }
}
