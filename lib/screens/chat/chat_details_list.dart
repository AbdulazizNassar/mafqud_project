import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mafqud_project/models/userModel.dart';
import 'package:mafqud_project/services/auth.dart';

import '../../models/messageModel.dart';
import '../../shared/DateTime.dart';
import 'cubit/chat_cubit.dart';
import 'cubit/chat_state.dart';

class ChatDetailsList extends StatefulWidget {
  final String? senderUid;
  final String? receiverUid;
  final UserModel? model;
  const ChatDetailsList({
    this.receiverUid,
    this.senderUid,
    this.model,
    Key? key,
  }) : super(key: key);

  @override
  State<ChatDetailsList> createState() => _ChatDetailsListState();
}

class _ChatDetailsListState extends State<ChatDetailsList> {
  var textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (BuildContext context) {
      ChatCubit.get(context).getMessage(
          receiverId: widget.receiverUid!, senderUid: widget.senderUid!);
      return BlocConsumer<ChatCubit, ChatState>(
        listener: (context, state) {
          if (state is SendMessageErrorState) {
            print(state.error);
          }
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
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              '${widget.model!.name}',
                              style: const TextStyle(height: 1.2, fontSize: 16),
                            ),
                          ],
                        ),
                        Text(
                          'Active',
                          style:
                              Theme.of(context).textTheme.bodySmall!.copyWith(
                                    height: 1.2,
                                  ),
                        ),
                      ],
                    ),
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
                            if (widget.senderUid == messages.senderId) {
                              return buildSenderMessage(messages);
                            } else {
                              return buildReceiverMessage(messages);
                            }
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
                                  receiverId: widget.receiverUid!,
                                  dateTime: Timestamp.fromDate(DateTime.now()),
                                  text: textController.text,
                                  senderId: widget.senderUid!,
                                  receivername: widget.model!.name!,
                                  receiverUid: widget.receiverUid!,
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

                            if (widget.senderUid == messages.senderId) {
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
                                print("object");

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
        child: Column(
          children: [
            Text(
              model.text!,
              style: const TextStyle(color: Colors.white, fontSize: 22),
            ),
            Text(readTimestamp(model.dateTime),
                style: const TextStyle(color: Colors.white, fontSize: 12))
          ],
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
