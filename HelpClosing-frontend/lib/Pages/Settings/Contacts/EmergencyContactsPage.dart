import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:help_closing_frontend/Controller/EmergencyContactsController.dart';
import 'package:help_closing_frontend/Domain/User.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class EmergencyContactsPage extends StatelessWidget {
  EmergencyContactsPage({super.key});
  final EmergencyContactsController ecc = Get.put(EmergencyContactsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("긴급 연락처"),
        titleTextStyle: const TextStyle(fontSize: 40,fontWeight: FontWeight.bold,color: Colors.blue),
      ),
      body: Obx( () => ListView.builder(
        itemCount: ecc.getContactLength(),
        itemBuilder: (context, index){
          return Slidable(
            key: Key(ecc.getContactByIndex(index).name),
            endActionPane: ActionPane(
              motion: const StretchMotion(),
              dismissible: DismissiblePane(
                onDismissed: () => ecc.deleteUserByIndex(index),
              ),
              children: [
                SlidableAction(
                    backgroundColor: Colors.red,
                  icon: Icons.delete_forever,
                  label: '삭제', onPressed: (BuildContext context) { ecc.deleteUserByIndex(index); print(index); },
                )
              ],

            ),
              child: buildUserListTile(ecc.getContactByIndex(index))
          );
        },
      )),
    );
  }

  Widget buildUserListTile(User contactByIndex) {
    return Builder(builder: (context) =>
        ListTile(
          contentPadding: EdgeInsets.all(15),
          title: Text(contactByIndex.name),
          subtitle: Text(contactByIndex.nickname),
          leading: CircleAvatar(
            radius: 30,
            backgroundImage: NetworkImage(contactByIndex.image ??
                'https://png.pngtree.com/png-vector/20190223/ourmid/pngtree-profile-line-black-icon-png-image_691051.jpg'),
          ),
        ));
  }
}

