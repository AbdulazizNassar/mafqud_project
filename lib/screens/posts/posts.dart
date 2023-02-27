

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mafqud_project/screens/posts/addPost.dart';

class Posts extends StatefulWidget {
  const Posts({Key? key}) : super(key: key);

  @override
  State<Posts> createState() => _PostsState();
}

class _PostsState extends State<Posts> {

  CollectionReference postsRef = FirebaseFirestore.instance.collection('Posts');

  getPosts() async {
    var posts = postsRef.doc();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Posts"),
        backgroundColor: Colors.blue[900],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              child: FutureBuilder(
                future: postsRef.get(),
                builder: (context, snapshot){
                  if (snapshot.hasData){
                    return Text("has data");}
                  else 
                    return Text("No data");
                },

              ),
            ),
            ElevatedButton(
              onPressed: ()  {
              Navigator.of(context).pushNamed("AddPost");
              },
              child: const Text(
                'Add Post',
                style: TextStyle(
                    fontSize: 12,
                    color: Colors.white),
              ),
            ),
          ],

        ),
      ),






    );
  }
}

class ListPosts extends StatelessWidget {
  final posts;
  ListPosts({this.posts});
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Row(
        children: [
          Expanded(
              flex: 3,
              child: ListTile(
                title: Text("${posts['postTitle']}"),
                subtitle: Text("${posts['category']}"),
                trailing: IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.edit),
                )
              ))
        ],
      ),
    );
  }
}


