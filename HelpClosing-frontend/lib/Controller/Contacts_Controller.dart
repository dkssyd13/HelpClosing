import 'package:get/get.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:permission_handler/permission_handler.dart';

class ContactsController extends GetxController{
  RxList _contacts = List<Contact>.empty(growable: true).obs;
  RxBool _permission = false.obs;

  RxBool get permission => _permission;

  RxList get contacts => _contacts;

  @override
  void onInit() async {
    // TODO: implement onInit
    super.onInit();
    Permission.contacts.request();
    var status = await Permission.contacts.status;
    if(status.isGranted){
      _permission.value = true;
      _contacts.value = await ContactsService.getContacts(withThumbnails: false);
      print(_contacts.length);
    }
  }


  getContactByIndex(int index){
    return _contacts.value[index];
  }

  deleteUserByIndex(int index){
    _contacts.value.removeAt(index);
  }


}