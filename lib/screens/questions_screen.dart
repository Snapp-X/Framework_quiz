import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    WidgetsBinding.instance.addPostFrameCallback((_) => checkFirstRun(context));
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

    final isAnswerSelected = selectedAnswer[currentQuestionIndex] != -1;
    final isLastQuestion = currentQuestionIndex == questions.length - 1;

    return Scaffold(
      appBar: buildCustomAppBar(context, currentQuestionIndex, questions, ref),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(top: screenHeight * 0.06),
          child: Center(
            child: Container(
              width: screenWidth * 0.4,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
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
                          padding: EdgeInsets.only(bottom: screenHeight * 0.03),
                          child: Text(
                            questions[currentQuestionIndex],
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ),
                        ListView.separated(
                          shrinkWrap: true,
                          itemCount: answers[currentQuestionIndex].length,
                          separatorBuilder: (context, index) => Divider(
                            color: Theme.of(context).dividerColor,
                          ),
                          itemBuilder: (context, index) {
                            final answer = answers[currentQuestionIndex][index];

                            return RadioListTile(
                              activeColor: Color(0xFF78FCB0),
                              title: Text(answer,
                                  style:
                                      Theme.of(context).textTheme.bodyMedium),
                              controlAffinity: ListTileControlAffinity.trailing,
                              visualDensity: VisualDensity.compact,
                              value: index,
                              groupValue: selectedAnswer[currentQuestionIndex],
                              onChanged: (value) {
                                ref
                                    .read(selectedAnswerProvider.notifier)
                                    .state = List.from(selectedAnswer)
                                  ..[currentQuestionIndex] = value as int;
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton:
          buildBottomButton(isAnswerSelected, isLastQuestion, context),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Padding buildBottomButton(
      bool isAnswerSelected, bool isLastQuestion, BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;
    return Padding(
      padding: EdgeInsets.only(bottom: screenHeight * 0.08),
      child: SizedBox(
        width: screenWidth * 0.4,
        height: screenHeight * 0.1,
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
      leading: currentQuestionIndex > 0
          ? Container(
              height: screenHeight * 0.03,
              width: screenWidth * 0.03,
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFF36343B).withOpacity(0.5),
              ),
              child: IconButton(
                onPressed: () {
                  if (currentQuestionIndex > 0) {
                    ref.read(currentQuestionIndexProvider.notifier).state--;
                    context.go('/');
                  }
                },
                icon: Icon(
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
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: LinearProgressIndicator(
                minHeight: 4,
                value: (currentQuestionIndex + 1) / firstHalfLength,
                backgroundColor: Color(0xFF36343B),
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF78FCB0)),
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
                backgroundColor: Color(0xFF36343B),
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF78FCB0)),
              ),
            )
          ],
        ),
      ),
      backgroundColor: Colors.black,
    );
  }

  void showDialogOnAppStart(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;
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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(100)),
          ),
          content: Builder(
            builder: (context) {
              return Container(
                height: screenHeight - (screenHeight * 0.1),
                width: screenWidth - (screenWidth * 0.07),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(bottom: screenWidth * 0.1),
                      child: Text(
                        'Which technology is\nbest for your app?',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.displayLarge,
                      ),
                    ),
                    SizedBox(
                      width: screenWidth * 0.4,
                      height: screenHeight * 0.1,
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

  Future checkFirstRun(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isFirstRun = prefs.getBool('isFirstRun') ?? true;
    if (isFirstRun) {
      showDialogOnAppStart(context);
      prefs.setBool('isFirstRun', false);
    } else {
      return null;
    }
  }
}
