import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mafqud_project/screens/posts/addPost.dart';
import 'package:mafqud_project/screens/posts/postDetails.dart';

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
    QuerySnapshot querySnapshot = await postsRef.get();

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
    return Scaffold(
      appBar: AppBar(
        title: const Text("Posts"),
        backgroundColor: Colors.blue[900],
      ),
      body: FutureBuilder(
          future: postsRef.get(),
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
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed("AddPost");
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
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
                  subtitle: Text("${posts['category']}"),
                )),
            const Icon(Icons.keyboard_double_arrow_right_outlined),
            const SizedBox(
              height: 90,
            )
          ],
        ),
      ),
    );
  }
}
