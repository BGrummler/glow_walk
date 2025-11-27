import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'settings.dart';
import 'store.dart';
import 'torch.dart';
import 'pulse_grid.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

// lib/main.dart

// TODO: add display animation fade in / out logic when toggling torch

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  
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
  late final TorchController _torch;  

  @override
  void initState() {
    super.initState();
    WakelockPlus.enable();
    final store = context.read<TorchStore>();
    _torch = TorchController(store);
  }

  @override
  void dispose() {
    WakelockPlus.disable();
    _torch.stopLoop();
    super.dispose();
  }

  void _toggleTorch() {
    setState(_torch.toggle);
  }

  @override
  Widget build(BuildContext context) {
    final _ = context.watch<TorchStore>();

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
      body: Container(
        color: Colors.black,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final circleSize = 50.0;
            final crossAxisCount = (constraints.maxWidth / (circleSize + 10))
                .floor();
            final mainAxisCount =
                ((constraints.maxHeight - 90) / (circleSize + 10)).floor();
            final totalCount = crossAxisCount * mainAxisCount;

            return _torch.isOn
                ? const PulsingGrid()
                : GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(10),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: totalCount,
                    itemBuilder: (context, index) => Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color.fromARGB(
                          255,
                          255,
                          17,
                          0,
                        ).withValues(alpha: 0.2),
                      ),
                    ),
                  );
          },
        ),
      ),

      bottomNavigationBar: SafeArea(
        child: SizedBox(
          width: double.infinity,
          height: 70,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: _torch.isOn ? Colors.redAccent : Colors.green,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.zero,
              ),
            ),
            onPressed: _toggleTorch,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _torch.isOn ? 'Turn Off' : 'Turn On',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(width: 10),
                Icon(
                  _torch.isOn ? Icons.flash_off : Icons.flash_on,
                  size: 24,
                  color: _torch.isOn ? Colors.grey : Colors.yellow,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}