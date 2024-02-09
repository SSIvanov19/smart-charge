// make login page

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../authentication_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

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
            child: const Text(
              'Email',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 57, 57, 57)),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(top: 10),
            width: 350,
            child: TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Email',
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(top: 50),
            child: const Text(
              'Password',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 57, 57, 57)),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(top: 10),
            width: 350,
            child: TextField(
              controller: _passwordController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Password',
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(top: 50),
            child: ElevatedButton(
              onPressed: () async {
                try {
                  await context.read<AuthenticationService>().signIn(
                        email: _emailController.text.trim(),
                        password: _passwordController.text.trim(),
                      );
                } on FirebaseAuthException catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(e.message!),
                    ),
                  );
                }
              },
              child: const Text('Login'),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(top: 20),
            child: ElevatedButton(
              onPressed: () async {
                try {
                  await context.read<AuthenticationService>().signUp(
                        email: _emailController.text.trim(),
                        password: _passwordController.text.trim(),
                      );
                } on FirebaseAuthException catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(e.message!),
                    ),
                  );
                }
              },
              child: const Text('Sign up'),
            ),
          ),
        ],
      )),
    );
  }
}
