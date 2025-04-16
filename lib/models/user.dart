import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pay_track/models/subscription.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum MonthlyMode { fixedInterval, byMonthDay }

enum DominantColor { red, green, blue, yellow, purple, orange }

const Map<DominantColor, Color> colorMapEnum = {
  DominantColor.red: Colors.red,
  DominantColor.green: Colors.green,
  DominantColor.blue: Colors.blue,
  DominantColor.yellow: Colors.yellow,
  DominantColor.purple: Colors.purple,
  DominantColor.orange: Colors.orange,
};

class UserPref {
  UserPref._privateConstructor();

  static final UserPref _instance = UserPref._privateConstructor();
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

  factory UserPref() {
    return _instance;
  }

  String? name;
  Subscription? salary;
  MonthlyMode monthlyMode = MonthlyMode.byMonthDay;
  DominantColor dominantColor = DominantColor.blue;
  ThemeMode themeMode = ThemeMode.system;
  bool _isInitialized = false;
  static const String sharedPrefKey = 'user_pref';

  Future<void> init() async {
    if (_isInitialized) return;
    try {
      final prefs = await SharedPreferences.getInstance();
      final dataString = prefs.getString(sharedPrefKey);
      final decodedData =
          dataString != null
              ? Map<String, dynamic>.from(jsonDecode(dataString))
              : null;
      if (decodedData != null) {
        name = decodedData['name'];
        salary = Subscription.fromJson(decodedData['salary']);
        monthlyMode = MonthlyMode.values[decodedData['monthlyMode']];
        dominantColor = DominantColor.values[decodedData['dominantColor']];
        themeMode = ThemeMode.values[decodedData['themeMode']];
      }
    } catch (e) {
      debugPrint('Error initializing UserPref: $e');
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
        'name': name,
        'salary': salary?.toJson(),
        'monthlyMode': monthlyMode.index,
        'themeMode': themeMode.index,
        'dominantColor': dominantColor.index,
      };
      final dataString = jsonEncode(data);
      await prefs.setString(sharedPrefKey, dataString);
      notifyListeners();
    } catch (e) {
      debugPrint('Error saving UserPref: $e');
    }
  }

  Future<void> clear() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(sharedPrefKey);
      name = null;
      salary = null;
      monthlyMode = MonthlyMode.byMonthDay;
      dominantColor = DominantColor.red;
      themeMode = ThemeMode.system;
      notifyListeners();
    } catch (e) {
      debugPrint('Error clearing UserPref: $e');
    }
  }

  Future<void> setName(String name) async {
    this.name = name;
    await save();
  }

  Future<void> setSalary(Subscription salary) async {
    this.salary = salary;
    await save();
  }

  Future<void> setMonthlyMode(MonthlyMode mode) async {
    monthlyMode = mode;
    await save();
  }

  Future<void> setDominantColor(DominantColor color) async {
    dominantColor = color;
    await save();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    themeMode = mode;
    await save();
  }

  Future<void> setAll(
    String? name,
    Subscription? salary,
    MonthlyMode monthlyMode,
    DominantColor dominantColor,
    ThemeMode themeMode,
  ) async {
    this.name = name;
    this.salary = salary;
    this.monthlyMode = monthlyMode;
    this.dominantColor = dominantColor;
    this.themeMode = themeMode;
    await save();
  }
}
