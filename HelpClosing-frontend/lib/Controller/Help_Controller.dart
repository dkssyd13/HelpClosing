import 'package:get/get.dart';

class HelpController extends GetxController {
  var _helpFlag = false.obs;

  get helpFlag => _helpFlag.value;

  void requestHelp() {
    print("controller의 flag true로 변경됨");
    _helpFlag.value=true;
  }

  void cancelHelp() {
    _helpFlag.value=false;
  }
}