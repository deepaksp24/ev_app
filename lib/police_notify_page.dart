// ignore_for_file: avoid_print

import 'package:ev_app/police_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:convert';

class PoliceNotify extends StatefulWidget {
  const PoliceNotify({super.key});

  @override
  State<PoliceNotify> createState() => _PoliceNotifyState();
}

class _PoliceNotifyState extends State<PoliceNotify> {
  Map payload = {};
  @override
  Widget build(BuildContext context) {
    final data = ModalRoute.of(context)!.settings.arguments;
    if (data is RemoteMessage) {
      payload = data.data;
      print(payload.toString());
    }
    if (data is NotificationResponse) {
      payload = jsonDecode(data.payload!);
      print(payload.toString());
    }
    return MaterialApp(
      title: 'notification',
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Police screen"),
          centerTitle: true,
          backgroundColor: const Color.fromARGB(255, 203, 99, 30),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Center(child: Text("notification screen")),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PoliceScreenClass(),
                    ),
                  );
                },
                child: const Text("map page")),
            Text(payload.toString()),
          ],
        ),
      ),
    );
  }
}
