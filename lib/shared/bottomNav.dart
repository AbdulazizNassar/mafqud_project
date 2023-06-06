
import 'package:flutter/material.dart';
import 'package:mafqud_project/screens/chat/chat_list.dart';
import 'package:mafqud_project/screens/posts/history.dart';
import 'package:mafqud_project/screens/posts/posts.dart';


class bottomNav extends StatefulWidget {
  const bottomNav({super.key});

  @override
  State<bottomNav> createState() => _bottomNavState();
}

class _bottomNavState extends State<bottomNav> {
  @override

    Widget build(BuildContext context) {
    return Scaffold(
     );
  }
}

Widget Bottombar(BuildContext context){
  return BottomAppBar(
    color: Colors.blue[900],
    padding: EdgeInsets.all(2),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,

      children: [
        IconButton(
          icon:Icon(Icons.message_outlined, size: 32,color: Color.fromARGB(255, 228, 228, 228),),
          onPressed: (){
            Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const ChatListScreen()));
          },
          ),
          IconButton(
          icon:Icon(Icons.home_outlined,size: 32,color: Color.fromARGB(255, 228, 228, 228),),
          onPressed: (){
            Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const Posts()));
          },
          ),
          IconButton(
          icon:Icon(Icons.history,size: 32,color: Color.fromARGB(255, 228, 228, 228),),
          onPressed: (){
            Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const History()));
          },
          ),
      ],
    ),
  );
}






