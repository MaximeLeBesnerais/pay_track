// category for the subscription like music, video, etc.
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:rrule/rrule.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum Category { food, music, video, gaming, social, income, other }

const Map<Category, IconData> categoryIcons = {
  Category.food: Icons.fastfood_rounded,
  Category.music: Icons.audiotrack_rounded,
  Category.video: Icons.ondemand_video_rounded,
  Category.gaming: Icons.videogame_asset_rounded,
  Category.social: Icons.people_rounded,
  Category.income: Icons.monetization_on,
  Category.other: Icons.category,
};

class Subscription {
  final String name;
  final DateTime startDate;
  final double amount;
  final Category category;
  final RecurrenceRule recurrenceRule;
  final DateTime? endDate;
  final String? description;


  Subscription({
    required this.name,
    required this.startDate,
    required this.amount,
    required this.category,
    required this.recurrenceRule,
    this.endDate,
    this.description,
  });

  Subscription.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        startDate = DateTime.parse(json['startDate']),
        amount = json['price'].toDouble(),
        category = Category.values[json['category']],
        recurrenceRule = RecurrenceRule.fromJson(json['recurrenceRule']),
        endDate = json['endDate'] != null ? DateTime.parse(json['endDate']) : null,
        description = json['description'];
  
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'startDate': startDate.toIso8601String(),
      'price': amount,
      'category': category.index,
      'recurrenceRule': recurrenceRule.toJson(),
      'endDate': endDate?.toIso8601String(),
      'description': description,
    };
  }
  
}

class SubscriptionList {
  SubscriptionList._privateConstructor();
  static final SubscriptionList _instance = SubscriptionList._privateConstructor();
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

  factory SubscriptionList() {
    return _instance;
  }

  List<Subscription> subscriptions = [];
  bool _isInitialized = false;
  static const String sharedPrefKey = 'subscriptions';
  
  Future<void> init() async {
    if (_isInitialized) return;
    try {
      final prefs = await SharedPreferences.getInstance();
      final dataString = prefs.getString(sharedPrefKey);
      final decodedData =
          dataString != null
              ? List<Map<String, dynamic>>.from(jsonDecode(dataString))
              : null;
      if (decodedData != null) {
        subscriptions = decodedData.map((e) => Subscription.fromJson(e)).toList();
      }
    } catch (e) {
      debugPrint('Error initializing SubscriptionList: $e');
    }
    _isInitialized = true;
  }

  Future<void> save() async {
    if (!_isInitialized) {
      await init();
    }
    try {
      final prefs = await SharedPreferences.getInstance();
      final data = subscriptions.map((e) => e.toJson()).toList();
      final dataString = jsonEncode(data);
      await prefs.setString(sharedPrefKey, dataString);
    } catch (e) {
      debugPrint('Error saving SubscriptionList: $e');
    }
  }

  void addSubscription(Subscription subscription) {
    subscriptions.add(subscription);
    notifyListeners();
  }

  void removeSubscription(Subscription subscription) {
    subscriptions.remove(subscription);
    notifyListeners();
  }

  void updateSubscription(Subscription oldSubscription, Subscription newSubscription) {
    final index = subscriptions.indexOf(oldSubscription);
    if (index != -1) {
      subscriptions[index] = newSubscription;
      notifyListeners();
    }
  }

  List<Subscription> getSubscriptionsByDate(DateTime date) {
    return subscriptions.where((subscription) {
      final startDate = subscription.startDate;
      final endDate = subscription.endDate ?? DateTime.now();
      return date.isAfter(startDate) && date.isBefore(endDate);
    }).toList();
  }
  List<Subscription> getSubscriptionsByDateRange(DateTime start, DateTime end) {
    return subscriptions.where((subscription) {
      final startDate = subscription.startDate;
      final endDate = subscription.endDate ?? DateTime.now();
      return (start.isBefore(endDate) && end.isAfter(startDate));
    }).toList();
  }

  List<Subscription> getSubscriptionsByCategory(Category category) {
    return subscriptions.where((subscription) => subscription.category == category).toList();
  }
  List<Subscription> getSubscriptionsByName(String name) {
    return subscriptions.where((subscription) => subscription.name == name).toList();
  }
  List<Subscription> getSubscriptionsByAmountRange(double min, double max) {
    return subscriptions.where((subscription) => subscription.amount >= min && subscription.amount <= max).toList();
  }
  List<Subscription> getSubscriptionsByRecurrence(RecurrenceRule rule) {
    return subscriptions.where((subscription) => subscription.recurrenceRule == rule).toList();
  }

  void sortSubscriptionsByDate({bool ascending = true}) {
    subscriptions.sort((a, b) => ascending
        ? a.startDate.compareTo(b.startDate)
        : b.startDate.compareTo(a.startDate));
    notifyListeners();
  }
  void sortSubscriptionsByName({bool ascending = true}) {
    subscriptions.sort((a, b) => ascending
        ? a.name.compareTo(b.name)
        : b.name.compareTo(a.name));
    notifyListeners();
  }
  void sortSubscriptionsByAmount({bool ascending = true}) {
    subscriptions.sort((a, b) => ascending
        ? a.amount.compareTo(b.amount)
        : b.amount.compareTo(a.amount));
    notifyListeners();
  }
  void sortSubscriptionsByCategory({bool ascending = true}) {
    subscriptions.sort((a, b) => ascending
        ? a.category.index.compareTo(b.category.index)
        : b.category.index.compareTo(a.category.index));
    notifyListeners();
  }
}
