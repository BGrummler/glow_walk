import 'package:flutter/foundation.dart'; // provides ChangeNotifier

class TorchStore extends ChangeNotifier {
  static const int minInterval = 150;
  static const int maxInterval = 1000;

  bool _isConstant = false;
  int _blinkIntervalMs = 250;

  bool get isConstant => _isConstant;
  set isConstant(bool val) {
    _isConstant = val;
    notifyListeners();
  }

  int get blinkIntervalMs => _blinkIntervalMs;

  set blinkIntervalMs(int val) {
    final clamped = val.clamp(minInterval, maxInterval);
    if (_blinkIntervalMs != clamped) {
      _blinkIntervalMs = clamped;
      notifyListeners();
    }
  }
}
