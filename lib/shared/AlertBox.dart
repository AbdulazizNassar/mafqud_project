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
