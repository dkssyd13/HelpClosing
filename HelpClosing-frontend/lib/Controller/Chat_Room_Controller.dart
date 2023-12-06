import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:help_closing_frontend/ChatService/ChatService.dart';
import 'package:help_closing_frontend/Controller/Auth_Controller.dart';
import 'package:help_closing_frontend/Controller/User_Controller.dart';
import 'package:help_closing_frontend/Domain/ChatMessageResponse.dart';
import 'package:help_closing_frontend/Domain/ChatRoom.dart';
import 'dart:convert';
import 'package:help_closing_frontend/Domain/UserMailandName.dart';
import 'package:help_closing_frontend/Pages/Chat/ChatRoomPage.dart';
import 'package:help_closing_frontend/ServerUrl.dart';
import 'package:http/http.dart' as http;



class ChatRoomController extends GetxController {
  var chatRoomList = List<ChatRoom>.empty(growable: true).obs;
  var isLoading = true.obs;
  late Rx<UserMailandName?> currentPartner;
  late Rx<String> currentChatRoomId;
  Timer? _timer;
  Timer get timer => _timer!;
  late RxList<ChatMessageResponse> messages;
  final _baseUrl=ServerUrl.baseUrl;

  ChatService chatService = ChatService();

  @override
  void onInit() {
    currentPartner = Rx<UserMailandName?>(null); // 초기화 추가
    currentChatRoomId = Rx<String>(''); // 초기화 추가
    fetchChatRoomList();

    messages=RxList<ChatMessageResponse>([]);



    super.onInit();
  }

  @override
  void onClose() {
    // _timer?.cancel(); // 타이머를 종료합니다.
    super.onClose();
  }

  void startUpdatingMessageList() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) { // 5초마다 fetchMessageList를 호출합니다.
      fetchMessageList();
    });
  }
  void stopUpdatingMessageList(){
    _timer?.cancel();
  }


  void fetchMessageList() async {
    print("Start Fetching Message List");
    var jwtToken = await AuthController.to.storage.read(key: 'jwtToken');
    try{
      int.parse(currentChatRoomId.value);
    }catch(e){
      stopUpdatingMessageList();
    }
    try {
      final response = await http.get(
          Uri.parse('$_baseUrl/chat/chatList?chatRoomId=${currentChatRoomId.value}'),
          // Uri.parse('$_baseUrl/chat/chatList?chatRoomId=9'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': "Bearer " + jwtToken!,
        }
      );
      print("status code = ${response.statusCode}");
      print("fetch Message List response body : ${response.body}");
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        List<ChatMessageResponse> chatList = [];
        for (var item in jsonData['value']) {
          chatList.add(ChatMessageResponse.fromJson(item));
        }
        messages.value = chatList;
      } else {
        throw Exception('Failed to fetch chat list');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  void setDone(String chatRoomId)async{
    var jwtToken=await AuthController.to.storage.read(key: 'jwtToken');
    print("Starting setDone chatRoomId = $chatRoomId");
    final response = await http.put(
      Uri.parse('${ServerUrl.baseUrl}/chatRoom/$chatRoomId/done'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': "Bearer " + jwtToken!,
      },
    );
    print(response.statusCode);
    if (response.statusCode == 200) {
      Get.snackbar("도움 완료 성공", "$chatRoomId번 채팅이 완료",backgroundColor: Colors.green);
      fetchChatRoomList();
    } else {
      Get.snackbar("도움 완료 실패", "$chatRoomId번 채팅이 완료 실패",backgroundColor: Colors.red);
    }
  }

  void deleteChatRoom(String chatRoomId) async {
    String? userEmail = AuthController.to.userController.getUserEmail();
    var jwtToken=await AuthController.to.storage.read(key: 'jwtToken');
    final response = await http.delete(
      Uri.parse('${ServerUrl.baseUrl}/chatRoom/exit?userEmail=$userEmail&chatRoomId=$chatRoomId'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': "Bearer " + jwtToken!,
      },
    );

    if (response.statusCode == 200) {
      Get.snackbar("채팅방 나가기 완료", "채팅방에서 나가셨습니다",backgroundColor: Colors.green);
      fetchChatRoomList();
    } else {
      Get.snackbar("채팅방 나가기 실패", "오류가 발생했습니다");
    }
  }

  Future<bool> getChatRoomStatus(String chatRoomId) async {
    var jwtToken=await AuthController.to.storage.read(key: 'jwtToken');
    print("start getting chat room status");
    final response = await http.get(
      Uri.parse('${ServerUrl.baseUrl}/chatRoom/$chatRoomId/status'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': "Bearer " + jwtToken!,
      },
    );
    print("status code : ${response.statusCode}");
    print("body : ${response.body}");
    print("type : ${response.body.runtimeType}");

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to get chat room status.');
    }
  }

  void fetchChatRoomList() async {
    var jwtToken=await AuthController.to.storage.read(key: 'jwtToken');
    print("Start fetchChatRoomList");
    if(jwtToken != null){
      try {
        isLoading(true);
        var response = await http.get(Uri.parse('$_baseUrl/chatRoom/chatRoomList?email=${UserController.to.getUserEmail()}'),
          // JWT를 포함한 헤더
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': "Bearer " + jwtToken,  // 여기에 실제 토큰 값이 들어가야 합니다.
          },
        );
        print("status code : ${response.statusCode}");
        if (response.statusCode == 200) {
          print("response body : ${response.body}");
          var jsonString = response.body;
          var jsonMap = json.decode(jsonString);
          chatRoomList.value = List<ChatRoom>.from(jsonMap['value'].map((i) => ChatRoom.fromJson(i)));
        }
      } catch (Exception) {
        print("fetch Chatroom error");
        print(Exception.toString());
      } finally {
        isLoading(false);
      }
    }


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
