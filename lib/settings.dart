import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'store.dart';

//Slider Constatnts
const int divisions = 17;
const double minDuration = 150;
const double maxDuration = 1000;

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    final store = context.watch<TorchStore>();

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              margin: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Flash Mode toggle
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Flash Mode'),
                      ElevatedButton(
                        onPressed: () {
                          final store = context.read<TorchStore>();
                          store.flashConstant = !store
                              .flashConstant; // automatically rebuilds TorchPage
                        },
                        child: Text(
                          store.flashConstant ? 'Constant' : 'Blinking',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Flash On Duration slider
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Flash On Duration'),
                      Text('${store.flashOnDurationMs} ms'),
                    ],
                  ),
                  Slider(
                    value: store.flashOnDurationMs.toDouble(),
                    min: minDuration,
                    max: maxDuration,
                    divisions: divisions,
                    onChanged: store.flashConstant
                        ? null // disable slider in constant mode
                        : (value) => store.flashOnDurationMs = value.toInt(),
                  ),
                  //Flash Off Duration slider
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Flash Off Duration'),
                      Text('${store.flashOffDurationMs} ms'),
                    ],
                  ),
                  Slider(
                    value: store.flashOffDurationMs.toDouble(),
                    min: minDuration,
                    max: maxDuration,
                    divisions: divisions,
                    onChanged: store.flashConstant
                        ? null // disable slider in constant mode
                        : (value) => store.flashOffDurationMs = value.toInt(),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),

            Card(
              margin: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Display Mode toggle
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Display Mode'),
                      ElevatedButton(
                        onPressed: () {
                          final store = context.read<TorchStore>();
                          store.displayConstant = !store.displayConstant;
                        },
                        child: Text(
                          store.displayConstant ? 'Constant' : 'Blinking',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Display On Duration slider
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Display On Duration'),
                      Text('${store.displayOnDurationMs} ms'),
                    ],
                  ),
                  Slider(
                    value: store.displayOnDurationMs.toDouble(),
                    min: minDuration,
                    max: maxDuration,
                    divisions: divisions,
                    onChanged: store.displayConstant
                        ? null // disable slider in constant mode
                        : (value) => store.displayOnDurationMs = value.toInt(),
                  ),
                  //Display Off Duration slider
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Display Off Duration'),
                      Text('${store.displayOffDurationMs} ms'),
                    ],
                  ),
                  Slider(
                    value: store.displayOffDurationMs.toDouble(),
                    min: minDuration,
                    max: maxDuration,
                    divisions: divisions,
                    onChanged: store.displayConstant
                        ? null // disable slider in constant mode
                        : (value) => store.displayOffDurationMs = value.toInt(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
