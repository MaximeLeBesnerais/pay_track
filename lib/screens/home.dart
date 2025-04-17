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
  CalendarFormat _calendarFormat = CalendarFormat.month;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: 
        Padding(
          padding: const EdgeInsets.all(20.0),
          child:  Column(
          children: [
            TableCalendar(
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
                  _calendarFormat = _calendarFormat == CalendarFormat.month
                      ? CalendarFormat.week
                      : CalendarFormat.month;
                });
              },
            ),
          ],
        )),
      ),
    );
  }
}
