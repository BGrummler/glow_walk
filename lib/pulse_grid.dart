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
  late Animation<double> _animation;  // <-- declare this

  @override
  void initState() {
    super.initState();
    final store = context.read<TorchStore>();

    if (store.displayConstant) {
      // Constant mode: no animation needed
      _animation = AlwaysStoppedAnimation(1.0);
      _controller = AnimationController(vsync: this); // dummy controller
    } else {
      final cycleDuration = store.displayOnDurationMs + store.displayOffDurationMs;

      _controller = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: cycleDuration),
      );

      _animation = TweenSequence<double>([
        TweenSequenceItem(
          tween: Tween(begin: 0.0, end: 1.0),
          weight: store.displayOnDurationMs.toDouble(),
        ),
        TweenSequenceItem(
          tween: Tween(begin: 1.0, end: 0.0),
          weight: store.displayOffDurationMs.toDouble(),
        ),
      ]).animate(_controller);

      _controller.repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final circleSize = 50.0;
        final crossAxisCount = (constraints.maxWidth / (circleSize + 10)).floor();
        final mainAxisCount = ((constraints.maxHeight - 90) / (circleSize + 10)).floor();
        final totalCount = crossAxisCount * mainAxisCount;

        return AnimatedBuilder(
          animation: _animation, // <-- animate _animation, not _controller
          builder: (context, _) {
            final glowColor = Color.lerp(
              Colors.black,
              const Color.fromARGB(255, 255, 0, 0),
              _animation.value, // <-- use _animation.value
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
