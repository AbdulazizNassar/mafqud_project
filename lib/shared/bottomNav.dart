import 'package:flutter/material.dart';
import 'package:mafqud_project/main.dart';
import 'package:mafqud_project/screens/chat/chat_list.dart';
import 'package:mafqud_project/screens/posts/history.dart';
import 'package:mafqud_project/screens/posts/posts.dart';
import 'package:mafqud_project/shared/constants.dart';

import '../screens/chat/cubit/chat_cubit.dart';

Widget Bottombar(BuildContext context) {
  const border = Border(
    left: BorderSide(width: 3.0, color: Colors.white),
  );
  return BottomAppBar(
    color: Colors.blue[900],
    padding: const EdgeInsets.all(0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width / 3,
          height: 60,
          child: InkWell(
            child: Container(
                color: Colors.blue[900],
                child: ElevatedButton(
                  style: btnStyle,
                  onPressed: () {
                    ChatCubit.get(context).getChatList();
                    navKey.currentState!.push(MaterialPageRoute(
                        builder: (context) => const ChatListScreen()));
                  },
                  child: const Icon(
                    Icons.message_outlined,
                    size: 32,
                    color: Color.fromARGB(255, 228, 228, 228),
                  ),
                )),
          ),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width / 3,
          height: 60,
          child: InkWell(
            child: Container(
                decoration: BoxDecoration(
                  border: border,
                  color: Colors.blue.shade900,
                ),
                child: ElevatedButton(
                  style: btnStyle,
                  onPressed: () {
                    navKey.currentState!.push(
                        MaterialPageRoute(builder: (context) => const Posts()));
                  },
                  child: const Icon(
                    Icons.home_outlined,
                    size: 32,
                    color: Color.fromARGB(255, 228, 228, 228),
                  ),
                )),
          ),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width / 3,
          height: 60,
          child: InkWell(
            child: Container(
                decoration: BoxDecoration(
                  border: border,
                  color: Colors.blue.shade900,
                ),
                child: IconButton(
                  style: btnStyle,
                  onPressed: () {
                    navKey.currentState!.push(MaterialPageRoute(
                        builder: (context) => const History()));
                  },
                  icon: const Icon(
                    Icons.history_outlined,
                    size: 32,
                    color: Color.fromARGB(255, 228, 228, 228),
                  ),
                )),
          ),
        ),
      ],
    ),
  );
}
