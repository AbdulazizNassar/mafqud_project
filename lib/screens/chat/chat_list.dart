import 'package:cached_network_image/cached_network_image.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mafqud_project/models/messageModel.dart';
import 'package:mafqud_project/models/userModel.dart';

import '../../shared/NavMenu.dart';
import '../../shared/constants.dart';
import 'chat_details.dart';
import 'chat_details_list.dart';
import 'cubit/chat_cubit.dart';
import 'cubit/chat_state.dart';

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({Key? key}) : super(key: key);

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
                    itemBuilder: (context, index) => buildChatItem(
                      context,
                      ChatCubit.get(context).users![index],
                    ),
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
                  body: const LinearProgressIndicator(),
                ));
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
