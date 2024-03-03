import 'package:ev_app/firebase_options.dart';
import 'package:ev_app/user_select.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final fcmToken = await FirebaseMessaging.instance.getToken();
  print(fcmToken);
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
    );
  }
}
