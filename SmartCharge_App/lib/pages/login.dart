import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/authentication_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
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
            padding: const EdgeInsets.only(top: 20),
            child: const Text(
              'Login',
              style: TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 57, 57, 57)),
            )),
      ),
      body: Center(
          child: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(top: 50),
            child: ElevatedButton(
              onPressed: () async {
                try {
                  await context.read<AuthenticationService>().signIn(context);
                } on Exception catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(e.toString()),
                    ),
                  );
                }
              },
              child: const Text('Login with your Shelly account'),
            ),
          ),
        ],
      )),
    );
  }
}
