import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:line_icons/line_icons.dart';
import 'package:http/http.dart' as http;
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:yee_mobile_app/pages/devices.dart';
import 'package:yee_mobile_app/services/authentication_service.dart';
import 'package:yee_mobile_app/services/device_service.dart';
import 'package:yee_mobile_app/types/get_user_devices_response.dart';
import 'package:yee_mobile_app/types/websocket_status_on_change_response.dart'
    as ws_status_response;

class DeviceInfo extends StatefulWidget {
  final Device device;

  const DeviceInfo({Key? key, required this.device}) : super(key: key);

  @override
  DeviceInfoState createState() => DeviceInfoState();
}

class DeviceInfoState extends State<DeviceInfo> {
  final deviceBox = Hive.box('deviceList');
  final box = Hive.box('localDB');
  var nameController = TextEditingController();
  var ipController = TextEditingController();
  late String connectedTo = widget.device.ssid;
  bool isEditing = false;
  String editStateName = "Редактирай";
  late String deviceType = widget.device.name;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 242, 242, 242),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 242, 242, 242),
        elevation: 0,
        toolbarHeight: 100,
        title: Container(
            alignment: Alignment.centerLeft,
            width: 600,
            padding: const EdgeInsets.only(top: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$deviceType информация',
                  style: const TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 57, 57, 57)),
                ),
                Text(
                  connectedTo,
                  style: const TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 175, 175, 175)),
                )
              ],
            )),
      ),
      body: Center(
          child: Column(
        children: [
          const SizedBox(height: 52),
          SizedBox(
            width: screenWidth * 0.75,
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: TextField(
                controller: nameController,
                cursorColor: Colors.black,
                autofocus: true,
                enabled: isEditing,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(14))),
                  labelText: 'Име на контакт',
                  hintText: 'Задайте името на контакта',
                  suffixIcon: (isEditing)
                      ? IconButton(
                          onPressed: nameController.clear,
                          icon: const Icon(LineIcons.times))
                      : null,
                  suffixIconColor: const Color.fromARGB(255, 57, 57, 57),
                  floatingLabelStyle:
                      const TextStyle(color: Color.fromARGB(255, 57, 57, 57)),
                  focusedBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(14)),
                      borderSide:
                          BorderSide(color: Color(0xff01B399), width: 2)),
                ),
              ),
            ),
          ),
          SizedBox(
            width: screenWidth * 0.75,
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: TextField(
                controller: ipController,
                cursorColor: Colors.black,
                enabled: isEditing,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(14)),
                      borderSide: BorderSide(width: 2)),
                  labelText: 'IP адрес на контакт',
                  hintText: 'Задайте IP адреса на контакта',
                  suffixIcon: (isEditing)
                      ? IconButton(
                          onPressed: ipController.clear,
                          icon: const Icon(LineIcons.times))
                      : null,
                  floatingLabelStyle:
                      const TextStyle(color: Color.fromARGB(255, 57, 57, 57)),
                  focusedBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(14)),
                      borderSide:
                          BorderSide(color: Color(0xff01B399), width: 2)),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            "Модел: ${widget.device.type}",
            style: const TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 175, 175, 175)),
          ),
          Text(
            "Статус: ${widget.device.deviceStatus?.cloud.connected ?? false ? "Онлайн" : "Офлайн"}",
            style: const TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 175, 175, 175)),
          ),
          Text(
            "Работи: ${widget.device.deviceStatus?.relays.first.ison ?? false}",
            style: const TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 175, 175, 175)),
          ),
        ],
      )),
    );
  }

  @override
  void initState() {
    super.initState();
    nameController.text = widget.device.name;
    ipController.text = widget.device.ip;
    onLoad(context);
  }

  void testCharger(String ip) async {
    var response = await http
        .get(Uri.parse('http://$ip/rpc/Shelly.GetStatus'))
        .timeout(const Duration(seconds: 2), onTimeout: () {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Charger did not respond!'),
          backgroundColor: Color.fromARGB(255, 220, 95, 95)));
      return http.Response("Request Timed Out", 408);
    });
    if (response.body == "Not Found") {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Charger responded successfully!'),
          backgroundColor: Color.fromARGB(255, 110, 220, 95)));
    }
  }

  void updateInfo(ip) async {
    var response = await http
        .get(Uri.parse('http://$ip/rpc/Shelly.GetStatus'))
        .timeout(const Duration(seconds: 2), onTimeout: () {
      return http.Response("Request Timed Out", 408);
    });
    if (response.body == "Not Found") {
      deviceBox.delete(widget.device.ip);
      deviceBox.put(ipController.text, [
        nameController.text,
        ipController.text,
        widget.device.ssid,
        widget.device.ip
      ]);
      setState(() {
        isEditing = false;
        editStateName = "Редактирай";
      });

      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Charger info has been updated'),
          backgroundColor: Color.fromARGB(255, 110, 220, 95)));
    } else {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('The entered IP did not respond!'),
          backgroundColor: Color.fromARGB(255, 220, 95, 95)));
    }
  }

  Future<void> onLoad(BuildContext context) async {
    var user = Hive.box<User>('user').get('user')!;
    var userApiUrl = user.userApiUrl.split("//").last;
    var accessToken = user.accessToken;

    final wsUrl =
        Uri.parse("wss://$userApiUrl:6113/shelly/wss/hk_sock?t=$accessToken");
    final channel = WebSocketChannel.connect(wsUrl);

    await channel.ready;

    channel.stream.listen((message) {
      if (jsonDecode(message)["event"] != "Shelly:StatusOnChange") return;

      var wsResponse = ws_status_response.StatusOnChangeResponse.fromJson(
          jsonDecode(message));

      log("${wsResponse.device.id} ${widget.device.id}");
      if (wsResponse.device.id == widget.device.id) {
        if (!context.mounted) return;
        setState(() {
          widget.device.deviceStatus = wsResponse.status;
        });
      }
    });

    if (!widget.device.cloudOnline) return;

    if (!context.mounted) return;

    var response = await context.read<DeviceService>().getDeviceStatus();
    response.data.devicesStatus
        .removeWhere((key, value) => key != widget.device.id);

    if (!context.mounted) return;
    if (response.data.devicesStatus.isEmpty) return;
    setState(() {
      widget.device.deviceStatus =
          response.data.devicesStatus.toList((entry) => entry.value).first;
    });
  }
}
