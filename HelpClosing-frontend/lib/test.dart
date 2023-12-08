import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:web_socket_channel/web_socket_channel.dart';


class ChatController extends GetxController {
  RxList<String> chatMessages = List<String>.empty().obs;
  late WebSocketChannel channel;

  @override
  void onInit() {
    super.onInit();
    channel = WebSocketChannel.connect(Uri.parse('ws://your-websocket-url')); // 웹소켓 서버 주소를 입력하세요
    channel.stream.listen((message) {
      chatMessages.add(message);
    });
    fetchChatMessages();
  }

  void fetchChatMessages() async {
    // var response = await http.get(Uri.parse('http://your-api-url/chat/chatList')); // 채팅 목록을 가져오는 API URL을 입력하세요
    // if (response.statusCode == 200) {
    //   var messages = jsonDecode(response.body) as List;
    //   chatMessages.addAll("ad");
    // }
  }

  void sendMessage(String message) {
    channel.sink.add(message);
  }

  @override
  void onClose() {
    channel.sink.close();
    super.onClose();
  }
}


class test extends StatefulWidget {
  const test({super.key});

  @override
  State<test> createState() => _testState();
}

class _testState extends State<test> {
  final TextEditingController _controller = TextEditingController();
  final _channel = WebSocketChannel.connect(
    Uri.parse('ws://localhost:8080/ws-stomp'),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("test"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Form(
              child: TextFormField(
                controller: _controller,
                decoration: const InputDecoration(labelText: 'Send a message'),
              ),
            ),
            const SizedBox(height: 24),
            StreamBuilder(
              stream: _channel.stream,
              builder: (context, snapshot) {
                return Text(snapshot.hasData ? '${snapshot.data}' : '');
              },
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _sendMessage,
        tooltip: 'Send message',
        child: const Icon(Icons.send),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      _channel.sink.add(_controller.text);
      print("message success");
    }
  }

  @override
  void dispose() {
    _channel.sink.close();
    _controller.dispose();
    super.dispose();
  }
}


