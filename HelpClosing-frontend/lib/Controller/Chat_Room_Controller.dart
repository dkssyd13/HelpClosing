import 'package:get/get.dart';
import 'package:help_closing_frontend/Domain/ChatRoom.dart';

import 'dart:convert';

class ChatRoomController extends GetxController {
  var chatRoomList = List<ChatRoom>.empty(growable: true).obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    fetchChatRoomList();
    super.onInit();
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
          "image": "https://example.com/user1.jpg"
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
          "image": "https://example.com/user1.jpg"
        }
      ]
    }
  ]
}
''';
    var jsonMap = json.decode(jsonString);
    chatRoomList.value =
    List<ChatRoom>.from(jsonMap['data'].map((i) => ChatRoom.fromJson(i)));
  }
}
