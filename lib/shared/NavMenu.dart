import 'package:flutter/material.dart';
import 'package:mafqud_project/screens/MenuItems/Notifications/notificationList.dart';
import 'package:mafqud_project/screens/homepage/Home.dart';
import 'package:mafqud_project/screens/MenuItems/support.dart';
import 'package:mafqud_project/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mafqud_project/shared/AlertBox.dart';
import 'package:mafqud_project/shared/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mafqud_project/screens/MenuItems/RateUs.dart';
import 'package:mafqud_project/screens/posts/history.dart';

// current logged in user
User? userAuth = AuthService().currentUser;

CollectionReference _userCollection =
    FirebaseFirestore.instance.collection('users');

//return current user doc
final userDoc = _userCollection
    .doc(userAuth!.uid)
    .get()
    .then((value) => value)
    .then((value) => value.data());

class NavMenu extends StatefulWidget {
  const NavMenu({super.key});

  @override
  State<NavMenu> createState() => _NavMenuState();
}

class _NavMenuState extends State<NavMenu> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Loading()
        : Drawer(
            child: SingleChildScrollView(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    buildHeader(context),
                    buildMenuItems(context),
                  ]),
            ),
          );
  }
}

Widget buildHeader(BuildContext context) => Material(
      color: Colors.blue[900],
      child: InkWell(
        onTap: () {
          //close Nav menu
          Navigator.pop(context);
          // Navigator.of(context).push(MaterialPageRoute(
          //   builder: (context) =>
          //   ));
        },
        child: Container(
          color: Colors.blue[900],
          padding: EdgeInsets.only(
            top: 24 + MediaQuery.of(context).padding.top,
            bottom: 24,
          ),
          child: FutureBuilder(
              future: userDoc,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done &&
                    snapshot.hasData) {
                  final data = Map<String, dynamic>.from(
                      snapshot.data as Map<String, dynamic>);
                  return Column(children: [
                    const FlutterLogo(
                      size: 80,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      // ignore: unnecessary_string_interpolations
                      "${data['name']}",
                      style: const TextStyle(fontSize: 28, color: Colors.white),
                    ),
                    Text(
                      "${data['email']}",
                      style: const TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ]);
                }
                return Loading();
              }),
        ),
      ),
    );
Widget buildMenuItems(BuildContext context) => Container(
      padding: const EdgeInsets.all(0),
      child: Wrap(
        runSpacing: 16, //vertical spacing
        children: <Widget>[
          ListTile(
            leading: const Icon(Icons.home_outlined),
            title: const Text("Home"),
            onTap: () => Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const Home())),
          ),
          ListTile(
            leading: const Icon(Icons.notifications_active_outlined),
            title: const Text("Notifications"),
            onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => NotificationList())),
          ),
          ListTile(
            leading: const Icon(Icons.history_outlined),
            title: const Text("History"),
            onTap: () => Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const History())),
          ),
          ListTile(
            leading: const Icon(Icons.message_outlined),
            title: const Text("Messages"),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.support_agent_outlined),
            title: const Text("Support"),
            onTap: () {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const support()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.star_border_outlined),
            title: const Text("Rate Us"),
            onTap: () {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const Rating()));
            },
          ),
          const Divider(color: Colors.black54),
          ListTile(
            leading: const Icon(
              Icons.logout,
              color: Colors.red,
            ),
            title: const Text("Log out"),
            onTap: () {
              signOutConfirm(context);
            },
          ),
        ],
      ),
    );
