import 'dart:convert';
// import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:http/http.dart' as http;

class ChatService {
  // static const String _uri = 'ws://서버 url';
  static const String _uri = 'wss://echo.websocket.events';
  // final IOWebSocketChannel _channel = IOWebSocketChannel.connect(Uri.parse(_uri));
  final WebSocketChannel _channel = WebSocketChannel.connect(Uri.parse(_uri));


  // void send(String message, int chatRoomId, String email, String name, String nickName, DateTime time) {
  //   final messageRequest = {
  //     'message': message,
  //     'chatRoomId': chatRoomId,
  //     'email': email,
  //     'name': name,
  //     'nickName': nickName,
  //     'time': time.toIso8601String(),
  //   };
  //   _channel.sink.add(json.encode(messageRequest));
  // }


  void send(String message) {
    _channel.sink.add(message);
  }

  Stream<dynamic> get messages => _channel.stream;
}