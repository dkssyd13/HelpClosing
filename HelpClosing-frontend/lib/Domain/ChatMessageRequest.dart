import 'dart:convert';

class ChatMessageRequest {
  String message;
  int chatRoomId;
  String email;
  String name;
  String nickName;
  DateTime time;

  ChatMessageRequest({
    required this.message,
    required this.chatRoomId,
    required this.email,
    required this.name,
    required this.nickName,
    required this.time,
  });

  Map<String, dynamic> toJson() => {
    'message': message,
    'chatRoomId': chatRoomId,
    'email': email,
    'name': name,
    'nickName': nickName,
    'time': time.toIso8601String(),
  };
}