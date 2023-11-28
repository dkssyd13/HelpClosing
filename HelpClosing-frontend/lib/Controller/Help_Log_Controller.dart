import 'dart:convert';
import 'package:get/get.dart';
import 'package:help_closing_frontend/Controller/User_Controller.dart';
import 'package:help_closing_frontend/ServerUrl.dart';
import 'package:http/http.dart' as http;
import '../Domain/HelpLog.dart';




class HelpLogController extends GetxController {
  var recipientHelpLogs = List<HelpLog>.empty(growable: true).obs;
  static const String baseUrl = ServerUrl.baseUrl;
  var isLoading = true.obs;
  final UserController _userController = Get.find();

  @override
  void onInit() {
    getHelpLogsForRecipient();
    super.onInit();
  }

  // Future<List<HelpLog>> getHelpLogsForRecipient() async {
  void getHelpLogsForRecipient() async {
    // //받는거
    // try {
    //   isLoading(true);
    //   final response = await http.get(Uri.parse('$baseUrl/helpLog/recipient/${_userController.getUserId()}'));
    //   if (response.statusCode == 200) {
    //     var jsonString = response.body;
    //     var jsonMap = json.decode(jsonString);
    //     recipientHelpLogs.value=List<HelpLog>.from(jsonMap['data'].map((i) => HelpLog.fromJson(i)));
    //   }
    // } catch (Exception) {
    //   print('Need to login for seeing chat room list');
    // } finally {
    //   isLoading(false);
    // }


    // var userId = AuthController.to.userController.getUserId();
    // final response = await http.get(Uri.parse('$baseUrl/helpLog/recipient/$userId'));
    //
    // if (response.statusCode == 200) {
    //   // If server returns an OK response, parse the JSON
    //   final List<dynamic> data = json.decode(response.body)['data'];
    //   List<HelpLog> helpLogs = data.map((json) => HelpLog.fromJson(json)).toList();
    //   return helpLogs;
    // } else {
    //   // If the server did not return a 200 OK response,
    //   // throw an exception.
    //   throw Exception('Failed to load help logs');
    // }

    var jsonString = '''{
    "data": [
  {
    "id": 1,
    "time": "2023-11-19T00:24:51Z",
    "requester": {
      "id": "123",
      "name": "홍길동",
      "email": "hong@example.com",
      "nickname": "길동",
      "profile": "http://example.com/profile.jpg",
      "location": {
        "description": "서울",
        "latitude": 37.5665,
        "longitude": 126.9780
      },
      "address": "서울 중구"
    },
    "recipient": {
      "id": "456",
      "name": "김철수",
      "email": "kim@example.com",
      "nickname": "철수",
      "profile": "http://example.com/profile2.jpg",
      "location": {
        "description": "부산",
        "latitude": 35.1796,
        "longitude": 129.0756
      },
      "address": "부산 중구"
    },
    "pledgeRequest": {
      "id": 1,
      "name": "기부 요청 1"
    },
    "pledgeRecipient": {
      "id": 2,
      "name": "기부 수령 1"
    },
    "location": {
      "description": "기부 위치 1",
      "latitude": 37.5665,
      "longitude": 126.9780
    }
  },
  {
    "id": 2,
    "time": "2023-11-20T00:24:51Z",
    "requester": {
      "id": "789",
      "name": "이영희",
      "email": "lee@example.com",
      "nickname": "영희",
      "profile": "http://example.com/profile3.jpg",
      "location": {
        "description": "대전",
        "latitude": 36.3504,
        "longitude": 127.3845
      },
      "address": "대전 중구"
    },
    "recipient": {
      "id": "012",
      "name": "박지성",
      "email": "park@example.com",
      "nickname": "지성",
      "profile": "http://example.com/profile4.jpg",
      "location": {
        "description": "광주",
        "latitude": 35.1595,
        "longitude": 126.8526
      },
      "address": "광주 동구"
    },
    "pledgeRequest": {
      "id": 3,
      "name": "기부 요청 2"
    },
    "pledgeRecipient": {
      "id": 4,
      "name": "기부 수령 2"
    },
    "location": {
      "description": "기부 위치 2",
      "latitude": 36.3504,
      "longitude": 127.3845
    }
  }
]
    }
    ''';
    var jsonMap = json.decode(jsonString);
    recipientHelpLogs.value=List<HelpLog>.from(jsonMap['data'].map((i) => HelpLog.fromJson(i)));
  }
}

