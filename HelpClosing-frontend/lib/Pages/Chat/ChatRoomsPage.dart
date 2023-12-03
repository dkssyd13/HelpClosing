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
    _chatRoomController.fetchChatRoomList();
    return Scaffold(
      body: Obx(
            () =>
            ListView.builder(
              itemCount: _chatRoomController.chatRoomList.length,
              itemBuilder: (context, index) {
                final chatRoom = _chatRoomController
                    .chatRoomList[index]; // -> chatRoom id, userList
                final UserMailandName? otherUser = getOtherUser(
                    chatRoom.userList);
                return Card(
                  color: Colors.white,
                  elevation: 50,
                  child: ListTile(
                    onTap: () {
                      _chatRoomController.goToChat(otherUser, chatRoom.chatRoomId);
                    },
                    leading: getPhoto(otherUser!), //
                    title: Text(nameOfOther(otherUser)!),
                    subtitle: Text("닉네임 : ${nickNameOfOther(otherUser)}"),
                  ),
                );
              },
            ),
      ),
    );
  }

  UserMailandName? getOtherUser(List<UserMailandName> userList) {
    for (var user in userList) {
      if (user.email != UserController.to.getUserEmail() &&
          user.nickName != UserController.to.getUserNickname()) {
        return user;
      }
    }
  }

  Widget getPhoto(UserMailandName user) {
    if (Uri
        .parse(user.image)
        .isAbsolute) {
      return CircleAvatar(
        backgroundImage: NetworkImage(user.image),
      );
    } else {
      return const CircleAvatar(
        child: Icon(Icons.account_circle),
      );
    }
  }


  String? nameOfOther(UserMailandName user) {
    if (user.email != UserController.to.getUserEmail() &&
        user.nickName != UserController.to.getUserNickname()) {
      return user.name;
    }
  }

  String? nickNameOfOther(UserMailandName user) {
    if (user.email != UserController.to.getUserEmail() &&
        user.nickName != UserController.to.getUserNickname()) {
      return user.nickName;
    }
  }

}
