// ignore_for_file: avoid_print

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
    String? token = await _messaging.getToken();
    if (token != null) {
      print('Token: $token');
      return token;
    }
    return null;
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
