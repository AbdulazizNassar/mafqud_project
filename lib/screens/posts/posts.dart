import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mafqud_project/services/googleMap/googleMapsShowPosts.dart';
import 'package:mafqud_project/services/notification.dart';
import 'package:mafqud_project/shared/NavMenu.dart';
import '../../shared/AlertBox.dart';
import '../../shared/PostCards.dart';
import '../../shared/loading.dart';

class Posts extends StatefulWidget {
  String? searchValue;
  Posts({Key? key, this.searchValue})
      : super(
          key: key,
        );

  @override
  State<Posts> createState() => _PostsState();
}

class _PostsState extends State<Posts> {
  Query<Map<String, dynamic>> postsRef =
      FirebaseFirestore.instance.collection('Posts').orderBy('Date');

  final _formKey = GlobalKey<FormState>();
  String searchString = '';
  switchPage() {
    var data = _formKey.currentState;
    if (data!.validate() && searchString != '') {
      data.save();
      setState(() {
        flag = true;
      });
    } else {
      setState(() {
        flag = false;
      });
    }
  }

  @override
  void initState() {
    getToken();
  }

  @override
  Widget build(BuildContext context) => postsMaterialApp(context);
  bool flag = false;
  Icon customIcon = const Icon(Icons.search);
  Widget customSearchBar = const Text('Posts');
  Widget postsMaterialApp(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: customSearchBar,
          titleSpacing: -25,
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
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const MapPosts()));
              },
            ),
            showSearchBar(context),
          ],
        ),
        drawer: const NavMenu(),
        body: flag
            ? TabBarView(
                children: [
                  displayPosts("Found", searchString),
                  displayPosts("Lost", searchString)
                ],
              )
            : TabBarView(
                children: [
                  displayPosts("Found", ""),
                  displayPosts("Lost", ""),
                ],
              ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.blue[900],
          onPressed: () {
            Navigator.of(context).pushNamed("AddPost");
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  IconButton showSearchBar(BuildContext context) {
    return IconButton(
      icon: customIcon,
      onPressed: () {
        setState(() {
          if (customIcon.icon == Icons.search) {
            customIcon = const Icon(Icons.cancel);
            customSearchBar = ListTile(
              title: validateSearch(context),
            );
          } else {
            customIcon = const Icon(Icons.search);
            customSearchBar = const Text('Posts');
            setState(() {
              flag = false;
            });
          }
        });
      },
    );
  }

  final _controller = TextEditingController();
  Widget validateSearch(BuildContext context) {
    return Form(
        key: _formKey,
        child: TextFormField(
          controller: _controller,
          validator: (value) {
            if (value == '') {
              setState(() {
                ScaffoldMessenger.of(context).showSnackBar(
                    snackBarError("Error", "Cannot search for empty fields"));
              });
            }
            setState(() {
              searchString = value!;
            });
          },
          decoration: searchBar(),
          style: const TextStyle(color: Colors.black),
        ));
  }

  InputDecoration searchBar() {
    return InputDecoration(
      prefixIcon: IconButton(
        icon: const Icon(
          Icons.search,
          color: Colors.black,
          size: 28,
        ),
        onPressed: () {
          switchPage();
        },
      ),
      fillColor: Colors.white,
      filled: true,
      contentPadding: const EdgeInsets.all(12.0),
      enabledBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.white, width: 2.0),
      ),
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.pink, width: 2.0),
      ),
      hintText: "Search...",
      hintStyle: const TextStyle(
          color: Colors.black, fontSize: 18, fontStyle: FontStyle.italic),
    );
  }

  FutureBuilder<QuerySnapshot<Object?>> displayPosts(
      String status, String searchValue) {
    return FutureBuilder<QuerySnapshot>(
        future: postsRef.where("status", isEqualTo: status).get(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Loading();
          } else {
            if (snapshot.data!.docs.isEmpty) {
              return noPostFoundMsg;
            }
            if (searchValue.isEmpty) {
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  return PostCards(posts: snapshot.data!.docs[index]);
                },
              );
            } else {
              //return all posts containing title
              Iterable<QueryDocumentSnapshot<Object?>> titleQuery =
                  searchByTitle(snapshot, searchValue);
              if (titleQuery.isEmpty) {
                return noPostFoundMsg;
              } else {
                return ListView(
                  children: [
                    ...titleQuery.map((QueryDocumentSnapshot<Object?> post) {
                      return PostCards(
                        posts: post,
                      );
                    })
                  ],
                );
              }
            }
          }
        });
  }

  Iterable<QueryDocumentSnapshot<Object?>> searchByTitle(
      AsyncSnapshot<QuerySnapshot<Object?>> snapshot, String searchValue) {
    return snapshot.data!.docs.where((QueryDocumentSnapshot<Object?> element) =>
        element['title'].toString().toLowerCase().contains(searchValue));
  }

  Widget noPostFoundMsg = Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Icon(
        Icons.warning,
        color: Colors.yellow.shade800,
      ),
      Text(
        "No Posts Found",
        style: TextStyle(color: Colors.red.shade500, fontSize: 25),
      ),
    ],
  );
}
