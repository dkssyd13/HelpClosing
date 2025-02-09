import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:help_closing_frontend/ChatService/ChatService.dart';
import 'package:help_closing_frontend/Controller/Auth_Controller.dart';
import 'package:help_closing_frontend/Controller/Chat_Controller.dart';
import 'package:help_closing_frontend/Controller/Chat_Room_Controller.dart';
import 'package:help_closing_frontend/Controller/User_Controller.dart';
import 'package:help_closing_frontend/Domain/ChatMessageResponse.dart';

class ChatRoomPage extends StatefulWidget {
  const ChatRoomPage({super.key});

  @override
  State<ChatRoomPage> createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends State<ChatRoomPage> {
  final _textController = TextEditingController();
  final _chatService = ChatService();
  final List<String> _messages=[];
  final ChatRoomController _chatRoomController = Get.put(ChatRoomController());
  final UserController userController = Get.find();
  final ChatController _chatController = Get.put(ChatController());
  final scrollController = ScrollController();
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      endDrawer: Drawer(
        width: MediaQuery
            .of(context)
            .size
            .width * 0.5,
        child: ListView(
          children: [
            //DrawerHeader(child: Text("메뉴",))//style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.blue),))
            UserAccountsDrawerHeader(
              accountName: Text(_chatRoomController.currentPartner.value!.name,
                style: const TextStyle(fontWeight: FontWeight.bold,),),
              accountEmail: Text(
                _chatRoomController.currentPartner.value!.email,
                style: const TextStyle(fontWeight: FontWeight.bold,),),
              currentAccountPicture: _chatRoomController.getPartnerImage(),
            ),
            ListTile(
              leading: const Icon(
                Icons.check,
              ),
              title: const Text('도움 요청 완료'),
              onTap: () {
                _chatRoomController.setDone(
                    _chatRoomController.currentChatRoomId.value);
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.delete_forever,
              ),
              title: const Text('채팅방에서 나가기'),
              onTap: () {
                _chatRoomController.deleteChatRoom(
                    _chatRoomController.currentChatRoomId.value);
                Get.back();
                Get.back();
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        leadingWidth: 100,
        leading: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(onPressed: () {
              _chatRoomController.stopUpdatingMessageList();
              _chatRoomController.stopUpdatingMessageList();
              Get.back();
            }, icon: const Icon(Icons.arrow_back, size: 24,)),
            const SizedBox(width: 10,),
            _chatRoomController.getPartnerImage(),
          ],
        ),
        title: Text(_chatRoomController.currentPartner.value!.name,),
      ),
      body: Container(
        height: MediaQuery
            .of(context)
            .size
            .height,
        width: MediaQuery
            .of(context)
            .size
            .width,
        child: Stack(
          children: [
            Obx(() =>
                Column(
                  children: [
                    Obx(() {
                      print(
                          "Current Chat Messages length : ${_chatRoomController
                              .messages.length}");
                      return Expanded(
                          child: ListView.builder(
                              shrinkWrap: true,
                              controller: scrollController,
                              reverse: true,
                              itemCount: _chatRoomController.messages.length,
                              itemBuilder: (context, index) {
                                final message = _chatRoomController
                                    .messages[index];
                                return _buildMessage(message);
                              }

                          )
                      );
                    }),
                    Align(
                        alignment: Alignment.bottomCenter,
                        child: _chatRoomController.roomStatus.value ? Container(
                          width: MediaQuery
                              .of(context)
                              .size
                              .width,
                          color: Colors.green,
                          child: const Text(
                            "이미 완료된 채팅방입니다",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white
                            ),
                          ),
                        )
                            : Row(
                          children: [
                            Expanded(
                              child: Card(
                                margin: const EdgeInsets.all(8),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                child: TextField(
                                  controller: _textController,
                                  decoration: const InputDecoration(
                                    labelText: 'Send a message',
                                    contentPadding: EdgeInsets.all(5),
                                  ),
                                  onSubmitted: (message) {
                                    _sendMessage();
                                    _textController.clear();
                                  },
                                ),
                              ),
                            ),
                            CircleAvatar(
                              radius: 25,
                              backgroundColor: Colors.blue[100],
                              child: IconButton(
                                  onPressed: () {
                                    _sendMessage();
                                    _textController.clear();
                                  },
                                  icon: const Icon(Icons.send)),
                            )
                          ],
                        )
                    )
                  ],

                )),
          ],
        ),
      ),
    );
  }


  Widget _buildMessage(ChatMessageResponse message) {
    final flag = message.email == userController.getUserEmail();
    // return ListTile(
    //     title: Text(message.message),
    //     subtitle: Text(message.chatDate.toString()),
    //     leading: CircleAvatar(
    //       backgroundImage: NetworkImage(message.image),
    //     ));

    DateTime parsedDate = DateTime.parse(message.chatDate.toString());

    print(message.chatDate);
    return Row(
      mainAxisAlignment: flag ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Container(
            decoration: BoxDecoration(
              color: flag ? Colors.blue[200] : Colors.grey[200],
              borderRadius: BorderRadius.circular(8.0),
            ),
            margin: const EdgeInsets.all(10.0),
            padding: const EdgeInsets.all(10.0),
            width: 145,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(message.message),
                Text(
                    "${parsedDate.year}-${parsedDate.month.toString().padLeft(2, '0')}-${parsedDate.day.toString().padLeft(2, '0')} ${parsedDate.hour.toString().padLeft(2, '0')}:${parsedDate.minute.toString().padLeft(2, '0')}:${parsedDate.second.toString().padLeft(2, '0')}",
                    style: const TextStyle(
                      fontSize: 10.0,
                      color: Colors.black54,))
              ],
            )
        ),
      ],
    );
  }

  void _sendMessage() {
    if (_textController.text.isNotEmpty) {
      scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      _chatService.send(_textController.text);
      var message = _textController.text.trim();
      var chatRoomId = _chatRoomController.currentChatRoomId.value;
      var email = UserController.to.getUserEmail();
      var name = UserController.to.getUserName();
      var nickName = UserController.to.getUserNickname();
      var time = DateTime.now();
      _chatController.sendMessage(message, chatRoomId, email!, name!, nickName!, time);
    }
  }

  @override
  void dispose() {
    // _channel.sink.close();
    // _controller.dispose();
    _chatRoomController.stopUpdatingMessageList();
    super.dispose();
  }
}
