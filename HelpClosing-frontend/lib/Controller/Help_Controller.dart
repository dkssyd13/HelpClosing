import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:help_closing_frontend/Controller/Auth_Controller.dart';
import 'package:help_closing_frontend/Controller/User_Controller.dart';
import 'package:help_closing_frontend/Domain/LocationResponse.dart';
import 'package:help_closing_frontend/Pages/MainPage.dart';
import 'package:help_closing_frontend/Pages/Req_Help/GiveHelpPage.dart';
import 'package:help_closing_frontend/Pages/Req_Help/NeedHelpPage.dart';
import 'package:help_closing_frontend/ServerUrl.dart';
import 'package:http/http.dart' as http;


class HelpController extends GetxController {
  final _requestHelpFlag = false.obs;
  final _giveHelpFlag = false.obs;
  RxList<LatLng> _locations = List<LatLng>.empty(growable: true).obs;
  get helpFlag => _requestHelpFlag.value;
  RxSet<Marker> _markers = Set<Marker>().obs;

  RxSet<Marker> get markers => _markers;

  void requestHelp() async {
    print("help controller의 flag true로 변경됨");
    _requestHelpFlag.value = true;
    _giveHelpFlag.value = false;
  }



  void findAround(double latitude, double longitude) async {
    var distance = 0.5;
    var jwtToken = await AuthController.to.storage.read(key: 'jwtToken');

    if (jwtToken != null) {
      try {
        final response = await http.get(
          Uri.parse('${ServerUrl
              .baseUrl}/location/distance?latitude=$latitude&longitude=$longitude&distance=$distance'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': "Bearer " + jwtToken,
          },
        );
        print("findAround status code = ${response.statusCode}");
        print("findAround response body = ${response.body}");
        if (response.statusCode == 200) {
          List<dynamic> body = jsonDecode(response.body);
          List<LocationResponse> locations = body
              .map((dynamic item) => LocationResponse.fromJson(item))
              .toList();
          print(locations);
          convertLocationResponse(locations);
        } else {
          throw Exception('Failed to find locations');
        }
      }catch(e){
        print("findAround error : $e");
      }
    }
  }

  void convertLocationResponse(List<LocationResponse> locationsList){
    print("Start Making Markers");
    for (var locationResponse in locationsList) {
      _locations.add(LatLng(locationResponse.latitude, locationResponse.longitude));
      _markers.add(Marker(
          markerId: MarkerId(locationResponse.userEmail),
          position: LatLng(locationResponse.latitude, locationResponse.longitude),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
          onTap: (){
            matchingInvite(locationResponse.userEmail,locationResponse.closenessRank);
          }
      ));
    }
    print("markers length : ${_markers.value.length}");

    print("Done making Markers");
  }

  void matchingInvite(String invitedEmail, closenessRank) async{
    print("Start Matching Invite");
    var jwtToken = await AuthController.to.storage.read(key: 'jwtToken');
    var url = Uri.parse('${ServerUrl.baseUrl}/matching/invite');
    var headers = {'Content-Type': 'application/json','Authorization': "Bearer " + jwtToken!,};

    print("invitePerson : ${UserController.to.getUserEmail()}");
    print("invitedPerson : $invitedEmail");
    print("closenessRank : $closenessRank");
    var body = jsonEncode({
      'inviteEmail': UserController.to.getUserEmail(),
      'invitedEmail': invitedEmail,
      'closenessRank' : closenessRank,
    });
    var response = await http.post(url, headers: headers, body: body);
    print(response.statusCode);
    if(response.statusCode==200){
      print("response body = ${response.body}");
      Get.snackbar("도움 요청을 보냈습니다!", "${response.body}", backgroundColor: Colors.green);
      getFcm(invitedEmail,closenessRank);
    }else{
      Get.snackbar("도움 요청을 실패했습니다!", "${response.body}", backgroundColor: Colors.red);
    }
  }

  void getFcm(String email,closenessRank) async{
    var jwtToken = await AuthController.to.storage.read(key: 'jwtToken');
    final response = await http.get(Uri.parse('${ServerUrl.baseUrl}/fb/getFCMToken?email=$email'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': "Bearer " + jwtToken!,
      },
    );

    if (response.statusCode == 200) {
      print("getFCM OK");
      // 만약 서버가 OK 응답을 반환하면, JSON을 파싱합니다.
      print(jsonDecode(response.body));
      Map<String, dynamic> jsonData = jsonDecode(response.body);
      print(jsonData['data']['fcmToken']);
      sendMessageFCM(jsonData['data']['fcmToken'],closenessRank);
    } else {
      // 만약 응답이 OK가 아니면, 에러를 던집니다.
      throw Exception('Failed to load FCM token');
    }
  }

  void sendMessageFCM(String targetToken,closenessRank) async{
    print("sendMessageFCM Starting...");
    final response = await http.post(
      Uri.parse('${ServerUrl.baseUrl}/fb/fcm'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'targetToken': targetToken,
        'title': "도움 요청 도착",
        'body': "당신은 $closenessRank번째 가까운 사람입니다",
      }),
    );
    print(response.statusCode);
    if (response.statusCode == 200) {
      // 서버가 200 OK 응답을 반환하면, 메시지 전송 결과를 파싱합니다.
      Map<String, dynamic> jsonData = jsonDecode(response.body);
      print(jsonData);
      print("sendMessageFCM OK");
      // return jsonData['response'];
    } else {
      // 서버가 200 OK 응답이 아닌 경우, 예외를 발생시킵니다.
      throw Exception('Failed to push message');
    }
  }



  Widget navigateHomePage(){
    if(_giveHelpFlag.value != false) {
      return const GiveHelpBody();
    }
    else if (_requestHelpFlag != false){
      return const NeedHelpBody();
    }
    else{
      return const DoesntNeedHelpBody();
    }
  }

  void giveHelp(){
    _requestHelpFlag.value = false;
    _giveHelpFlag.value = true;
  }

  void cancelHelp() {
    _requestHelpFlag.value=false;
  }
}