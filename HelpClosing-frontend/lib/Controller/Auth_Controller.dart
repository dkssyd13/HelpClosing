import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:help_closing_frontend/Domain/User.dart';
import 'package:help_closing_frontend/Fcm/fcmSettings.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../Pages/Login_SignUp/Login.dart';
import '../Pages/MainPage.dart';
import 'User_Controller.dart';
import 'package:flutter/material.dart';

class AuthController extends GetxController{
  //어디서든 접근 가능해야됨
  static AuthController get to => Get.find();
  UserController userController = UserController();
  late Rx<User?> _currentUser;
  final RxBool _rememberUser=false.obs;
  final storage = const FlutterSecureStorage();

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
      userController.createCurrentUser(userInfo["name"], userInfo["email"], userInfo["nickname"], userInfo["image"]);
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


  void register(String email, password) async {
    // final response = await http.post(
    //   Uri.parse('http://서버_주소.com/register'),
    //   headers: <String, String>{
    //     'Content-Type': 'application/json; charset=UTF-8',
    //   },
    //   body: jsonEncode(<String, String>{
    //     'password': password,
    //     'email': email,
    //   }),
    // );
    //
    // final int statusCode = response.statusCode;
    // if (statusCode == 200) {
    //   print('Register successful');
    //   final responseJson = jsonDecode(response.body);
    // }
    //
    // if(statusCode < 200 || statusCode > 400){
    //   //통신이 안됐을 때, 에러가 났을때
    //     Get.snackbar(
    //         "Error Message  ",
    //         "User Message",
    //         backgroundColor: Colors.red[50],
    //         snackPosition: SnackPosition.BOTTOM,
    //         titleText: const Text("회원가입 실패"),
    //         messageText: const Text("ㅇㅇ 안됨")
    //     );
    // }
  }

  void checkEmail(String email)async{
    final response = await http.get(
      Uri.parse('http://서버_주소.com/register/email?email=$email'),
    );

    if (response.statusCode==200){
      Get.snackbar(backgroundColor: Colors.green,"이메일 코드 전송 완료", "이메일로 인증 코드를 보냈습니다.");
    }
    else{
      Get.snackbar(backgroundColor: Colors.red,"이메일 코드 전송 실패", "이메일로 인증 코드를 보내는데 문제가 생김.");
    }
  }

  void login(String email, String password) async {
    // final response = await http.post(
    //   Uri.parse('http://서버_주소.com/login'),
    //   headers: <String, String>{
    //     'Content-Type': 'application/json; charset=UTF-8',
    //   },
    //   body: jsonEncode(<String, String>{
    //     'password': password,
    //     'email': email,
    //   }),
    // );
    //
    // if (response.statusCode == 200) {
    //   print('Login successful');
    //   final responseJson = jsonDecode(response.body);
    //
    //   // 서버에서 받아온 사용자 정보를 사용.
    //   // String token = responseJson['jwtToken'];
    //   String name = responseJson['name'];
    //   String nickname = responseJson['nickName'];
    //   String image = responseJson['image'];
    //   String email = responseJson['email'];
    //
    //   await storage.write(key: 'login', value: responseJson);
    //
    //   // 로그인이 성공하면 createCurrentUser 메서드를 호출합니다.
    //   userController.createCurrentUser(name, email, nickname, image);
    //   print(UserController.currentUser);
    //   _currentUser.value=UserController.currentUser;
    // } else {
    //   throw Exception('Failed to login');
    // }

    userController.createCurrentUser('김중앙', email, 'hd', 'image');
    print(UserController.currentUser);
    _currentUser.value=UserController.currentUser;
  }

  void logout() async{
    //로그아웃
    //자동 로그인 정보 삭제
    await storage.delete(key: "login");
    _currentUser.value=null;
  }

}
