import 'package:flutter/material.dart';
import 'package:pay_track/models/colors_theming.dart';
import 'package:pay_track/models/subscription.dart';
import 'package:pay_track/models/user.dart';
import 'package:pay_track/screens/home/home.dart';
import 'package:pay_track/screens/settings/settings.dart';
import 'package:pay_track/screens/stats.dart';

class _HomeHandler extends StatefulWidget {
  const _HomeHandler();

  @override
  State<_HomeHandler> createState() => _HomeHandlerState();
}

class _HomeHandlerState extends State<_HomeHandler> {
  int _selectedIndex = 1;

  static final List<Widget> _widgetOptions = <Widget>[
    StatsScreen(),
    HomeScreen(),
    SettingsScreen( )
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _widgetOptions,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Stats',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        onTap: _onItemTapped,
      ),
    );
  }
}






void main() async {
  final userPref = UserPref();
  final colorsTheming = ColorsTheming(); 
  final subList = SubscriptionList();
  await userPref.init();
  await colorsTheming.init();
  await subList.init();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final userPref = UserPref();
  final colorsTheming = ColorsTheming();
  late Color appColor = colorMapEnum[colorsTheming.dominantColor]!;
  late ThemeMode themeMode = themeModeMapEnum[colorsTheming.chosenTheming]!;

  void setThemeMode(ThemeMode mode) {
    setState(() {
      themeMode = mode;
    });
  }

  void setAppColor(Color color) {
    setState(() {
      appColor = color;
    });
  }

  @override
  void initState() {
    super.initState();
    colorsTheming.addListener(() {
      setState(() {
        appColor = colorMapEnum[colorsTheming.dominantColor]!;
        themeMode = themeModeMapEnum[colorsTheming.chosenTheming]!;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: appColor),
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: appColor,
          brightness: Brightness.dark,
        ),
      ),
      themeMode: themeMode,
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _HomeHandler()
        ),
    );
  }
}
