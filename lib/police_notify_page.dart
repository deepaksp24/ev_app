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
            NotificationDataWidget(
              title: 'Location',
              data: payload['custom_key'] ?? '',
            ),
            Text(payload.toString()),
          ],
        ),
      ),
    );
  }
}

class NotificationDataWidget extends StatelessWidget {
  final String title;
  final String data;

  const NotificationDataWidget({
    Key? key,
    required this.title,
    required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              data,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PoliceScreenClass(),
                    ),
                  );
                },
                child: const Text("map page"))
          ],
        ),
      ),
    );
  }
}
