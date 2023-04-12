import 'package:flutter/material.dart';



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

class GetMessagesSuccessState extends ChatState {}
