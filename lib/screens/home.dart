import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime _focusDate = DateTime.now();
  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Center(
        child: TableCalendar(
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
          calendarFormat: CalendarFormat.month,
          onHeaderTapped: (focusedDay) => print(focusedDay),
        ),
      ),
    );
  }
}
