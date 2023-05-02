import 'package:flutter/material.dart';
import 'package:mafqud_project/shared/size_config.dart';

const textInputDecoration = InputDecoration(
  fillColor: Colors.white,
  filled: true,
  contentPadding: EdgeInsets.all(12.0),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.white, width: 2.0),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.pink, width: 2.0),
  ),
);

const primaryColor = Colors.blue;
const textColor = Colors.black;

const textStyle = TextStyle(
  color: Colors.black,
  fontWeight: FontWeight.bold,
  fontSize: 25.0,
);
InputDecoration textFormFieldStyle(String LabelText) {
  return InputDecoration(
    labelText: LabelText,
    labelStyle: const TextStyle(color: primaryColor),
    prefixIcon: Icon(
      Icons.mail,
      size: SizeConfig.defaultSize * 2,
      color: primaryColor,
    ),
    filled: true,
    enabledBorder: UnderlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide.none,
    ),
    focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: primaryColor)),
  );
}

String? uId = 'start';
