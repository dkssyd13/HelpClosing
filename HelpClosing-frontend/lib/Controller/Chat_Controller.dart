import 'dart:convert';
import 'package:get/get.dart';
import 'package:help_closing_frontend/Controller/Auth_Controller.dart';
import 'package:help_closing_frontend/Controller/Chat_Room_Controller.dart';
import 'package:help_closing_frontend/Domain/ChatMessageResponse.dart';
import 'package:help_closing_frontend/ServerUrl.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';

class ChatController extends GetxController {
  late final StompClient client;
  final ChatRoomController chatRoomController = Get.put(ChatRoomController());

  @override
  void onInit() async {
    chatRoomController.startUpdatingMessageList();
    super.onInit();
    var jwtToken = await AuthController.to.storage.read(key: 'jwtToken');
    print(jwtToken);
    client = StompClient(
        config: StompConfig(
          url: ServerUrl.wsURL,
          onConnect: (frame) => onConnect(client, frame),
          beforeConnect: () async{
            print("Waiting for Connect...");
            await Future.delayed(const Duration(milliseconds: 200));
            print("Connceting");
          },
          onWebSocketError: (p0) => print("onWebSocketError : ${p0.toString()}"),
          stompConnectHeaders: {'Authorization' : 'Bearer ${jwtToken!}'},
          webSocketConnectHeaders: {'Authorization' : 'Bearer $jwtToken'},
          onDisconnect: (f) => print("Disconnected")
        ));
    client!.activate();
  }



  onConnect(StompClient stompClient, StompFrame) async {
    print("Starting onConnect()....");
    print("current Chat room ID : ${chatRoomController.currentChatRoomId}");
    var jwtToken = await AuthController.to.storage.read(key: 'jwtToken');
    stompClient?.subscribe(
        destination: 'sub/chat/room/${chatRoomController.currentChatRoomId}',
        headers: {'Authorization' : 'Bearer ' + jwtToken!},
        callback: (frame){
          print("Received msg : ${frame.body}");
          ChatMessageResponse msg = ChatMessageResponse.fromJson(jsonDecode(frame.body!));
        }
    );
    stompClient?.send(
        destination: 'pub/chat/room/${chatRoomController.currentChatRoomId}',
      headers: {'Authorization' : 'Bearer ' + jwtToken!},
    );
  }



  void enterChatRoom(String chatRoomId, String email, String nickName) {
    final message = {
      'chatRoomId': chatRoomId,
      'email': email,
      'nickName': nickName,
    };

    client.send(
        destination: '/pub/chat/enter', body: jsonEncode(message), headers: {});
  }

  void sendMessage(String message, String chatRoomId, String email, String name, String nickName, DateTime time) async {
    var jwtToken = await AuthController.to.storage.read(key: 'jwtToken');
      final messageRequest = {
        'message': message,
        'chatRoomId': int.parse(chatRoomId),
        'email': email,
        'name': name,
        'nickName': nickName,
        'time': time.toIso8601String(),
      };
      print("start sending message ....");
    client.send(
        destination: '/pub/chat/message', body: jsonEncode(messageRequest),
      headers: {'Authorization' : 'Bearer ' + jwtToken!},
    );
  }

  @override
  void onClose() {
    client.deactivate();
    super.onClose();
  }
}