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
              Padding(
                padding: const EdgeInsets.only(bottom: 70.0),
                child: Text(
                  questions[currentQuestionIndex],
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              ListView.separated(
                shrinkWrap:
                    true, // Added this line to make the ListView fit its content
                itemCount: answers[currentQuestionIndex].length,
                separatorBuilder: (context, index) =>
                    Divider(), // Add a divider between each RadioListTile
                itemBuilder: (context, index) {
                  final answer = answers[currentQuestionIndex][index];

                  return RadioListTile(
                    title: Text(answer),
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
              Padding(
                padding: const EdgeInsets.only(top: 80.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black,
                    backgroundColor: Color(0xff78FCB0), // Background color
                  ),
                  onPressed: isAnswerSelected
                      ? () {
                          if (isLastQuestion) {
                            context.go('/results');
                          } else {
                            ref
                                .read(currentQuestionIndexProvider.notifier)
                                .state++;
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
        ),
      ),
    );
/*    return Scaffold(
      appBar: buildCustomAppBar(context, currentQuestionIndex, questions, ref),
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.4,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  questions[currentQuestionIndex],
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              Expanded(
                child: ListView.separated(
                  itemCount: answers[currentQuestionIndex].length,
                  separatorBuilder: (context, index) =>
                      Divider(), // Add a divider between each RadioListTile
                  itemBuilder: (context, index) {
                    final answer = answers[currentQuestionIndex][index];

                    return RadioListTile(
                      title: Text(answer),
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
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black,
                    backgroundColor: Color(0xff78FCB0), // Background color
                  ),
                  onPressed: isAnswerSelected
                      ? () {
                          if (isLastQuestion) {
                            context.go('/results');
                          } else {
                            ref
                                .read(currentQuestionIndexProvider.notifier)
                                .state++;
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
        ),
      ),
    );*/
  }

  AppBar buildCustomAppBar(BuildContext context, int currentQuestionIndex,
      List<String> questions, WidgetRef ref) {
    return AppBar(
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
                backgroundColor: Colors.greenAccent,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
              ),
            ),
            Align(
                child: Text(
                  currentQuestionIndex.toString() +
                      "/" +
                      questions.length.toString(),
                  style: TextStyle(backgroundColor: Colors.blue),
                ),
                alignment: Alignment.center),
          ],
        ),
      ),
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
    );
  }

  void showDialogOnAppStart() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (_) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
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
                height: height - 200,
                width: width - 100,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Which technology is\nbest for your app?',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 60),
                    ),
                    SizedBox(height: 20),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('Find it out'),
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
    showDialogOnAppStart();
    if (isFirstRun) {
      showDialogOnAppStart();
      prefs.setBool('isFirstRun', false);
    } else {
      return null;
    }
  }
}
