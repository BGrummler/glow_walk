import 'package:torch_light/torch_light.dart';
import 'store.dart';

class TorchController {
  bool _running = false;
  bool _logicOn = false;     // User toggle
  bool _torchIsOn = false;   // Actual hardware state
  bool _blinkOn = false;

  final TorchStore store;

  TorchController(this.store);

  bool get isOn => _logicOn;

  void toggle() {
    _logicOn = !_logicOn;

    if (!_logicOn) {
      _blinkOn = false;
      stopLoop();
    } else {
      startLoop();
    }
  }

  Future<void> _torchOn() async {
    if (!_torchIsOn) {
      await TorchLight.enableTorch();
      _torchIsOn = true;
    }
  }

  Future<void> _torchOff() async {
    if (_torchIsOn) {
      await TorchLight.disableTorch();
      _torchIsOn = false;
    }
  }

  Future<void> startLoop() async {
    if (_running) return;
    _running = true;

    while (_running) {
      final onMs  = store.flashOnDurationMs.clamp(150, 1000);
      final offMs = store.flashOffDurationMs.clamp(150, 1000);

      // 🔴 User disabled flash → keep turned off
      if (!_logicOn || !store.flashEnabled) {
        await _torchOff();
        await Future.delayed(Duration(milliseconds: offMs));
        continue;
      }

      // 🔵 Constant mode
      if (store.flashConstant) {
        await _torchOn();
        await Future.delayed(Duration(milliseconds: onMs));
        continue;
      }

      // 🟡 Blinking mode
      if (_blinkOn) {
        await _torchOn();
        await Future.delayed(Duration(milliseconds: onMs));
      } else {
        await _torchOff();
        await Future.delayed(Duration(milliseconds: offMs));
      }

      _blinkOn = !_blinkOn;
    }
  }

  void stopLoop() {
    _running = false;
    _torchOff();
  }
}
