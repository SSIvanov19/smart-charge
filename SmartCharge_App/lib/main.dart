import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:yee_mobile_app/pages/oauth_tokens.dart';
import 'package:yee_mobile_app/services/authentication_service.dart';
import 'package:yee_mobile_app/services/device_service.dart';
import 'package:yee_mobile_app/services/user_service.dart';
import 'package:yee_mobile_app/types/get_user_devices_response.dart';
import 'pages/login.dart';
import 'pages/homepage.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'dart:io' show Platform;
import 'package:flutter_background/flutter_background.dart';
import 'package:go_router/go_router.dart';
import 'package:session_next/session_next.dart';
import 'package:uni_links_desktop/uni_links_desktop.dart';
import 'package:uni_links/uni_links.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  await Hive.initFlutter();
  Hive.registerAdapter(UserAdapter());
  Hive.registerAdapter(DeviceAdapter());
  await Hive.openBox('localDB');
  await Hive.openBox('deviceList');
  await Hive.openBox('statistics');
  await Hive.openBox<User>('user');

  if (Platform.isAndroid) {
    const androidConfig = FlutterBackgroundAndroidConfig(
      notificationTitle: "flutter_background example app",
      notificationText:
          "Background notification for keeping the example app running in the background",
      notificationImportance: AndroidNotificationImportance.Default,
      notificationIcon: AndroidResource(
          name: 'background_icon',
          defType: 'drawable'), // Default is ic_launcher from folder mipmap
    );

    bool success =
        await FlutterBackground.initialize(androidConfig: androidConfig);
    bool hasPermissions = await FlutterBackground.hasPermissions;

    if (success && hasPermissions) {
      await FlutterBackground.enableBackgroundExecution();
    }
  }
  if (Platform.isWindows) {
    registerProtocol('com.codingburgas.smartcharge');
  }

  runApp(const MyApp());
  FlutterNativeSplash.remove();
}

void initUniLinks(BuildContext context) async {
  try {
    final initialLink = await getInitialLink();
    if (initialLink != null) {
      // Handle the initial link here
      print('Initial link: $initialLink');
    }
  } on Exception catch (e) {
    print('Error initializing uni_links: $e');
  }

  // Listen for incoming links
  linkStream.listen((link) {
    // Handle the link here
    print('Received link: $link');
    final codeParam = Uri.parse(link!).queryParameters['code'] ?? '';
    final stateParam = Uri.parse(link).queryParameters['state'] ?? '';

    GoRouter.of(context).go("/oauth-tokens?code=$codeParam&state=$stateParam");
  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          Provider<AuthenticationService>(
              create: (_) => AuthenticationService()),
          Provider<UserService>(create: (_) => UserService()),
          Provider<DeviceService>(create: (_) => DeviceService()),
        ],
        child: MaterialApp.router(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.grey,
          ),
          routerConfig: router,
        ));
  }
}

final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (_, __) => AuthenticationWrapper(key: UniqueKey()),
      routes: [
        GoRoute(
          path: 'oauth-tokens',
          builder: (context, state) {
            final code = state.uri.queryParameters['code'] ?? '';
            final stateParam = state.uri.queryParameters['state'] ?? '';

            return OAuthTokens(code: code, state: stateParam);
          },
        ),
      ],
    ),
  ],
);

class AuthenticationWrapper extends StatelessWidget {
  const AuthenticationWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (Platform.isWindows) {
      initUniLinks(context);
    }
    var session = SessionNext();
    var isAppInit = session.get<bool>('appInit') ?? false;

    if (!isAppInit) {
      context.read<AuthenticationService>().tokenCheck(context);
      context.read<AuthenticationService>().startTokenCheck(context);
      session.set("appInit", true);
    }

    var isUserLoggedIn = Hive.box<User>('user').get('user') != null;

    return isUserLoggedIn ? const Homepage() : const LoginPage();
  }
}
