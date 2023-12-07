// import 'dart:html';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:help_closing_frontend/Domain/User.dart';
import 'package:help_closing_frontend/Fcm/fcmSettings.dart';
import 'package:help_closing_frontend/ServerUrl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../Pages/Login_SignUp/Login.dart';
import '../Pages/MainPage.dart';
import 'User_Controller.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:http_parser/http_parser.dart';

class AuthController extends GetxController{
  //어디서든 접근 가능해야됨
  static AuthController get to => Get.find();
  UserController userController = UserController();
  late Rx<User?> _currentUser;
  final RxBool _rememberUser=false.obs;
  final storage = const FlutterSecureStorage();
  String registerEmail = "";
  late String myUrlPledgeRequest;
  late String myUrlPledgeResponse;

  bool get rememberUser => _rememberUser.value;

  @override
  void onReady(){
    super.onReady(); //_user 초기화하려고
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _asyncMethod();
    });
    _currentUser = Rx<User?>(UserController.currentUser);
    //_user.bindStream(authentication.userChanges()); //user -> stream(=유저의 모든 행동 실시간으로 전달)  : bind.
    ever(_currentUser, _moveToPage); //유저가 변화를 일으킴? -> 바로 moveToPage 으로 전달됨
  }

  _asyncMethod() async {
    // read 함수로 key값에 맞는 정보를 불러오고 데이터타입은 String 타입
    // 데이터가 없을때는 null을 반환
    var userInfoJson = await storage.read(key:'login');

    // user의 정보가 있다면 로그인 후 들어가는 첫 페이지로 넘어가게 합니다.
    if (userInfoJson != null) {
      Map<String, dynamic> userInfo = jsonDecode(userInfoJson);
      userController.createCurrentUser(userInfo["name"], userInfo["email"], userInfo["nickname"], userInfo["image"], userInfo['userId'], userInfo['urlPledgeRequest'], userInfo['urlPledgeResponse']);
      var fcmToken = await storage.read(key: "fcmToken");
      saveFCMToken(userInfo["email"], fcmToken!);
    }
  }

  void toggleRemember(bool val){
    _rememberUser.value=val;
    print("remember value = ${_rememberUser.value}");
  }

  _moveToPage(User? user) {
    print(_currentUser.value);
    if(user==null) {
      Get.offAll(()=>const LoginPage());
    }else {
      Get.offAll(()=>const MainPage());
    }
  }


  Future<bool> register(String email, password, confirmPw, nickName,name) async {
    print("register_start");
    print("email = $email");
    print("pass = $password");
    final response = await http.post(
      Uri.parse('${ServerUrl.baseUrl}/register/simple'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'password': password,
        'confirmPw' : confirmPw,
        'nickName' : nickName,
        'name' : name,
      }),
    );
    print(response.body);
    print(response.statusCode);
    print('Response headers: ${response.headers}');

    final int statusCode = response.statusCode;
    if (statusCode == 200) {
      final responseJson = jsonDecode(response.body);
      print(responseJson['result']);
      if(responseJson['result']==false){
        Get.snackbar(
            "Error Message  ",
            "User Message",
            backgroundColor: Colors.red[50],
            snackPosition: SnackPosition.BOTTOM,
            titleText: const Text("회원가입 실패"),
            messageText: Text("${responseJson["description"]}")
        );
        return false;
      }
      return true;
    }else{
      Get.snackbar(
          "Error Message  ",
          "User Message",
          backgroundColor: Colors.red[50],
          snackPosition: SnackPosition.BOTTOM,
          titleText: const Text("회원가입 실패"),
          messageText: const Text("ㅇㅇ 안됨")
      );
      return false;
    }
  }

  Future<bool> checkEmail(String email)async{
    final response = await http.get(
      Uri.parse('${ServerUrl.baseUrl}/register/email?email=$email'),
    );

    if (response.statusCode==200){
      Get.snackbar(backgroundColor: Colors.green,"이메일 코드 전송 완료", "이메일로 인증 코드를 보냈습니다.");
      return true;
    }
    else{
      Get.snackbar(backgroundColor: Colors.red,"이메일 코드 전송 실패", "이메일로 인증 코드를 보내는데 문제가 생김.");
      return false;
    }
  }

  void login(String email, String password) async {
    print("Start logging");
    final response = await http.post(
      Uri.parse('${ServerUrl.baseUrl}/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'password': password,
        'email': email,
      }),
    );
    print(response.statusCode);
    print(response.body);


    if (response.statusCode == 200) {
      print('Login successful');
      print(response.body);
      final responseJson = jsonDecode(response.body);

      // 서버에서 받아온 사용자 정보를 사용.
      print("aaa");
      String token = responseJson['jwtToken'];
      print(token);
      String id = responseJson['userId'].toString();
      String name = responseJson['name'];
      String nickname = responseJson['nickName'];
      String urlPledgeRequest= responseJson['urlPledgeRequest'];
      String urlPledgeResponse = responseJson['urlPledgeResponse'];
      String image;
      if(responseJson['image'] == null){
        image = '';
      }
      else{
        image = responseJson['image'];
      }
      String email = responseJson['email'];
      await storage.write(key: 'login', value: responseJson.toString());
      print(storage.read(key: 'login'));
      await storage.write(key: 'jwtToken', value: token);
      print("token end");

      // 로그인이 성공하면 createCurrentUser 메서드를 호출합니다.
      userController.createCurrentUser(name, email, nickname, image,id, urlPledgeRequest, urlPledgeResponse);
      print(UserController.currentUser);
      _currentUser.value=UserController.currentUser;
      saveFCMToken(email, token);
    } else {
      Get.snackbar("로그인 실패", "입력한 정보를 다시 한번 확인해주세요",snackPosition: SnackPosition.BOTTOM,backgroundColor: Colors.redAccent[100]);
      throw Exception('Failed to login');
    }

    // userController.createCurrentUser('김중앙', email, 'hd', 'image','');
    // print(UserController.currentUser);
    // _currentUser.value=UserController.currentUser;
  }

  void saveFCMToken(String email, jwtToken) async{
    print("Starting saveFCMToken...");
    String? fcmToken = await storage.read(key: 'fcmToken');

    if (fcmToken != null){
      print("abc = ${fcmToken}");
      final response = await http.post(
        Uri.parse('${ServerUrl.baseUrl}/fb/saveFCMToken'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': "Bearer " + jwtToken,

        },
        body: jsonEncode(<String, String>{
          'email': email,
          'fcmtoken': fcmToken,
        }),
      );

      if (response.statusCode == 200) {
        // 서버가 200 OK 응답을 반환하면, 토큰 저장 결과를 파싱합니다.
        print("saved FCM TOKEN : ${fcmToken}");
        print("SaveToken OK");
      } else {
        // 서버가 200 OK 응답이 아닌 경우, 예외를 발생시킵니다.
        print(response.statusCode);
        print(response.body);
        throw Exception('Failed to save FCM token');
      }
    }
  }

  void uploadS3(String dir, reqOrResp, reqOrResp2) async {
    print("start uploading s3");
    File imgFile = File(dir);

    var uri = Uri.parse("${ServerUrl.baseUrl}/register/${reqOrResp}");

    // MultipartRequest를 생성합니다.
    var request = http.MultipartRequest('POST', uri);

    request.fields['email'] = registerEmail;
    print("registerEmail : ${registerEmail}");

    // 파일을 바이트로 읽습니다.
    // List<int> bytes = await imgFile.readAsBytesSync();
    List<int> bytes = await imgFile.readAsBytes();

    // 바이트를 MultipartFile로 변환합니다.
    var multipartFile = http.MultipartFile.fromBytes(
      reqOrResp2, // 서버에서 이 파일을 참조할 키
      bytes,
      contentType: MediaType('image', 'png'), // 이미지의 타입을 지정합니다.
      filename: "${reqOrResp}_${registerEmail}", // 파일명을 지정합니다.
    );

    request.files.add(multipartFile);



    var response = await request.send();

    print("response code : ${response.statusCode}");
    response.stream.transform(utf8.decoder).listen((value) {
      print(value);
    });

    if (response.statusCode == 200) {
      Get.snackbar("저장 완료", "성공적으로 저장.", backgroundColor: Colors.green);
    } else {
      Get.snackbar("저장 실패", "저장하는데 문제가 발생했습니다.", backgroundColor: Colors.red);
    }

  }

  void logout() async{
    //로그아웃
    //자동 로그인 정보 삭제
    await storage.delete(key: "login");
    _currentUser.value=null;
    Get.to(const LoginPage());
  }

}
