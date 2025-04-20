import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

CalendarBuilders calBuild() {
  return CalendarBuilders(
    markerBuilder: (context, date, events) {
      if (events.isEmpty) return const SizedBox.shrink();

      final visibleEvents = events.take(3).toList();
      final tooMany = events.length > 3;

      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(visibleEvents.length, (i) {
          final isLast = i == 2 && tooMany;

          if (isLast && tooMany) {
            return Container(
              width: 10,
              height: 10,
              margin: const EdgeInsets.symmetric(horizontal: 0),
              alignment: Alignment.center,
              child: const Text(
                '▼',
                style: TextStyle(fontSize: 10, color: Colors.blue, height: 1),
              ),
            );
          } else {
            return Container(
              width: 6,
              height: 6,
              margin: const EdgeInsets.symmetric(horizontal: 1),
              decoration: const BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
            );
          }
        }),
      );
    },
  );
}
