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
  Set<ChosenTheming> _selected = <ChosenTheming>{ChosenTheming.system};
  late List<Widget> segments = <Widget>[
    const Text('Light'),
    const Text('Dark'),
    const Text('System'),
  ];

  void _setupTheming() async {
    await colorsTheming.init();
    setState(() {
      dominantColor = colorsTheming.dominantColor;
      themeMode = colorsTheming.chosenTheming;
      _selected = <ChosenTheming>{themeMode};
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
                  colorsTheming.setDominantColor(color.key);
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
      Divider(),
      const SizedBox(width: 8),
      Text("Theme Mode", style: Theme.of(context).textTheme.titleLarge),
      const SizedBox(height: 16),
      Center(
        child: SegmentedButton(
          segments: [
            ButtonSegment<ChosenTheming>(
              value: ChosenTheming.light,
              label: segments[0],
              icon: const Icon(Icons.wb_sunny_outlined),
            ),
            ButtonSegment<ChosenTheming>(
              value: ChosenTheming.dark,
              label: segments[1],
              icon: const Icon(Icons.nightlight_round_outlined),
            ),
            ButtonSegment<ChosenTheming>(
              value: ChosenTheming.system,
              label: segments[2],
              icon: const Icon(Icons.settings_system_daydream_outlined),
            ),
          ],
          selected: _selected,
          onSelectionChanged: (p0) => {
            setState(() {
              _selected = p0;
              colorsTheming.setTheming(p0.first);
            }),
          },
        ),
      ),
    ]);
  }
}
