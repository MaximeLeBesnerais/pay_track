import 'package:flutter/material.dart';
import 'package:pay_track/models/colors_theming.dart';
import 'package:pay_track/models/subscription.dart';
import 'package:pay_track/models/user.dart';
import 'package:pay_track/screens/settings/get_greetings.dart';
import 'package:pay_track/screens/settings/name_salary.dart';
import 'package:pay_track/tools/m_card.dart';


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
  late DominantColor dominantColor;
  late ChosenTheming themeMode;

  bool editMode = false;

  @override
  void initState() {
    super.initState();
    userPref = UserPref();
    colorsTheming = ColorsTheming();
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

  void _setupData() async {
    await userPref.init();
    await colorsTheming.init();

    setState(() {
      name = userPref.name;
      salary = userPref.salary;
      monthlyMode = userPref.monthlyMode;
      dominantColor = colorsTheming.dominantColor;
      themeMode = colorsTheming.chosenTheming;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          Text(getGreeting(), style: Theme.of(context).textTheme.headlineLarge),
          const SizedBox(height: 16),
          NameSalaryCard(),
          mCard([
            Text("Theme", style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (var color in colorMapEnum.entries)
                    InkWell(
                      onTap: () {
                        colorsTheming.dominantColor = color.key;
                        colorsTheming.save();
                      },
                      child: Container(
                        width: 36,
                        height: 36,
                        margin: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: color.value,
                          border: Border.all(
                            color: dominantColor == color.key
                                ? Colors.black
                                : Colors.transparent,
                            width: 3,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ]),
        ],
      ),
    );
  }
}
