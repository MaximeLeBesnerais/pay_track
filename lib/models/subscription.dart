// category for the subscription like music, video, etc.
import 'package:flutter/material.dart';
import 'package:rrule/rrule.dart';

enum Category { music, video, gaming, social, income, taxes, other }

const Map<Category, IconData> categoryIcons = {
  Category.music: Icons.audiotrack_rounded,
  Category.video: Icons.ondemand_video_rounded,
  Category.gaming: Icons.videogame_asset_rounded,
  Category.social: Icons.people_rounded,
  Category.income: Icons.monetization_on,
  Category.taxes: Icons.money_off_rounded,
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
