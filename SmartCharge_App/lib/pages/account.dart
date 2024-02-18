import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:yee_mobile_app/services/user_service.dart';
import '../services/authentication_service.dart';
import 'account_settings.dart';

class Account extends StatefulWidget {
  const Account({Key? key}) : super(key: key);

  @override
  AccountState createState() => AccountState();
}

class AccountState extends State<Account> {
  final url = "https://sites.google.com/view/powercharge/home";
  var name = '';
  var profilePicture = '';

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
            padding: const EdgeInsets.only(top: 15, left: 15),
            child: const Text(
              'Профил',
              style: TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 57, 57, 57)),
            )),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: SizedBox(
              width: screenWidth * 0.93,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  CircleAvatar(
                    radius: 80,
                    backgroundImage: NetworkImage(profilePicture),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    name,
                    style: const TextStyle(
                        fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 60),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Профил',
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 4),
                      ),
                    ),
                  ),
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color.fromARGB(255, 34, 34, 34),
                      backgroundColor: const Color.fromARGB(255, 212, 216, 216),
                      side: const BorderSide(
                          color: Color.fromARGB(0, 1, 179, 152), width: 0),
                      minimumSize: Size(screenWidth * 0.67, 60),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                    ),
                    onPressed: () {
                      Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: ((context) => const ProfileSettingsPage())));
                    },
                    child: const Stack(children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text("Настройки на профила",
                            style: TextStyle(
                                fontSize: 20,
                                color: Color.fromARGB(255, 47, 74, 71))),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Icon(Icons.keyboard_arrow_right_rounded,
                            size: 30, color: Color.fromARGB(255, 47, 74, 71)),
                      ),
                    ]),
                  ),
                  const SizedBox(height: 10),
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color.fromARGB(255, 34, 34, 34),
                      backgroundColor: const Color.fromARGB(255, 212, 216, 216),
                      side: const BorderSide(
                          color: Color.fromARGB(0, 1, 179, 152), width: 0),
                      minimumSize: Size(screenWidth * 0.67, 60),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                    ),
                    onPressed: () {
                      context.read<AuthenticationService>().signOut(context);
                    },
                    child: const Stack(children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text("Излизане от профила",
                            style: TextStyle(
                                fontSize: 20,
                                color: Color.fromARGB(255, 47, 74, 71))),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Icon(Icons.keyboard_arrow_right_rounded,
                            size: 30, color: Color.fromARGB(255, 47, 74, 71)),
                      ),
                    ]),
                  )
                ],
              ),
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: GestureDetector(
                onTap: () async {
                  await launchUrl(Uri.parse(url));
                },
                child: const Text('Политика за поверителност',
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                        color: Color.fromARGB(255, 82, 82, 82))),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }

  Future<void> onLoad(BuildContext context) async {
    var response = await context.read<UserService>().getUserSettings();

    setState(() {
      name = response.data.settings.name;
      profilePicture = response.data.settings.avatar;

      if (profilePicture.startsWith("color")) {
        var backgroundColor = "";

        if (profilePicture.endsWith("1")) {
          backgroundColor = "83d186";
        } else if (profilePicture.endsWith("2")) {
          backgroundColor = "8de7dc";
        } else if (profilePicture.endsWith("3")) {
          backgroundColor = "71ccff";
        } else if (profilePicture.endsWith("4")) {
          backgroundColor = "2491ff";
        } else if (profilePicture.endsWith("5")) {
          backgroundColor = "a177d7";
        } else if (profilePicture.endsWith("6")) {
          backgroundColor = "e298db";
        } else if (profilePicture.endsWith("7")) {
          backgroundColor = "b2536f";
        } else if (profilePicture.endsWith("8")) {
          backgroundColor = "ff8285";
        }

        profilePicture =
            "https://api.dicebear.com/7.x/initials/png?seed=${name[0]}&backgroundColor=$backgroundColor";
      } else if (!profilePicture.startsWith("http")) {
        profilePicture = "https://control.shelly.cloud$profilePicture";
      }
    });
  }

  @override
  void initState() {
    super.initState();
    onLoad(context);
  }
}
