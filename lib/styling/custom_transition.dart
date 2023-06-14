import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';
import 'package:snappx_quiz/screens/results_screen/results_screen.dart';

class LottieTransition extends StatefulWidget {
  final Animation<double> animation;
  final Widget child;

  const LottieTransition({
    Key? key,
    required this.animation,
    required this.child,
  }) : super(key: key);

  @override
  State<LottieTransition> createState() => _LottieTransitionState();
}

class _LottieTransitionState extends State<LottieTransition>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );
    _controller.forward().then((value) {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => const ResultsScreen(),
      ));
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.animation,
      builder: (context, child) {
        return Scaffold(
          body: Stack(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: Container(
                  margin: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.15,
                      right: MediaQuery.of(context).size.width * 0.10),
                  child: SvgPicture.asset(
                    'assets/loading_indicator_wording.svg',
                    colorFilter: const ColorFilter.mode(
                      Colors.transparent,
                      BlendMode.srcIn,
                    ),
                    semanticsLabel: 'Flutter Wording',
                  ),
                ),
              ),
              Center(
                child: Lottie.asset(
                  'assets/loading_indicator.json',
                  controller: _controller,
                  animate: false,
                  width: MediaQuery.of(context).size.width * 0.6,
                  height: MediaQuery.of(context).size.height * 0.38,
                ),
              ),
            ],
          ),
        );
      },
      child: widget.child,
    );
  }
}
