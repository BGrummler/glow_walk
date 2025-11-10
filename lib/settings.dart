import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'store.dart';

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
            // Mode toggle
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Mode'),
                ElevatedButton(
                  onPressed: () {
                    final store = context.read<TorchStore>();
                    store.isConstant =
                        !store.isConstant; // automatically rebuilds TorchPage
                  },
                  child: Text(store.isConstant ? 'Constant' : 'Blinking'),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Blink interval slider
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Blink Interval'),
                Text('${store.blinkIntervalMs} ms'),
              ],
            ),
            Slider(
              value: store.blinkIntervalMs.toDouble(),
              min: 150,
              max: 1000,
              divisions: 17,
              onChanged: (value) => store.blinkIntervalMs = value.toInt(),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
