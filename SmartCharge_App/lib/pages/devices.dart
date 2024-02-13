import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:yee_mobile_app/services/device_service.dart';
import 'package:yee_mobile_app/types/get_user_devices_response.dart';
import 'add_charger.dart';
import 'device_info.dart';
import 'package:animations/animations.dart';

class Devices extends StatefulWidget {
  const Devices({Key? key}) : super(key: key);

  @override
  DevicesState createState() => DevicesState();
}

class DevicesState extends State<Devices> {
  /*
  final listBox = Hive.box('deviceList');
  */
  late List<Device> items = List<Device>.empty(growable: true);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

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
              'Устройства',
              style: TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 57, 57, 57)),
            )),
      ),
      body: Center(
          child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: SizedBox(
                  height: screenHeight * 0.6,
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: items.length,
                    itemBuilder: (BuildContext ctxt, int index) {
                      return Container(
                          margin: const EdgeInsets.all(25),
                          width: screenWidth * 0.88,
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              foregroundColor:
                                  const Color.fromARGB(255, 34, 34, 34),
                              backgroundColor: const Color(0xffE8ECED),
                              side: const BorderSide(
                                  color: Color(0xff01B399), width: 1.5),
                              minimumSize: Size(screenWidth * 0.67, 60),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                            ),
                            onPressed: () {
                              // listBox.deleteAll(listBox.keys);

                              Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: ((context) => DeviceInfo(
                                              device: items[index]))))
                                  .then((value) => setState(() {
                                        items =
                                            List<Device>.from(items.toList());
                                      }));
                            },
                            child: Stack(children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(items[index].name,
                                    style: const TextStyle(
                                        fontSize: 23.0,
                                        color:
                                            Color.fromARGB(255, 47, 74, 71))),
                              ),
                              const Align(
                                alignment: Alignment.centerRight,
                                child: Icon(Icons.keyboard_arrow_right_rounded,
                                    size: 30,
                                    color: Color.fromARGB(255, 47, 74, 71)),
                              ),
                            ]),
                          ));
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      )),
      floatingActionButton: OpenContainer(
        openColor: const Color.fromARGB(255, 242, 242, 242),
        closedColor: const Color.fromARGB(255, 242, 242, 242),
        closedElevation: 0,
        closedShape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(50))),
        onClosed: (value) => setState(() {
          //items = List<dynamic>.from(listBox.values.toList());
        }),
        transitionType: ContainerTransitionType.fade,
        openBuilder: (BuildContext context, VoidCallback _) {
          return const AddCharger();
        },
        closedBuilder: (BuildContext context, VoidCallback openContainer) {
          return FloatingActionButton(
            onPressed: openContainer,
            foregroundColor: Colors.white,
            backgroundColor: const Color(0xff01B399),
            child: const Icon(Icons.add),
          );
        },
      ),
    );
  }

  Future<void> onLoad(BuildContext context) async {
    var response = await context.read<DeviceService>().getDevices();

    setState(() {
      items = response.data.devices
          .toList((entry) => entry.value)
          .where((element) => element.category == "relay")
          .toList();
      log("${items.length} devices found");
    });
  }

  @override
  void initState() {
    super.initState();
    onLoad(context);
  }
}

extension ListFromMap<Key, Element> on Map<Key, Element> {
  List<T> toList<T>(T Function(MapEntry<Key, Element> entry) getElement) =>
      entries.map(getElement).toList();
}
