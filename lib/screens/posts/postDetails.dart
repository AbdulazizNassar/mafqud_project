import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mafqud_project/shared/constants.dart';
import 'package:mafqud_project/shared/loading.dart';

import '../../shared/DateTime.dart';

class postDetails extends StatefulWidget {
  final posts;
  const postDetails({super.key, this.posts});
  @override
  State<postDetails> createState() => _postDetailsState();
}

class _postDetailsState extends State<postDetails> {
  @override
  Widget build(BuildContext context) {
    //get user that created post
    CollectionReference user = FirebaseFirestore.instance.collection("users");

    return FutureBuilder<DocumentSnapshot>(
        future: user.doc("${widget.posts["userID"]}").get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> data =
                snapshot.data!.data() as Map<String, dynamic>;
            return Scaffold(
              appBar: AppBar(
                title: Text("${widget.posts['title']}"),
                backgroundColor: Colors.blue[900],
              ),
              body: Column(children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [],
                ),
                const SizedBox(
                  height: 300,
                ),
                Row(children: const [
                  Icon(
                    Icons.pin_drop_outlined,
                    size: 40,
                  ),
                  //Todo edit to make location written by user
                  Text("Ksu", style: textStyle),
                ]),
                const SizedBox(height: 15),
                Container(
                    margin: const EdgeInsets.only(right: 250),
                    color: Colors.grey,
                    child: Text(
                      "status: ${widget.posts["status"]}",
                      style: textStyle,
                    )),
                const SizedBox(height: 15),
                Row(
                  children: [
                    const Icon(
                      Icons.timer_outlined,
                      size: 30,
                    ),
                    Text(
                      readTimestamp(widget.posts["Date"]),
                      style: textStyle,
                    ),
                  ],
                ),
                const SizedBox(height: 1),
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  margin: const EdgeInsets.fromLTRB(0, 30, 190, 0),
                  color: Colors.blue,
                  child: Text(
                    "Description: \n ${widget.posts["description"]}",
                    style: textStyle,
                  ),
                ),
                const SizedBox(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "ad posted by : ${data["name"]}",
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.message),
                    label: const Text("Send a Message"))
              ]),
            );
          }
          return Loading();
        });
  }
}
