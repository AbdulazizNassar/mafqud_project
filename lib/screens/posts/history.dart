import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mafqud_project/screens/posts/editPost.dart';

import '../../services/auth.dart';
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("History"),
        backgroundColor: Colors.blue[900],
      ),
      drawer: const NavMenu(),
      body: FutureBuilder(
          future: postsRef
              .where("userID",
                  isEqualTo: FirebaseAuth.instance.currentUser?.uid)
              .get(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  itemCount: snapshot.data?.docs.length,
                  itemBuilder: (context, i) {
                    return ListPosts(
                      posts: snapshot.data?.docs[i],
                      docID: snapshot.data?.docs[i].id,
                    );
                  });
            } else if (snapshot.hasError) {
              return const Text("Error");
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              const Text("loading");
            }
            return const Text(".");
          }),
    );
  }
}

class ListPosts extends StatelessWidget {
  final posts;
  final docID;

  const ListPosts({this.posts, this.docID});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => EditPost(
                      posts: posts,
                      docID: docID,
                    )));
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
              style: const TextStyle(fontWeight: FontWeight.w100, fontSize: 15),
            ),
            const Icon(
              Icons.edit,
              size: 30,
            ),
            const SizedBox(
              height: 90,
            )
          ],
        ),
      ),
    );
  }
}
