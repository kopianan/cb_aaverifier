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
    apiKey: 'AIzaSyCWQ_6yvO-IrTtU5lBIwGNjGTWrTADqHmQ',
    appId: '1:853356807631:web:f26ab0bde7fab3c01c7eba',
    messagingSenderId: '853356807631',
    projectId: 'fluttermpc',
    authDomain: 'fluttermpc.firebaseapp.com',
    storageBucket: 'fluttermpc.appspot.com',
    measurementId: 'G-R1CSEC0DG3',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBa7_9Fc6ZKH0prNloqTIf4jsuNJI755G0',
    appId: '1:853356807631:android:b778e625d9c05ea91c7eba',
    messagingSenderId: '853356807631',
    projectId: 'fluttermpc',
    storageBucket: 'fluttermpc.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBOVE-kys72ICmAVgZQI4X6ZCdUklzwd10',
    appId: '1:853356807631:ios:f97e7a7f6269f1821c7eba',
    messagingSenderId: '853356807631',
    projectId: 'fluttermpc',
    storageBucket: 'fluttermpc.appspot.com',
    androidClientId: '853356807631-e2unpg4m3uolsreajikcn05uk17v7aj5.apps.googleusercontent.com',
    iosClientId: '853356807631-jpfqgob2eshgrmj8jvhmnq2pm14rih78.apps.googleusercontent.com',
    iosBundleId: 'com.example.coinbitVerifier',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBOVE-kys72ICmAVgZQI4X6ZCdUklzwd10',
    appId: '1:853356807631:ios:f97e7a7f6269f1821c7eba',
    messagingSenderId: '853356807631',
    projectId: 'fluttermpc',
    storageBucket: 'fluttermpc.appspot.com',
    androidClientId: '853356807631-e2unpg4m3uolsreajikcn05uk17v7aj5.apps.googleusercontent.com',
    iosClientId: '853356807631-jpfqgob2eshgrmj8jvhmnq2pm14rih78.apps.googleusercontent.com',
    iosBundleId: 'com.example.coinbitVerifier',
  );
}
