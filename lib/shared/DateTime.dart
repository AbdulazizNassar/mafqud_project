import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:mafqud_project/services/auth.dart';
import 'package:mafqud_project/services/notification.dart';

String readTimestamp(Timestamp? timestamp) {
  var now = DateTime.now();
  var format = DateFormat('h:mm a');
  var date = DateTime.fromMillisecondsSinceEpoch(timestamp!.seconds * 1000);
  var diff = now.difference(date);
  var time = '';

  if (diff.inSeconds <= 0 ||
      diff.inSeconds > 0 && diff.inMinutes == 0 ||
      diff.inMinutes > 0 && diff.inHours == 0 ||
      diff.inHours > 0 && diff.inDays == 0) {
    time = format.format(date);
  } else if (diff.inDays > 0 && diff.inDays < 7) {
    if (diff.inDays == 1) {
      time = '${diff.inDays} DAY AGO';
    } else {
      time = '${diff.inDays} DAYS AGO';
    }
  } else {
    if (diff.inDays == 7) {
      time = '${(diff.inDays / 7).floor()} WEEK AGO';
    } else {
      time = '${(diff.inDays / 7).floor()} WEEKS AGO';
    }
  }

  return time;
}

sendUpdatePost() async {
  QuerySnapshot<Map<String, dynamic>> posts =
      await FirebaseFirestore.instance.collection('Posts').get();

  posts.docs.forEach((element) async {
    QuerySnapshot<Map<String, dynamic>> notifications = await FirebaseFirestore
        .instance
        .collection('notifications')
        .where('postID', isEqualTo: element.id)
        .get();
    var diff =
        element['expiry']!.toDate().difference(element['Date']!.toDate());

    if (diff.inDays == 2 && notifications.docs.isEmpty) {
      sendPushMessage(
          "Update post",
          "Post will automatically delete after 3 days if not updated",
          await getTokenByUID(element['userID']),
          uidReceiver: element['userID'],
          postID: element.id);
    }
  });
}
