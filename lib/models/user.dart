import 'package:flutter/material.dart';
import 'package:pay_track/models/subscription.dart';

enum MonthlyMode {
  fixedInterval,
  byMonthDay,
}

class UserPref {
  String? name;
  Subscription? salary;
  MonthlyMode monthlyMode = MonthlyMode.byMonthDay;
  Color dominantColor = Colors.blue;
  ThemeMode themeMode = ThemeMode.system;

  UserPref({
    this.name,
    this.salary,
  });

  // do all setters
  void setName(String? name) {
    this.name = name;
  }

  void setSalary(Subscription? salary) {
    this.salary = salary;
  }

  void setMonthlyMode(MonthlyMode monthlyMode) {
    this.monthlyMode = monthlyMode;
  }

  void setDominantColor(Color dominantColor) {
    this.dominantColor = dominantColor;
  }

  void setThemeMode(ThemeMode themeMode) {
    this.themeMode = themeMode;
  }

}
