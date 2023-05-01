import 'package:flutter/material.dart';

import 'package:mafqud_project/screens/MenuItems/Notifications/constant.dart';
import 'package:mafqud_project/shared/DateTime.dart';

class NotificationTiles extends StatelessWidget {
  final notification;
  final bool enable;
  const NotificationTiles({
    Key? key,
    required this.notification,
    required this.enable,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor:
          notification['status'] == "new" ? Colors.amberAccent : Colors.white,
      leading: notification['status'] == "new"
          ? Stack(
              children: [msgIcon, newIndicator],
            )
          : msgIcon,
      title: Text(notification['title'],
          style: const TextStyle(color: kDarkColor)),
      subtitle: Text(notification['subtitle'],
          style: const TextStyle(color: kLightColor)),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          deleteIcon,
          Text(
            readTimestamp(notification["date"]),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      enabled: enable,
    );
  }
}
