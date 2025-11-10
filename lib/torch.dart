import 'package:torch_light/torch_light.dart';
import 'store.dart';

class TorchController {
  bool _isTorchOn = false;
  bool _blinkOn = false;
  bool _running = false;
  final TorchStore store;

  TorchController(this.store);

  bool get isOn => _isTorchOn;

  void toggle() {
    _isTorchOn = !_isTorchOn;
    if (!_isTorchOn) {
      _blinkOn = false;
      stopLoop();
      } else {
      startLoop();}
  }

  Future<void> startLoop() async {
    if (_running) return;
    _running = true;

    while (_running) {
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

  void stopLoop() {
    _running = false;
    TorchLight.disableTorch();
  }
}
