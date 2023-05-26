import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:mafqud_project/shared/DateTime.dart';
import 'package:mafqud_project/shared/PostCards.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../screens/MainScreen.dart';
import '../services/auth.dart';
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

signOutConfirm(context) {
  Alert(
    context: context,
    title: "Do you want to sign out ? ",
    image: Image.asset("assets/logout.png"),
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
    buttons: [
      DialogButton(
          child: const Text("Cancel"), onPressed: () => Navigator.pop(context)),
      DialogButton(
          child: const Text("Sign out"),
          onPressed: () async {
            Navigator.pop(context);
            await AuthService().signOut();
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: ((context) => const MainScreen())));
          }),
    ],
  ).show();
}
