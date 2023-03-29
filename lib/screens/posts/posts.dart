import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:mafqud_project/screens/posts/addPost.dart';
import 'package:mafqud_project/screens/posts/postDetails.dart';
import 'package:mafqud_project/services/showPostDetails.dart';
import 'package:mafqud_project/shared/DateTime.dart';
import 'package:flutter/material.dart';
import 'package:mafqud_project/screens/posts/posts.dart';
import 'package:mafqud_project/services/auth.dart';
import 'package:mafqud_project/services/googleMap/googleMapsShowPosts.dart';
import '../../shared/loading.dart';

class Posts extends StatefulWidget {
  const Posts({Key? key}) : super(key: key);

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
              postListBuilder("Found"),
              postListBuilder("Lost"),
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

  FutureBuilder<QuerySnapshot<Object?>> postListBuilder(String status) {
    return FutureBuilder(
        future: postsRef.where("status", isEqualTo: status).get(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                itemCount: snapshot.data?.docs.length,
                itemBuilder: (context, i) {
                  return ListPosts(posts: snapshot.data?.docs[i]);
                });
          } else if (snapshot.hasError) {
            return const Text("Error");
            print(snapshot.error);
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return Loading();
          }
          return const Text(".");
        });
  }
}

class ListPosts extends StatelessWidget {
  final posts;
//get address based on long and lat

  ListPosts({super.key, this.posts});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        await showPostDetails(posts, context);
        // ignore: use_build_context_synchronously
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
              Icons.keyboard_double_arrow_right_outlined,
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
