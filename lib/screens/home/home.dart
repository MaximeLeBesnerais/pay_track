import 'package:flutter/material.dart';
import 'package:pay_track/models/subscription.dart';
import 'package:pay_track/screens/home/list_events.dart';
import 'package:pay_track/tools/get_greetings.dart';
import 'package:rrule/rrule.dart';
import 'package:table_calendar/table_calendar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

DateTime normalizeDate(DateTime date) =>
    DateTime(date.year, date.month, date.day);

class _HomeScreenState extends State<HomeScreen> {
  DateTime _focusDate = DateTime.now();
  DateTime _selectedDate = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.month;
  final Map<DateTime, List<Subscription>> _events = {
    normalizeDate(DateTime.now()): [
      Subscription(
        amount: 10.0,
        name: 'Event 1',
        category: Category.food,
        recurrenceRule: RecurrenceRule(frequency: Frequency.daily, interval: 1),
        startDate: DateTime.now(),
      ),
      Subscription(
        amount: 20.0,
        name: 'Event 2',
        category: Category.gaming,
        recurrenceRule: RecurrenceRule(
          frequency: Frequency.weekly,
          interval: 1,
        ),
        startDate: DateTime.now(),
      ),
      Subscription(
        amount: 30.0,
        name: 'Event 3',
        category: Category.video,
        recurrenceRule: RecurrenceRule(
          frequency: Frequency.monthly,
          interval: 1,
        ),
        startDate: DateTime.now(),
      ),
      Subscription(
        amount: 40.0,
        name: 'Event 4',
        category: Category.food,
        recurrenceRule: RecurrenceRule(
          frequency: Frequency.yearly,
          interval: 1,
        ),
        startDate: DateTime.now(),
      ),
    ],
    normalizeDate(DateTime.now().add(const Duration(days: 1))): [
      Subscription(
        amount: 50.0,
        name: 'Event 5',
        category: Category.gaming,
        recurrenceRule: RecurrenceRule(
          frequency: Frequency.daily,
          interval: 1,
        ),
        startDate: DateTime.now(),
      ),
    ],
    normalizeDate(DateTime.now().add(const Duration(days: 5))): [
      Subscription(
        amount: 60.0,
        name: 'Event 6',
        category: Category.video,
        recurrenceRule: RecurrenceRule(
          frequency: Frequency.weekly,
          interval: 1,
        ),
        startDate: DateTime.now(),
      ),
    ],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(
          left: 16.0,
          right: 16.0,
          top: 44.0,
          bottom: 16.0,
        ),
        child: Column(
          children: [
            Text(
              getGreeting(),
              style: Theme.of(context).textTheme.displayLarge,
            ),
            TableCalendar(
              eventLoader: (day) => _events[normalizeDate(day)] ?? [],
              headerStyle: HeaderStyle(
                titleCentered: true,
                formatButtonVisible: false,
                titleTextStyle: Theme.of(
                  context,
                ).textTheme.headlineLarge!.copyWith(
                  color: Theme.of(context).buttonTheme.colorScheme?.primary,
                ),
              ),
              startingDayOfWeek: StartingDayOfWeek.monday,
              weekendDays: [],
              calendarStyle: CalendarStyle(
                todayDecoration: BoxDecoration(
                  color: Theme.of(context).buttonTheme.colorScheme?.primary,
                  shape: BoxShape.circle,
                ),
                selectedDecoration: BoxDecoration(
                  color: Theme.of(context).buttonTheme.colorScheme?.secondary,
                  shape: BoxShape.circle,
                ),
              ),
              focusedDay: _focusDate,
              selectedDayPredicate: (day) => isSameDay(day, _selectedDate),
              onDaySelected: (focusedDay, selectedDay) {
                setState(() {
                  _focusDate = focusedDay;
                  _selectedDate = selectedDay;
                });
              },
              firstDay: DateTime(1980, 1, 1),
              lastDay: DateTime(2100, 12, 31),
              calendarFormat: _calendarFormat,
              onHeaderTapped: (focusedDay) {
                setState(() {
                  _calendarFormat =
                      _calendarFormat == CalendarFormat.month
                          ? CalendarFormat.week
                          : CalendarFormat.month;
                });
              },
            ),
            const SizedBox(height: 16.0),
            Text(
              'Events on ${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            listEvents(_events[_selectedDate] ?? []),
          ],
        ),
      ),
    );
  }
}
