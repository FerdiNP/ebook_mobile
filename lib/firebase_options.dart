// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
        return windows;
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
    apiKey: 'AIzaSyBE3y1k0KXBO5jiR8oIiZcD873pE2aDFHY',
    appId: '1:203608316252:web:7ba782566a69fe6e07c999',
    messagingSenderId: '203608316252',
    projectId: 'ebook-f190c',
    authDomain: 'ebook-f190c.firebaseapp.com',
    storageBucket: 'ebook-f190c.appspot.com',
    measurementId: 'G-3D1KH65VXL',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDBrhC5C8dZE27HlCSIgeYhZ2XMYGiUP_o',
    appId: '1:203608316252:android:481622db2d01f17207c999',
    messagingSenderId: '203608316252',
    projectId: 'ebook-f190c',
    storageBucket: 'ebook-f190c.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyB6geBG5Ekt6MNMCsaGx_WTneZ3a7I_1VM',
    appId: '1:203608316252:ios:0fb9578b18a1046a07c999',
    messagingSenderId: '203608316252',
    projectId: 'ebook-f190c',
    storageBucket: 'ebook-f190c.appspot.com',
    iosBundleId: 'com.example.prakMobile',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyB6geBG5Ekt6MNMCsaGx_WTneZ3a7I_1VM',
    appId: '1:203608316252:ios:0fb9578b18a1046a07c999',
    messagingSenderId: '203608316252',
    projectId: 'ebook-f190c',
    storageBucket: 'ebook-f190c.appspot.com',
    iosBundleId: 'com.example.prakMobile',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBE3y1k0KXBO5jiR8oIiZcD873pE2aDFHY',
    appId: '1:203608316252:web:4f6f9010ef67d1e507c999',
    messagingSenderId: '203608316252',
    projectId: 'ebook-f190c',
    authDomain: 'ebook-f190c.firebaseapp.com',
    storageBucket: 'ebook-f190c.appspot.com',
    measurementId: 'G-R51X4YFHMP',
  );
}
