import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mafqud_project/models/userModel.dart';
import 'package:mafqud_project/services/auth.dart';

import '../../models/messageModel.dart';
import 'cubit/chat_cubit.dart';
import 'cubit/chat_state.dart';

class ChatDetailsScreen extends StatelessWidget {
  final userData;
  final String? senderUid;
  final String? receiverUid;
  final String? senderName;
  final String? receiverName;
  final UserModel? model;

  ChatDetailsScreen({
    this.userData,
    this.receiverUid,
    this.senderUid,
    this.model,
    this.senderName,
    this.receiverName,
    Key? key,
  }) : super(key: key);

  var textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (BuildContext context) {
      ChatCubit.get(context)
          .getMessage(receiverId: receiverUid!, senderUid: senderUid!);

      return BlocConsumer<ChatCubit, ChatState>(
        listener: (context, state) {
          if (state is SendMessageErrorState) {}
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: Row(
                children: [
                  const CircleAvatar(
                    radius: 25,
                    child:
                        Image(image: AssetImage('assets/user.png'), height: 30),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            '${userData!['name']}',
                            style: const TextStyle(height: 1.2, fontSize: 16),
                          ),
                        ],
                      ),
                      Text(
                        'Active',
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                              height: 1.2,
                            ),
                      ),
                    ],
                  ),
                ],
              ),
              titleSpacing: 0,
              elevation: 1,
            ),
            body: ConditionalBuilder(
              condition: ChatCubit.get(context).messages.isNotEmpty,
              builder: (context) => Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.separated(
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            var messages =
                                ChatCubit.get(context).messages[index];

                            if (senderUid == messages.senderId) {
                              return buildSenderMessage(messages);
                            }

                            return buildReceiverMessage(messages);
                          },
                          separatorBuilder: (context, index) => const SizedBox(
                                height: 10,
                              ),
                          itemCount: ChatCubit.get(context).messages.length),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      child: Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 15,
                              ),
                              child: TextFormField(
                                controller: textController,
                                decoration: const InputDecoration(
                                  hintText: 'Type your message here ...',
                                  border: InputBorder.none,
                                ),
                                keyboardType: TextInputType.text,
                              ),
                            ),
                          ),
                          Container(
                            height: 50,
                            color: Colors.deepPurple,
                            child: MaterialButton(
                              onPressed: () {
                                String? sendername;
                                if (AuthService().currentUser!.displayName ==
                                    null) {
                                  sendername = ChatCubit.get(context).username!;
                                } else {
                                  sendername =
                                      AuthService().currentUser!.displayName;
                                }
                                if (textController.text.isNotEmpty) {
                                  ChatCubit.get(context).sendMessage(
                                    receiverId: receiverUid!,
                                    dateTime:
                                        Timestamp.fromDate(DateTime.now()),
                                    text: textController.text,
                                    senderId: senderUid!,
                                    receivername: userData!['name'],
                                    receiverUid: receiverUid!,
                                    sendername: sendername as String,
                                  );
                                }

                                textController.clear();
                              },
                              minWidth: 1,
                              child: const Icon(
                                Icons.send,
                                size: 18,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              fallback: (context) => Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.separated(
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            var messages =
                                ChatCubit.get(context).messages[index];

                            if (senderUid == messages.senderId) {
                              return buildSenderMessage(messages);
                            }

                            return buildReceiverMessage(messages);
                          },
                          separatorBuilder: (context, index) => const SizedBox(
                                height: 10,
                              ),
                          itemCount: ChatCubit.get(context).messages.length),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      child: Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 15,
                              ),
                              child: TextFormField(
                                controller: textController,
                                decoration: const InputDecoration(
                                  hintText: 'Type your message here ...',
                                  border: InputBorder.none,
                                ),
                                keyboardType: TextInputType.text,
                              ),
                            ),
                          ),
                          Container(
                            height: 50,
                            color: Colors.deepPurple,
                            child: MaterialButton(
                              onPressed: () async {
                                String? sendername;
                                if (AuthService().currentUser!.displayName ==
                                    null) {
                                  sendername = ChatCubit.get(context).username!;
                                } else {
                                  sendername =
                                      AuthService().currentUser!.displayName;
                                }
                                ChatCubit.get(context).sendMessage(
                                  receiverId: receiverUid!,
                                  dateTime: Timestamp.fromDate(DateTime.now()),
                                  text: textController.text,
                                  senderId: senderUid!,
                                  receivername: userData!['name'],
                                  receiverUid: receiverUid!,
                                  sendername: sendername as String,
                                );
                                textController.clear();
                              },
                              minWidth: 1,
                              child: const Icon(
                                Icons.send,
                                size: 18,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    });
  }

  Widget buildSenderMessage(ChatMessageModel model) => Align(
        alignment: AlignmentDirectional.centerEnd,
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadiusDirectional.only(
              bottomStart: Radius.circular(10),
              bottomEnd: Radius.circular(10),
              topStart: Radius.circular(10),
            ),
          ),
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          child: Text(
            model.text!,
            style: const TextStyle(color: Colors.white, fontSize: 22),
          ),
        ),
      );

  Widget buildReceiverMessage(ChatMessageModel model) => Align(
        alignment: AlignmentDirectional.centerStart,
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadiusDirectional.only(
              bottomEnd: Radius.circular(10),
              bottomStart: Radius.circular(10),
              topEnd: Radius.circular(10),
            ),
          ),
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          child: Text(
            model.text!,
            style: const TextStyle(color: Colors.white, fontSize: 22),
          ),
        ),
      );
}
