import 'package:flutter/material.dart';
import 'package:mafqud_project/screens/MenuItems/Notifications/constant.dart';
import 'package:mafqud_project/screens/chat/chat_list.dart';
import 'package:mafqud_project/screens/chat/cubit/chat_cubit.dart';
import 'package:mafqud_project/screens/MenuItems/Notifications/notificationList.dart';
import 'package:mafqud_project/screens/MenuItems/support.dart';
import 'package:mafqud_project/services/auth.dart';
import 'package:mafqud_project/shared/AlertBox.dart';
import 'package:mafqud_project/shared/constants.dart';
import 'package:mafqud_project/shared/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mafqud_project/screens/MenuItems/RateUs.dart';
import 'package:mafqud_project/screens/posts/history.dart';
import 'package:mafqud_project/screens/posts/posts.dart';
import '../screens/profile/profile.dart';

CollectionReference _userCollection =
    FirebaseFirestore.instance.collection('users');

class NavMenu extends StatefulWidget {
  const NavMenu({super.key});

  @override
  State<NavMenu> createState() => _NavMenuState();
}

dynamic notificationIcon;

class _NavMenuState extends State<NavMenu> {
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    Query<Map<String, dynamic>> notificationRef = FirebaseFirestore.instance
        .collection("notifications")
        .where("uid", isEqualTo: AuthService().currentUser!.uid);
    notificationRef.get().then((value) {
      value.docs.forEach((element) {
        if (element['status'] == 'new') {
          notificationIcon = Stack(
            children: [const Icon(Icons.notifications_outlined), newIndicator],
          );
        }
      });
    });
  }

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

buildHeader(BuildContext context) => isLoading
    ? Loading()
    : Material(
        color: Colors.blue[900],
        child: InkWell(
          onTap: () {
            //close Nav menu
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const ProfileScreen()));
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
              future: _userCollection
                  .where("uid", isEqualTo: AuthService().currentUser!.uid)
                  .get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Loading();
                }
                if (snapshot.connectionState == ConnectionState.none) {
                  return Loading();
                }
                if (snapshot.connectionState == ConnectionState.done) {
                  var user = snapshot.data!.docs.first;
                  return Column(children: [
                    user['image'] == ''
                        ? const CircleAvatar(
                            radius: 60,
                            child: Image(
                                image: AssetImage('assets/user.png'),
                                height: 70),
                          )
                        : CircleAvatar(
                            radius: 60,
                            backgroundColor: Colors.white,
                            backgroundImage: NetworkImage(user['image']),
                          ),
                    const SizedBox(height: 12),
                    Text(
                      '${user['name']}',
                      style: const TextStyle(fontSize: 28, color: Colors.white),
                    ),
                    Text(
                      '${user['email']}',
                      style: const TextStyle(fontSize: 16, color: Colors.white),
                    ),
                    const Icon(
                      Icons.double_arrow_outlined,
                      color: Colors.white,
                    ),
                  ]);
                }
                return const Text("Something has gone wrong");
              },
            ),
          ),
        ),
      );

// BlocConsumer<ChatCubit, ChatState> newMethod() {
//   return BlocConsumer<ChatCubit, ChatState>(
//       listener: (context, state) {},
//       builder: (context, state) {
//         if (state is GetUserLoadingState) {
//           return Loading();
//         }
//         if (state is GetMessagesSuccessState) {
//           return Column(children: [
//             ChatCubit.get(context).userData!.image == ''
//                 ? const CircleAvatar(
//                     radius: 60,
//                     child:
//                         Image(image: AssetImage('assets/user.png'), height: 70),
//                   )
//                 : CircleAvatar(
//                     radius: 60,
//                     backgroundColor: Colors.white,
//                     backgroundImage:
//                         NetworkImage(ChatCubit.get(context).userData!.image!),
//                   ),
//             const SizedBox(height: 12),
//             Text(
//               '${ChatCubit.get(context).userData!.name}'
//               // "${data['name']}"
//               ,
//               style: const TextStyle(fontSize: 28, color: Colors.white),
//             ),
//             Text(
//               '${ChatCubit.get(context).userData!.email}'
//               // "${data['email']}"
//               ,
//               style: const TextStyle(fontSize: 16, color: Colors.white),
//             ),
//             const Icon(
//               Icons.double_arrow_outlined,
//               color: Colors.white,
//             ),
//           ]);
//         }
//         return const Text("Something went wrong");
//       });
// }

Widget buildMenuItems(BuildContext context) => Container(
      padding: const EdgeInsets.all(0),
      child: Wrap(
        runSpacing: 16, //vertical spacing
        children: <Widget>[
          ListTile(
            leading: const Icon(Icons.home_outlined),
            title: const Text("Home"),
            onTap: () => Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => Posts())),
          ),
          ListTile(
            leading: notificationIcon,
            title: const Text("Notifications"),
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => NotificationList()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.history_outlined),
            title: const Text("History"),
            onTap: () => Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => const History())),
          ),
          ListTile(
            leading: const Icon(Icons.message_outlined),
            title: const Text("Messages"),
            onTap: () {
              ChatCubit.get(context).getChatList();
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const ChatListScreen()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.support_agent_outlined),
            title: const Text("Support"),
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const support()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.star_border_outlined),
            title: const Text("Rate Us"),
            onTap: () {
              Navigator.of(context).push(
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
              uId = '';
              signOutConfirm(context);
            },
          ),
        ],
      ),
    );
