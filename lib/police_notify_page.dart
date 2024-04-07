// ignore_for_file: avoid_print

import 'package:ev_app/global_variable.dart';
import 'package:ev_app/police_screen.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:convert';

import 'package:geolocator/geolocator.dart';

class PoliceNotify extends StatefulWidget {
  const PoliceNotify({super.key});

  @override
  State<PoliceNotify> createState() => _PoliceNotifyState();
}

class _PoliceNotifyState extends State<PoliceNotify> {
  Map payload = {};
  final FirebaseDatabase _firebaseDatabase = FirebaseDatabase.instance;
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
        body: payload.isNotEmpty
            ? Column(
                //mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //const Center(child: Text("notification screen")),
                  NotificationDataWidget(
                    title: 'Location',
                    data: payload['custom_key'] ?? '',
                  ),
                  Text(payload.toString()),
                ],
              )
            : const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                      child: Text(
                    "No Notification",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  )),
                ],
              ),
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            FloatingActionButton.extended(
              onPressed: () async {
                Position position = await _getCurrentLocation();
                // Update the location to Firebase
                _firebaseDatabase
                    .ref('police_location/$globalUserId/location')
                    .set({
                  'token': usertoken,
                  'latitude': position.latitude,
                  'longitude': position.longitude,
                  'timestamp': ServerValue.timestamp,
                });
              },
              label: const Text("set location"),
              icon: const Icon(Icons.my_location_sharp),
            ),
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
        child: Row(
          // Wrap content in a Row
          mainAxisAlignment: MainAxisAlignment.spaceBetween, // Space evenly
          children: [
            Expanded(
              // Expand first two Text widgets
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
                ],
              ),
            ),
            ElevatedButton(
              // No need for Expanded here
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PoliceScreenClass(),
                  ),
                );
              },
              child: const Text("track the amublance"),
            ),
          ],
        ),
      ),
    );
  }
}

Future<Position> _getCurrentLocation() async {
  bool serviceEnabled;
  LocationPermission permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return Future.error('Location permissions are denied');
    }
  }

  return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high);
}
