import 'package:flutter/material.dart';
import 'package:pay_track/models/subscription.dart';
import 'package:pay_track/models/user.dart';
import 'package:pay_track/screens/settings/get_greetings.dart';
import 'package:pay_track/tools/m_card.dart';
import 'package:rrule/rrule.dart';

// addon press
void setNameDialog(BuildContext context, Function(String) onNameSet) {
  final TextEditingController nameController = TextEditingController();
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Set Name"),
        content: TextField(
          controller: nameController,
          decoration: const InputDecoration(hintText: "Enter your name"),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              onNameSet(nameController.text);
              Navigator.of(context).pop();
            },
            child: const Text("Save"),
          ),
        ],
      );
    },
  );
}

void setSalaryDialog(BuildContext context, Function(Subscription) onSalarySet) {
  final TextEditingController salaryController = TextEditingController();
  final TextEditingController salaryDayController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  int whenSalaryReceived = 1;

  bool validSalary = false;
  bool validSalaryDay = false;

  void onPressed() {
    final salary = Subscription(
      name: "Salary",
      startDate: selectedDate,
      amount: double.tryParse(salaryController.text) ?? 0,
      category: Category.income,
      recurrenceRule: RecurrenceRule(
        byMonthDays: [whenSalaryReceived],
        frequency: Frequency.monthly,
      ),
    );
    onSalarySet(salary);
    Navigator.of(context).pop();
  }

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        // lets us update the UI inside the dialog
        builder: (context, setState) {
          return AlertDialog(
            title: const Text("Set Salary"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    const Text("Start Date: "),
                    const Spacer(),
                    TextButton(
                      onPressed: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: selectedDate,
                          firstDate: DateTime(1960),
                          lastDate: DateTime(2100),
                        );
                        if (picked != null) {
                          setState(() => selectedDate = picked);
                        }
                      },
                      child: Text(
                        "${selectedDate.year}-${selectedDate.month}-${selectedDate.day}",
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: salaryController,
                  decoration: const InputDecoration(
                    hintText: "Enter your salary",
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    final doubleValue = double.tryParse(value);
                    if (doubleValue != null && doubleValue > 0) {
                      validSalary = true;
                    } else {
                      validSalary = false;
                    }
                  },
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: salaryDayController,
                  decoration: const InputDecoration(
                    hintText: "When is your salary received?",
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    final intValue = int.tryParse(value);
                    if (intValue != null && intValue > 0 && intValue <= 31) {
                      validSalaryDay = true;
                      whenSalaryReceived = intValue;
                    } else {
                      validSalaryDay = false;
                    }
                  },
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("Cancel"),
              ),
              Spacer(),
              TextButton(
                onPressed: (validSalaryDay && validSalary) ? onPressed : null,
                child: const Text("Save"),
              ),
            ],
          );
        },
      );
    },
  );
}

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          Text(getGreeting(), style: Theme.of(context).textTheme.headlineLarge),
          const SizedBox(height: 16),
          mCard([
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                const Icon(Icons.account_circle),
                const SizedBox(width: 8),
                Text("Name: ", style: Theme.of(context).textTheme.bodyLarge),
                const Spacer(),
                InkWell(
                  onLongPress: () {
                    setNameDialog(context, (value) {
                      userPref.setName(value);
                    });
                  },
                  child: Text(
                    name ?? "No name - Long press to edit",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                const Icon(Icons.monetization_on),
                const SizedBox(width: 8),
                Text("Salary: ", style: Theme.of(context).textTheme.bodyLarge),
                const Spacer(),
                InkWell(
                  onLongPress: () {
                    setSalaryDialog(context, (value) {
                      userPref.setSalary(value);
                    });
                  },
                  child: Text(
                    salary != null
                        ? "${salary!.amount} on every ${salary!.startDate.day}, since ${salary!.startDate.year}-${salary!.startDate.month}"
                        : "No salary - Long press to edit",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ]),
          mCard([
            Text("Theme", style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Row(children: [

              ],
            ),
          ]),
        ],
      ),
    );
  }
}
