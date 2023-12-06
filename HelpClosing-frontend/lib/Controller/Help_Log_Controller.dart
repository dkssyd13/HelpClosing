import 'dart:convert';
import 'package:get/get.dart';
import 'package:help_closing_frontend/Controller/Auth_Controller.dart';
import 'package:help_closing_frontend/Controller/User_Controller.dart';
import 'package:help_closing_frontend/ServerUrl.dart';
import 'package:http/http.dart' as http;
import '../Domain/HelpLog.dart';




class HelpLogController extends GetxController {
  var recipientHelpLogs = List<HelpLog>.empty(growable: true).obs;
  var requesterHelpLogs = List<HelpLog>.empty(growable: true).obs;
  static const String baseUrl = ServerUrl.baseUrl;
  var isLoading = true.obs;
  final UserController _userController = Get.find();

  @override
  void onInit() {
    getHelpLogsForRecipient();
    super.onInit();
  }


  void createHelpLog(String requesterEmail, String recipientEmail, String lat, long) async {
    print("Start creating help log... ");
    print("requesterEmail : ${requesterEmail}");
    print("recipientEmail : ${recipientEmail}");
    var jwtToken = await AuthController.to.storage.read(key: 'jwtToken');
    var url = Uri.parse('${ServerUrl.baseUrl}/helpLog/create');
    var body = jsonEncode({
      'requesterEmail': requesterEmail,
      'recipientEmail': recipientEmail,
      'latitude' : lat,
      'longitude' : long
    });
    var response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': "Bearer " + jwtToken!,
      },
      body: body,
    );
    var result = json.decode(response.body);
    print(result);
    print('status : ${result['status']}');
    if (result['status'] == 'OK') {
      print('Help Log created successfully');
    } else {
      print('Error in creating Help Log: ${result['description']}');
    }
  }

  // Future<List<HelpLog>> getHelpLogsForRecipient() async {
  void getHelpLogsForRecipient() async {
    print("Start getting helpLogs for recipient");
    // //받는거
    try {
      isLoading(true);
      var jwtToken = await AuthController.to.storage.read(key: 'jwtToken');
      final response = await http.get(
          Uri.parse('$baseUrl/helpLog/recipient/${_userController.getUserId()}'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': "Bearer " + jwtToken!,
        },
      );
      print(response.statusCode);
      print(response);
      print(response.body);
      if (response.statusCode == 200) {
        var jsonString = response.body;
        var jsonMap = json.decode(jsonString);
        recipientHelpLogs.value=List<HelpLog>.from(jsonMap['value'].map((i) => HelpLog.fromJson(i)));
      }
    } catch (Exception) {
      print(Exception.toString());
    } finally {
      isLoading(false);
    }
  }


  void getHelpLogsForRequester() async {
    print("Start getting helpLogs for requester");
    // //받는거
    try {
      isLoading(true);
      var jwtToken = await AuthController.to.storage.read(key: 'jwtToken');
      final response = await http.get(
        Uri.parse('$baseUrl/helpLog/request/${_userController.getUserId()}'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': "Bearer " + jwtToken!,
        },
      );
      print(response.statusCode);
      print(response);
      print(response.body);
      if (response.statusCode == 200) {
        var jsonString = response.body;
        var jsonMap = json.decode(jsonString);
        requesterHelpLogs.value=List<HelpLog>.from(jsonMap['value'].map((i) => HelpLog.fromJson(i)));
      }
    } catch (Exception) {
      print(Exception.toString());
    } finally {
      isLoading(false);
    }
  }
}

