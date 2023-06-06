import 'package:flutter/material.dart';
import 'package:mafqud_project/main.dart';
import 'package:mafqud_project/screens/chat/chat_list.dart';
import 'package:mafqud_project/screens/posts/history.dart';
import 'package:mafqud_project/screens/posts/posts.dart';

import '../screens/chat/cubit/chat_cubit.dart';

Widget Bottombar(BuildContext context) {
  return BottomAppBar(
    color: Colors.blue[900],
    padding: const EdgeInsets.all(2),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        IconButton(
          icon: const Icon(
            Icons.message_outlined,
            size: 32,
            color: Color.fromARGB(255, 228, 228, 228),
          ),
          onPressed: () {
            ChatCubit.get(context).getChatList();

            navKey.currentState!.pushReplacement(MaterialPageRoute(
                builder: (context) => const ChatListScreen()));
          },
        ),
        IconButton(
          icon: const Icon(
            Icons.home_outlined,
            size: 32,
            color: Color.fromARGB(255, 228, 228, 228),
          ),
          onPressed: () {
            navKey.currentState!.pushReplacement(
                MaterialPageRoute(builder: (context) => const Posts()));
          },
        ),
        IconButton(
          icon: const Icon(
            Icons.history,
            size: 32,
            color: Color.fromARGB(255, 228, 228, 228),
          ),
          onPressed: () {
            navKey.currentState!
                .push(MaterialPageRoute(builder: (context) => const History()));
          },
        ),
      ],
    ),
  );
}
