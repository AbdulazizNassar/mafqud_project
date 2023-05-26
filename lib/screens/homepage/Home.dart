import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mafqud_project/screens/posts/posts.dart';
import 'package:mafqud_project/services/notification.dart';
import 'package:mafqud_project/shared/AlertBox.dart';
import 'package:mafqud_project/shared/Lists.dart';
import 'package:mafqud_project/shared/NavMenu.dart';

import '../../services/auth.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String dropdownValue = 'Electronics';
  final _formKey = GlobalKey<FormState>();
  String searchString = '';
  searchPosts() {
    var data = _formKey.currentState;
    if (data!.validate() && searchString != '') {
      data.save();
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Posts(
                    searchValue: searchString,
                  )));
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    getToken();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Home'),
          backgroundColor: Colors.blue[900],
          centerTitle: true,
        ),
        drawer: const NavMenu(),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    DocumentSnapshot snap = await FirebaseFirestore.instance
                        .collection("userToken")
                        .doc(AuthService().currentUser!.uid)
                        .get();
                    String token = snap['token'];
                    sendPushMessage("title", "subtitle", token);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    child: const Text("send Notification test"),
                  ),
                ),
                const SizedBox(
                  height: 70,
                ),
                const Text('Search for an item:',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  validator: (value) {
                    if (value == '') {
                      ScaffoldMessenger.of(context).showSnackBar(snackBarError(
                          "Error", "Cannot search for empty fields"));
                    }
                    setState(() {
                      searchString = value!;
                    });
                  },
                  decoration: const InputDecoration(
                      labelText: 'Search', suffixIcon: Icon(Icons.search)),
                ),
                const SizedBox(
                  height: 70,
                ),
                const Text(' Or by Categories: ',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                const SizedBox(
                  height: 30,
                ),
                DropdownButton<String>(
                  isExpanded: true,
                  value: dropdownValue,
                  items: postCategories
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: const TextStyle(fontSize: 17),
                      ),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      dropdownValue = newValue!;
                    });
                  },
                ),
                const SizedBox(
                  height: 100,
                ),
                Center(
                  child: TextButton(
                    onPressed: () {
                      searchPosts();
                    },
                    child: const Text(
                      "Search",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
