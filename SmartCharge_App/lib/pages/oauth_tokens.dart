import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yee_mobile_app/services/authentication_service.dart';

class OAuthTokens extends StatefulWidget {
  String code = '';
  String state = '';

  OAuthTokens({super.key, required this.code, required this.state});

  @override
  State<OAuthTokens> createState() => _OAuthTokensState();

  Future<void> onLoad(BuildContext context) async {
    await context
        .read<AuthenticationService>()
        .obtainAccessToken(code, state, context);
  }
}

class _OAuthTokensState extends State<OAuthTokens> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 242, 242, 242),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color.fromARGB(255, 242, 242, 242),
        elevation: 0,
        toolbarHeight: 100,
        title: Container(
            alignment: Alignment.centerLeft,
            width: 350,
            padding: const EdgeInsets.only(top: 20),
            child: const Text(
              'Logging in with Shelly cloud...',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 57, 57, 57)),
            )),
      ),
      body: Center(
          child: Column(
        children: [
          Container(
              padding: const EdgeInsets.only(top: 50),
              child: const Text('Please wait...')),
          // Add cool animation here
          Container(
              padding: const EdgeInsets.only(top: 50),
              child: const CircularProgressIndicator()),
          // Add error text here
        ],
      )),
    );
  }

  @override
  void initState() {
    super.initState();
    widget.onLoad(context);
  }
}
