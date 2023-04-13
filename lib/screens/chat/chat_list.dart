import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:mafqud_project/models/messageModel.dart';
import 'package:mafqud_project/models/userModel.dart';

import '../../shared/NavMenu.dart';
import '../../shared/constants.dart';
import 'chat_details.dart';
import 'chat_details_list.dart';
import 'cubit/chat_cubit.dart';
import 'cubit/chat_state.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

deleteChat({required String receiverId, required String senderUid}) async {
  await FirebaseFirestore.instance
      .collection('users')
      .doc(senderUid)
      .collection('chats')
      .doc(receiverId)
      .delete();
  await FirebaseFirestore.instance
      .collection('users')
      .doc(senderUid)
      .collection('MyUsers')
      .doc(receiverId)
      .delete();
}

class _ChatListScreenState extends State<ChatListScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChatCubit, ChatState>(
      listener: (context, state) {},
      builder: (context, state) {
        return ConditionalBuilder(
            condition: ChatCubit.get(context).users!.isNotEmpty,
            builder: (context) => Scaffold(
                  appBar: AppBar(
                    title: const Text('Messages'),
                    backgroundColor: Colors.blue[900],
                    centerTitle: true,
                  ),
                  drawer: const NavMenu(),
                  body: ListView.separated(
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      return Slidable(
                        key: UniqueKey(),
                        endActionPane: ActionPane(
                            motion: const ScrollMotion(),
                            dismissible: DismissiblePane(onDismissed: () async {
                              setState(() {
                                deleteChat(
                                    receiverId: ChatCubit.get(context)
                                        .users![index]
                                        .uid!,
                                    senderUid: uId!);
                              });
                            }),
                            children: [
                              SlidableAction(
                                onPressed: (BuildContext context) {
                                  setState(() {
                                    deleteChat(
                                        receiverId: ChatCubit.get(context)
                                            .users![index]
                                            .uid!,
                                        senderUid: uId!);
                                  });
                                },
                                backgroundColor: const Color(0xFFFE4A49),
                                foregroundColor: Colors.white,
                                icon: Icons.delete,
                                label: 'Delete',
                              ),
                            ]),
                        child: buildChatItem(
                          context,
                          ChatCubit.get(context).users![index],
                        ),
                      );
                    },
                    separatorBuilder: (context, index) => Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 0,
                      ),
                      child: Container(
                        height: 0,
                      ),
                    ),
                    itemCount: ChatCubit.get(context).users!.length,
                  ),
                ),
            fallback: (context) => Scaffold(
                appBar: AppBar(
                  title: const Text('Messages'),
                  backgroundColor: Colors.blue[900],
                  centerTitle: true,
                ),
                drawer: const NavMenu(),
                body: const Center(
                  child: Text(
                    "No messages found",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                )));
      },
    );
  }

  Widget buildChatItem(context, UserModel model) => InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => ChatDetailsList(
                        senderUid: uId,
                        receiverUid: model.uid,
                        model: model,
                      )));
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10),
          child: Row(
            children: [
              const CircleAvatar(
                radius: 25,
                child: Image(image: AssetImage('assets/user.png'), height: 30),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          '${model.name}',
                          style: const TextStyle(
                            height: 1.2,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      'Today',
                      style: Theme.of(context).textTheme.caption!.copyWith(
                            height: 1.2,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
}
