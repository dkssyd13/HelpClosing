import 'package:help_closing_frontend/Domain/ChatRoom.dart';

import '../Domain/User.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ChatRoomController {
  //static const String baseUrl = 'http://your_server_url'; // 서버 URL을 입력하세요.

  Future<List<ChatRoom>> getChatRoomList() async {
    //final response = await http.get(Uri.parse('$baseUrl/chatRoomList'));

    // if (response.statusCode == 200) {
    //   final List<dynamic> responseBody = json.decode(response.body)['data'];
    //   return responseBody.map((dynamic item) => ChatRoom.fromJson(item)).toList();
    // } else {
    //   throw Exception('Failed to load chat room list');
    // }
    // 예제 JSON 응답
    const String response = '''
    {
      "resultCode": "OK",
      "description": "매칭룸목록(roomid)",
      "data": [
        {
          "chatRoomId": "room1",
          "userList": [
            {
              "email": "user1@example.com",
              "name": "User1",
              "nickName": "U1",
              "image": "image_url_1"
            },
            {
              "email": "user2@example.com",
              "name": "User2",
              "nickName": "U2",
              "image": "image_url_2"
            }
          ]
        },
        {
          "chatRoomId": "room2",
          "userList": [
            {
              "email": "user3@example.com",
              "name": "User3",
              "nickName": "U3",
              "image": "image_url_3"
            },
            {
              "email": "user4@example.com",
              "name": "User4",
              "nickName": "U4",
              "image": "image_url_4"
            }
          ]
        }
      ]
    }
    ''';

    final List<dynamic> responseBody = json.decode(response)['data'];
    return responseBody.map((dynamic item) => ChatRoom.fromJson(item)).toList();
  }
}

