import 'dart:math';

class TimeInterval {
  final int start;
  final int end;
  final String greeting;

  TimeInterval(this.start, this.end, this.greeting);

  bool isInInterval(DateTime dateTime) {
    final hour = dateTime.hour;
    if (start > end) {
      return hour >= start || hour < end;
    }
    return hour >= start && hour < end;
  }
}

String getGreeting() {
  final now = DateTime.now();

  final timeIntervals = [
    TimeInterval(5, 12, "Good morning"),
    TimeInterval(12, 17, "Good afternoon"),
    TimeInterval(17, 21, "Good evening"),
    TimeInterval(21, 5, "Good night"),
  ];

  for (var interval in timeIntervals) {
    if (interval.isInInterval(now)) {
      return interval.greeting;
    }
  }
  return 'Hello there';
}
