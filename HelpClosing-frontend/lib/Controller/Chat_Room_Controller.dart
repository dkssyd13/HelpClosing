import '../Domain/User.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ChatRoomController {
  static const String baseUrl = 'http://your_server_url'; // 서버 URL을 입력하세요.

  Future<List<ChatRoom>> getChatRoomList() async {
    final response = await http.get(Uri.parse('$baseUrl/chatRoomList'));

    if (response.statusCode == 200) {
      final List<dynamic> responseBody = json.decode(response.body);
      return responseBody.map((dynamic item) => ChatRoom.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load chat room list');
    }
  }
}

// class ChatRoom {
//   String roomId;
//
//   ChatRoom({required this.roomId});
//
//   factory ChatRoom.fromJson(Map<String, dynamic> json) {
//     return ChatRoom(
//       roomId: json['roomId'],
//     );
//   }
}
