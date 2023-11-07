import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:help_closing_frontend/Domain/ChatRoom.dart';

import '../../Controller/Chat_Room_Controller.dart';

class ChatRoomListPage extends StatelessWidget {
  final ChatRoomController chatRoomController = ChatRoomController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<ChatRoom>>(
        future: chatRoomController.getChatRoomList(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final chatRoom = snapshot.data![index];
                return ListTile(
                  // title: Text('Room ID: ${chatRoom.chatRoomId}'),
                  title: Text('Room ID: ${chatRoom.chatRoomId.}'),
                  subtitle: Text('User List: ${chatRoom.userList.map((user) => user.name).join(', ')}'),
                );
              },
            );
          }
        },
      ),
    );
  }
}