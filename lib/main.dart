// ignore_for_file: avoid_print, use_super_parameters

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pushnotification/firebase_options.dart';
import 'package:pushnotification/firebase_service.dart';
import 'package:pushnotification/home_page.dart';
import 'package:pushnotification/notification_page.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    await FirebaseService.instance.initNotifications();
    runApp(const MyApp());
  } catch (e) {
    print("Error initializing Firebase: $e");
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Push Notification',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      navigatorKey: navigatorKey,
      routes: {
        NotificationPage.route: (context) => const NotificationPage(),
      },
      home: const HomePage(),
    );
  }
}
