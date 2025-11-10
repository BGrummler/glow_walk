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
  late int _blinkInterval;

  @override
  void initState() {
    super.initState();
    final store = context.read<TorchStore>();
    _blinkInterval = store.blinkIntervalMs.clamp(150, 1000);

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: _blinkInterval),
    )..repeat(reverse: true);
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
        final crossAxisCount =
            (constraints.maxWidth / (circleSize + 10)).floor();
        final mainAxisCount =
            ((constraints.maxHeight - 90) / (circleSize + 10)).floor();
        final totalCount = crossAxisCount * mainAxisCount;

        return AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            final glowColor = Color.lerp(
              Colors.black,
              const Color.fromARGB(255, 255, 0, 0),
              _controller.value,
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
                        color: glowColor.withValues(alpha: 0.8),
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
