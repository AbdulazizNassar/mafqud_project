import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mafqud_project/models/userModel.dart';
import 'package:mafqud_project/services/notification.dart';
import 'package:mafqud_project/shared/constants.dart';
import '../../../models/messageModel.dart';
import 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit() : super(ChatInitial());

  static ChatCubit get(context) => BlocProvider.of(context);
  List<UserModel>? users;
  UserModel? userItem;

  String? username;

  UserModel? userData;

  getUserData() {
    users = [];
    emit(GetUserLoadingState());
    FirebaseFirestore.instance.collection('users').doc(uId).get().then((value) {
      userData = UserModel.fromJson(value.data()!);
      username = value.data()!['name'];
      print(userData!.name);
      print(username);
      emit(GetUserSuccessState());
    }).catchError((error) {
      print(error);
    });
  }

  void getChatList() {
    users = [];
    emit(AllUsersLoadingState());
    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .collection('myUsers')
        .get()
        .then((value) {
      value.docs.forEach((element) {
        users!.add(UserModel.fromJson(element.data()));
      });
      emit(AllUsersSuccessState());
    }).catchError((error) {
      emit(AllUsersErrorState(error.toString()));
    });
  }

  void getChatItem({required String uidReciever}) {
    emit(AllUsersLoadingState());
    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .collection('myUsers')
        .doc(uidReciever)
        .get()
        .then((value) {
      userItem = UserModel.fromJson(value.data()!);
      print(userItem!.uid);
      print(userItem!.name);

      emit(GetChatItemSuccessState(model: userItem!));
    }).catchError((error) {
      emit(GetChatItemErrorState(error.toString()));
    });
  }

  void sendMessage({
    required String receiverId,
    required Timestamp? dateTime,
    required String senderId,
    required String text,
    required String receivername,
    required String sendername,
    required String receiverUid,
  }) async {
    ChatMessageModel messageModel = ChatMessageModel(
      senderId: senderId,
      receiverId: receiverId,
      dateTime: dateTime,
      text: text,
    );
    DocumentSnapshot snap = await FirebaseFirestore.instance
        .collection("userToken")
        .doc(receiverId)
        .get();
    String token = snap['token'];
    sendPushMessage("You've got a new message ", 'from $sendername', token,
        uidReceiver: receiverId, nameReceiver: receivername);
    FirebaseFirestore.instance
        .collection('users')
        .doc(senderId)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .add(messageModel.toMap())
        .then((value) {
      emit(SendMessageSuccessState());
    }).catchError((error) {
      emit(SendMessageErrorState(error.toString()));
    });

    //set receiver chats

    FirebaseFirestore.instance
        .collection('users')
        .doc(receiverId)
        .collection('chats')
        .doc(senderId)
        .collection('messages')
        .add(messageModel.toMap())
        .then((value) {
      emit(SendMessageSuccessState());
    }).catchError((error) {
      emit(SendMessageErrorState(error.toString()));
    });

    FirebaseFirestore.instance
        .collection('users')
        .doc(senderId)
        .collection('myUsers')
        .doc(receiverUid)
        .set({
      'name': receivername,
      'uid': receiverUid,
    });
    FirebaseFirestore.instance
        .collection('users')
        .doc(receiverId)
        .collection('myUsers')
        .doc(senderId)
        .set({
      'name': sendername,
      'uid': senderId,
    });
  }

  List<ChatMessageModel> messages = [];

  void getMessage({required String receiverId, required String senderUid}) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(senderUid)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .orderBy('dateTime')
        .snapshots()
        .listen((event) {
      messages = [];

      for (var element in event.docs) {
        messages.add(ChatMessageModel.fromJson(element.data()));
      }
      emit(GetMessagesSuccessState());
    });
  }
}
