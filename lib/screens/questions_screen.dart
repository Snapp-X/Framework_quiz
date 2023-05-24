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
    final questions = ref.watch(questionsProvider);
    final answers = ref.watch(answersProvider);
    final currentQuestionIndex = ref.watch(currentQuestionIndexProvider);
    final selectedAnswer = ref.watch(selectedAnswerProvider);

    final isAnswerSelected = selectedAnswer[currentQuestionIndex] != -1;
    final isLastQuestion = currentQuestionIndex == questions.length - 1;

    return Scaffold(
      appBar: buildCustomAppBar(context, currentQuestionIndex, questions, ref),
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.4,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(40),
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
                      padding: const EdgeInsets.only(bottom: 40),
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
                              style: Theme.of(context).textTheme.bodyMedium),
                          controlAffinity: ListTileControlAffinity.trailing,
                          value: index,
                          groupValue: selectedAnswer[currentQuestionIndex],
                          onChanged: (value) {
                            ref.read(selectedAnswerProvider.notifier).state =
                                List.from(selectedAnswer)
                                  ..[currentQuestionIndex] = value as int;
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
              buildBottomButton(isAnswerSelected, isLastQuestion, context),
            ],
          ),
        ),
      ),
    );
  }

  Padding buildBottomButton(
      bool isAnswerSelected, bool isLastQuestion, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 40),
      child: SizedBox(
        width: double.infinity,
        height: 60,
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
                fontSize: 18),
          ),
        ),
      ),
    );
  }

  AppBar buildCustomAppBar(BuildContext context, int currentQuestionIndex,
      List<String> questions, WidgetRef ref) {
    return AppBar(
      leading: currentQuestionIndex > 0
          ? Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey.withOpacity(0.2),
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
                  size: 24,
                  color: Color(0xFF78FCB0),
                ),
              ),
            )
          : null,
      title: SizedBox(
        height: 30,
        width: MediaQuery.of(context).size.width * 0.4,
        child: Stack(
          children: <Widget>[
            Center(
              child: LinearProgressIndicator(
                minHeight: 4,
                value: (currentQuestionIndex + 1) / questions.length,
                backgroundColor: Color(0xFF36343B),
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF78FCB0)),
              ),
            ),
            Center(
              child: Container(
                color: Colors.black,
                width: MediaQuery.of(context).size.width * 0.07,
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  '${currentQuestionIndex + 1}/${questions.length}',
                  style: Theme.of(context).appBarTheme.titleTextStyle,
                ),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.black,
    );
  }

  void showDialogOnAppStart(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (_) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: AlertDialog(
          insetPadding: EdgeInsets.zero,
          contentPadding: EdgeInsets.zero,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          backgroundColor: Colors.grey.withOpacity(0.2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(100)),
          ),
          content: Builder(
            builder: (context) {
              var height = MediaQuery.of(context).size.height;
              var width = MediaQuery.of(context).size.width;

              return Container(
                height: height - 100,
                width: width - 100,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 100),
                      child: Text(
                        'Which technology is\nbest for your app?',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.displayLarge,
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.3,
                      height: 60,
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
