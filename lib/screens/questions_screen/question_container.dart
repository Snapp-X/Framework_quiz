import 'dart:core';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:snappx_quiz/styling/colors.dart';
import 'package:snappx_quiz/styling/constants.dart';

class QuestionContainer extends StatelessWidget {
  const QuestionContainer({
    super.key,
    required this.currentQuestionIndex,
    required this.questions,
    required this.isMobileDevice,
    required this.screenWidth,
    required this.screenHeight,
    required this.scrollController,
    required this.answers,
    required this.selectedAnswer,
    required this.isAnswerSelected,
    required this.isLastQuestion,
    required this.answerPressed,
    required this.backPressed,
    required this.nextPressed,
  });

  final int currentQuestionIndex;
  final List<String> questions;
  final bool isMobileDevice;
  final double screenWidth;
  final double screenHeight;
  final ScrollController scrollController;
  final List<List<String>> answers;
  final List<Set<int>> selectedAnswer;
  final bool isAnswerSelected;
  final bool isLastQuestion;
  final Function answerPressed;
  final VoidCallback backPressed;
  final VoidCallback nextPressed;

  @override
  Widget build(BuildContext context) {
    final paddingQuestionSide =
        isMobileDevice ? FunnyWebAppConstants.xs : FunnyWebAppConstants.xxl;
    final cornerRadius =
        isMobileDevice ? FunnyWebAppConstants.m : FunnyWebAppConstants.xxxl;

    return Container(
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
                appBar: _buildCustomAppBar(context, currentQuestionIndex,
                    questions, backPressed, isMobileDevice),
                body: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    SingleChildScrollView(
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 20.0),
                              child: Container(
                                width: screenWidth * 0.8,
                                padding: EdgeInsets.only(
                                  top: 20,
                                  bottom: 30,
                                  left: paddingQuestionSide,
                                  right: paddingQuestionSide,
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: const Color(0xFF36343B)
                                        .withOpacity(0.3),
                                    width: 3.0,
                                  ),
                                  borderRadius:
                                      BorderRadius.circular(cornerRadius),
                                ),
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(
                                          right: screenHeight * 0.01,
                                          left: screenHeight * 0.01,
                                          bottom: screenHeight * 0.02,
                                          top: screenHeight * 0.02),
                                      child: Text(
                                        questions[currentQuestionIndex],
                                        style: Theme.of(context)
                                            .textTheme
                                            .displayMedium,
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    SizedBox(
                                      height: screenHeight * 0.4,
                                      child: ListView.separated(
                                        controller: scrollController,
                                        shrinkWrap: true,
                                        itemCount: answers[currentQuestionIndex]
                                            .length,
                                        separatorBuilder: (context, index) =>
                                            Divider(
                                          thickness: 3,
                                          endIndent: 20,
                                          color: Theme.of(context).dividerColor,
                                        ),
                                        padding: const EdgeInsets.only(
                                            right: 16, left: 16),
                                        itemBuilder: (context, index) {
                                          final answer =
                                              answers[currentQuestionIndex]
                                                  [index];
                                          final isSelected = selectedAnswer[
                                                  currentQuestionIndex]
                                              .contains(index);

                                          return CheckboxListTile(
                                            activeColor:
                                                const Color(0xFF78FCB0),
                                            title: Text(
                                              answer,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium,
                                            ),
                                            controlAffinity:
                                                ListTileControlAffinity
                                                    .trailing,
                                            value: isSelected,
                                            onChanged: (value) {
                                              final newSelectedAnswers =
                                                  Set<int>.from(selectedAnswer[
                                                      currentQuestionIndex]);

                                              if (value == true) {
                                                newSelectedAnswers.add(index);
                                              } else {
                                                newSelectedAnswers
                                                    .remove(index);
                                              }

                                              answerPressed(newSelectedAnswers);
                                            },
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Spacer(),
                  ],
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
                    buildBottomButton(
                        isAnswerSelected, isLastQuestion, context, nextPressed),
                  ],
                ),
              ),
              SizedBox(
                height: isMobileDevice
                    ? FunnyWebAppConstants.xxxl
                    : FunnyWebAppConstants.l,
              )
            ],
          ),
        ],
      ),
    );
  }

  AppBar _buildCustomAppBar(BuildContext context, int currentQuestionIndex,
      List<String> questions, VoidCallback backPressed, bool isMobileDevice) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;
    final totalQuestions = questions.length;
    final firstHalfLength = totalQuestions ~/ 2;
    final secondHalfLength = totalQuestions - firstHalfLength;
    return AppBar(
      automaticallyImplyLeading: false,
      centerTitle: true,
      titleSpacing: 0,
      elevation: 0,
      leading: currentQuestionIndex > 0
          ? Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF36343B).withOpacity(0.5),
              ),
              child: IconButton(
                splashRadius: 24.0,
                onPressed: () {
                  if (currentQuestionIndex > 0) {
                    backPressed.call();
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
        width: !isMobileDevice ? screenWidth * 0.4 : screenWidth * 0.6,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: ClipRRect(
                borderRadius:
                    const BorderRadius.horizontal(left: Radius.circular(20)),
                child: LinearProgressIndicator(
                  minHeight: 4,
                  value: (currentQuestionIndex + 1) / firstHalfLength,
                  backgroundColor: const Color(0xFF36343B).withOpacity(0.5),
                  valueColor:
                      const AlwaysStoppedAnimation<Color>(Color(0xFF78FCB0)),
                ),
              ),
            ),
            Container(
              color: const Color(0xFF141414),
              width: !isMobileDevice ? screenWidth * 0.05 : screenWidth * 0.10,
              alignment: Alignment.center,
              child: Text(
                '${currentQuestionIndex + 1}/${questions.length}',
                style: Theme.of(context).appBarTheme.titleTextStyle,
              ),
            ),
            Expanded(
              child: ClipRRect(
                borderRadius:
                    const BorderRadius.horizontal(right: Radius.circular(20)),
                child: LinearProgressIndicator(
                  minHeight: 4,
                  value: (currentQuestionIndex - firstHalfLength + 1) /
                      secondHalfLength,
                  backgroundColor: const Color(0xFF36343B).withOpacity(0.5),
                  valueColor:
                      const AlwaysStoppedAnimation<Color>(Color(0xFF78FCB0)),
                ),
              ),
            )
          ],
        ),
      ),
      backgroundColor: const Color(0xFF141414),
    );
  }

  Padding buildBottomButton(bool isAnswerSelected, bool isLastQuestion,
      BuildContext context, VoidCallback nextPressed) {
    return Padding(
      padding: const EdgeInsets.only(top: 28.0),
      child: ElevatedButton(
        onPressed: isAnswerSelected
            ? () {
                if (isLastQuestion) {
                  context.push('/results');
                } else {
                  nextPressed.call();
                }
              }
            : null,
        child: Text(isLastQuestion ? 'See result' : 'Next Question',
            style: Theme.of(context).textTheme.labelLarge),
      ),
    );
  }
}
