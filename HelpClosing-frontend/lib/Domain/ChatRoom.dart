import 'package:help_closing_frontend/Domain/UserMailandName.dart';

class ChatRoom {
  final String chatRoomId;
  final List<UserMailandName> userList;

  ChatRoom({required this.chatRoomId, required this.userList});

  factory ChatRoom.fromJson(Map<String, dynamic> json) {
    return ChatRoom(
      chatRoomId: json['chatRoomId'],
      userList: (json['userList'] as List).map((i) => UserMailandName.fromJson(i)).toList(),
    );
  }
}