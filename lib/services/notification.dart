import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'package:mafqud_project/services/auth.dart';

String? mtoken = " ";

void getToken() async {
  await FirebaseMessaging.instance.getToken().then((token) {
    mtoken = token;
    saveToken(token!);
  });
}

void saveToken(String token) async {
  await FirebaseFirestore.instance
      .collection("userToken")
      .doc(AuthService().currentUser!.uid)
      .update({
    "uid": AuthService().currentUser!.uid,
    "token": token,
  });
}

void requestPermission() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    print('User granted permission');
  } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
    print('User granted provisional permission');
  } else {
    print('User declined or has not accepted permission');
  }
}

void sendPushMessage(String title, String body, String token) async {
  try {
    await http.post(
      Uri.parse('https://fcm.googleapis.com/fcm/send'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization':
            'key=AAAATrnSN4M:APA91bFclWR-GxPruTqUuZZ3nMx-Sl1KGSlxeXhhkpEkS7wIbXYTexjvKlw2eMcpdH_qFLR6e72fMIhKtdlqtEwAZSw0XLZYpaSLgZbmkbkTd_uDfUWHRoAyIsreGgK9f8lJVhxeIERw',
      },
      body: jsonEncode(
        <String, dynamic>{
          'priority': 'high',
          'data': <String, dynamic>{
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'id': '1',
            'status': 'done',
            "body": body,
            "title": title
          },
          'notification': <String, dynamic>{
            'body': body,
            'title': title,
          },
          "to": token,
        },
      ),
    );
    await FirebaseFirestore.instance.collection("notifications").add({
      "uid": AuthService().currentUser!.uid,
      "title": title,
      'subtitle': body,
      "date": DateTime.now(),
    });
  } catch (e) {
    print("error push notificatiot");
  }
}
