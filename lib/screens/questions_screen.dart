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
      backgroundColor: Colors.black,
      appBar: buildCustomAppBar(context, currentQuestionIndex, questions, ref),
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.4,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding:
                    EdgeInsets.only(top: 40, bottom: 40, left: 40, right: 40),
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
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                    ListView.separated(
                      shrinkWrap: true,
                      itemCount: answers[currentQuestionIndex].length,
                      separatorBuilder: (context, index) => Divider(
                        color: Colors.white.withOpacity(0.5),
                      ),
                      itemBuilder: (context, index) {
                        final answer = answers[currentQuestionIndex][index];

                        return Theme(
                          data: Theme.of(context).copyWith(
                            unselectedWidgetColor:
                                Colors.white.withOpacity(0.5),
                          ),
                          child: RadioListTile(
                            activeColor: Color(0xFF78FCB0),
                            title: Text(answer,
                                style: TextStyle(
                                    color: Colors.white.withOpacity(0.5))),
                            controlAffinity: ListTileControlAffinity.trailing,
                            value: index,
                            groupValue: selectedAnswer[currentQuestionIndex],
                            onChanged: (value) {
                              ref.read(selectedAnswerProvider.notifier).state =
                                  List.from(selectedAnswer)
                                    ..[currentQuestionIndex] = value as int;
                            },
                          ),
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
          style: ButtonStyle(
            foregroundColor: MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> states) {
                if (states.contains(MaterialState.disabled)) {
                  return Colors.white.withOpacity(0.5);
                }
                return Color(0xFF141414);
              },
            ),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100),
              ),
            ),
            backgroundColor: MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> states) {
                if (states.contains(MaterialState.disabled)) {
                  return Color(0xFF36343B);
                }
                return Color(0xFF78FCB0);
              },
            ),
          ),
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
          ),
        ),
      ),
    );
  }

  AppBar buildCustomAppBar(BuildContext context, int currentQuestionIndex,
      List<String> questions, WidgetRef ref) {
    return AppBar(
      backgroundColor: Colors.black,
      title: SizedBox(
        height: 30,
        width: MediaQuery.of(context).size.width * 0.4,
        child: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.center,
              child: LinearProgressIndicator(
                minHeight: 4,
                value: currentQuestionIndex / questions.length,
                backgroundColor: Color(0xFF36343B),
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF78FCB0)),
              ),
            ),
            Align(
                child: Text(
                  currentQuestionIndex.toString() +
                      "/" +
                      questions.length.toString(),
                  style: TextStyle(
                      backgroundColor: Colors.black,
                      color: Colors.white.withOpacity(0.5),
                      fontSize: 16),
                ),
                alignment: Alignment.center),
          ],
        ),
      ),
      leading: currentQuestionIndex > 0
          ? IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: Color(0xFF78FCB0),
              ),
              onPressed: () {
                if (currentQuestionIndex > 0) {
                  ref.read(currentQuestionIndexProvider.notifier).state--;
                  context.go('/');
                }
              },
            )
          : null,
    );
  }

  void showDialogOnAppStart() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (_) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: new AlertDialog(
          insetPadding: EdgeInsets.zero,
          contentPadding: EdgeInsets.zero,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          backgroundColor: Colors.grey.withOpacity(0.2),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(100))),
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
                        style: TextStyle(
                            fontFamily: 'Clash Grotesk Display',
                            fontWeight: FontWeight.w500,
                            fontSize: 60,
                            color: Colors.white),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.3,
                      height: 60,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          foregroundColor:
                              MaterialStateProperty.resolveWith<Color>(
                            (Set<MaterialState> states) {
                              if (states.contains(MaterialState.disabled)) {
                                return Colors.white.withOpacity(0.5);
                              }
                              return Color(0xFF141414);
                            },
                          ),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100),
                            ),
                          ),
                          backgroundColor:
                              MaterialStateProperty.resolveWith<Color>(
                            (Set<MaterialState> states) {
                              if (states.contains(MaterialState.disabled)) {
                                return Color(0xFF36343B);
                              }
                              return Color(0xFF78FCB0);
                            },
                          ),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text('Find it out'),
                      ),
                    ),
                    /*TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('Find it out'),
                    ),*/
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
    showDialogOnAppStart();
    if (isFirstRun) {
      showDialogOnAppStart();
      prefs.setBool('isFirstRun', false);
    } else {
      return null;
    }
  }
}
