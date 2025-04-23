import 'package:flutter/material.dart';
import 'package:pay_track/models/subscription.dart';

Widget listEvents(List<Subscription> events) {
  return Expanded(
    child: ListView.builder(
      itemCount: events.length,
      itemBuilder: (context, index) {
        final event = events[index];
        return ListTile(
          title: Text(event.name),
          subtitle: Text(event.category.toString()),
          trailing: Text('\$${event.amount.toStringAsFixed(2)}'),
        );
      },
    ),
  );
}
