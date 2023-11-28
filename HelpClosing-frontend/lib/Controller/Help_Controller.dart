import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:help_closing_frontend/Pages/MainPage.dart';
import 'package:help_closing_frontend/Pages/Req_Help/GiveHelpPage.dart';
import 'package:help_closing_frontend/Pages/Req_Help/NeedHelpPage.dart';

class HelpController extends GetxController {
  final _requestHelpFlag = false.obs;
  final _giveHelpFlag = false.obs;

  get helpFlag => _requestHelpFlag.value;

  void requestHelp() {
    print("controller의 flag true로 변경됨");
    _requestHelpFlag.value=true;
    _giveHelpFlag.value = false;
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