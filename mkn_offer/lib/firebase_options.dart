import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for ios - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyDfqb1WDr06un2BBHPKH3wsl-luXI4B7NI',
    appId: '1:1084926273327:web:6541ea194f92cd770223da',
    messagingSenderId: '1084926273327',
    projectId: 'vibrant-chain-348900',
    authDomain: 'vibrant-chain-348900.firebaseapp.com',
    databaseURL: 'https://vibrant-chain-348900-default-rtdb.firebaseio.com',
    storageBucket: 'vibrant-chain-348900.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDHOsU478rpdgxL0awn9TZmIf3gGp_BkLQ',
    appId: '1:1084926273327:android:13d9ca6c3671b67e0223da',
    messagingSenderId: '1084926273327',
    projectId: 'vibrant-chain-348900',
    databaseURL: 'https://vibrant-chain-348900-default-rtdb.firebaseio.com',
    storageBucket: 'vibrant-chain-348900.appspot.com',
  );
}
