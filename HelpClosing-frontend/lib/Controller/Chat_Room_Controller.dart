import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:help_closing_frontend/ChatService/ChatService.dart';
import 'package:help_closing_frontend/Domain/ChatMessageResponse.dart';
import 'package:help_closing_frontend/Domain/ChatRoom.dart';
import 'dart:convert';
import 'package:help_closing_frontend/Domain/UserMailandName.dart';
import 'package:help_closing_frontend/Pages/Chat/ChatRoomPage.dart';
import 'package:http/http.dart' as http;



class ChatRoomController extends GetxController {
  var chatRoomList = List<ChatRoom>.empty(growable: true).obs;
  var isLoading = true.obs;
  late Rx<UserMailandName?> currentPartner;
  late Rx<String> currentChatRoomId;
  Timer? _timer;
  late RxList<ChatMessageResponse> messages;

  ChatService chatService = ChatService();

  @override
  void onInit() {
    currentPartner = Rx<UserMailandName?>(null); // 초기화 추가
    currentChatRoomId = Rx<String>(''); // 초기화 추가
    fetchChatRoomList();

    //직접
    // startUpdatingMessageList();
    messages=RxList<ChatMessageResponse>([]);
    super.onInit();
  }

  @override
  void onClose() {
    // _timer?.cancel(); // 타이머를 종료합니다.
    super.onClose();
  }

  void startUpdatingMessageList() {
    _timer = Timer.periodic(Duration(seconds: 5), (timer) { // 5초마다 fetchMessageList를 호출합니다.
      fetchMessageList();
    });
  }

  void sendMessage(String message){
    // messages.add(message);
  }


  void fetchMessageList() async {
    // try {
    //   final response = await http.get(
    //       Uri.parse('/chat/chatList?chatRoomId=${currentChatRoomId.value}'));
    //   if (response.statusCode == 200) {
    //     final jsonData = json.decode(response.body);
    //     List<ChatMessageResponse> chatList = [];
    //     for (var item in jsonData['data']) {
    //       chatList.add(ChatMessageResponse.fromJson(item));
    //     }
    //     messages.value = chatList;
    //   } else {
    //     throw Exception('Failed to fetch chat list');
    //   }
    // } catch (e) {
    //   throw Exception('Error: $e');
    // }


    const response = '''
{
  "status": "200",
  "message": "Success",
  "data": [
    {
      "message": "Hello, world!",
      "chatDate": "2023-11-26T15:36:21",
      "chatRoomId": 1,
      "name": "User 2",
      "nickName": "user2",
      "email": "user2@example.com",
      "image": "https://cdn-icons-png.flaticon.com/256/190/190648.png"
    },
    {
      "message": "Hi, there!",
      "chatDate": "2023-11-26T15:37:21",
      "chatRoomId": 1,
      "name": "User 1-현재 사용자",
      "nickName": "user1",
      "email": "123",
      "image": "null"
    }
  ]
}
    ''';

    final jsonData = json.decode(response);
    List<ChatMessageResponse> chatList = [];
    for (var item in jsonData['data']) {
      chatList.add(ChatMessageResponse.fromJson(item));
    }
    messages.value = chatList;
  }


  void fetchChatRoomList() async {
    //   try {
    //     isLoading(true);
    //     var response = await http.get(Uri.parse('http://yourserver.com/chatRoomList'));
    //     if (response.statusCode == 200) {
    //       var jsonString = response.body;
    //       var jsonMap = json.decode(jsonString);
    //       chatRoomList.value = List<ChatRoom>.from(jsonMap['data'].map((i) => ChatRoom.fromJson(i)));
    //     }
    //   } catch (Exception) {
    //     print('Need to login for seeing chat room list');
    //   } finally {
    //     isLoading(false);
    //   }
    // }
    var jsonString = '''{
  "data": [
    {
      "chatRoomId": "room1",
      "userList": [
        {
          "email": "123",
          "name": "User 1-현재 사용자",
          "nickName": "user1",
          "image": "null"
        },
        {
          "email": "user2@example.com",
          "name": "User 2",
          "nickName": "user2",
          "image": "https://cdn-icons-png.flaticon.com/256/190/190648.png"
        }
      ]
    },
    {
      "chatRoomId": "room2",
      "userList": [
        {
          "email": "user3@example.com",
          "name": "User 3",
          "nickName": "user3",
          "image": "https://cdn-icons-png.flaticon.com/512/219/219969.png"
        },
        {
          "email": "123",
          "name": "User 1-현재 사용자",
          "nickName": "user1",
          "image": "null"
        }
      ]
    }
  ]
}
''';
    var jsonMap = json.decode(jsonString);
    chatRoomList.value =List<ChatRoom>.from(jsonMap['data'].map((i) => ChatRoom.fromJson(i)));
    print("abc ${chatRoomList.value}");
  }

  void goToChat(UserMailandName user, String chatRoomID){
    currentPartner.value = user;
    currentChatRoomId.value = chatRoomID;
    Get.to(const ChatRoomPage());
  }

  Widget getPartnerImage() {
    if (Uri
        .parse(currentPartner.value!.image)
        .isAbsolute) {
      return CircleAvatar(
        backgroundImage: NetworkImage(currentPartner.value!.image),
      );
    } else {
      return const CircleAvatar(
        child: Icon(Icons.account_circle),
      );
    }
  }


}
