
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:mafqud_project/models/postModel.dart';
import 'package:mafqud_project/screens/posts/posts.dart';
import 'package:mafqud_project/services/notifications.dart';
import 'package:mafqud_project/shared/AlertBox.dart';
import 'package:mafqud_project/shared/Lists.dart';
import 'package:mafqud_project/shared/NavMenu.dart';
import 'package:mafqud_project/screens/homepage/Home.dart';
import 'package:mafqud_project/models/postModel.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String dropdownValue = 'Electronics';
  final _formKey = GlobalKey<FormState>();
  String searchString = '';
  List result = [];

  postModal obj = new postModal();
  List<postModal> psts= <postModal>[];


   void getObjects() async{
      obj.PostBuilder();

   }

  @override
  void initState() {
    // TODO: implement initState
    setState(() {
      getObjects();
    });
    super.initState();
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
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                    if (value!.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(snackBarError(
                          "Error", "Cannot search for empty fields"));
                    }
                  },
                  onSaved: (newValue) {
                    searchString = newValue!;
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
                    onPressed: () async {

                     // Navigator.of(context).pushNamed("Posts");
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
