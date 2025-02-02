import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});
  static const route = '/notificationPage';

  @override
  Widget build(BuildContext context) {
    final message = ModalRoute.of(context)!.settings.arguments as RemoteMessage;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.network(message.notification!.android?.imageUrl?? '') ,
              Text('${message.notification!.title}'), // Title
              Text('${message.notification!.body}'), // Body
            ],
          ),
        ),
      ),
    );
  }
}
