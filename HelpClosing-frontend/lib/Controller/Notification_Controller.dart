import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:help_closing_frontend/Controller/Auth_Controller.dart';
import 'package:help_closing_frontend/Controller/Chat_Controller.dart';
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
      List<dynamic> invitations = jsonResponse['value']['invitationList'];
      _notifications.value = invitations.map((item) => new Invitation.fromJson(Map<String, dynamic>.from(item))).toList();
    } else {
      throw Exception('Failed to load invitation list');
    }

    for (var o in _notifications.value) {
      print(o.toString());
    }
  }


  void acceptInvitation(String senderEmail, String recipientEmail, int chatRoomId) async {
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
      Position _currentPosition = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      _helpLogController.createHelpLog(senderEmail, recipientEmail,_currentPosition.latitude.toString(), _currentPosition.longitude.toString());
      ChatController chatController = Get.put(ChatController());
      chatController.enterChatRoom(0.toString(), UserController.to.getUserEmail()!,UserController.to.getUserNickname()!);
      chatController.onClose();




    } else {
      throw Exception('Failed to accept invitation');
    }
  }

}