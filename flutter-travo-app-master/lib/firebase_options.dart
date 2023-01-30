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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyD8RD-JPlRvXYBlLTzZ999AMZ-_RmyOTyg',
    appId: '1:198982603432:web:dfaa9c98185eabe571689d',
    messagingSenderId: '198982603432',
    projectId: 'flutter-firebase-9cc09',
    authDomain: 'flutter-firebase-9cc09.firebaseapp.com',
    storageBucket: 'flutter-firebase-9cc09.appspot.com',
    measurementId: 'G-775GHTEFSX',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyD4xZjBo7UtiedJD8qXt9-3j0bIlk0ta1o',
    appId: '1:198982603432:android:eb7dfe45dacadb6071689d',
    messagingSenderId: '198982603432',
    projectId: 'flutter-firebase-9cc09',
    storageBucket: 'flutter-firebase-9cc09.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDXuNvHDhiDBssO5Gwa7uUSkq3UGWbPBBo',
    appId: '1:198982603432:ios:d4416a3c6877b25d71689d',
    messagingSenderId: '198982603432',
    projectId: 'flutter-firebase-9cc09',
    storageBucket: 'flutter-firebase-9cc09.appspot.com',
    iosClientId: '198982603432-7f7p5mq3v0vr8v9huish0f3vf9sfhlam.apps.googleusercontent.com',
    iosBundleId: 'com.example.travoAppSource',
  );
}