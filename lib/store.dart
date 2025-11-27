import 'package:flutter/foundation.dart'; // provides ChangeNotifier

class TorchStore extends ChangeNotifier {
  static const int minInterval = 150;
  static const int maxInterval = 1000;

  @Deprecated('Use _flashConstant / _displayConstant instead')
  bool _isConstant = false;
  bool _flashConstant = true;    // true = flash is constant, false = blinking
  bool _displayConstant = false; // true = display is constant, false = blinking
  int _blinkIntervalMs = 250; //deprecated
  int _flashOnDurationMs = 250; // duration the flash stays on during a blink
  int _flashOffDurationMs = 250; // duration the flash stays off during a blink
  int _displayOnDurationMs = 250; // duration the display stays bright during a blink
  int _displayOffDurationMs = 250; // duration the display stays dim during a blink

  @Deprecated('Use flashConstant / displayConstant instead')
  bool get isConstant => _isConstant;
  set isConstant(bool val) {
    _isConstant = val;
    notifyListeners();
  }

  bool get flashConstant => _flashConstant;
  set flashConstant(bool val) {
    _flashConstant = val;
    notifyListeners();
  }

  bool get displayConstant => _displayConstant;
  set displayConstant(bool val) {
    _displayConstant = val;
    notifyListeners();
  }


  @Deprecated('Use flashOnDurationMs / flashOffDurationMs instead')
  set blinkIntervalMs(int val) {
    final clamped = val.clamp(minInterval, maxInterval);
    if (_blinkIntervalMs != clamped) {
      _blinkIntervalMs = clamped;
      notifyListeners();
    }
  }

  set flashOffDurationMs(int val) {
    final clamped = val.clamp(minInterval, maxInterval);
    if (clamped != _flashOffDurationMs){
      _flashOffDurationMs = clamped;
      notifyListeners();
    }
  }

  set flashOnDurationMs(int val) {
    final clamped = val.clamp(minInterval, maxInterval);
    if (clamped != _flashOnDurationMs){
      _flashOnDurationMs = clamped;
      notifyListeners();
    }
  }

  set displayOnDurationMs(int val) {
    final clamped = val.clamp(minInterval, maxInterval);
    if (clamped != _displayOnDurationMs) {
    _displayOnDurationMs = clamped;
    notifyListeners();
    }
  }

  set displayOffDurationMs(int val) {
    final clamped = val.clamp(minInterval, maxInterval);
    if (clamped != _displayOffDurationMs){
    _displayOffDurationMs = clamped;
    notifyListeners();
    }
  }

  @Deprecated('Use flashOnDurationMs / flashOffDurationMs instead')
  int get blinkIntervalMs => _blinkIntervalMs;
  int get flashOnDurationMs => _flashOnDurationMs;
  int get flashOffDurationMs => _flashOffDurationMs;
  int get displayOnDurationMs => _displayOnDurationMs;
  int get displayOffDurationMs => _displayOffDurationMs;
}
