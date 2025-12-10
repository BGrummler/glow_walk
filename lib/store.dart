import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TorchStore extends ChangeNotifier {
  static const int minInterval = 150;
  static const int maxInterval = 1000;

  // default values
  bool _flashEnabled = true;
  bool _displayEnabled = true;
  bool _flashConstant = false;
  bool _displayConstant = false;
  int _flashOnDurationMs = 250;
  int _flashOffDurationMs = 500;
  int _displayOnDurationMs = 250;
  int _displayOffDurationMs = 500;
  Color _displayColor = Colors.red;

  // getters
  bool get flashEnabled => _flashEnabled;
  bool get displayEnabled => _displayEnabled;
  bool get flashConstant => _flashConstant;
  bool get displayConstant => _displayConstant;
  int get flashOnDurationMs => _flashOnDurationMs;
  int get flashOffDurationMs => _flashOffDurationMs;
  int get displayOnDurationMs => _displayOnDurationMs;
  int get displayOffDurationMs => _displayOffDurationMs;
  Color get displayColor => _displayColor;

  // constructor: load saved prefs
  TorchStore() {
    _loadPrefs();
  }

  Future<void> _loadPrefs() async {
    final prefs = await SharedPreferences.getInstance();

    _flashEnabled = prefs.getBool('flashEnabled') ?? _flashEnabled;
    _displayEnabled = prefs.getBool('displayEnabled') ?? _displayEnabled;
    _flashConstant = prefs.getBool('flashConstant') ?? _flashConstant;
    _displayConstant = prefs.getBool('displayConstant') ?? _displayConstant;
    _flashOnDurationMs = prefs.getInt('flashOnDurationMs') ?? _flashOnDurationMs;
    _flashOffDurationMs = prefs.getInt('flashOffDurationMs') ?? _flashOffDurationMs;
    _displayOnDurationMs = prefs.getInt('displayOnDurationMs') ?? _displayOnDurationMs;
    _displayOffDurationMs = prefs.getInt('displayOffDurationMs') ?? _displayOffDurationMs;

    // Store Color as ARGB integer
    final colorValue = prefs.getInt('displayColor');
    if (colorValue != null) _displayColor = Color(colorValue);

    notifyListeners();
  }

  Future<void> _savePrefs() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool('flashEnabled', _flashEnabled);
    await prefs.setBool('displayEnabled', _displayEnabled);
    await prefs.setBool('flashConstant', _flashConstant);
    await prefs.setBool('displayConstant', _displayConstant);
    await prefs.setInt('flashOnDurationMs', _flashOnDurationMs);
    await prefs.setInt('flashOffDurationMs', _flashOffDurationMs);
    await prefs.setInt('displayOnDurationMs', _displayOnDurationMs);
    await prefs.setInt('displayOffDurationMs', _displayOffDurationMs);
    await prefs.setInt('displayColor', _displayColor.value);
  }

  // setters: save and notify
  set flashEnabled(bool val) {
    _flashEnabled = val;
    _savePrefs();
    notifyListeners();
  }

  set displayEnabled(bool val) {
    _displayEnabled = val;
    _savePrefs();
    notifyListeners();
  }

  set flashConstant(bool val) {
    _flashConstant = val;
    _savePrefs();
    notifyListeners();
  }

  set displayConstant(bool val) {
    _displayConstant = val;
    _savePrefs();
    notifyListeners();
  }

  set flashOnDurationMs(int val) {
    final clamped = val.clamp(minInterval, maxInterval);
    if (_flashOnDurationMs != clamped) {
      _flashOnDurationMs = clamped;
      _savePrefs();
      notifyListeners();
    }
  }

  set flashOffDurationMs(int val) {
    final clamped = val.clamp(minInterval, maxInterval);
    if (_flashOffDurationMs != clamped) {
      _flashOffDurationMs = clamped;
      _savePrefs();
      notifyListeners();
    }
  }

  set displayOnDurationMs(int val) {
    final clamped = val.clamp(minInterval, maxInterval);
    if (_displayOnDurationMs != clamped) {
      _displayOnDurationMs = clamped;
      _savePrefs();
      notifyListeners();
    }
  }

  set displayOffDurationMs(int val) {
    final clamped = val.clamp(minInterval, maxInterval);
    if (_displayOffDurationMs != clamped) {
      _displayOffDurationMs = clamped;
      _savePrefs();
      notifyListeners();
    }
  }

  set displayColor(Color value) {
    _displayColor = value;
    _savePrefs();
    notifyListeners();
  }
}
