// ignore: file_names
import 'package:flutter/material.dart';
import 'package:mafqud_project/MainScreen.dart';
import 'package:mafqud_project/screens/homepage/Home.dart';
import 'package:mafqud_project/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

User? user = AuthService().currentUser;
final CollectionReference _userCollection =
    FirebaseFirestore.instance.collection('users');

class NavMenu extends StatelessWidget {
  const NavMenu({super.key});

  @override
  Widget build(BuildContext context) => Drawer(
        child: SingleChildScrollView(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                buildHeader(context),
                buildMenuItems(context),
              ]),
        ),
      );

  Widget buildHeader(BuildContext context) => Material(
        color: Colors.blue,
        child: InkWell(
          onTap: () {
            //close Nav menu
            Navigator.pop(context);

            // Navigator.of(context).push(MaterialPageRoute(
            //   builder: (context) =>
            //   ));
          },
          child: Container(
            color: Colors.blue,
            padding: EdgeInsets.only(
              top: 24 + MediaQuery.of(context).padding.top,
              bottom: 24,
            ),
            child: FutureBuilder(
                future:
                    _userCollection.where("uid", isEqualTo: user!.uid).get(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Column(children: [
                      const FlutterLogo(
                        size: 80,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        // ignore: unnecessary_string_interpolations
                        "${snapshot.data!.docs[0].get("name")!}",
                        style:
                            const TextStyle(fontSize: 28, color: Colors.white),
                      ),
                      Text(
                        "${user!.email}",
                        style:
                            const TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ]);
                  }
                  return Text("loading");
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
              leading: const Icon(Icons.history_outlined),
              title: const Text("History"),
              onTap: () {
                // Navigator.pop(context);
                // Navigator.of(context).pushNamed(MaterialPageRoute(
                //   builder: (context) => const //Page
                // ));
              },
            ),
            ListTile(
              leading: const Icon(Icons.message_outlined),
              title: const Text("Messages"),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.support_agent_outlined),
              title: const Text("Support"),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.star_border_outlined),
              title: const Text("Rate Us"),
              onTap: () {},
            ),
            const Divider(color: Colors.black54),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text("Log out"),
              onTap: () {
                signOutConfirm(context);
              },
            ),
          ],
        ),
      );
}

signOutConfirm(context) {
  Alert(
    context: context,
    title: "Do you want to sign out ? ",
    image: Image.asset("assets/logout.jpg"),
    style: const AlertStyle(
      titleStyle: TextStyle(
        color: Colors.red,
        fontWeight: FontWeight.bold,
      ),
      descStyle: TextStyle(
        color: Colors.red,
        fontWeight: FontWeight.bold,
      ),
    ),
    buttons: [
      DialogButton(
          child: const Text("Cancel"), onPressed: () => Navigator.pop(context)),
      DialogButton(
          child: const Text("Sign out"),
          onPressed: () async {
            await AuthService().signOut();
            Navigator.pop(context);
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: ((context) => const MainScreen())));
          }),
    ],
  ).show();
}
