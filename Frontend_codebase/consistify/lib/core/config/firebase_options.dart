
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
    apiKey: 'AIzaSyCrO2cc7corTduvOsGj6Q1Gj_hiiYS3l0M',
    appId: '1:121146493417:web:bc7115c9a0fcd53bb7a378',
    messagingSenderId: '121146493417',
    projectId: 'consistify-app',
    authDomain: 'consistify-app.firebaseapp.com',
    storageBucket: 'consistify-app.firebasestorage.app',
    measurementId: 'G-HLP4P96CN6',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCcAiQTYPLLS9RX2CfpYC7SMW38hcd9fgc',
    appId: '1:121146493417:android:8650b2a763d9bd25b7a378',
    messagingSenderId: '121146493417',
    projectId: 'consistify-app',
    storageBucket: 'consistify-app.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBygdwbdWhcuXmIY7dASF8AL-O6m9BTwEA',
    appId: '1:121146493417:ios:55229eb5ba9b50dbb7a378',
    messagingSenderId: '121146493417',
    projectId: 'consistify-app',
    storageBucket: 'consistify-app.firebasestorage.app',
    iosBundleId: 'com.example.consistify',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBygdwbdWhcuXmIY7dASF8AL-O6m9BTwEA',
    appId: '1:121146493417:ios:55229eb5ba9b50dbb7a378',
    messagingSenderId: '121146493417',
    projectId: 'consistify-app',
    storageBucket: 'consistify-app.firebasestorage.app',
    iosBundleId: 'com.example.consistify',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCrO2cc7corTduvOsGj6Q1Gj_hiiYS3l0M',
    appId: '1:121146493417:web:ebbd7f13f6554c5db7a378',
    messagingSenderId: '121146493417',
    projectId: 'consistify-app',
    authDomain: 'consistify-app.firebaseapp.com',
    storageBucket: 'consistify-app.firebasestorage.app',
    measurementId: 'G-VDCR3DGVR6',
  );
}
