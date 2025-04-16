import 'package:flutter/material.dart';
import 'package:pay_track/models/subscription.dart';
import 'package:pay_track/models/user.dart';
import 'package:pay_track/screens/settings/get_greetings.dart';
import 'package:pay_track/tools/m_card.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late final UserPref userPref;

  String? name;
  Subscription? salary;
  MonthlyMode monthlyMode = MonthlyMode.byMonthDay;
  DominantColor dominantColor = DominantColor.red;
  ThemeMode themeMode = ThemeMode.system;

  bool editMode = false;

  @override
  void initState() {
    super.initState();
    userPref = UserPref();
    _setupData();
    userPref.addListener(() {
      _setupData();
    });
  }

  @override
  void dispose() {
    userPref.removeListener(_setupData);
    super.dispose();
  }

  void _setupData() {
    setState(() {
      name = userPref.name;
      salary = userPref.salary;
      monthlyMode = userPref.monthlyMode;
      dominantColor = userPref.dominantColor;
      themeMode = userPref.themeMode;
    });
  }

  void _updateFromValue() {
    setState(() {
      userPref.name = name;
      userPref.salary = salary;
      userPref.monthlyMode = monthlyMode;
      userPref.dominantColor = dominantColor;
      userPref.themeMode = themeMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
        actions:
            !editMode
                ? [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      setState(() {
                        editMode = !editMode;
                      });
                    },
                  ),
                ]
                : [
                  IconButton(
                    icon: const Icon(Icons.cancel),
                    onPressed: () {
                      setState(() {
                        editMode = false;
                        _setupData();
                      });
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.save),
                    onPressed: () {
                      setState(() {
                        userPref.name = name;
                        userPref.salary = salary;
                        userPref.monthlyMode = monthlyMode;
                        userPref.dominantColor = dominantColor;
                        userPref.themeMode = themeMode;
                      });
                    },
                  ),
                ],
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          mCard([
            Text(
              getGreeting(),
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                const Icon(Icons.account_circle),
                const Text("Name: "),
                Spacer(),
                TextField(
                  decoration: InputDecoration(
                    hintText: "Enter your name",
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    setState(() {
                      name = value;
                    });
                  },
                ),
              ],
            ),
          ]),
        ],
      ),
    );
  }
}
