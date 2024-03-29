import 'package:cloud_firestore/cloud_firestore.dart';

class ChatMessageModel {
  String? senderId;
  String? receiverId;
  String? text;
  Timestamp? dateTime;

  ChatMessageModel({
    this.senderId,
    this.receiverId,
    this.text,
    this.dateTime,
  });

  ChatMessageModel.fromJson(Map<String, dynamic> json) {
    senderId = json['senderId'];
    receiverId = json['receiverId'];
    text = json['text'];
    dateTime = json['dateTime'];
  }

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'receiverId': receiverId,
      'text': text,
      'dateTime': dateTime,
    };
  }
}
