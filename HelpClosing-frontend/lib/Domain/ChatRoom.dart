import 'package:help_closing_frontend/Domain/UserMailandName.dart';

class ChatRoom {
  final String chatRoomId;
  final List<UserMailandName> userList;

  ChatRoom({required this.chatRoomId, required this.userList});

  factory ChatRoom.fromJson(Map<String, dynamic> json) {
    var userListFromJson = json['users'] as List;
    List<UserMailandName> userList = userListFromJson.map((i) => UserMailandName.fromJson(i)).toList();

    return ChatRoom(
      chatRoomId: json['chatRoomId'].toString(),
      userList: userList,
    );
  }
}