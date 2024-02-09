// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDYcN3JmoS7LnItvLNKtj3RnUbf9i-BQg8',
    appId: '1:106271239019:web:df923c6cceac07142b7a2e',
    messagingSenderId: '106271239019',
    projectId: 'powercharge-5572a',
    authDomain: 'powercharge-5572a.firebaseapp.com',
    storageBucket: 'powercharge-5572a.appspot.com',
    measurementId: 'G-E51FMVM3RY',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCf5hQ2v7SsSlULPvm7PNni8lvEY86Lcp0',
    appId: '1:106271239019:android:bf741ef3993ee3432b7a2e',
    messagingSenderId: '106271239019',
    projectId: 'powercharge-5572a',
    storageBucket: 'powercharge-5572a.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDu9f-IDwjuqttIDibMB4AnDEyUBN7SRzY',
    appId: '1:106271239019:ios:b4d28c88ce5d80e92b7a2e',
    messagingSenderId: '106271239019',
    projectId: 'powercharge-5572a',
    storageBucket: 'powercharge-5572a.appspot.com',
    iosClientId: '106271239019-3in5s403og8qakc4i09k31396515d8i5.apps.googleusercontent.com',
    iosBundleId: 'com.example.yeeMobileApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDu9f-IDwjuqttIDibMB4AnDEyUBN7SRzY',
    appId: '1:106271239019:ios:b4d28c88ce5d80e92b7a2e',
    messagingSenderId: '106271239019',
    projectId: 'powercharge-5572a',
    storageBucket: 'powercharge-5572a.appspot.com',
    iosClientId: '106271239019-3in5s403og8qakc4i09k31396515d8i5.apps.googleusercontent.com',
    iosBundleId: 'com.example.yeeMobileApp',
  );
}
