import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mafqud_project/main.dart';
import 'package:mafqud_project/services/googleMap/googleMapsShowPosts.dart';
import 'package:mafqud_project/services/notification.dart';
import 'package:mafqud_project/shared/NavMenu.dart';
import 'package:mafqud_project/shared/constants.dart';
import '../../shared/AlertBox.dart';
import '../../shared/PostCards.dart';
import '../../shared/loading.dart';
import 'package:mafqud_project/screens/posts/selectImage.dart';
import 'package:mafqud_project/shared/bottomNav.dart';

class Posts extends StatefulWidget {
  final String? searchValue;
  const Posts({Key? key, this.searchValue, this.navKey})
      : super(
          key: key,
        );
  final navKey;
  @override
  State<Posts> createState() => _PostsState();
}

enum CategoryItem { Animals, Personalitems, Electronics }

class _PostsState extends State<Posts> {
  double lat = 0.0;
  double long = 0.0;
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

  final ScrollController controller = ScrollController();

  Future<Position> getUserCurrentLocation() async {
    await Geolocator.requestPermission()
        .then((value) {})
        .onError((error, stackTrace) async {
      await Geolocator.requestPermission();
    });
    return await Geolocator.getCurrentPosition();
  }

  @override
  void initState() {
    super.initState();
    getToken();

    controller.addListener(() {
      if (controller.position.pixels == controller.position.maxScrollExtent) {
        setState(() {
          numOfPosts += 5;
        });
      }
      if (controller.offset == 0.0) {
        setState(() {
          if (numOfPosts > 0) {
            numOfPosts -= 5;
          }
          lastDoc = null;
        });
      }
    });
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
  bool isLoading = false;
  Widget postsMaterialApp(BuildContext context) => isLoading
      ? Loading()
      : MaterialApp(
          home: DefaultTabController(
              length: 2,
              child: Scaffold(
                appBar: AppBar(
                  centerTitle: true,
                  title: customSearchBar,
                  titleSpacing: -25,
                  backgroundColor: Colors.blue[900],
                  bottom: TabBar(
                      indicatorSize: TabBarIndicatorSize.tab,
                      indicator: const UnderlineTabIndicator(
                        borderSide: BorderSide(
                          color: Colors.amber,
                          width: 2,
                        ),
                      ),
                      tabs: [
                        Container(
                          color: Colors.green.shade600,
                          width: MediaQuery.of(context).size.width / 2,
                          child: tabView(Colors.green, "Found"),
                        ),
                        Container(
                          color: Colors.red.shade600,
                          width: MediaQuery.of(context).size.width / 2,
                          child: tabView(Colors.red, "Lost"),
                        ),
                      ]),
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.map_outlined),
                      onPressed: () async {
                        setState(() {
                          isLoading = true;
                        });
                        await getUserCurrentLocation().then((value) {
                          setState(() {
                            lat = value.latitude;
                            long = value.longitude;
                          });
                        });
                        setState(() {
                          isLoading = false;
                        });
                        navKey.currentState!.pushReplacement(MaterialPageRoute(
                            builder: (context) => MapPosts(
                                  lat: lat,
                                  long: long,
                                  navKey: widget.navKey,
                                )));
                      },
                    ),
                    showSearchBar(context),
                  ],
                ),
                drawer: const NavMenu(),
                bottomNavigationBar: Bottombar(context),
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
                              displayPosts("Found", "", ""),
                              displayPosts("Lost", "", ""),
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
                      filterButton(context),
                    ]),
              )));

  Theme filterButton(BuildContext context) {
    return Theme(
      data: themeData(context, highLightedColor),
      child: SizedBox(
        height: 50,
        width: 150,
        child: FloatingActionButton(
          heroTag: "btn2",
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(50))),
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
                  if (item.name == "Personalitems") {
                    categoryTitle =
                        "${item.name.substring(0, 8)} ${item.name.substring(8)}";
                  } else {
                    categoryTitle = item.name;
                  }
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
                  title: Text("Animals", style: popupMenuStyle(context)),
                ),
              ),
              PopupMenuItem(
                value: CategoryItem.Electronics,
                child: ListTile(
                  leading: const Icon(
                    Icons.phone_outlined,
                    color: Colors.white,
                  ),
                  title: Text("Electronics", style: popupMenuStyle(context)),
                ),
              ),
              PopupMenuItem(
                value: CategoryItem.Personalitems,
                child: ListTile(
                  leading: const Icon(
                    Icons.person_search_outlined,
                    color: Colors.white,
                  ),
                  title: Text("Personal Items", style: popupMenuStyle(context)),
                ),
              ),
            ],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                categoryFlag
                    ? const Icon(Icons.close_outlined, color: Colors.red)
                    : filterIcon,
                Text(categoryTitle)
              ],
            ),
          ),
        ),
      ),
    );
  }

  tabView(Color? color, String title) {
    return Tab(
      child: Center(
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.white, fontSize: 25),
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
          onChanged: (value) {
            searchString = value;
            switchPage();
          },
          onTapOutside: (event) {
            showSearchBar(context);
          },
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
      suffixIcon: IconButton(
        icon: const Icon(
          Icons.close_outlined,
          color: Colors.red,
        ),
        onPressed: () {
          setState(() {
            _controller.clear();
          });
        },
      ),
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

  int numOfPosts = 6;
  DocumentSnapshot? lastDoc;
  FutureBuilder<QuerySnapshot<Object?>> displayPosts(
      String status, String searchValue, String category) {
    return FutureBuilder<QuerySnapshot>(
        future: lastDoc == null
            ? postsRef
                .where('status', isEqualTo: status)
                .limit(numOfPosts)
                .get()
            : postsRef
                .where('status', isEqualTo: status)
                .limit(numOfPosts)
                .startAtDocument(lastDoc!)
                .get(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            if (snapshot.data!.docs.isEmpty) {
              return noPostFoundMsg;
            }
            if (snapshot.data!.docs.length > numOfPosts) {
              setState(() {
                lastDoc ??= snapshot.data!.docs.last;
              });
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
                        postID: post.id,
                      );
                    })
                  ],
                );
              }
            }
            if (searchValue.isEmpty) {
              return ListView.builder(
                controller: controller,
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  var snap = snapshot.data!.docs;
                  lastDoc = snap.last;
                  return PostCards(
                    posts: snap[index],
                    postID: snap[index].id,
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
                        postID: post.id,
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
        element['title'].toString().toLowerCase().contains(searchValue) ||
        element['description'].toString().toLowerCase().contains(searchValue));
  }

  Iterable<QueryDocumentSnapshot<Object?>> searchByCategory(
      AsyncSnapshot<QuerySnapshot<Object?>> snapshot, String category) {
    if (category == 'Personalitems') {
      category = "${category.substring(0, 8)} ${category.substring(8)}";
    }
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
