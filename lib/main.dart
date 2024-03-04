import 'package:ev_app/firebase_options.dart';
import 'package:ev_app/login_page.dart';
import 'package:ev_app/police_notify_page.dart';
import 'package:ev_app/push_notification_firebase.dart';
import 'package:ev_app/user_select.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

final navigatorKey = GlobalKey<NavigatorState>();

// function to lisen to background changes
Future _firebaseBackgroundMessage(RemoteMessage message) async {
  if (message.notification != null) {
    print("Some notification Received");
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // final fcmToken = await FirebaseMessaging.instance.getToken();
  // print(fcmToken);

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    if (message.notification != null) {
      print("Background Notification Tapped");
      navigatorKey.currentState!.pushNamed("/message", arguments: message);
    } else {
      print("message is null bro");
    }
  });

  PushNotifications.init();
  PushNotifications.localNotiInit();
  // Listen to background notifications
  FirebaseMessaging.onBackgroundMessage(_firebaseBackgroundMessage);

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    String payloadData = jsonEncode(message.data);
    print("Got a message in foreground");
    if (message.notification != null) {
      PushNotifications.showSimpleNotification(
          title: message.notification!.title!,
          body: message.notification!.body!,
          payload: payloadData);
    }
  });

  // for handling in terminated state
  final RemoteMessage? message =
      await FirebaseMessaging.instance.getInitialMessage();

  if (message != null) {
    print("Launched from terminated state");
    Future.delayed(Duration(seconds: 1), () {
      navigatorKey.currentState!.pushNamed("/message", arguments: message);
    });
  }
  runApp(const LoginApp());
}

// cR0-IFXHSEWR7r2zYVFXeG:APA91bEFfZggV7hUqpcOSkhMdwtwnaDtIdAph3UKhwdeqU8BZPnGVz_cz8rwJgpPk4v54rYI0eM8S8wxLc72vk48KD8kxktO1Ypt67GCPkxQu6HS0Z7mSQDB2EWeX5Kp5jUUM9xGEkQT
class LoginApp extends StatelessWidget {
  const LoginApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'User Login',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        body: Container(
          color: Colors.lightBlue, // Set the background color here
          child: const UserSelect(),
        ),
      ),
      routes: {
        //'/': (context) => const LoginPage(),
        '/message': (context) => const PoliceNotify()
      },
    );
  }
}
