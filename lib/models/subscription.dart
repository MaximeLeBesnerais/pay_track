// category for the subscription like music, video, etc.
import 'package:rrule/rrule.dart';

enum Category { music, video, gaming, social, income, taxes, other }


class Subscription {
  final String id;
  final String name;
  final DateTime startDate;
  final double price;
  final Category category;
  final RecurrenceRule recurrenceRule;
  final DateTime? endDate;
  final String? description;


  Subscription({
    required this.id,
    required this.name,
    required this.startDate,
    required this.price,
    required this.category,
    required this.recurrenceRule,
    this.endDate,
    this.description,
  });

}
