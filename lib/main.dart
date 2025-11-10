import 'package:flutter/material.dart';
import 'package:torch_light/torch_light.dart';
import 'package:provider/provider.dart';
import 'settings.dart';
import 'store.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => TorchStore(),
      child: const GlowWalkApp(),
    ),
  );
}

class GlowWalkApp extends StatelessWidget {
  const GlowWalkApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'GlowWalk',
      theme: ThemeData.dark().copyWith(
        colorScheme: const ColorScheme.dark(
          primary: Colors.redAccent,
          secondary: Colors.orangeAccent,
        ),
      ),
      home: const TorchPage(),
    );
  }
}

class TorchPage extends StatefulWidget {
  const TorchPage({super.key});

  @override
  State<TorchPage> createState() => _TorchPageState();
}

class _TorchPageState extends State<TorchPage> {
  bool _isTorchOn = false;
  bool _blinkOn = false;
  late final TorchStore store;

  @override
  void initState() {
    super.initState();
    store = context.read<TorchStore>();
    _torchLoop(); // start the continuous loop
  }

  void _torchLoop() async {
    while (mounted) {
      final interval = store.blinkIntervalMs.clamp(150, 1000);
      final isConstant = store.isConstant;

      if (_isTorchOn) {
        if (isConstant) {
          await TorchLight.enableTorch();
        } else {
          if (_blinkOn) {
            await TorchLight.enableTorch();
          } else {
            await TorchLight.disableTorch();
          }
          _blinkOn = !_blinkOn;
        }
      } else {
        await TorchLight.disableTorch();
      }

      await Future.delayed(Duration(milliseconds: interval));
    }
  }

  void _toggleTorch() {
    setState(() {
      _isTorchOn = !_isTorchOn;
      if (!_isTorchOn) _blinkOn = false; // reset blinking
    });
  }

  @override
  Widget build(BuildContext context) {
    final _ = context.watch<TorchStore>(); // rebuild UI on settings changes

    return Scaffold(
      appBar: AppBar(
        title: const Text('GlowWalk'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: 'Settings',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SettingsPage()),
            ),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _isTorchOn ? Icons.flash_on : Icons.flash_off,
              size: 120,
              color: _isTorchOn ? Colors.yellow : Colors.grey,
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: _isTorchOn ? Colors.redAccent : Colors.green,
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              onPressed: _toggleTorch,
              child: Text(
                _isTorchOn ? 'Turn Off' : 'Turn On1',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
