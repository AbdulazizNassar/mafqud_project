import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:mafqud_project/shared/DateTime.dart';
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
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      content: InkWell(
        onTap: () async {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          await showPostDetailsPage(posts: posts, context: context);
        },
        child: Card(
          child: Row(
            children: [
              Expanded(
                  flex: 3,
                  child: Image.network(
                    posts['image'],
                    fit: BoxFit.cover,
                  )),
              Expanded(
                  flex: 9,
                  child: ListTile(
                    title: Text("${posts['title']}"),
                    subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                              padding: const EdgeInsets.only(top: 5),
                              child: Text("${posts['category']}")),
                          Container(
                            padding: const EdgeInsets.only(top: 5),
                            child: Text(
                              "${posts['status']}",
                              style: const TextStyle(
                                backgroundColor: Colors.amber,
                                fontSize: 15,
                              ),
                            ),
                          )
                        ]),
                  )),
              const Icon(
                Icons.timer_outlined,
                size: 30,
              ),
              Text(
                readTimestamp(posts["Date"]),
                style:
                    const TextStyle(fontWeight: FontWeight.w100, fontSize: 15),
              ),
              const Icon(
                Icons.keyboard_double_arrow_right_outlined,
                size: 30,
              ),
              const SizedBox(
                height: 90,
              )
            ],
          ),
        ),
      ),
    ),
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
