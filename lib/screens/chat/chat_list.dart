import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:mafqud_project/models/messageModel.dart';
import 'package:mafqud_project/models/userModel.dart';
import 'package:mafqud_project/services/auth.dart';
import 'package:mafqud_project/screens/MenuItems/Notifications/constant.dart';
import 'package:mafqud_project/shared/loading.dart';
import '../../shared/DateTime.dart';
import '../../shared/NavMenu.dart';
import '../../shared/constants.dart';
import 'chat_details_list.dart';
import 'cubit/chat_cubit.dart';
import 'cubit/chat_state.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

bool isLoading = false;
deleteChat(UserModel model) async {
  String currentUser = AuthService().currentUser!.uid;
  //delete messages
  CollectionReference<Map<String, dynamic>> messagesRef = FirebaseFirestore
      .instance
      .collection('users')
      .doc(currentUser)
      .collection("chats")
      .doc(model.uid)
      .collection('messages');
  var snapshots = await messagesRef.get();
  for (var doc in snapshots.docs) {
    await doc.reference.delete();
  }
//delete chat with user
  DocumentReference<Map<String, dynamic>> myUsersRef = FirebaseFirestore
      .instance
      .collection('users')
      .doc(currentUser)
      .collection('myUsers')
      .doc(model.uid);
  await myUsersRef.delete();
}

class _ChatListScreenState extends State<ChatListScreen> {
  @override
  Widget build(BuildContext context) => BlocConsumer<ChatCubit, ChatState>(
        listener: (context, state) {},
        builder: (context, state) {
          return ConditionalBuilder(
              condition: ChatCubit.get(context).users!.isNotEmpty &&
                  ChatCubit.get(context).messages.isNotEmpty,
              builder: (context) => Scaffold(
                    appBar: AppBar(
                      title: const Text('Messages'),
                      backgroundColor: Colors.blue[900],
                      centerTitle: true,
                    ),
                    drawer: const NavMenu(),
                    body: isLoading
                        ? Loading()
                        : ListView.separated(
                            physics: const BouncingScrollPhysics(),
                            itemBuilder: (context, index) {
                              //get most recent message
                              var message =
                                  ChatCubit.get(context).messages.last;
                              return Slidable(
                                key: UniqueKey(),
                                endActionPane: ActionPane(
                                    motion: const ScrollMotion(),
                                    dismissible: DismissiblePane(
                                      onDismissed: () {
                                        setState(() {
                                          isLoading = true;
                                        });
                                        deleteChat(ChatCubit.get(context)
                                            .users![index]);
                                        setState(() {
                                          isLoading = false;
                                        });
                                      },
                                    ),
                                    children: [
                                      SlidableAction(
                                        onPressed: (BuildContext context) {
                                          setState(() {
                                            isLoading = true;
                                          });
                                          setState(() {
                                            deleteChat(ChatCubit.get(context)
                                                .users![index]);
                                          });
                                          setState(() {
                                            isLoading = false;
                                          });
                                        },
                                        backgroundColor:
                                            const Color(0xFFFE4A49),
                                        foregroundColor: Colors.white,
                                        icon: Icons.delete,
                                        label: 'Delete',
                                      ),
                                    ]),
                                child: buildChatItem(
                                    context,
                                    ChatCubit.get(context).users![index],
                                    message),
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
  Widget buildChatItem(context, UserModel model, ChatMessageModel messages) =>
      InkWell(
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
          child: ListTile(
            leading: const CircleAvatar(
                radius: 25,
                child: Image(
                  image: AssetImage('assets/user.png'),
                  height: 30,
                )),
            title: Text(
              '${model.name}',
              style: const TextStyle(
                height: 1.2,
              ),
            ),
            //show last message
            subtitle: uId == messages.receiverId
                ? Text(
                    '${model.name}: ${messages.text}',
                  )
                : Text("You: ${messages.text}"),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                deleteIcon,
                Text(readTimestamp(messages.dateTime)),
              ],
            ),
            enabled: true,
          ));
}

class NewWidget extends StatelessWidget {
  const NewWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
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
                const Row(),
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
    );
  }
}
