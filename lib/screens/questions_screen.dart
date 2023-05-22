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
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  questions[currentQuestionIndex],
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              ...answers[currentQuestionIndex]
                  .asMap()
                  .entries
                  .map(
                    (entry) => RadioListTile(
                      title: Text(entry.value),
                      value: entry.key,
                      groupValue: selectedAnswer[currentQuestionIndex],
                      onChanged: (value) {
                        ref.read(selectedAnswerProvider.notifier).state =
                            List.from(selectedAnswer)
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
  }

  AppBar buildCustomAppBar(BuildContext context, int currentQuestionIndex,
      List<String> questions, WidgetRef ref) {
    return AppBar(
      title: SizedBox(
        height: 30,
        width: MediaQuery.of(context).size.width * 0.6,
        child: Stack(
          children: <Widget>[
            SizedBox.expand(
              child: LinearProgressIndicator(
                value: currentQuestionIndex / questions.length,
                backgroundColor: Colors.greenAccent,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
              ),
            ),
            Align(
                child: Text(currentQuestionIndex.toString() +
                    "/" +
                    questions.length.toString()),
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
      builder: (context) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: AlertDialog(
          title: Text('Which technology is best for your app?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Find it out'),
            ),
          ],
        ),
      ),
    );
  }

  Future checkFirstRun(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isFirstRun = prefs.getBool('isFirstRun') ?? true;

    if (isFirstRun) {
      showDialogOnAppStart();
      prefs.setBool('isFirstRun', false);
    } else {
      return null;
    }
  }
}
