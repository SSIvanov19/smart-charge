import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:line_icons/line_icons.dart';
import 'package:http/http.dart' as http;
import 'package:hive_flutter/hive_flutter.dart';
import 'package:yee_mobile_app/types/get_user_devices_response.dart';

class DeviceInfo extends StatefulWidget {
  final Device device;

  const DeviceInfo({
    Key? key,
    required this.device
  }) : super(key: key);

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
  late String deviceType = widget.device.type;

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
                ),
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
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 10),
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color.fromARGB(255, 255, 255, 255),
                    backgroundColor: const Color(0xff01B399),
                    minimumSize: Size(screenWidth * 0.25, 50),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100)),
                  ),
                  onPressed: () {
                    setState(() {
                      if (!isEditing) {
                        isEditing = true;
                        editStateName = "Запази";
                      } else {
                        updateInfo(ipController.text);
                      }
                    });
                  },
                  child: Text(editStateName,
                      style: const TextStyle(fontSize: 20.0)),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 10),
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color.fromARGB(255, 255, 255, 255),
                    backgroundColor: const Color.fromARGB(255, 31, 161, 255),
                    minimumSize: Size(screenWidth * 0.25, 50),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100)),
                  ),
                  onPressed: () {
                    testCharger(ipController.text);
                  },
                  child: const Text("Тествай", style: TextStyle(fontSize: 20.0)),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 10),
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color.fromARGB(255, 255, 255, 255),
                    backgroundColor: const Color.fromARGB(255, 255, 31, 58),
                    minimumSize: Size(screenWidth * 0.25, 50),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100)),
                  ),
                  onPressed: () {
                    deviceBox.delete(widget.device.ip);
                    if (widget.device.name ==
                        box.get("selectedCharger").toString()) {
                      box.delete("selectedCharger");
                    }
                    Navigator.pop(context);
                  },
                  child: const Text("Изтрий", style: TextStyle(fontSize: 20.0)),
                ),
              ),
            ],
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
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Charger info has been updated'),
          backgroundColor: Color.fromARGB(255, 110, 220, 95)));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('The entered IP did not respond!'),
          backgroundColor: Color.fromARGB(255, 220, 95, 95)));
    }
  }
}
