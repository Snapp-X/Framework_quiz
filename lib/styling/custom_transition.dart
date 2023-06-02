import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:snappx_quiz/screens/results_screen.dart';

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
        return Lottie.asset(
          'assets/loading_indicator.json',
          controller: _controller,
        );
      },
      child: widget.child,
    );
  }
}
