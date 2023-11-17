import 'package:get/get.dart';
import 'package:help_closing_frontend/Domain/User.dart';
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

  bool get rememberUser => _rememberUser.value;

  @override
  void onReady(){
    super.onReady(); //_user 초기화하려고
    _currentUser = Rx<User?>(null);
    //_user.bindStream(authentication.userChanges()); //user -> stream(=유저의 모든 행동 실시간으로 전달)  : bind.
    ever(_currentUser, _moveToPage); //유저가 변화를 일으킴? -> 바로 moveToPage 으로 전달됨
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
    //회원가입에 대한 get 요청 가정.
    var registerRequest = await http.get(Uri.parse("https://사이트_url.com/register.json"));
    final int statusCode = registerRequest.statusCode;
    if(statusCode < 200 || statusCode > 400){
      //통신이 안됐을 때, 에러가 났을때
        Get.snackbar(
            "Error Message  ",
            "User Message",
            backgroundColor: Colors.red[50],
            snackPosition: SnackPosition.BOTTOM,
            titleText: const Text("회원가입 실패"),
            messageText: const Text("ㅇㅇ 안됨")
        );
    }
    // 문제 없을때
    var data = jsonDecode(registerRequest.body);
    userController.createUser(data['name'], data['email'], data['nickname'], data['profile']);
  }

  void login(String email, String password) async {
    // final response = await http.post(
    //   Uri.parse('http://서버_주소.com/login'),
    //   headers: <String, String>{
    //     'Content-Type': 'application/json; charset=UTF-8',
    //   },
    //   body: jsonEncode(<String, String>{
    //     'email': email,
    //     'password': password,
    //   }),
    // );
    //
    // if (response.statusCode == 200) {
    //   print('Login successful');
    //   final responseJson = jsonDecode(response.body);
    //
    //   // 서버에서 받아온 사용자 정보를 사용.
    //   String name = responseJson['name'];
    //   String nickname = responseJson['nickName'];
    //   String profile = responseJson['image'];
    //   String email = responseJson['email'];
    //
    //
    //   // 로그인이 성공하면 createUser 메서드를 호출합니다.
    //   userController.createUser(name, email, nickname, profile);
    //   print(UserController.currentUser);
    //   _currentUser.value=UserController.currentUser;
    // } else {
    //   throw Exception('Failed to login');
    // }

    userController.createUser('김중앙', email, 'hd', 'profile');
    print(UserController.currentUser);
    _currentUser.value=UserController.currentUser;
  }

  void logout() {
    //로그아웃
    _currentUser.value=null;
  }
}
