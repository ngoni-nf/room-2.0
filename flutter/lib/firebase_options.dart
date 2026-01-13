import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
        throw UnsupportedError('DefaultFirebaseOptions has not been configured for linux.');
      default:
        throw UnsupportedError('DefaultFirebaseOptions has not been configured for this platform.');
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBYTRJqiayQmiPeD4hwHFIKqIGDkXmRaVY',
    appId: '1:646571701334:web:5e8c3c5c8c5c5c5c5c5c5c',
    messagingSenderId: '646571701334',
    projectId: 'room-app-sa-89857',
    authDomain: 'room-app-sa-89857.firebaseapp.com',
    databaseURL: 'https://room-app-sa-89857.firebaseio.com',
    storageBucket: 'room-app-sa-89857.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyD7U5q5q5q5q5q5q5q5q5q5q5q5q5q5q5',
    appId: '1:646571701334:android:5e8c3c5c8c5c5c5c5c5c5c',
    messagingSenderId: '646571701334',
    projectId: 'room-app-sa-89857',
    databaseURL: 'https://room-app-sa-89857.firebaseio.com',
    storageBucket: 'room-app-sa-89857.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyD7U5q5q5q5q5q5q5q5q5q5q5q5q5q5q5',
    appId: '1:646571701334:ios:5e8c3c5c8c5c5c5c5c5c5c',
    messagingSenderId: '646571701334',
    projectId: 'room-app-sa-89857',
    databaseURL: 'https://room-app-sa-89857.firebaseio.com',
    storageBucket: 'room-app-sa-89857.appspot.com',
    iosBundleId: 'com.room20.app',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyD7U5q5q5q5q5q5q5q5q5q5q5q5q5q5q5',
    appId: '1:646571701334:macos:5e8c3c5c8c5c5c5c5c5c5c',
    messagingSenderId: '646571701334',
    projectId: 'room-app-sa-89857',
    databaseURL: 'https://room-app-sa-89857.firebaseio.com',
    storageBucket: 'room-app-sa-89857.appspot.com',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyD7U5q5q5q5q5q5q5q5q5q5q5q5q5q5q5',
    appId: '1:646571701334:windows:5e8c3c5c8c5c5c5c5c5c5c',
    messagingSenderId: '646571701334',
    projectId: 'room-app-sa-89857',
    databaseURL: 'https://room-app-sa-89857.firebaseio.com',
    storageBucket: 'room-app-sa-89857.appspot.com',
  );
}
