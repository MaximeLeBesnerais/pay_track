// category for the subscription like music, video, etc.
import 'package:rrule/rrule.dart';

enum Category { music, video, gaming, social, income, taxes, other }
enum ThemeColor { blue, green, red, purple, orange }
enum ThemeStyle { light, dark, system }

class Subscription {
  final String name;
  final DateTime startDate;
  final double amount;
  final Category category;
  final ThemeColor? themeColor;
  final ThemeStyle? themeStyle;
  final RecurrenceRule recurrenceRule;
  final DateTime? endDate;
  final String? description;


  Subscription({
    required this.name,
    required this.startDate,
    required this.amount,
    required this.category,
    required this.recurrenceRule,
    this.themeColor,
    this.themeStyle,
    this.endDate,
    this.description,
  });

  Subscription.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        startDate = DateTime.parse(json['startDate']),
        amount = json['price'].toDouble(),
        category = Category.values[json['category']],
        themeColor = json['themeColor'] != null
            ? ThemeColor.values[json['themeColor']]
            : null,
        themeStyle = json['themeStyle'] != null
            ? ThemeStyle.values[json['themeStyle']]
            : null,
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
