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
    apiKey: 'AIzaSyDhIBfxzeMIm7pwpGfGSy3doA95drltJVE',
    appId: '1:811952952274:web:770883481e9d96f6cdae0b',
    messagingSenderId: '811952952274',
    projectId: 'toody-63cd1',
    authDomain: 'toody-63cd1.firebaseapp.com',
    storageBucket: 'toody-63cd1.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDQaSRuzoCebfnMW_VmkcPz4gbtjRwSh44',
    appId: '1:811952952274:android:6db332e2469616b6cdae0b',
    messagingSenderId: '811952952274',
    projectId: 'toody-63cd1',
    storageBucket: 'toody-63cd1.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDKhYgbpeOtVGmIZRitLTgDE48GnnIZW9c',
    appId: '1:811952952274:ios:a844790d47c2c975cdae0b',
    messagingSenderId: '811952952274',
    projectId: 'toody-63cd1',
    storageBucket: 'toody-63cd1.appspot.com',
    iosBundleId: 'com.example.todolist',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDKhYgbpeOtVGmIZRitLTgDE48GnnIZW9c',
    appId: '1:811952952274:ios:363eff58d8b84e22cdae0b',
    messagingSenderId: '811952952274',
    projectId: 'toody-63cd1',
    storageBucket: 'toody-63cd1.appspot.com',
    iosBundleId: 'com.example.todolist.RunnerTests',
  );
}