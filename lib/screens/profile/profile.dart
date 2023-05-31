import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mafqud_project/screens/MenuItems/support.dart';
import '../../shared/NavMenu.dart';
import 'edit_profile.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool? light = true;
  String? name;
  String? myEmail;
  String? myPassword;
  String? myPhoneNum;
  int? ID;
  String? myImage;
  String? uid;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: const NavMenu(),
      appBar: AppBar(
          centerTitle: true,
          title: const Text(
            'Profile',
            style: TextStyle(
                fontSize: 25, color: Colors.white, fontWeight: FontWeight.bold),
          ),
          backgroundColor:
              Colors.blue.shade900 //const Color.fromRGBO(59, 92, 222, 1.0) ,
          ),
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.center,
          child: FutureBuilder(
            future: _fetch(),
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return const LinearProgressIndicator();
              }
              return Container(
                padding: const EdgeInsets.all(20),
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // profile image
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(
                              width: 15,
                            ),
                            Stack(alignment: Alignment.bottomRight, children: [
                              myImage! == ''
                                  ? const CircleAvatar(
                                      radius: 60,
                                      child: Image(
                                          image: AssetImage('assets/user.png'),
                                          height: 70),
                                    )
                                  : CircleAvatar(
                                      radius: 60,
                                      backgroundColor: Colors.white,
                                      backgroundImage: NetworkImage(myImage!),
                                    ),
                              CircleAvatar(
                                  radius: 20,
                                  backgroundColor:
                                      const Color.fromRGBO(59, 92, 222, 1.0),
                                  child: IconButton(
                                    icon: const Icon(
                                      Icons.edit,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                    onPressed: () {
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (_) => EditProfileScreen(
                                                    name: name,
                                                    email: myEmail,
                                                    phone: myPhoneNum,
                                                    uid: uid,
                                                    image: myImage,
                                                    ID: ID,
                                                  )));
                                    },
                                  )),
                            ]),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        "$name",
                        style: const TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 5,
                      ),

                      Container(
                        padding: const EdgeInsets.all(10),
                        child: Center(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.local_phone_outlined,
                                color: Colors.black,
                                size: 50,
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              Text(
                                "$myPhoneNum",
                                style: const TextStyle(fontSize: 25),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.mail_outline_outlined,
                            color: Colors.black,
                            size: 50,
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Text(
                            "$myEmail",
                            style: const TextStyle(fontSize: 20),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.support_agent_outlined,
                            color: Colors.black,
                            size: 50,
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          TextButton(
                            style: TextButton.styleFrom(
                              textStyle: const TextStyle(
                                  fontSize: 20, color: Colors.black),
                            ),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => const support()));
                            },
                            child: const Text(
                              'Contact Support',
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                                color: Colors.black,
                              ),
                            ),
                          )
                        ],
                      ),
                      // Container(
                      //   padding: const EdgeInsets.all(30),
                      //   child: Row(
                      //     children: [
                      //       const Text(
                      //         "Notifications",
                      //         style: TextStyle(
                      //             fontSize: 25, fontWeight: FontWeight.bold),
                      //       ),
                      //       const SizedBox(
                      //         width: 20,
                      //       ),
                      //       SizedBox(
                      //         width: 80,
                      //         height: 70,
                      //         child: FittedBox(
                      //           fit: BoxFit.fill,
                      //           child: Switch(
                      //             // This bool value toggles the switch.
                      //             value: light!,

                      //             onChanged: (bool value) {
                      //               // This is called when the user toggles the switch.
                      //               setState(() {
                      //                 light = value;
                      //               });
                      //             },
                      //           ),
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  _fetch() async {
    final firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(firebaseUser.uid)
          .get()
          .then((ds) {
        myEmail = ds.get('email') as String;
        uid = ds.get('uid') as String;
        myImage = ds.get('image') as String;
        name = ds.get('name') as String;
        myPhoneNum = ds.get('phoneNum') as String;
        ID = ds.get('ID');
      }).catchError((e) {
        if (kDebugMode) {
          print(e);
        }
      });
    }
  }
}
