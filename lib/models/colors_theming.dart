
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum DominantColor { red, green, blue, yellow, purple, orange }
enum ChosenTheming { light, dark, system }

const Map<DominantColor, Color> colorMapEnum = {
  DominantColor.red: Colors.red,
  DominantColor.green: Colors.green,
  DominantColor.blue: Colors.blue,
  DominantColor.yellow: Colors.yellow,
  DominantColor.purple: Colors.purple,
  DominantColor.orange: Colors.orange,
};

const Map<ChosenTheming, ThemeMode> themeModeMapEnum = {
  ChosenTheming.light: ThemeMode.light,
  ChosenTheming.dark: ThemeMode.dark,
  ChosenTheming.system: ThemeMode.system,
};

class ColorsTheming {
  ColorsTheming._privateConstructor();
  static final ColorsTheming _instance = ColorsTheming._privateConstructor();

  factory ColorsTheming() {
    return _instance;
  }

  final List<VoidCallback> _listeners = [];
  void addListener(VoidCallback listener) {
    _listeners.add(listener);
  }
  void removeListener(VoidCallback listener) {
    _listeners.remove(listener);
  }
  void notifyListeners() {
    for (var listener in _listeners) {
      listener();
    }
  }

  DominantColor _dominantColor = DominantColor.blue;
  ChosenTheming _chosenTheming = ChosenTheming.system;
  final String sharedPrefKey = 'colors_theming';
  bool _isInitialized = false;



  Future<void> init() async {
    if (_isInitialized) return;
    try {
      final prefs = await SharedPreferences.getInstance();
      final dataString = prefs.getString(sharedPrefKey);
      final decodedData = dataString != null
          ? Map<String, dynamic>.from(jsonDecode(dataString))
          : null;
      if (decodedData != null) {
        _dominantColor = DominantColor.values[decodedData['dominantColor']];
        _chosenTheming = ChosenTheming.values[decodedData['chosenTheming']];
      }
    } catch (e) {
      debugPrint('Error initializing ColorsTheming: $e');
    }
    _isInitialized = true;
  }

  Future<void> save() async {
    if (!_isInitialized) {
      await init();
    }
    try {
      final prefs = await SharedPreferences.getInstance();
      final data = {
        'dominantColor': _dominantColor.index,
        'chosenTheming': _chosenTheming.index,
      };
      final dataString = jsonEncode(data);
      await prefs.setString(sharedPrefKey, dataString);
      notifyListeners();
    } catch (e) {
      debugPrint('Error saving ColorsTheming: $e');
    }
  }

  DominantColor get dominantColor => _dominantColor;
  set dominantColor(DominantColor value) {
    _dominantColor = value;
    save();
  }

  ChosenTheming get chosenTheming => _chosenTheming;
  set chosenTheming(ChosenTheming value) {
    _chosenTheming = value;
    save();
  }
}
