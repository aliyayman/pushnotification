// ignore_for_file: avoid_print

import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:pushnotification/main.dart';
import 'package:pushnotification/second_page.dart';

class FirebaseService {
  static FirebaseService? _instance;
  static FirebaseService get instance {
    _instance ??= FirebaseService._init();
    return _instance!;
  }

  FirebaseService._init();

  final _messaging = FirebaseMessaging.instance;

  Future<String?> getFcmToken() async {
   if (Platform.isIOS) {
      // iOS cihazlarda APNS tokenini al
      String? apnsToken = await _messaging.getAPNSToken();
      print("iOS APNS Token: $apnsToken");
      return apnsToken;
    } else {
      // Android cihazlarda FCM tokenini al
      String? fcmToken = await _messaging.getToken();
      print("Android FCM Token: $fcmToken");
      return fcmToken;
    }
  }

  Future<void> initNotifications() async {
    await FirebaseMessaging.instance.requestPermission();
    await getFcmToken();
    await initPushNotifications();
  }

  void handleMessage(RemoteMessage? message) {
    if (message != null) {
      navigatorKey.currentState?.pushNamed(SecondPage.route, arguments: message);
    }
  }

  Future<void> initPushNotifications() async {
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    FirebaseMessaging.instance.getInitialMessage().then(handleMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
  }
}

Future<void> handleBackgroundMessage(RemoteMessage message) async {
  if (message.notification != null) {
    print('Title: ${message.notification!.title}');
    print('Body: ${message.notification!.body}');
    print('ImageUrl: ${message.notification!.android?.imageUrl}');
    navigatorKey.currentState?.pushNamed(SecondPage.route, arguments: message);
  }
}
