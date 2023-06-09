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
    apiKey: 'AIzaSyAjMmd73Y3Io7zH1p3YUKgk8kkxcJTHJFk',
    appId: '1:736900960385:web:eaa1a173db6735ba73fd80',
    messagingSenderId: '736900960385',
    projectId: 'flutter-iconics',
    authDomain: 'flutter-iconics.firebaseapp.com',
    databaseURL: 'https://flutter-iconics-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'flutter-iconics.appspot.com',
    measurementId: 'G-D441N39ZX7',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyC4zSlo2taN4tdtQ_KcWJrjp6O7hK3qUIw',
    appId: '1:736900960385:android:ba5afb8815f873be73fd80',
    messagingSenderId: '736900960385',
    projectId: 'flutter-iconics',
    databaseURL: 'https://flutter-iconics-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'flutter-iconics.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBcizICUn_BbkCRUGJoAOZNdnTKdQzBKuU',
    appId: '1:736900960385:ios:1625e5f1e8c49e6d73fd80',
    messagingSenderId: '736900960385',
    projectId: 'flutter-iconics',
    databaseURL: 'https://flutter-iconics-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'flutter-iconics.appspot.com',
    iosClientId: '736900960385-s1k4mb062u960bu1eltv0e285f127404.apps.googleusercontent.com',
    iosBundleId: 'com.example.iconicsApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBcizICUn_BbkCRUGJoAOZNdnTKdQzBKuU',
    appId: '1:736900960385:ios:1625e5f1e8c49e6d73fd80',
    messagingSenderId: '736900960385',
    projectId: 'flutter-iconics',
    databaseURL: 'https://flutter-iconics-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'flutter-iconics.appspot.com',
    iosClientId: '736900960385-s1k4mb062u960bu1eltv0e285f127404.apps.googleusercontent.com',
    iosBundleId: 'com.example.iconicsApp',
  );
}
