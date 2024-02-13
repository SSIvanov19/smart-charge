import 'dart:async';
import 'package:animations/animations.dart';
import 'package:battery_plus/battery_plus.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:hive_flutter/hive_flutter.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';
import 'devices.dart';
import 'home.dart';
import 'statistics.dart';
import 'account.dart';
import 'package:intl/intl.dart';
import 'package:battery_info/battery_info_plugin.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  HomepageState createState() => HomepageState();
}

class HomepageState extends State<Homepage> {
  final box = Hive.box('localDB');
  final statisticsBox = Hive.box('statistics');

  final Battery _battery = Battery();
  StreamSubscription<BatteryState>? _batteryStateSubscription;
  late int _batteryLevel = box.get("batteryLevel", defaultValue: 0);
  late double batteryLimit = box.get("batteryLimit", defaultValue: 80.0);
  late int batteryLimitInt = batteryLimit.toInt();
  bool? _currentPlugState = false;
  late String ip = box.get("ip", defaultValue: 0);
  int _pageIndex = 0;

  var currentTime = DateTime.now();
  var currentDay = DateFormat('EEEE').format(DateTime.now());
  late var lastStatisticsHour =
      statisticsBox.get("lastStatisticsHour", defaultValue: 0);

  void _navigateBottomBar(int index) {
    if (mounted) {
      setState(() {
        _pageIndex = index;
      });
    }
  }

  final List<Widget> _pages = const [
    Home(),
    Devices(),
    Statistics(),
    Account(),
  ];

  @override
  void initState() {
    super.initState();
    Timer.periodic(const Duration(seconds: 1), (timer) {
      getBatteryLevel();
    });
    Timer.periodic(const Duration(seconds: 60), (timer) {
      getDate();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 242, 242, 242),
        body: PageTransitionSwitcher(
            duration: const Duration(milliseconds: 350),
            transitionBuilder: (child, animation, secondaryAnimation) {
              return FadeThroughTransition(
                animation: animation,
                secondaryAnimation: secondaryAnimation,
                child: child,
              );
            },
            child: _pages[_pageIndex]),
        bottomNavigationBar: Container(
          color: const Color.fromARGB(255, 242, 242, 242),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            child: GNav(
                backgroundColor: const Color.fromARGB(255, 242, 242, 242),
                color: const Color.fromARGB(255, 151, 151, 151),
                activeColor: const Color.fromARGB(255, 64, 64, 64),
                tabBackgroundColor: Colors.transparent,
                tabActiveBorder:
                    Border.all(color: const Color.fromARGB(255, 64, 64, 64)),
                gap: 8,
                padding: const EdgeInsets.all(16),
                onTabChange: _navigateBottomBar,
                tabs: const [
                  GButton(icon: LineIcons.home, text: 'Начало', iconSize: 26),
                  GButton(
                      icon: LineIcons.folderOpenAlt,
                      text: 'Устройства',
                      iconSize: 26),
                  GButton(
                      icon: LineIcons.pieChart,
                      text: 'Ститистики',
                      iconSize: 26),
                  GButton(icon: LineIcons.user, text: 'Профил', iconSize: 26)
                ]),
          ),
        ));
  }

  @override
  void dispose() {
    super.dispose();
    if (_batteryStateSubscription != null) {
      _batteryStateSubscription!.cancel();
    }
  }

  getBatteryLevel() async {
    final battery = (await BatteryInfoPlugin().androidBatteryInfo);

    if (!mounted) {
      return;
    }

    setState(() {
      if (battery?.batteryLevel != _batteryLevel) {
        _batteryLevel = battery!.batteryLevel!.toInt();
        box.put('batteryLevel', _batteryLevel);

        batteryLimit = box.get("batteryLimit", defaultValue: 80.0);
        batteryLimitInt = batteryLimit.toInt();

        if (_batteryLevel >= batteryLimitInt) {
          sendOffRequest();
        } else {
          if (battery.temperature! <= 45) {
            sendOnRequest();
          }
        }
      }
    });
  }

  sendOffRequest() async {
    var response = await http.get(Uri.parse('http://$ip/relay/0?turn=off'));
    _currentPlugState = false;
  }

  sendOnRequest() async {
    var response = await http.get(Uri.parse('http://$ip/relay/0?turn=on'));
    _currentPlugState = true;
  }

  getDate() {
    if (!mounted) {
      return;
    }

    setState(() {
      currentTime = DateTime.now();
      calculateDailySavings();

      if (lastStatisticsHour != currentTime.hour) {
        currentDay = DateFormat('EEEE').format(DateTime.now());
        lastStatisticsHour = currentTime.hour;

        if (currentTime.hour == 0) {
          statisticsBox.deleteAll(statisticsBox.keys);
        }

        statisticsBox.put('lastStatisticsHour', currentTime.hour);
        statisticsBox.put(currentTime.hour, _batteryLevel);
      }
    });
  }

  calculateDailySavings() {
    var dailySavings = 0.0;

    for (int i = 0; i < 24; i++) {
      double batteryGained = 0;

      if (i != 0) {
        batteryGained = statisticsBox.get(i, defaultValue: 0).toDouble() -
            statisticsBox.get((i - 1), defaultValue: 0).toDouble();
      }

      if (batteryGained > 0) {
        dailySavings += (batteryGained * 0.05);
      }
    }

    statisticsBox.put(currentDay, dailySavings);
  }
}
