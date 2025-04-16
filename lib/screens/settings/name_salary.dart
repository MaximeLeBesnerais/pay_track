import 'package:flutter/material.dart';
import 'package:pay_track/models/subscription.dart';
import 'package:pay_track/models/user.dart';
import 'package:pay_track/tools/m_card.dart';
import 'package:rrule/rrule.dart';

class NameSalaryCard extends StatefulWidget {
  const NameSalaryCard({super.key});

  @override
  State<NameSalaryCard> createState() => _NameSalaryCardState();
}

class _NameSalaryCardState extends State<NameSalaryCard> {
  final userPref = UserPref();
  String? name;
  Subscription? salary;

  @override
  void initState() {
    super.initState();
    userPref.addListener(_setupData);
    _setupData();
  }

  void _setupData() async {
    await userPref.init();
    setState(() {
      name = userPref.name;
      salary = userPref.salary;
    });
  }

  void _setNameDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Set your name"),
          content: TextField(
            onChanged: (value) {
              userPref.name = value;
            },
            decoration: const InputDecoration(hintText: "Enter your name"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                userPref.save();
                Navigator.of(context).pop();
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }

  void _setSalaryDialog(BuildContext context) {
    TextEditingController salaryController = TextEditingController();

    bool isDoubleSalary(String text) {
      if (text.isEmpty) return false;
      final n = double.tryParse(text);
      return n != null && n > 0;
    }

    bool validity = isDoubleSalary(salaryController.text);

    salaryController.addListener(() {
      setState(() {
        validity = isDoubleSalary(salaryController.text);
      });
    });

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (dialogContext, setDialogState) {
            return AlertDialog(
              title: const Text("Set your salary"),
              content: TextField(
                decoration: const InputDecoration(
                  hintText: "Enter your salary",
                ),
                controller: salaryController,
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setDialogState(() {
                    validity = isDoubleSalary(value);
                  });
                },
              ),
              actions: [
                TextButton(
                  onPressed:
                      !validity
                          ? null
                          : () {
                            userPref.setSalary(
                              Subscription(
                                name: "Salary",
                                startDate: DateTime.now().subtract(
                                  const Duration(days: 365 * 3),
                                ),
                                amount: double.parse(salaryController.text),
                                category: Category.income,
                                recurrenceRule: RecurrenceRule(
                                  frequency: Frequency.monthly,
                                  interval: 1,
                                ),
                              ),
                            );
                            Navigator.of(context).pop();
                          },
                  child: const Text("Save"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return mCard([
      Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          const Icon(Icons.account_circle),
          const SizedBox(width: 8),
          Text("Name: ", style: Theme.of(context).textTheme.bodyLarge),
          const Spacer(),
          InkWell(
            onLongPress: () {
              _setNameDialog(context);
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
              _setSalaryDialog(context);
            },
            child: Text(
              salary != null
                  ? "${salary!.amount}"
                  : "No salary - Long press to edit",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
        ],
      ),
    ]);
  }
}
