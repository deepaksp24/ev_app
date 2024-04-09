import 'dart:convert';
import 'package:ev_app/global_variable.dart';
import 'package:flutter/services.dart';
import 'package:googleapis_auth/auth_io.dart' as auth;

Future<bool> sendPushMessage({
  required String recipientToken,
  required String title,
  required String body,
}) async {
  final jsonCredentials =
      await rootBundle.loadString('data/new-project-afe89-982de6fad46d.json');
  final creds = auth.ServiceAccountCredentials.fromJson(jsonCredentials);

  final client = await auth.clientViaServiceAccount(
    creds,
    ['https://www.googleapis.com/auth/cloud-platform'],
  );
  print(recipientToken);

  final notificationData = {
    'message': {
      'token': recipientToken,
      'notification': {'title': title, 'body': body},
      "data": {"globalUserId": globalUserId},
    },
  };

  const String senderId = '434991368322';
  final response = await client.post(
    Uri.parse('https://fcm.googleapis.com/v1/projects/$senderId/messages:send'),
    headers: {
      'content-type': 'application/json',
    },
    body: jsonEncode(notificationData),
  );

  client.close();
  if (response.statusCode == 200) {
    return true; // Success!
  }

  print('Notification Sending Error Response status: ${response.statusCode}');
  print('Notification Response body: ${response.body}');
  return false;
}
