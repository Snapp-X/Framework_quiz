import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import '../providers/qa_provider.dart';
import '../providers/results_provider.dart';

class ResultsScreen extends ConsumerWidget {
  const ResultsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final results = ref.watch(resultProvider);
    final selectedAnswer = ref.watch(selectedAnswerProvider.notifier).state;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.close,
              color: Color(0xFF78FCB0),
            ),
            onPressed: () {
              ref.read(currentQuestionIndexProvider.notifier).state = 0;
              ref.read(selectedAnswerProvider.notifier).state =
                  List<int>.filled(selectedAnswer.length, -1);
              context.go('/');
            },
          )
        ],
      ),
      body: Center(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 80, bottom: 60),
                child: Text(
                  'Flutter it is!',
                  style: TextStyle(
                      fontFamily: 'Clash Grotesk Display',
                      fontWeight: FontWeight.w500,
                      fontSize: 60,
                      color: Colors.white),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.4,
                    child: ListView.builder(
                      itemCount: results.length,
                      itemBuilder: (context, index) {
                        final entries = results.entries.toList();
                        return ListTile(
                          title: Padding(
                            padding: EdgeInsets.only(bottom: 6),
                            child: new LinearPercentIndicator(
                              backgroundColor: Color(0xFF36343B),
                              animation: true,
                              lineHeight: 30,
                              animationDuration: 2000,
                              percent: entries[index].value,
                              barRadius: const Radius.circular(16),
                              progressColor: Color(0xFF78FCB0),
                            ),
                          ),
                          subtitle: Padding(
                            padding:
                                const EdgeInsets.only(bottom: 10, left: 20),
                            child: Text(
                              entries[index].key,
                              style: TextStyle(
                                  fontFamily: 'Switzer',
                                  fontWeight: FontWeight.w500,
                                  fontSize: 20,
                                  color: Colors.white.withOpacity(0.5)),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
