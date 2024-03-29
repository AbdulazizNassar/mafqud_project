import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:mafqud_project/main.dart';
import 'package:mafqud_project/models/userModel.dart';
import 'package:mafqud_project/screens/MenuItems/Notifications/constant.dart';
import 'package:flutter/material.dart';
import 'package:mafqud_project/screens/MenuItems/Notifications/notificationTiles.dart';
import 'package:mafqud_project/screens/chat/chat_details_list.dart';
import 'package:mafqud_project/screens/posts/selectImage.dart';
import 'package:mafqud_project/shared/loading.dart';

import '../../../services/auth.dart';
import '../../../services/showPostDetails.dart';

class NotificationList extends StatefulWidget {
  const NotificationList({Key? key}) : super(key: key);

  @override
  _NotificationListState createState() => _NotificationListState();
}

class _NotificationListState extends State<NotificationList> {
  CollectionReference notificationsRef =
      FirebaseFirestore.instance.collection('notifications');
  UserModel? model;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: kWhiteColor,
        appBar: AppBar(
          title: const Text('Notifications'),
          centerTitle: true,
          backgroundColor: Colors.blue.shade900,
        ),
        body: displayNotification(),
      ),
    );
  }

  FutureBuilder<QuerySnapshot<Object?>> displayNotification() {
    return FutureBuilder<QuerySnapshot>(
        future: notificationsRef
            .where("uidReceiver", isEqualTo: AuthService().currentUser!.uid)
            .get(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Loading();
          } else {
            if (snapshot.data!.docs.isEmpty) {
              return noNotification;
            } else {
              return listBuilder(snapshot.data!.docs);
            }
          }
        });
  }

  ListView listBuilder(List<QueryDocumentSnapshot<Object?>> snapshot) {
    return ListView.separated(
      physics: const ClampingScrollPhysics(),
      padding: EdgeInsets.zero,
      itemCount: snapshot.length,
      itemBuilder: (context, i) {
        return Slidable(
            key: UniqueKey(),
            endActionPane: ActionPane(
                motion: const ScrollMotion(),
                dismissible: DismissiblePane(onDismissed: () {
                  setState(() {
                    deleteNotification(snapshot[i].id);
                  });
                }),
                children: [
                  SlidableAction(
                    onPressed: (BuildContext context) async {
                      setState(() {
                        deleteNotification(snapshot[i].id);
                      });
                    },
                    backgroundColor: const Color(0xFFFE4A49),
                    foregroundColor: Colors.white,
                    icon: Icons.delete,
                    label: 'Delete',
                  )
                ]),
            child: InkWell(
              onTap: () async {
                if (snapshot[i]['postID'] != null) {
                  DocumentSnapshot post = await FirebaseFirestore.instance
                      .collection('Posts')
                      .doc(snapshot[i]['postID'])
                      .get();
                  await showPostDetailsPage(
                      posts: post,
                      context: context,
                      images: post["image"],
                      postID: post.id);
                } else {
                  navKey.currentState!.push(MaterialPageRoute(
                      builder: (_) => ChatDetailsList(
                            receiverUid: snapshot[i]['uid'],
                            senderUid: snapshot[i]['uidReceiver'],
                            receiverName: snapshot[i]['nameReceiver'],
                          )));
                }

                await notificationsRef
                    .doc(snapshot[i].id)
                    .update({'status': "old"});
              },
              child: NotificationTiles(
                notification: snapshot[i],
                enable: true,
              ),
            ));
      },
      separatorBuilder: (BuildContext context, int index) {
        return const Divider(
          color: Colors.black,
        );
      },
    );
  }

  deleteNotification(String id) async {
    await FirebaseFirestore.instance
        .collection("notifications")
        .doc(id)
        .delete();
  }
}
