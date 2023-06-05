import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 26, right: 26),
              child: buildCustomAppBar(ref, selectedAnswer, context),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Expanded(
                  flex: 1,
                  child: SizedBox(),
                ),
                Expanded(
                  flex: 2,
                  child: Center(
                    child: Text(
                      'Flutter it is!',
                      style: Theme.of(context).textTheme.displayLarge,
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: SvgPicture.asset(
                    'assets/flutter_dash.svg',
                    colorFilter: const ColorFilter.mode(
                        Colors.transparent, BlendMode.srcIn),
                    semanticsLabel: 'Flutter Icon',
                  ),
                ),
              ],
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SizedBox(
                  width: screenWidth * 0.4,
                  child: ListView.builder(
                    itemCount: results.length,
                    itemBuilder: (context, index) {
                      final entries = results.entries.toList();
                      final result = entries[index].value;
                      return ListTile(
                        title: Padding(
                          padding: const EdgeInsets.only(bottom: 6),
                          child: Stack(
                            children: [
                              LinearPercentIndicator(
                                backgroundColor: const Color(0xFF36343B),
                                animation: true,
                                lineHeight: 30,
                                animationDuration: 2000,
                                percent: result['percentage'],
                                barRadius: const Radius.circular(16),
                                progressColor: const Color(0xFF78FCB0),
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
    );
  }

  AppBar buildCustomAppBar(
      WidgetRef ref, List<Set<int>> selectedAnswer, BuildContext context) {
    return AppBar(
      centerTitle: true,
      elevation: 0,
      backgroundColor: const Color(0xFF141414),
      automaticallyImplyLeading: false,
      actions: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFF36343B).withOpacity(0.5),
          ),
          child: IconButton(
            onPressed: () {
              ref.read(currentQuestionIndexProvider.notifier).state = 0;
              ref.read(selectedAnswerProvider.notifier).state =
                  List<Set<int>>.filled(selectedAnswer.length, <int>{});
              modifyPrefs();
              context.push('/');
            },
            icon: const Icon(
              Icons.close,
              color: Color(0xFF78FCB0),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> modifyPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isFirstRun', true);
  }
}
