import 'package:get/get.dart';
import 'package:help_closing_frontend/Controller/Auth_Controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:help_closing_frontend/Controller/User_Controller.dart';
import 'package:help_closing_frontend/Pages/Settings/Contacts/EmergencyContactsPage.dart';
import 'package:help_closing_frontend/Pages/Settings/Pledge/PledgePage.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}


class _SettingsPageState extends State<SettingsPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            AccountInfo(),
            Divider(),
            ChangeSettings(),
          ],
        ),
      ),
    );
  }
}


class AccountInfo extends StatelessWidget {
  const AccountInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircleAvatar(
              backgroundColor: Color(0xffE6E6E6),
              radius: 100,
              child: Icon(
                Icons.person,
                color: Color(0xffCCCCCC),
                size: 50,
              ),
            ),
            Text(UserController.to.getUserName() ??  "null",style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 50,
            ),),
            const Divider(color: Colors.white,),
          ],
        ));
  }
}

class ChangeSettings extends StatelessWidget {
  const ChangeSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 50,left: 20,right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            onTap: (){
              Get.to(const PledgePage());
            },
            leading: Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                  color: Colors.deepPurple.shade100,
                  shape: BoxShape.circle
              ),
              child: const Icon(
                Icons.description,
                color: Colors.deepPurple,
                size: 35,
              ),
            ),
            title: const Text("계약서 확인하기",style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 20,
            ),),
            trailing: const Icon(Icons.arrow_forward_ios_rounded),
          ),

          const SizedBox(height: 20,),

          ListTile(
            onTap: (){
              Get.to(EmergencyContactsPage());
            },
            leading: Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                  color: Colors.green.shade100,
                  shape: BoxShape.circle
              ),
              child: const Icon(
                Icons.contact_emergency,
                color: Colors.green,
                size: 35,
              ),
            ),
            title: const Text("긴급 연락처 추가",style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 20,
            ),),
            trailing: const Icon(Icons.arrow_forward_ios_rounded),
          ),

          const SizedBox(height: 20,),

          ListTile(
            onTap: (){},
            leading: Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                  color: Colors.blue.shade100,
                  shape: BoxShape.circle
              ),
              child: const Icon(
                CupertinoIcons.person,
                color: Colors.blue,
                size: 35,
              ),
            ),
            title: const Text("정보 변경",style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 20,
            ),),
            trailing: const Icon(Icons.arrow_forward_ios_rounded),
          ),

          const Divider(),
          const SizedBox(height: 20,),

          ListTile(
            onTap: (){
              AuthController.to.logout();
            },
            leading: Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                  color: Colors.redAccent.shade100,
                  shape: BoxShape.circle
              ),
              child: const Icon(
                Icons.logout,
                color: Colors.redAccent,
                size: 35,
              ),
            ),
            title: const Text("로그아웃",style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 20,
            ),),
            trailing: const Icon(Icons.arrow_forward_ios_rounded),
          ),
        ],
      ),
    );
  }
}
