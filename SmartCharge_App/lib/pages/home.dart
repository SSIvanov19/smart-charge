import 'dart:async';
import 'package:battery_plus/battery_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:yee_mobile_app/pages/devices.dart';
import 'package:yee_mobile_app/services/device_service.dart';
import 'package:yee_mobile_app/types/get_user_devices_response.dart';
import '../components/dropdown.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'add_charger.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  final box = Hive.box('localDB');
  final Battery _battery = Battery();
  StreamSubscription<BatteryState>? _batteryStateSubscription;
  late int _batteryLevel = box.get("batteryLevel", defaultValue: 0);
  late double batteryLimit = box.get("batteryLimit", defaultValue: 80.0);
  late int batteryLimitInt = batteryLimit.toInt();
  late Timer timer;
  bool? _currentPlugState = false;
  late List<Device> items = List<Device>.empty(growable: true);
  List<String> chargerNames = [];
  late Device? selectedValue = null;
  Timer? _debounce;
  late String ip = box.get("ip", defaultValue: 0);

  @override
  void initState() {
    super.initState();
    onLoad(context);
    transformList();
    Timer.periodic(const Duration(seconds: 1), (timer) {
      getBatteryLevel();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 242, 242, 242),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 242, 242, 242),
        elevation: 0,
        toolbarHeight: 100,
        title: Container(
            alignment: Alignment.centerLeft,
            width: 350,
            padding: const EdgeInsets.only(top: 15, left: 15),
            child: const Text(
              'Моето устройство',
              style: TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 57, 57, 57)),
            )),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularPercentIndicator(
              radius: 120.0,
              lineWidth: 9.0,
              animation: true,
              animateFromLastPercent: true,
              percent: _batteryLevel.toDouble() / 100,
              rotateLinearGradient: _batteryLevel != 100 ? true : false,
              center: Text(
                '$_batteryLevel%',
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 50.0,
                    color: Color.fromARGB(255, 57, 57, 57)),
              ),
              circularStrokeCap: CircularStrokeCap.round,
              linearGradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color.fromARGB(255, 38, 224, 155),
                  Color(0xff01B399),
                ],
              ),
            ),
            const SizedBox(height: 62),
            Container(
                alignment: Alignment.centerLeft,
                width: 250,
                child: Text(
                  'Зареждане до: $batteryLimitInt%',
                  style: const TextStyle(
                      fontSize: 20,
                      color: Color.fromARGB(255, 57, 57, 57),
                      fontWeight: FontWeight.bold),
                )),
            SizedBox(
              width: 290,
              child: SfSlider(
                min: 60,
                max: 100,
                value: batteryLimit,
                interval: 40,
                showLabels: true,
                labelFormatterCallback: (actualValue, formattedText) =>
                    formattedText
                        .toString()
                        .replaceAll('60', '60%')
                        .replaceAll('100', '100%'),
                showTicks: false,
                // enableTooltip: true,
                // tooltipShape: const SfPaddleTooltipShape(),
                activeColor: const Color(0xff01B399),
                inactiveColor: const Color.fromARGB(255, 184, 199, 203),
                minorTicksPerInterval: 1,
                onChanged: (dynamic value) {
                  setState(() {
                    batteryLimit = value;
                    batteryLimitInt = batteryLimit.toInt();
                    box.put('batteryLimit', batteryLimit);
                  });
                  _onSearchChanged();
                },
              ),
            ),
            const SizedBox(height: 44),
            Container(
                width: 250,
                alignment: Alignment.centerLeft,
                child: const Text(
                  'Умен контакт',
                  style: TextStyle(
                      fontSize: 20,
                      color: Color.fromARGB(255, 57, 57, 57),
                      fontWeight: FontWeight.bold),
                )),
            SizedBox(
                width: 250,
                child: Column(children: [
                  const SizedBox(height: 10),
                  GestureDetector(
                      onTap: () {
                        if (items.isEmpty == true) {
                          // Open Shelly app
                          /*
                          Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: ((context) =>
                                          const AddCharger())))
                              .then((value) => setState(() {
                                    items = List<dynamic>.from(
                                        deviceBox.values.toList());
                                    transformList();
                                  }));
                                  */
                        }
                      },
                      child: CustomDropdownButton2(
                        hint: (items.isEmpty == true)
                            ? 'Add Charger'
                            : 'Select Charger',
                        dropdownItems: items,
                        value: selectedValue,
                        onChanged: (value) {
                          setState(() {
                            selectedValue = value;
                            box.put('selectedCharger', selectedValue);
                          });

                          setIp(value?.name);
                        },
                      )),
                ])),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _debounce?.cancel();
    if (_batteryStateSubscription != null) {
      _batteryStateSubscription!.cancel();
    }
  }

  getBatteryLevel() async {
    final level = await _battery.batteryLevel;
    if (mounted) {
      setState(() {
        if (level != _batteryLevel) {
          _batteryLevel = box.get('batteryLevel');
        }
      });
    }
  }

  setIp(chargerName) {
    for (var i = 0; i < items.length; i++) {
      if (items[i].name == chargerName) {
        ip = items[i].ip;
        box.put('ip', ip);
        //deviceBox.put(ip, [chargerName, ip, "My Device", "Charger"]);
      }
    }
  }

  sendOffRequest() async {
    var response = await http.get(Uri.parse('http://$ip/relay/0?turn=off'));
    _currentPlugState = false;
  }

  sendOnRequest() async {
    var response = await http.get(Uri.parse('http://$ip/relay/0?turn=on'));
    _currentPlugState = true;
  }

  _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 1000), () {
      if (_batteryLevel >= batteryLimitInt) {
        sendOffRequest();
      } else {
        sendOnRequest();
      }
    });
  }

  transformList() {
    for (int i = 0; i < items.length; ++i) {
      setState(() {
        chargerNames.add(items[i].name);
      });
    }
  }

  Future<void> onLoad(BuildContext context) async {
    var response = await context.read<DeviceService>().getDevices();

    if (!context.mounted) return;
    
    setState(() {
      items = response.data.devices
          .toList((entry) => entry.value)
          .where((element) => element.category == "relay")
          .toList();
    });
  }
}
