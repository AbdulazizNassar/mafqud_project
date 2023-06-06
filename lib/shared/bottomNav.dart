import 'package:flutter/material.dart';
import 'package:mafqud_project/main.dart';
import 'package:mafqud_project/screens/chat/chat_list.dart';
import 'package:mafqud_project/screens/posts/history.dart';
import 'package:mafqud_project/screens/posts/posts.dart';
import 'package:mafqud_project/shared/constants.dart';

import '../screens/chat/cubit/chat_cubit.dart';

Widget Bottombar(BuildContext context) {
  return BottomAppBar(
    color: Colors.blue[900],
    padding: const EdgeInsets.all(2),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        InkWell(
          child: Container(
          color: Colors.blue[900],
          width: 130,
          height: 60,
          child: ElevatedButton(
            style: btnStyle,
            onPressed: (){
              ChatCubit.get(context).getChatList();
                            navKey.currentState!
                  .push(MaterialPageRoute(builder: (context) => const ChatListScreen()));
            },
            child: Icon(
              Icons.message_outlined,
              size: 32,
              color: Color.fromARGB(255, 228, 228, 228),
              
            ),
          )
          
        ),
        ),InkWell(
          child: Container(
          color: Colors.blue[900],
          width: 130,
          height: 60,
          child: ElevatedButton(
            style: btnStyle,
            onPressed: (){
                            navKey.currentState!
                  .push(MaterialPageRoute(builder: (context) => const Posts()));
            },
            child: Icon(
              Icons.home_outlined,
              size: 32,
              color: Color.fromARGB(255, 228, 228, 228),
              
            ),
          )
          
        ),
        ),
        InkWell(
          child: Container(
          color: Colors.blue[900],
          width: 130,
          height: 60,
          child: ElevatedButton(
            style: btnStyle,
            onPressed: (){
                            navKey.currentState!
                  .push(MaterialPageRoute(builder: (context) => const History()));
            },
            child: Icon(
              Icons.history_outlined,
              size: 32,
              color: Color.fromARGB(255, 228, 228, 228),
              
            ),
          )
          
        ),
        ), 
      ],
    ),
  );
}
