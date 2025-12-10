import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'store.dart';

// Slider Constants
const int divisions = 17;
const double minDuration = 150;
const double maxDuration = 1000;

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  static const List<Color> visibleColors = [
    Colors.red,
    Colors.green,
    Colors.yellow,
  ];

  @override
  Widget build(BuildContext context) {
    final store = context.watch<TorchStore>();

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            // Flash settings card
            Card(
              margin: const EdgeInsets.symmetric(vertical: 6),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    // Flash Enabled toggle
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Flash Enabled'),
                        Switch(
                          value: store.flashEnabled,
                          onChanged: (val) => store.flashEnabled = val,
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Flash Mode'),
                        ElevatedButton(
                          onPressed: () => store.flashConstant = !store.flashConstant,
                          child: Text(store.flashConstant ? 'Constant' : 'Blinking'),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('On Duration'),
                        Text('${store.flashOnDurationMs} ms'),
                      ],
                    ),
                    Slider(
                      value: store.flashOnDurationMs.toDouble(),
                      min: minDuration,
                      max: maxDuration,
                      divisions: divisions,
                      onChanged: store.flashConstant ? null : (v) => store.flashOnDurationMs = v.toInt(),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Off Duration'),
                        Text('${store.flashOffDurationMs} ms'),
                      ],
                    ),
                    Slider(
                      value: store.flashOffDurationMs.toDouble(),
                      min: minDuration,
                      max: maxDuration,
                      divisions: divisions,
                      onChanged: store.flashConstant ? null : (v) => store.flashOffDurationMs = v.toInt(),
                    ),
                  ],
                ),
              ),
            ),

            // Display settings card
            Card(
              margin: const EdgeInsets.symmetric(vertical: 6),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Display Enabled'),
                        Switch(
                          value: store.displayEnabled,
                          onChanged: (val) => store.displayEnabled = val,
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Display Mode'),
                        ElevatedButton(
                          onPressed: () => store.displayConstant = !store.displayConstant,
                          child: Text(store.displayConstant ? 'Constant' : 'Blinking'),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('On Duration'),
                        Text('${store.displayOnDurationMs} ms'),
                      ],
                    ),
                    Slider(
                      value: store.displayOnDurationMs.toDouble(),
                      min: minDuration,
                      max: maxDuration,
                      divisions: divisions,
                      onChanged: store.displayConstant ? null : (v) => store.displayOnDurationMs = v.toInt(),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Off Duration'),
                        Text('${store.displayOffDurationMs} ms'),
                      ],
                    ),
                    Slider(
                      value: store.displayOffDurationMs.toDouble(),
                      min: minDuration,
                      max: maxDuration,
                      divisions: divisions,
                      onChanged: store.displayConstant ? null : (v) => store.displayOffDurationMs = v.toInt(),
                    ),
                    const SizedBox(height: 8),
                    // Color picker row
                    Row(
                      children: visibleColors.map((color) {
                        final isSelected = store.displayColor == color;
                        return GestureDetector(
                          onTap: () => store.displayColor = color,
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 3),
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: color,
                              shape: BoxShape.circle,
                              border: isSelected ? Border.all(color: Colors.white, width: 2) : null,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
