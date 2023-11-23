import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:help_closing_frontend/Controller/User_Controller.dart';
import 'package:help_closing_frontend/Domain/UserMailandName.dart';

import '../../Controller/Chat_Room_Controller.dart';

class ChatRoomListPage extends StatelessWidget {
  final ChatRoomController _chatRoomController = Get.put(ChatRoomController());

  ChatRoomListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
            () => ListView.builder(
          itemCount: _chatRoomController.chatRoomList.length,
          itemBuilder: (context, index) {
            final chatRoom = _chatRoomController.chatRoomList[index]; // -> chatRoom id, userList
            return Card(
              color: Colors.white,
              elevation: 0,
              child: ListTile(
                onTap: (){},
                leading: getPhoto(chatRoom.userList), //
                title: Text(nameOfOther(chatRoom.userList)),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget getPhoto(List<UserMailandName> chatRoomUserList){
    for(UserMailandName otherUser in chatRoomUserList) {
      if(otherUser.email != UserController.to.getUserEmail() && otherUser.nickName != UserController.to.getUserNickname()) {
        if(Uri.parse(otherUser.image).isAbsolute){
          return CircleAvatar(
            backgroundImage: NetworkImage(otherUser.image),
          );
        } else {
          return const CircleAvatar(
            child: Icon(Icons.account_circle),
          );
        }
      }
    }
    return const CircleAvatar(
      child: Icon(Icons.account_circle),
    );
  }


  String nameOfOther(List<UserMailandName> chatRoomUserList) {
    for(UserMailandName otherUser in chatRoomUserList) {
      if(otherUser.email != UserController.to.getUserEmail() && otherUser.nickName != UserController.to.getUserNickname()) {
        return otherUser.name;
      }
    }

    return "None";
  }
}



class ChatRoom extends StatelessWidget {
  const ChatRoom({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
