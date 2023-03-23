import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mafqud_project/screens/posts/addPost.dart';
import 'package:mafqud_project/screens/posts/postDetails.dart';
import 'package:mafqud_project/shared/DateTime.dart';

class Posts extends StatefulWidget {
  const Posts({Key? key}) : super(key: key);

  @override
  State<Posts> createState() => _PostsState();
}

class _PostsState extends State<Posts> {
  CollectionReference postsRef = FirebaseFirestore.instance.collection('Posts');

  var posts = [];

  Future<void> getData() async {
    // Get docs from collection reference
    Query query = postsRef.where("status", isEqualTo: "Lost");
    QuerySnapshot querySnapshot = await query.get();

    // Get data from docs and convert map to List
    final allData = querySnapshot.docs.map((doc) => doc.data()).toList();
    posts = allData;
  }

  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: const Text("Posts"),
            backgroundColor: Colors.blue[900],
            bottom: TabBar(
                indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color: Colors.blue.shade300),
                tabs: [
                  const Tab(
                    child: Text("Found"),
                  ),
                  const Tab(
                    child: Text("Lost"),
                  )
                ]),
          ),
          body: TabBarView(
            children: [
              post("Found"),
              post("Lost"),
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

  FutureBuilder<QuerySnapshot<Object?>> post(String status) {
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
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            const Text("loading");
          }
          return const Text(".");
        });
  }
}

class ListPosts extends StatelessWidget {
  final posts;

  ListPosts({this.posts});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => postDetails(posts: posts)));
      },
      child: Card(
        child: Row(
          children: [
            Expanded(
                flex: 2,
                child: Image.asset(
                  "assets/flower.jpg", // For test
                  height: 100, fit: BoxFit.fitWidth,
                )),
            Expanded(
                flex: 3,
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
