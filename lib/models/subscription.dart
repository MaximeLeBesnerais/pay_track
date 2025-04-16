// category for the subscription like music, video, etc.
import 'package:rrule/rrule.dart';

enum Category { music, video, gaming, social, income, taxes, other }


class Subscription {
  final String name;
  final DateTime startDate;
  final double price;
  final Category category;
  final RecurrenceRule recurrenceRule;
  final DateTime? endDate;
  final String? description;


  Subscription({
    required this.name,
    required this.startDate,
    required this.price,
    required this.category,
    required this.recurrenceRule,
    this.endDate,
    this.description,
  });

  Subscription.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        startDate = DateTime.parse(json['startDate']),
        price = json['price'].toDouble(),
        category = Category.values[json['category']],
        recurrenceRule = RecurrenceRule.fromJson(json['recurrenceRule']),
        endDate = json['endDate'] != null ? DateTime.parse(json['endDate']) : null,
        description = json['description'];
  
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'startDate': startDate.toIso8601String(),
      'price': price,
      'category': category.index,
      'recurrenceRule': recurrenceRule.toJson(),
      'endDate': endDate?.toIso8601String(),
      'description': description,
    };
  }
  
}
