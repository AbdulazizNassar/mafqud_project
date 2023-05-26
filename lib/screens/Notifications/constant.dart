import 'package:flutter/material.dart';

const kPrimaryColor = Color(0xFFFF8084);
const kAccentColor = Color(0xFFF1F1F1);
const kWhiteColor = Color(0xFFFFFFFF);
const kLightColor = Color(0xFF808080);
const kDarkColor = Color(0xFF303030);
const kTransparent = Colors.transparent;

Icon deleteIcon = const Icon(
  Icons.delete_sweep_outlined,
  color: Colors.red,
);

Widget noNotification = Row(
  mainAxisAlignment: MainAxisAlignment.center,
  crossAxisAlignment: CrossAxisAlignment.center,
  children: [
    Icon(
      Icons.warning,
      color: Colors.yellow.shade800,
    ),
    Text(
      "No Notifications Found",
      style: TextStyle(color: Colors.red.shade500, fontSize: 25),
    ),
  ],
);
