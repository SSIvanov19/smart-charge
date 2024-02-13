import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:http/http.dart' as http;

part 'authentication_service.g.dart';

@HiveType(typeId: 1)
class User {
  @HiveField(0)
  String uid;

  @HiveField(1)
  String userApiUrl;

  @HiveField(2)
  String accessToken;

  @HiveField(3)
  String refreshToken;

  @HiveField(4)
  DateTime expirationTime;

  User({
    required this.uid,
    required this.userApiUrl,
    required this.accessToken,
    required this.refreshToken,
    required this.expirationTime,
  });
}

class AuthenticationService {
  AuthenticationService();

  Stream<User?> get authStateChanges => const Stream<User?>.empty();

  Future<String?> signIn(BuildContext context) async {
    try {
      // TODO: Don't forget to add state in production.
      final authorizationUrl = Uri.parse(
        'https://my.shelly.cloud/oauth_login.html?client_id=shelly-diy&redirect_uri=https://smartcharge.stoyan.dev/oauth-tokens',
      );

      // open url in default browser
      await launchUrl(authorizationUrl);

      return null;
    } on Exception catch (e) {
      return e.toString();
    }
  }

  Future<void> obtainAccessToken(
      String code, String state, BuildContext context) async {
    // decode authroization code to get userApiUrl
    var jwtDecodedCode = JwtDecoder.decode(code);
    var userApiUrl = jwtDecodedCode['user_api_url'];

    // send GET request to get access token to <userApiUrl>/oauth/authauth?client_id=shelly-diy&grant_type=code&code=<code>
    var response = await http.get(Uri.parse(
        "$userApiUrl/oauth/auth?client_id=shelly-diy&grant_type=code&code=$code"));

    if (response.statusCode != 200) {
      throw Exception('Failed to obtain access token');
    }

    var jsonResponse = jsonDecode(response.body);
    var accessToken = jsonResponse['access_token'];
    var refreshToken = jsonResponse['refresh_token'];
    var expiresIn = jsonResponse['expires_in'];

    var uid = JwtDecoder.decode(code)['user_id'];

    // Create a new User object
    var expirationTime = DateTime.now().add(Duration(seconds: expiresIn));
    var user = User(
        accessToken: accessToken,
        refreshToken: refreshToken,
        expirationTime: expirationTime,
        uid: uid,
        userApiUrl: userApiUrl);

    // Save user data in Hive
    var userBox = Hive.box<User>('user');
    await userBox.put('user', user);

    // Save access token, refresh token and expiration time in hive
    // Redirect to home and delete previous pages from stack
    if (!context.mounted) return;
    GoRouter.of(context).go("/");
  }

  Future<void> tokenCheck(BuildContext context) async {
    final user = Hive.box<User>('user').get('user');
    if (user == null || user.accessToken == "") {
      log("User is not logged in");
      return;
    }

    final nextCheckTime =
        DateTime.now().add(const Duration(seconds: 3 * 60 * 60 + 123));

    if (!user.expirationTime.isBefore(nextCheckTime)) return;

    log("Renewing token");

    try {
      await renewToken(user);
      log("Token renewed");
    } catch (error) {
      log("Error renewing token: $error");

      await Hive.box<User>('user').deleteFromDisk();
      await Hive.openBox<User>("user");

      if (!context.mounted) return;
      GoRouter.of(context).replace("/");
    }

  }

  void startTokenCheck(BuildContext context) {
    Timer.periodic(
        const Duration(seconds: 3 * 60 * 60), (Timer t) => tokenCheck(context));
  }

  Future<void> renewToken(User user) async {
    var userApiUrl = user.userApiUrl;
    var refreshToken = user.refreshToken;

    var response = await http.get(Uri.parse(
        "$userApiUrl/oauth/auth?client_id=shelly-diy&grant_type=code&code=$refreshToken"));

    if (response.statusCode != 200) {
      throw Exception('Failed to obtain access token');
    }

    var jsonResponse = jsonDecode(response.body);
    user.accessToken = jsonResponse['access_token'];
    user.refreshToken = jsonResponse['refresh_token'];
    var expiresIn = jsonResponse['expires_in'];

    user.expirationTime = DateTime.now().add(Duration(seconds: expiresIn));

    Hive.box<User>('user').put('user', user);
  }

  Future<void> signOut(BuildContext context) async {
    // delete user box
    await Hive.box<User>('user').deleteFromDisk();
    await Hive.openBox<User>("user");

    if (!context.mounted) return;
    GoRouter.of(context).replace("/");
  }
}
