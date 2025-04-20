import 'package:flutter/material.dart';
import 'package:pay_track/models/colors_theming.dart';
import 'package:pay_track/models/subscription.dart';
import 'package:pay_track/models/user.dart';
import 'package:pay_track/screens/settings/name_salary.dart';
import 'package:pay_track/screens/settings/theme_card.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late final UserPref userPref;
  late final ColorsTheming colorsTheming;

  String? name;
  Subscription? salary;
  MonthlyMode monthlyMode = MonthlyMode.byMonthDay;
  late DominantColor dominantColor = DominantColor.blue;
  late ChosenTheming themeMode;

  bool editMode = false;

  @override
  void initState() {
    super.initState();
    userPref = UserPref();
    colorsTheming = ColorsTheming();
    _setupData();
    _setupTheming();
    userPref.addListener(() {
      _setupData();
    });
    colorsTheming.addListener(() {
      _setupTheming();
    });
  }

  @override
  void dispose() {
    userPref.removeListener(_setupData);
    super.dispose();
  }

  void _setupData() async {
    await userPref.init();

    setState(() {
      name = userPref.name;
      salary = userPref.salary;
      monthlyMode = userPref.monthlyMode;
    });
  }

  void _setupTheming() async {
    await colorsTheming.init();
    setState(() {
      dominantColor = colorsTheming.dominantColor;
      themeMode = colorsTheming.chosenTheming;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
      ),
      body: ListView(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
        ),
        children: [
          const SizedBox(height: 16),
          NameSalaryCard(),
          ThemeCard()
        ],
      ),
    );
  }
}
