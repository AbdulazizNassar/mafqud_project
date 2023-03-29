import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:mafqud_project/shared/DateTime.dart';
import 'package:mafqud_project/shared/PostCards.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../services/showPostDetails.dart';

snackBarError(String title, String message) {
  return SnackBar(
    /// need to set following properties for best effect of awesome_snackbar_content
    elevation: 0,
    behavior: SnackBarBehavior.floating,
    backgroundColor: Colors.transparent,
    content: AwesomeSnackbarContent(
      title: title,
      message: message,

      /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
      contentType: ContentType.failure,
    ),
  );
}

snackBarPostDetails(posts, context) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar
    ..showSnackBar(
      SnackBar(
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          content: PostCards(posts: posts)),
    );
}

snackBarSuccess(String title, String message) {
  return SnackBar(
    /// need to set following properties for best effect of awesome_snackbar_content
    elevation: 0,
    behavior: SnackBarBehavior.floating,
    backgroundColor: Colors.transparent,
    content: AwesomeSnackbarContent(
      title: title,
      message: message,

      /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
      contentType: ContentType.success,
    ),
  );
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
