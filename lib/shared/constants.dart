import 'package:flutter/material.dart';
import 'package:mafqud_project/shared/size_config.dart';

import '../services/auth.dart';

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
InputDecoration textFormFieldStyle(String LabelText, IconData? icon,
    [IconButton? iconButton]) {
  return InputDecoration(
    labelText: LabelText,
    labelStyle: const TextStyle(color: primaryColor),
    prefixIcon: Icon(
      icon,
      size: SizeConfig.defaultSize * 2,
      color: primaryColor,
    ),
    suffixIcon: iconButton,
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

ThemeData themeData(BuildContext context, bool flag) {
  return Theme.of(context).copyWith(
    highlightColor: flag ? Colors.green.shade700 : Colors.blue.shade900,
    cardColor: Colors.blue.shade900,
    textTheme: const TextTheme(displayLarge: TextStyle(color: Colors.white)),
  );
}

Icon listIcon(bool highLightedColor, Icon icon) => highLightedColor
    ? const Icon(
        Icons.close_outlined,
        color: Colors.red,
      )
    : icon;

TextStyle? popupMenuStyle(BuildContext context) {
  return Theme.of(context).textTheme.bodyLarge;
}

String? uId = 'start';
