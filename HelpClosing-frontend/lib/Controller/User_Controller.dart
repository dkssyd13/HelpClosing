import 'package:get/get.dart';
import 'package:help_closing_frontend/Domain/User.dart';

class UserController {
  static User? _currentUser;
  static UserController get to => Get.find();


  static User? get currentUser => _currentUser;

  void createCurrentUser(String name, String email, String nickname,String image){
    _currentUser = User(
        name: name,
        email: email,
        nickname: nickname,
        image: image,
        id: '',
        location: null,
        address: ''
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
    return _currentUser?.id;
  }
  String? getUserNickname(){
    return _currentUser?.nickname;
  }



  bool isUserExists(){
    return false;
  }

}