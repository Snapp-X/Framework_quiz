import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:snappx_quiz/styling/colors.dart';
import 'package:snappx_quiz/styling/constants.dart';
import 'package:url_launcher/url_launcher.dart';

class ResultsContainer extends StatelessWidget {
  const ResultsContainer({
    super.key,
    required this.selectedAnswer,
    required this.screenWidth,
    required this.results,
    required this.screenHeight,
    required this.onClosePressed,
    required this.isMobileDevice,
  });

  final bool isMobileDevice;
  final List<Set<int>> selectedAnswer;
  final double screenWidth;
  final Map<String, dynamic> results;
  final double screenHeight;
  final VoidCallback onClosePressed;

  @override
  Widget build(BuildContext context) {
    final centerWidth = isMobileDevice ? screenWidth * 0.9 : screenWidth * 0.6;
    return Material(
      child: Container(
        color: FunnyWebAppColors.background,
        child: Stack(
          children: [
            SafeArea(
              child: Padding(
                padding: EdgeInsets.only(
                  top: screenHeight * 0.02,
                  bottom: screenHeight * 0.02,
                  left: screenWidth * 0.02,
                  right: screenWidth * 0.02,
                ),
                child: Scaffold(
                  appBar: _buildCustomAppBar(
                      onClosePressed, selectedAnswer, context),
                  body: SingleChildScrollView(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(height: isMobileDevice ? 20 : 10),
                          SizedBox(
                            width: centerWidth,
                            child: Row(
                              mainAxisAlignment: isMobileDevice
                                  ? MainAxisAlignment.center
                                  : MainAxisAlignment.end,
                              children: [
                                Image.asset(
                                  'assets/dash_result.webp',
                                  width: 300,
                                  semanticLabel: 'Flutter Icon',
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: isMobileDevice ? 20 : 50),
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
                                    style: Theme.of(context)
                                        .textTheme
                                        .displayMedium,
                                  ),
                                ),
                              ),
                              const Expanded(
                                flex: 1,
                                child: SizedBox(),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: SizedBox(
                              width: centerWidth,
                              height: screenHeight * 0.6,
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
                                            backgroundColor:
                                                const Color(0xFF36343B),
                                            animation: true,
                                            lineHeight: 30,
                                            animationDuration: 2000,
                                            percent: result['percentage'],
                                            barRadius:
                                                const Radius.circular(16),
                                            progressColor:
                                                const Color(0xFF78FCB0),
                                          ),
                                          Positioned(
                                            left: 0,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10.0),
                                              child: Container(
                                                width: 30,
                                                height: 30,
                                                padding:
                                                    const EdgeInsets.all(6),
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Colors.grey
                                                      .withOpacity(0.4),
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
                                      padding: const EdgeInsets.only(
                                          bottom: 20, left: 20),
                                      child: Text(
                                        entries[index].key,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Column(
              children: [
                const Spacer(),
                Padding(
                  padding: EdgeInsets.only(
                    left: screenWidth * 0.02,
                    right: screenWidth * 0.02,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () => launchUrl(Uri.parse('https://snappx.io')),
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'A Project By',
                                style:
                                    Theme.of(context).textTheme.headlineSmall,
                              ),
                              TextSpan(
                                text: ' Snapp X',
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineSmall
                                    ?.copyWith(color: Colors.blue),
                              ),
                              TextSpan(
                                text: '.',
                                style:
                                    Theme.of(context).textTheme.headlineSmall,
                              ),
                            ],
                          ),
                        ),
                      ),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: ' | ',
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () => context.go('/licenses'),
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'Licenses',
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineSmall
                                    ?.copyWith(color: Colors.blue),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: FunnyWebAppConstants.l,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  AppBar _buildCustomAppBar(VoidCallback onClosePressed,
      List<Set<int>> selectedAnswer, BuildContext context) {
    return AppBar(
      centerTitle: true,
      elevation: 0,
      backgroundColor: const Color(0xFF141414),
      automaticallyImplyLeading: false,
      actionsIconTheme: const IconThemeData(
        size: 56,
      ),
      actions: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFF36343B).withOpacity(0.5),
          ),
          child: IconButton(
            splashRadius: 24.0,
            onPressed: () {
              onClosePressed.call();
            },
            icon: const Icon(
              Icons.close,
              size: 24,
              color: Color(0xFF78FCB0),
            ),
          ),
        ),
      ],
    );
  }
}
