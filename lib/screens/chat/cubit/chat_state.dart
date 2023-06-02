import 'package:flutter/material.dart';
import 'package:mafqud_project/models/userModel.dart';

import '../../../models/messageModel.dart';



@immutable
abstract class ChatState {}

class ChatInitial extends ChatState {}



class AllUsersLoadingState extends ChatState {}

class AllUsersSuccessState extends ChatState {}

class AllUsersErrorState extends ChatState {
  final String error;

 AllUsersErrorState(this.error);
}

class GetUserLoadingState extends ChatState {}

class GetUserSuccessState extends ChatState {}

class GetUserErrorState extends ChatState {
  final String error;

  GetUserErrorState(this.error);
}

class SendMessageSuccessState extends ChatState {}

class SendMessageErrorState extends ChatState {
  late final String error;

  SendMessageErrorState(this.error);
}

class GetMessagesSuccessState extends ChatState {
 List <ChatMessageModel> ?  messageModel ;
  GetMessagesSuccessState({this.messageModel});
}


class GetChatItemSuccessState extends ChatState {
  UserModel model ;
  GetChatItemSuccessState({required this.model});
}

class GetChatItemErrorState extends ChatState {
  late final String error;

  GetChatItemErrorState(this.error);
}