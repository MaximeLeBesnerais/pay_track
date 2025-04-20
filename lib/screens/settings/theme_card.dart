import 'package:flutter/material.dart';
import 'package:pay_track/models/colors_theming.dart';
import 'package:pay_track/tools/m_card.dart';

class ThemeCard extends StatefulWidget {
  const ThemeCard({super.key});

  @override
  State<ThemeCard> createState() => _ThemeCardState();
}

class _ThemeCardState extends State<ThemeCard> {
  late final ColorsTheming colorsTheming;
  late DominantColor dominantColor = DominantColor.blue;
  late ChosenTheming themeMode;

  void _setupTheming() async {
    await colorsTheming.init();
    setState(() {
      dominantColor = colorsTheming.dominantColor;
      themeMode = colorsTheming.chosenTheming;
    });
  }

  @override
  void initState() {
    super.initState();
    colorsTheming = ColorsTheming();
    _setupTheming();
    colorsTheming.addListener(() {
      _setupTheming();
    });
  }

  @override
  Widget build(BuildContext context) {
    return mCard([
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
                      color:
                          dominantColor == color.key
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
    ]);
  }
}
