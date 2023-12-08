import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:help_closing_frontend/Domain/User.dart';

class EmergencyContactsController extends GetxController{
  final RxList<User> _contactsList = List<User>.empty(growable: true).obs;
  RxList<User> get contactsList => _contactsList;

  int getContactLength(){
    return _contactsList.value.length;
  }

  User getContactByIndex(int index){
    return _contactsList.value[index];
  }

  void deleteUserByIndex(int index){
    Get.snackbar("긴급 연락처 삭제", "${_contactsList.value[index].name}님이 성공적으로 삭제되었습니다!",backgroundColor: Colors.lightBlue[50], duration: const Duration(seconds: 3));
    _contactsList.removeAt(index);
  }

}