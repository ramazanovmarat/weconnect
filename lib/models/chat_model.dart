import 'package:cloud_firestore/cloud_firestore.dart';

class ChatModel {
  final String userName;
  final String userId;
  final String message;
  final Timestamp timestamp;

  ChatModel ({
      required this.userName,
      required this.userId,
      required this.message,
      required this.timestamp
  });
}