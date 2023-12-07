import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:help_closing_frontend/Controller/Auth_Controller.dart';
import 'package:help_closing_frontend/Controller/Chat_Controller.dart';
import 'package:help_closing_frontend/Controller/Help_Controller.dart';
import 'package:help_closing_frontend/Controller/Help_Log_Controller.dart';
import 'package:help_closing_frontend/Controller/User_Controller.dart';
import 'package:help_closing_frontend/ServerUrl.dart';
import 'package:http/http.dart' as http;
import 'package:help_closing_frontend/Domain/InvitationList.dart';

class NotificationController extends GetxController{
  RxList<Invitation> _notifications = RxList<Invitation>.empty(growable: true);
  final HelpLogController _helpLogController = Get.put(HelpLogController());
  RxList<Invitation> get notifications => _notifications;

  @override
  void onInit() {
    super.onInit();
    fetchInvitationList();
  }

  fetchInvitationList() async {
    print("Start Getting Notifications...");
    var jwtToken = await AuthController.to.storage.read(key: 'jwtToken');
    print("jwtToken = ${jwtToken}");
    final response = await http.get(
      Uri.parse('${ServerUrl.baseUrl}/matching/invitedList?email=${AuthController.to.userController.getUserEmail()}'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': "Bearer " + jwtToken!,
      },
    );


    if (response.statusCode == 200) {
      print("Fetch Notifications OK");
      Map<String, dynamic> jsonResponse = json.decode(response.body);
      print(response.body);
      List<dynamic> invitations = jsonResponse['value'];
      _notifications.value = invitations.map((item) => Invitation.fromJson(Map<String, dynamic>.from(item))).toList();
      for (int i =0 ; i<_notifications.length; i++){
        _notifications.value[i].inviteName=await getUserProfile(_notifications.value[i].inviteEmail);
        _notifications.refresh();
      }
    } else {
      throw Exception('Failed to load invitation list');
    }
  }

  Future<String> getUserProfile(String email) async{
    print("Invitation start getting user profile");
    var jwtToken = await AuthController.to.storage.read(key: 'jwtToken');
    final response = await http.get(Uri.parse("${ServerUrl.baseUrl}/user/get/?email=$email"),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': "Bearer " + jwtToken!,
      },
    );

    print(response.body);

    if (response.statusCode == 200) {
      // If the server returns a 200 OK response, then parse the JSON.
      print(response.body);
      Map<String, dynamic> jsonResponse = json.decode(response.body);
      print(jsonResponse['name'].runtimeType);
      return jsonResponse['name'];
    } else {
      // If the server did not return a 200 OK response, then throw an exception.
      throw Exception('Failed to load user profile');
    }
  }

  void acceptInvitation(String senderEmail, String recipientEmail, int chatRoomId,Invitation invitation) async {
    print("Start accpeInvitation");
    var jwtToken = await AuthController.to.storage.read(key: 'jwtToken');
    final response = await http.post(
      Uri.parse('${ServerUrl.baseUrl}/matching/accept'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': "Bearer " + jwtToken!,
      },
      body: jsonEncode({
        'senderEmail': senderEmail,
        'recipientEmail': recipientEmail,
        'chatRoomId': chatRoomId,
      }),
    );
    print("response status code : ${response.statusCode}");
    print("senderEmail = ${senderEmail}");
    print("recipientEmail = ${recipientEmail}");
    print("chatRoomID = ${chatRoomId}");
    print("Accept response : ${response.toString()}");
    print("response body : ${response.body}");
    if (response.statusCode == 200) {
      print("Invitation accepted successfully");
      _helpLogController.createHelpLog(senderEmail, recipientEmail,invitation.latitude.toString(), invitation.longitude.toString());
      ChatController chatController = Get.put(ChatController());
      chatController.enterChatRoom(0.toString(), UserController.to.getUserEmail()!,UserController.to.getUserNickname()!);
      chatController.onClose();
    } else {
      throw Exception('Failed to accept invitation');
    }
  }

  void rejectMatching(String senderEmail, String recipientEmail) async {
    var jwtToken = await AuthController.to.storage.read(key: 'jwtToken');

    final response = await http.delete(
      Uri.parse('${ServerUrl.baseUrl}/matching/reject'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': "Bearer " + jwtToken!,
      },
      body: jsonEncode(<String, dynamic>{
        'senderEmail': senderEmail,
        'recipientEmail': recipientEmail,
        'chatRoomId': 0,
      }),
    );

    if (response.statusCode == 200) {
      Get.snackbar("도움 요청 거절 완료", "${senderEmail}님의 도움 요청을 거절 완료",backgroundColor: Colors.green);
      fetchInvitationList();
    } else {
      Get.snackbar("도움 요청 거절 실패", "${senderEmail}님의 도움 요청을 거절 실패",backgroundColor: Colors.red);
      throw Exception('Failed to reject matching');
    }
  }

}