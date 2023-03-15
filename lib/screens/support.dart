import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mafqud_project/shared/AlertBox.dart';
import 'package:mafqud_project/shared/NavMenu.dart';
import 'package:mafqud_project/shared/constants.dart';
import 'package:mafqud_project/shared/loading.dart';

import '../services/auth.dart';

class support extends StatefulWidget {
  const support({super.key});

  @override
  State<support> createState() => _supportState();
}

class _supportState extends State<support> {
  @override
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  var title, desc, category, type;
  String msg = '';
  Widget build(BuildContext context) => isLoading
      ? Loading()
      : Scaffold(
          appBar: AppBar(
            title: const Text("Support"),
          ),
          drawer: const NavMenu(),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        decoration: const InputDecoration(labelText: 'Title'),
                        keyboardType: TextInputType.text,
                        onFieldSubmitted: (value) {
                          setState(() {
                            title = value;
                          });
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Title cannot be empty';
                          }
                        },
                        maxLength: 30,
                        maxLines: 1,
                      ),
                      TextFormField(
                        validator: (val) {
                          if (val!.isEmpty) {
                            return "Description is required";
                          }
                        },
                        maxLines: 4,
                        maxLength: 250,
                        onSaved: (val) {
                          desc = val;
                        },
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 20,
                          ),
                          hintText: 'Enter the description',
                          hintStyle: const TextStyle(fontSize: 14),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Column(
                  children: <Widget>[
                    const Text(
                      "Category",
                      style: textStyle,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const SizedBox(
                      height: 7,
                    ),
                    Column(
                      children: [
                        RadioListTile(
                            title: const Text("Suggestions"),
                            value: "Suggestions",
                            groupValue: type,
                            onChanged: (value) {
                              setState(() {
                                type = value;
                              });
                            }),
                        RadioListTile(
                            title: const Text("Problems"),
                            value: "Problems",
                            groupValue: type,
                            onChanged: (value) {
                              setState(() {
                                type = value;
                              });
                            }),
                        Text(
                          msg,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        setState(() {
                          isLoading = true;
                        });
                        CollectionReference support =
                            FirebaseFirestore.instance.collection("support");
                        var userID = AuthService().currentUser!.uid;
                        var data = _formKey.currentState;
                        if (data!.validate() && type != null) {
                          data.save();
                          await support.add({
                            "title": title,
                            "description": desc,
                            "userID": userID,
                            "type": type,
                            "Date": DateTime.now(),
                          });
                          confirmationAlert(
                              context, "Message sent successfully");
                        } else {
                          setState(() {
                            msg = "Please choose type of message";
                          });
                        }
                        setState(() {
                          isLoading = false;
                        });
                      },
                      child: const Text("submit"),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
}
