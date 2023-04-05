import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:mafqud_project/screens/posts/addPost.dart';
import 'package:mafqud_project/services/showPostDetails.dart';
import 'package:mafqud_project/shared/DateTime.dart';
import 'package:flutter/material.dart';
import 'package:mafqud_project/screens/posts/posts.dart';
import 'package:mafqud_project/services/auth.dart';
import 'package:mafqud_project/services/googleMap/googleMapsShowPosts.dart';
import '../../shared/PostCards.dart';
import '../../shared/loading.dart';

class Posts extends StatefulWidget {
  var searchValue;
  Posts({Key? key, searchValue})
      : super(
          key: key,
        );

  @override
  State<Posts> createState() => _PostsState();
}

class _PostsState extends State<Posts> {
  Query<Map<String, dynamic>> postsRef =
      FirebaseFirestore.instance.collection('Posts').orderBy('Date');

  @override
  Widget build(BuildContext context) => PostsMaterialApp(context);

  MaterialApp PostsMaterialApp(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_outlined),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            title: const Text("Posts"),
            backgroundColor: Colors.blue[900],
            bottom: TabBar(
                indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color: Colors.blue.shade300),
                tabs: const [
                  Tab(
                    child: Text("Found"),
                  ),
                  Tab(
                    child: Text("Lost"),
                  )
                ]),
            actions: [
              IconButton(
                icon: const Icon(Icons.map_outlined),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const MapPosts()));
                },
              ),
            ],
          ),
          body: TabBarView(
            children: [
              displayPosts()
              // postListBuilder("Found"),
              // postListBuilder("Lost"),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.blue[900],
            onPressed: () {
              Navigator.of(context).pushNamed("AddPost");
            },
            tooltip: 'Increment',
            child: const Icon(Icons.add),
          ),
        ),
      ),
    );
  }

  StreamBuilder<QuerySnapshot<Object?>> displayPosts() {
    return StreamBuilder<QuerySnapshot>(
        stream: postsRef.snapshots().asBroadcastStream(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Loading();
          } else {
            return ListView(
              children: [
                ...snapshot.data!.docs
                    .where((QueryDocumentSnapshot<Object?> element) =>
                        element['title']
                            .toString()
                            .toLowerCase()
                            .contains('test'))
                    .map((QueryDocumentSnapshot<Object?> data) {
                  final String title = data.get('title');
                  final String desc = data.get('category');

                  return PostCards(
                    posts: data,
                  );
                })
              ],
            );
          }
        });
  }

  FutureBuilder<QuerySnapshot<Object?>> postListBuilder(String status) {
    return FutureBuilder(
        future: postsRef.where("status", isEqualTo: status).get(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                itemCount: snapshot.data?.docs.length,
                itemBuilder: (context, i) {
                  return PostCards(posts: snapshot.data?.docs[i]);
                });
          } else if (snapshot.hasError) {
            return const Text("Error");
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return Loading();
          }
          return const Text(".");
        });
  }
}
