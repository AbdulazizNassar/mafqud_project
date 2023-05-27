import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mafqud_project/services/googleMap/googleMapsShowPosts.dart';
import 'package:mafqud_project/services/notification.dart';
import 'package:mafqud_project/shared/NavMenu.dart';
import 'package:mafqud_project/shared/constants.dart';
import '../../shared/AlertBox.dart';
import '../../shared/PostCards.dart';

import '../../shared/loading.dart';
import 'package:mafqud_project/screens/posts/selectImage.dart';

class Posts extends StatefulWidget {
  final String? searchValue;
  const Posts({Key? key, this.searchValue})
      : super(
          key: key,
        );

  @override
  State<Posts> createState() => _PostsState();
}

enum CategoryItem { Animals, Personalitems, Electronics }

class _PostsState extends State<Posts> {
  Query<Map<String, dynamic>> postsRef =
      FirebaseFirestore.instance.collection('Posts').orderBy('Date');

  final _formKey = GlobalKey<FormState>();
  String searchString = '';
  String category = ' ';
  switchPage() {
    var data = _formKey.currentState;
    if (data!.validate() && searchString != '') {
      data.save();
      setState(() {
        searchFlag = true;
      });
    } else {
      setState(() {
        searchFlag = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getToken();
  }

  @override
  Widget build(BuildContext context) => postsMaterialApp(context);

  bool searchFlag = false;
  bool categoryFlag = false;
  Icon customIcon = const Icon(Icons.search);
  Widget customSearchBar = const Text('Posts');
  CategoryItem? selectedMenu;
  String categoryTitle = 'Filter';
  Icon filterIcon = const Icon(
    Icons.filter_alt_outlined,
    color: Colors.white,
  );
  bool highLightedColor = false;
  Widget postsMaterialApp(BuildContext context) {
    return MaterialApp(
        home: DefaultTabController(
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
                    ),
                    tabs: [
                      tabView(Colors.green, "Found"),
                      tabView(Colors.red, "Lost")
                    ]),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.map_outlined),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const MapPosts()));
                    },
                  ),
                  showSearchBar(context),
                ],
              ),
              drawer: const NavMenu(),
              body: searchFlag
                  ? TabBarView(
                      children: [
                        displayPosts("Found", searchString, ''),
                        displayPosts("Lost", searchString, '')
                      ],
                    )
                  : categoryFlag
                      ? TabBarView(
                          children: [
                            displayPosts("Found", "",
                                selectedMenu.toString().substring(13)),
                            displayPosts("Lost", "",
                                selectedMenu.toString().substring(13)),
                          ],
                        )
                      : TabBarView(
                          children: [
                            displayPosts("Found", "", ''),
                            displayPosts("Lost", "", ''),
                          ],
                        ),
              floatingActionButton: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    FloatingActionButton(
                      heroTag: "btn1",
                      backgroundColor: Colors.blue[900],
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const addImages()));
                      },
                      child: const Icon(Icons.add),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Theme(
                      data: themeData(context, highLightedColor),
                      child: SizedBox(
                        height: 50,
                        width: 150,
                        child: FloatingActionButton(
                          heroTag: "btn2",
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50))),
                          onPressed: () {},
                          backgroundColor: Colors.blue.shade900,
                          child: PopupMenuButton<CategoryItem>(
                            initialValue: selectedMenu,
                            onOpened: () {
                              if (categoryFlag) {
                                setState(() {
                                  categoryFlag = false;
                                  highLightedColor = false;
                                  categoryTitle = 'Filter';
                                });
                              }
                            },
                            onCanceled: () {
                              setState(() {
                                highLightedColor = false;
                                categoryFlag = false;
                                categoryTitle = "Filter";
                              });
                            },
                            onSelected: (CategoryItem item) {
                              if (categoryFlag) {
                                setState(() {
                                  categoryFlag = false;
                                  highLightedColor = false;
                                  categoryTitle = "Filter";
                                });
                              } else {
                                setState(() {
                                  highLightedColor = true;
                                  categoryFlag = true;
                                  categoryTitle = item.name;
                                });
                              }
                              selectedMenu = item;
                            },
                            itemBuilder: (BuildContext context) =>
                                <PopupMenuEntry<CategoryItem>>[
                              PopupMenuItem(
                                value: CategoryItem.Animals,
                                child: ListTile(
                                  leading: const Icon(
                                    Icons.pets_outlined,
                                    color: Colors.white,
                                  ),
                                  title: Text("Animals",
                                      style: popupMenuStyle(context)),
                                ),
                              ),
                              PopupMenuItem(
                                value: CategoryItem.Electronics,
                                child: ListTile(
                                  leading: const Icon(
                                    Icons.phone_outlined,
                                    color: Colors.white,
                                  ),
                                  title: Text("Electronics",
                                      style: popupMenuStyle(context)),
                                ),
                              ),
                              PopupMenuItem(
                                value: CategoryItem.Personalitems,
                                child: ListTile(
                                  leading: const Icon(
                                    Icons.person_search_outlined,
                                    color: Colors.white,
                                  ),
                                  title: Text("Personal Items",
                                      style: popupMenuStyle(context)),
                                ),
                              ),
                            ],
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                categoryFlag
                                    ? const Icon(Icons.close_outlined,
                                        color: Colors.red)
                                    : filterIcon,
                                Text(categoryTitle)
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ]),
            )));
  }

  Container tabView(Color? color, String title) {
    return Container(
      decoration:
          BoxDecoration(borderRadius: BorderRadius.circular(25), color: color),
      width: 150,
      child: Tab(
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Text(
                title,
                textAlign: TextAlign.center,
              ),
            ],
          ),
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
              searchFlag = false;
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
            return null;
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
      enabledBorder: UnderlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.lightBlue, width: 2.0),
          borderRadius: BorderRadius.circular(10)),
      hintText: "Search...",
      hintStyle: const TextStyle(
          color: Colors.black, fontSize: 18, fontStyle: FontStyle.italic),
    );
  }

  List<String> list = [];
  FutureBuilder<QuerySnapshot<Object?>> displayPosts(
      String status, String searchValue, String category) {
    return FutureBuilder<QuerySnapshot>(
        future: postsRef.where("status", isEqualTo: status).get(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Loading();
          } else {
            if (snapshot.data!.docs.isEmpty) {
              return noPostFoundMsg;
            }
            if (category.isNotEmpty) {
              Iterable<QueryDocumentSnapshot<Object?>> categoryQuery =
                  searchByCategory(snapshot, category);
              if (categoryQuery.isEmpty) {
                return noPostFoundMsg;
              } else {
                return ListView(
                  children: [
                    ...categoryQuery.map((QueryDocumentSnapshot<Object?> post) {
                      return PostCards(
                        posts: post,
                        image: post['image'],
                      );
                    })
                  ],
                );
              }
            }
            if (searchValue.isEmpty) {
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  return PostCards(
                    posts: snapshot.data!.docs[index],
                  );
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
                        image: post["image"],
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

  Iterable<QueryDocumentSnapshot<Object?>> searchByCategory(
      AsyncSnapshot<QuerySnapshot<Object?>> snapshot, String category) {
    return snapshot.data!.docs.where((QueryDocumentSnapshot<Object?> element) =>
        element['category'].toString().contains(category));
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
