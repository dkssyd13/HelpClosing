import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'package:get/get.dart';
import 'package:help_closing_frontend/Controller/User_Controller.dart';
import 'package:help_closing_frontend/Domain/UserMailandName.dart';

import '../../Controller/Chat_Room_Controller.dart';

class ChatRoomListPage extends StatefulWidget {

  ChatRoomListPage({super.key});

  @override
  State<ChatRoomListPage> createState() => _ChatRoomListPageState();
}

class _ChatRoomListPageState extends State<ChatRoomListPage> {
  final ChatRoomController _chatRoomController = Get.put(ChatRoomController());
  Timer? _timer;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(mounted);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) async{ // 5초마다 fetchMessageList를 호출합니다.
      if(mounted){
        setState(() {});
      }else{_timer!.cancel();}
    });
  }



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
                return Slidable(
                  key: Key(chatRoom.chatRoomId),
                  startActionPane: ActionPane(
                    motion: const StretchMotion(),
                    children: [
                      SlidableAction(
                        backgroundColor: Colors.green,
                        icon: Icons.check,
                        label: "Done",
                        onPressed: (BuildContext context){
                          _chatRoomController.setDone(chatRoom.chatRoomId);
                        },
                      )
                    ],
                  ),
                  endActionPane: ActionPane(
                    motion: const StretchMotion(),
                    children: [
                      SlidableAction(
                        backgroundColor: Colors.red,
                        icon: Icons.delete_forever,
                        label: "Delete",
                        onPressed: (BuildContext context){
                          _chatRoomController.deleteChatRoom(chatRoom.chatRoomId);
                        },
                      )
                    ],
                  ),
                  child: Card(
                    color: Colors.white,
                    elevation: 50,
                    child: ListTile(
                      onTap: () {
                        _chatRoomController.goToChat(otherUser, chatRoom.chatRoomId);
                      },
                      leading: getPhoto(otherUser!), //
                      title: Text(nameOfOther(otherUser)!),
                      subtitle: Text("닉네임 : ${nickNameOfOther(otherUser)}"),
                      iconColor: Colors.green,
                      trailing: FutureBuilder<bool>(
                        future: _chatRoomController.getChatRoomStatus(chatRoom.chatRoomId),
                        builder: (BuildContext context, AsyncSnapshot<bool> snapshot){
                          if (snapshot.connectionState == ConnectionState.done || snapshot.connectionState==ConnectionState.waiting) {
                            // return const CircularProgressIndicator();
                            return (snapshot.data??false) ? const Icon(Icons.check) : const Icon(Icons.directions_run);
                          } else {
                              return const Icon(Icons.error,color: Colors.red,);
                          }
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
      ),
    );
  }

  UserMailandName? getOtherUser(List<UserMailandName> userList) {
    for (var user in userList) {
      if (user.email != UserController.to.getUserEmail()) {
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
    if (user.email != UserController.to.getUserEmail()) {
      return user.name;
    }
  }

  String? nickNameOfOther(UserMailandName user) {
    if (user.email != UserController.to.getUserEmail()) {
      return user.nickName;
    }
  }
}
