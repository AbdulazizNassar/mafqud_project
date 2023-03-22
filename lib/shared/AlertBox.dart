import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

errorAlert(context, desc) {
  Alert(
    context: context,
    title: "Error",
    desc: "$desc",
    image: Image.asset("assets/error.png"),
    style: const AlertStyle(
      titleStyle: TextStyle(
        color: Colors.red,
        fontWeight: FontWeight.bold,
      ),
      descStyle: TextStyle(
        color: Colors.red,
        fontWeight: FontWeight.bold,
      ),
    ),
  ).show();
}

confirmationAlert(context, desc) {
  Alert(
    context: context,
    title: "Succesful",
    desc: "$desc",
    image: Image.asset("assets/success.png"),
    style: const AlertStyle(
      titleStyle: TextStyle(
        color: Colors.green,
        fontWeight: FontWeight.bold,
      ),
      descStyle: TextStyle(
        color: Colors.green,
        fontWeight: FontWeight.bold,
      ),
    ),
  ).show();
}

showNotification(context) {
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    ScaffoldMessenger.of(context).showMaterialBanner(
      MaterialBanner(
        padding: const EdgeInsets.all(20),
        content:
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text(
            "New Notification",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
          ),
          const SizedBox(height: 5),
          Text(message.data['title']),
          Text(message.data['body'])
        ]),
        leading: const Icon(Icons.notifications),
        backgroundColor: Colors.grey,
        actions: <Widget>[
          TextButton(
            onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
            },
            child: const Text('DISMISS'),
          ),
          TextButton(onPressed: () {}, child: const Text("view")),
        ],
      ),
    );
    if (message.notification != null) {
      print(
          'Message also contained a notification: ${message.notification!.title.toString()}');
    }
  });
}
