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
  String? searchValue;
  Posts({Key? key, this.searchValue})
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
              displayPostsv2("Found"),
              displayPostsv2("Lost"),
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

  FutureBuilder<QuerySnapshot<Object?>> displayPostsv2(String status) {
    return FutureBuilder<QuerySnapshot>(
        future: postsRef.where("status", isEqualTo: status).get(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Text("");
          } else if (snapshot.hasData) {
            return ListView(
              children: [
                ...snapshot.data!.docs
                    .where((QueryDocumentSnapshot<Object?> element) =>
                        element['title']
                            .toString()
                            .toLowerCase()
                            .contains(widget.searchValue!))
                    .map((QueryDocumentSnapshot<Object?> post) {
                  return PostCards(
                    posts: post,
                  );
                })
              ],
            );
          } else {
            return Loading();
          }
        });
  }
}
