import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:mafqud_project/screens/MenuItems/Notifications/constant.dart';
import 'package:flutter/material.dart';
import 'package:mafqud_project/screens/MenuItems/Notifications/notificationTiles.dart';
import 'package:mafqud_project/shared/loading.dart';

class NotificationList extends StatefulWidget {
  NotificationList({Key? key}) : super(key: key);

  @override
  _NotificationListState createState() => _NotificationListState();
}

class _NotificationListState extends State<NotificationList> {
  Query<Map<String, dynamic>> notificationsRef =
      FirebaseFirestore.instance.collection('notifications');
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
              onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const Scaffold())),
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

  FutureBuilder<QuerySnapshot<Object?>> displayNotification() {
    return FutureBuilder<QuerySnapshot>(
        future: notificationsRef
            .where("uid", isEqualTo: FirebaseAuth.instance.currentUser?.uid)
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

  deleteNotification(String id) async {
    await FirebaseFirestore.instance
        .collection("notifications")
        .doc(id)
        .delete();
  }
}
