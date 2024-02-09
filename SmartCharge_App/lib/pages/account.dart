import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../authentication_service.dart';

class Account extends StatefulWidget {
  const Account({Key? key}) : super(key: key);

  @override
  AccountState createState() => AccountState();
}

class AccountState extends State<Account> {
  final url = "https://sites.google.com/view/powercharge/home";

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
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // ElevatedButton(
          //   onPressed: () {
          //     context.read<AuthenticationService>().signOut();
          //   },
          //   child: const Text('Sign Out'),
          // ),
          Center(
            child: SizedBox(
              width: screenWidth * 0.93,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const CircleAvatar(
                    radius: 80,
                    backgroundImage: AssetImage('assets/PFP.png'),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'John Doe',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 60),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Профил',
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, letterSpacing: 4),
                      ),
                    ),
                  ),
                  OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              foregroundColor:
                                  const Color.fromARGB(255, 34, 34, 34),
                              backgroundColor: const Color.fromARGB(255, 212, 216, 216),
                              side: const BorderSide(
                                  color: Color.fromARGB(0, 1, 179, 152),
                                  width: 0),
                              minimumSize: Size(screenWidth * 0.67, 60),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                            ),
                            onPressed: () {
                              
                            },
                            child: const Stack(children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text("Настройки на профила",
                                    style: TextStyle(fontSize: 20, color: Color.fromARGB(255, 47, 74, 71))),
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: Icon(Icons.keyboard_arrow_right_rounded,
                                    size: 30,
                                    color: Color.fromARGB(255, 47, 74, 71)),
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
      )),
    );
  }
}
