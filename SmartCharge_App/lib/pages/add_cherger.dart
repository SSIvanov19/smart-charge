import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:http/http.dart' as http;
import 'package:hive_flutter/hive_flutter.dart';

class AddCharger extends StatefulWidget {
  const AddCharger({Key? key}) : super(key: key);

  @override
  AddChargerState createState() => AddChargerState();
}

class AddChargerState extends State<AddCharger> {
  final deviceBox = Hive.box('deviceList');
  var nameController = TextEditingController();
  var ipController = TextEditingController();

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
            width: 350,
            child: const Text(
              'Добави контакт',
              style: TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 57, 57, 57)),
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
                decoration: InputDecoration(
                  border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(14))),
                  labelText: 'Име',
                  hintText: 'Име на устройството',
                  suffixIcon: IconButton(
                      onPressed: nameController.clear,
                      icon: const Icon(LineIcons.times)),
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
                decoration: InputDecoration(
                  border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(14)),
                      borderSide: BorderSide(width: 2)),
                  labelText: 'IP адрес',
                  hintText: 'Въведете IP адреса на устройството',
                  suffixIcon: IconButton(
                      onPressed: ipController.clear,
                      icon: const Icon(LineIcons.times)),
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
          Container(
            margin: const EdgeInsets.all(25),
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color.fromARGB(255, 34, 34, 34),
                backgroundColor: const Color(0xff01B399),
                minimumSize: Size(screenWidth * 0.67, 60),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
              ),
              onPressed: () {
                addCharger(ipController.text, nameController.text);
              },
              child: const Text("Добави устройство",
                  style: TextStyle(
                      fontSize: 22.0,
                      color: Color.fromARGB(255, 255, 255, 255))),
            ),
          ),
          const Text(
            'Поддържаме само Shelly умни контакти',
            style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 178, 178, 178)),
          ),
        ],
      )),
    );
  }

  @override
  void initState() {
    super.initState();
    searchIp();
  }

  void searchIp() {
    final String subnet = '192.168.0';
    final int minHost = 1;
    final int maxHost = 255;

    for (int i = minHost; i <= maxHost; i++) {
      final String host = '$subnet.$i';
      pingIp(host);
    }
  }

    void pingIp(ip) async {
    var response = await http
        .get(Uri.parse('http://$ip/rpc/Shelly.GetStatus'))
        .timeout(const Duration(seconds: 2), onTimeout: () {
      return http.Response("Request Timed Out", 408);
    });

    if (response.body == "Not Found") {
      ipController.text = ip;
      nameController.text = "Shelly Smart Plug";
    }
  }

  void addCharger(ip, name) async {
    var response = await http
        .get(Uri.parse('http://$ip/rpc/Shelly.GetStatus'))
        .timeout(const Duration(seconds: 2), onTimeout: () {
      return http.Response("Request Timed Out", 408);
    });
    if (response.body == "Not Found") {
      var device = "None";
      var type = "Charger";
      deviceBox.put(ip, [name, ip, device, type]);
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
    } else {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Charger not found'),
        duration: Duration(seconds: 3),
        backgroundColor: Colors.red,
      ));
    }
  }
}
