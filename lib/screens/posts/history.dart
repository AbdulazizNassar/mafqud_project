import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:mafqud_project/main.dart';
import 'package:mafqud_project/screens/MenuItems/Notifications/constant.dart';
import 'package:mafqud_project/screens/posts/editPost.dart';
import 'package:mafqud_project/screens/posts/selectImage.dart';
import 'package:mafqud_project/shared/bottomNav.dart';
import 'package:mafqud_project/shared/loading.dart';

import '../../services/auth.dart';
import '../../services/imagePicker.dart';
import '../../shared/DateTime.dart';
import '../../shared/NavMenu.dart';

class History extends StatefulWidget {
  const History({Key? key}) : super(key: key);

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  User? userAuth = AuthService().currentUser;
  CollectionReference postsRef = FirebaseFirestore.instance.collection('Posts');

  @override
  Widget build(BuildContext context) => isLoading
      ? Loading()
      : Scaffold(
          appBar: AppBar(
            title: const Text("My Posts"),
            backgroundColor: Colors.blue[900],
          ),
          bottomNavigationBar: Bottombar(context),
          drawer: const NavMenu(),
          body: FutureBuilder(
              future: postsRef
                  .where("userID",
                      isEqualTo: FirebaseAuth.instance.currentUser?.uid)
                  .orderBy("Date", descending: true)
                  .get(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                      itemCount: snapshot.data?.docs.length,
                      itemBuilder: (context, i) {
                        return listPosts(
                          context: context,
                          posts: snapshot.data?.docs[i],
                          docID: snapshot.data?.docs[i].id,
                        );
                      });
                } else if (!snapshot.hasData) {
                  return const Center(
                    child: Text(
                      "No Posts Found",
                      style: TextStyle(color: Colors.red),
                    ),
                  );
                } else if (snapshot.hasError) {
                  return const Text("Error");
                } else if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  Loading();
                }
                return const Text(".");
              }),
        );

  bool isLoading = false;
  deletePost(post, docID) async {
    await FirebaseFirestore.instance.collection('Posts').doc(docID).delete();
  }

  Slidable listPosts(
      {required BuildContext context, required posts, required docID}) {
    return Slidable(
      key: UniqueKey(),
      endActionPane: ActionPane(
          motion: const ScrollMotion(),
          dismissible: DismissiblePane(onDismissed: () async {
            setState(() {
              isLoading = true;
            });
            await deletePost(posts, docID);
            setState(() {
              isLoading = false;
            });
          }),
          children: [
            SlidableAction(
              onPressed: (BuildContext context) async {
                setState(() {
                  isLoading = true;
                });
                await deletePost(posts, docID);
                setState(() {
                  isLoading = false;
                });
              },
              backgroundColor: const Color(0xFFFE4A49),
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: "Delete",
            )
          ]),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => addImages(posts: posts, docID: docID)));
        },
        child: Card(
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: checkUrl(posts['image'][0]),
              ),
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
              deleteIcon,
              const SizedBox(
                height: 90,
              )
            ],
          ),
        ),
      ),
    );
  }
}
