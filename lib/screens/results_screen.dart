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
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;
    final results = ref.watch(resultProvider);
    final selectedAnswer = ref.watch(selectedAnswerProvider.notifier).state;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        actions: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFF36343B).withOpacity(0.5),
            ),
            child: IconButton(
              onPressed: () {
                ref.read(currentQuestionIndexProvider.notifier).state = 0;
                ref.read(selectedAnswerProvider.notifier).state =
                    List<int>.filled(selectedAnswer.length, -1);
                context.go('/');
              },
              icon: Icon(
                Icons.close,
                color: Color(0xFF78FCB0),
              ),
            ),
          ),
        ],
      ),
      body: Center(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: EdgeInsets.only(right: screenWidth * 0.068),
                  child: Container(
                    height: 112,
                    width: 308,
                    child: ImageIcon(
                      AssetImage('assets/flutter_dash.png'),
                      color: Colors.transparent,
                    ),
                  ),
                ),
              ),
              Text(
                'Flutter it is!',
                style: Theme.of(context).textTheme.displayLarge,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    width: screenWidth * 0.4,
                    child: ListView.builder(
                      itemCount: results.length,
                      itemBuilder: (context, index) {
                        final entries = results.entries.toList();
                        final result = entries[index].value;
                        return ListTile(
                          title: Padding(
                            padding: EdgeInsets.only(bottom: 6),
                            child: Stack(
                              children: [
                                LinearPercentIndicator(
                                  backgroundColor: Color(0xFF36343B),
                                  animation: true,
                                  lineHeight: 30,
                                  animationDuration: 2000,
                                  percent: result['percentage'],
                                  barRadius: const Radius.circular(16),
                                  progressColor: Color(0xFF78FCB0),
                                ),
                                Positioned(
                                  left: 0,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 10.0),
                                    child: Container(
                                      width: 30,
                                      height: 30,
                                      padding: const EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.grey.withOpacity(0.4),
                                      ),
                                      child: ImageIcon(
                                        AssetImage(
                                          result['description'],
                                        ),
                                        color: Colors.transparent,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          subtitle: Padding(
                            padding: EdgeInsets.only(
                                bottom: screenHeight * 0.01, left: 20),
                            child: Text(
                              entries[index].key,
                              style: Theme.of(context).textTheme.bodyMedium,
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
