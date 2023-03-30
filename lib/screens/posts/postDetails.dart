import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mafqud_project/shared/constants.dart';
import 'package:mafqud_project/shared/loading.dart';
import 'package:geocoding/geocoding.dart';
import '../../shared/DateTime.dart';

class postDetails extends StatefulWidget {
  final posts;
  final locality;
  final subLocality;
  const postDetails({super.key, this.posts, this.locality, this.subLocality});
  @override
  State<postDetails> createState() => _postDetailsState();
}

class _postDetailsState extends State<postDetails> {
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
              backgroundColor: Colors.grey.shade200,
              appBar: AppBar(
                title: Text("${widget.posts['title']}"),
                backgroundColor: Colors.blue[900],
              ),
              body: Column(children: [
                Row(
                  children: [
                    Expanded(
                        flex: 3,
                        child: Image.network(
                          widget.posts['image'],
                          fit: BoxFit.fill,
                          height: 350,
                        )),
                  ],
                ),
                Container(
                  margin: const EdgeInsets.only(top: 20),
                  width: double.infinity,
                  height: 350,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.pin_drop_outlined,
                              size: 40,
                            ),
                            Text("${widget.locality}, \n${widget.subLocality}",
                                style: textStyle),
                          ],
                        ),
                      ),
                      const SizedBox(height: 15),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        child: Align(
                          alignment: Alignment.topRight,
                          child: Row(
                            children: [
                              Text(
                                "Status: ${widget.posts["status"]}",
                                style: textStyle,
                              ),
                              const SizedBox(
                                width: 25,
                              ),
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
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 0),
                        child: Container(
                          padding: const EdgeInsets.fromLTRB(15, 15, 0, 0),
                          width: double.infinity,
                          decoration: const BoxDecoration(
                              border: Border.symmetric(),
                              color: Colors.blueGrey,
                              borderRadius:
                                  BorderRadius.all(Radius.elliptical(15, 15))),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Description:",
                                style: textStyle,
                              ),
                              const SizedBox(
                                height: 4,
                              ),
                              Text(
                                '${widget.posts["description"]}',
                                style: textStyle,
                              )
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "ad posted by : ${data["name"]}",
                              style: const TextStyle(fontSize: 20),
                            ),
                            ElevatedButton.icon(
                                onPressed: () {},
                                icon: const Icon(Icons.message),
                                label: const Text("Send a Message"))
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ]),
            );
          }
          return Loading();
        });
  }
}
