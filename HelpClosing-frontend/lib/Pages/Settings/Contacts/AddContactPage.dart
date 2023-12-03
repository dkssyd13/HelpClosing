import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:help_closing_frontend/Controller/Contacts_Controller.dart';
import 'package:help_closing_frontend/Controller/EmergencyContactsController.dart';
import 'package:help_closing_frontend/Domain/User.dart';

class AddContactPage extends StatelessWidget {
  const AddContactPage({super.key});

  @override
  Widget build(BuildContext context) {
    ContactsController contactsController = Get.put(ContactsController());
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("연락처 추가하기"),
        titleTextStyle: const TextStyle(fontSize: 40,fontWeight: FontWeight.bold,color: Colors.blue),
      ),
      body: Obx( () => contactsController.permission.value ? ListView.builder(
        itemCount: contactsController.contacts.length,
        itemBuilder: (context, index){
          return Slidable(
              key: Key(contactsController.getContactByIndex(index).givenName),
              endActionPane: ActionPane(
                motion: const StretchMotion(),
                dismissible: DismissiblePane(
                  onDismissed: () => addContact(contactsController, index),
                ),
                children: [
                  SlidableAction(
                    backgroundColor: Colors.green,
                    icon: Icons.add,
                    label: '추가', onPressed: (BuildContext context) {
                      addContact(contactsController, index);
                      },
                  )
                ],

              ),
              child: buildUserListTile(contactsController.getContactByIndex(index))
          );
        },
      ) : const Center(child: Text('설정에서 연락처 권한 필요'),)),
    );
  }
  addContact(ContactsController contactsController,index){
    var name = "${contactsController.getContactByIndex(index).familyName}${contactsController.getContactByIndex(index).givenName!}";
    var id = contactsController.getContactByIndex(index).phones[0].value.toString();
    print("number : ${id}");
    Get.find<EmergencyContactsController>().contactsList.value.add(
        User(
            id: id,
            name: name,
            email: '',
            nickname: name,
            image: null,
            location: null,
            address: null)
    );

    Get.snackbar("긴급 연락처 추가 성공", "${name}님을 긴급연락처에 저장했습니다!",backgroundColor: Colors.green);
  }

  Widget buildUserListTile(Contact contactByIndex) {
    return Builder(builder: (context) =>
        ListTile(
          contentPadding: const EdgeInsets.all(15),
          title: Text("${contactByIndex.familyName}${contactByIndex.givenName!}"),
          leading: const CircleAvatar(
            radius: 30,
            child: Icon(Icons.account_box,size: 50,),
          ),
        ));
  }
}
