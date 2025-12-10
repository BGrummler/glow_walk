import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'store.dart';

class PulsingGrid extends StatefulWidget {
  const PulsingGrid({super.key});

  @override
  State<PulsingGrid> createState() => _PulsingGridState();
}

class _PulsingGridState extends State<PulsingGrid>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late Animation<double> _animation;

  static const double fadeTimeMs = 10.0; // Fade duration

  @override
  void initState() {
    super.initState();
    final store = context.read<TorchStore>();

    if (!store.displayEnabled) {
      // Display is off, no animation needed
      _animation = AlwaysStoppedAnimation(0.0);
      _controller = AnimationController(vsync: this); // dummy
      return;
    }

    if (store.displayConstant) {
      // Constant display
      _animation = AlwaysStoppedAnimation(1.0);
      _controller = AnimationController(vsync: this); // dummy
      return;
    }

    final onTime = store.displayOnDurationMs.toDouble();
    final offTime = store.displayOffDurationMs.toDouble();
    final totalCycle = onTime + offTime;

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: totalCycle.toInt()),
    );

    _animation = TweenSequence<double>([
      // Off hold
      TweenSequenceItem(
        tween: ConstantTween(0.0),
        weight: offTime - fadeTimeMs,
      ),
      // Fade in
      TweenSequenceItem(
        tween: Tween(begin: 0.0, end: 1.0),
        weight: fadeTimeMs,
      ),
      // On hold
      TweenSequenceItem(
        tween: ConstantTween(1.0),
        weight: onTime - fadeTimeMs,
      ),
      // Fade out
      TweenSequenceItem(
        tween: Tween(begin: 1.0, end: 0.0),
        weight: fadeTimeMs,
      ),
    ]).animate(_controller);

    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final store = context.watch<TorchStore>();

    // Display off
    if (!store.displayEnabled) {
      return Container(color: Colors.black);
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final circleSize = 50.0;
        final crossAxisCount = (constraints.maxWidth / (circleSize + 10)).floor();
        final mainAxisCount =
            ((constraints.maxHeight - 90) / (circleSize + 10)).floor();
        final totalCount = crossAxisCount * mainAxisCount;

        return AnimatedBuilder(
          animation: _animation,
          builder: (context, _) {
            final glowColor = Color.lerp(
              Colors.black,
              store.displayColor,
              //const Color.fromARGB(255, 0, 255, 0),
              //const Color.fromARGB(255, 255, 0, 0),
              _animation.value,
            )!;

            return GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.all(10),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: totalCount,
              itemBuilder: (context, index) {
                return Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: glowColor,
                    boxShadow: [
                      BoxShadow(
                        color: glowColor.withOpacity(0.8),
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
