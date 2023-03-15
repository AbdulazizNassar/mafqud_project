import 'package:firebase_messaging/firebase_messaging.dart';

var token = FirebaseMessaging.instance;

Future<String?> getUserToken() async {
  token.getToken();
}
