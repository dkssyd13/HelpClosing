import 'dart:convert';
import 'package:help_closing_frontend/Domain/UserProfileRequest.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:help_closing_frontend/Domain/User.dart';
import 'package:help_closing_frontend/ServerUrl.dart';

class UserController extends GetxController{
  static User? _currentUser;
  static UserController get to => Get.find();
  final String _baseUrl=ServerUrl.baseUrl;
  static User? get currentUser => _currentUser;



  Future<Map<String, dynamic>> getProfile(String email) async {
    var response = await http.get(Uri.parse("$_baseUrl/profile/$email"));
    if (response.statusCode == 200) {
      print(jsonDecode(response.body));
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load profile');
    }
  }

  Future<Map<String, dynamic>> updateProfile(UserProfileRequest userProfileRequest) async {
    var response = await http.put(
      Uri.parse("$_baseUrl/profile/update"),
      headers: <String, String>{'Content-Type': 'application/json'},
      body: jsonEncode(userProfileRequest.toJson()),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to update profile');
    }
  }

  Future<Map<String, dynamic>> getUser(String email) async {
    var response = await http.get(Uri.parse("$_baseUrl/user/get?email=$email"));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to get user');
    }
  }

  void createCurrentUser(String name, String email, String nickname,String image, String id, String urlPledgeRequest, String urlPledgeResponse){
    _currentUser = User(
        name: name,
        email: email,
        nickname: nickname,
        image: image,
        id: id,
        location: null,
        address: '',
        urlPledgeRequest:urlPledgeRequest,
      urlPledgeResponse:urlPledgeResponse
    );
  }

  User createUser(String name, String email, String nickname,String image){
    return User(
        name: name,
        email: email,
        nickname: nickname,
        image: image,
        id: '',
        location: null,
        address: ''
    );
  }

  String? getUserName(){
    return _currentUser?.name;
  }

  String? getUserEmail(){
    return _currentUser?.email;
  }

  String? getUserId(){
    print(_currentUser?.id);
    return _currentUser?.id;
  }
  String? getUserNickname(){
    return _currentUser?.nickname;
  }

  String? getUserRequestPledge(){
    return _currentUser?.urlPledgeRequest;
  }

  String? getUserResponsePledge(){
    return _currentUser?.urlPledgeResponse;
  }



  bool isUserExists(){
    return false;
  }

}