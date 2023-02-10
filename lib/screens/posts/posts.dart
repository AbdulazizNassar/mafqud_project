

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mafqud_project/screens/posts/addPost.dart';

class Posts extends StatefulWidget {
  const Posts({Key? key}) : super(key: key);

  @override
  State<Posts> createState() => _PostsState();
}

class _PostsState extends State<Posts> {
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

