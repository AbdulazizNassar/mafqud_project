import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mafqud_project/models/userModel.dart';
import 'package:mafqud_project/services/auth.dart';
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

  getUserData() async {
    users = [];
    emit(GetUserLoadingState());
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .get()
        .then((value) {
      userData = UserModel.fromJson(value.data()!);
      username = value.data()!['name'];
      emit(GetUserSuccessState());
    }).catchError((error) {
      print(error);
    });
  }

  void getChatList() async {
    users = [];
    emit(AllUsersLoadingState());
    await FirebaseFirestore.instance
        .collection('users')
        .doc(AuthService().currentUser!.uid)
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

  void getChatItem({required String uidReciever}) async {
    emit(AllUsersLoadingState());
    await FirebaseFirestore.instance
        .collection('users')
        .doc(AuthService().currentUser!.uid)
        .collection('myUsers')
        .doc(uidReciever)
        .get()
        .then((value) {
      userItem = UserModel.fromJson(value.data()!);

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
    DocumentSnapshot<Map<String, dynamic>> snap = await FirebaseFirestore
        .instance
        .collection("userToken")
        .doc(receiverUid)
        .get();
    sendPushMessage(
        "You've got a new message ", 'from $sendername', snap['token'],
        uidReceiver: receiverId, nameReceiver: receivername);
    await FirebaseFirestore.instance
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

    await FirebaseFirestore.instance
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

    await FirebaseFirestore.instance
        .collection('users')
        .doc(senderId)
        .collection('myUsers')
        .doc(receiverUid)
        .set({
      'name': receivername,
      'uid': receiverUid,
    });
    await FirebaseFirestore.instance
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

  void getMessage(
      {required String receiverId, required String senderUid}) async {
    await FirebaseFirestore.instance
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
      emit(GetMessagesSuccessState(messageModel: messages));
    });
  }
}
