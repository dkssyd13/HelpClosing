import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:help_closing_frontend/Controller/Auth_Controller.dart';
import 'package:help_closing_frontend/Controller/Help_Controller.dart';
import 'package:help_closing_frontend/Controller/Notification_Controller.dart';
import 'package:help_closing_frontend/Controller/User_Controller.dart';


class NotificationPage extends StatefulWidget {
  NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  HelpController helpController = Get.put(HelpController());

  NotificationController notificationController = Get.put(NotificationController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    notificationController.fetchInvitationList();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("알림"),
        titleTextStyle: const TextStyle(
            fontSize: 40, fontWeight: FontWeight.bold),
      ),
      body: Obx(() => ListView.builder(
        itemCount: notificationController.notifications.value.length,
          itemBuilder: (context, index){
          return Center(
            child: Card(
              elevation: 50,
              child: Container(
                width: MediaQuery
                    .of(context)
                    .size
                    .width * 0.9,
                child: Column(
                  children: [
                    Text("${notificationController.notifications.value[index].inviteName}이 도움을 요청했습니다.",style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 20)),
                    const SizedBox(height: 5,),
                    Text("• 당신은 ${notificationController.notifications.value[index].inviteName}에게 ${notificationController.notifications.value[index].closenessRank + 1}번째로 가까운 사람입니다.",style: const TextStyle(fontWeight: FontWeight.w500,fontSize: 15)),
                    const SizedBox(height: 5,),
                    Text("• ${notificationController.notifications.value[index].inviteName}님의 현재 상태 : ${notificationController.notifications.value[index].description}",style: const TextStyle(fontWeight: FontWeight.w500,fontSize: 15),),
                    const SizedBox(height: 5,),
                    const Text("수락하시겠습니까?",style: TextStyle(fontSize: 20),),
                    const SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                            onPressed: () {
                              var senderEmail = notificationController.notifications.value[index].inviteEmail;
                              var recipientEmail = AuthController.to.userController.getUserEmail();
                              helpController.requesterPosition=LatLng(notificationController.notifications.value[index].latitude, notificationController.notifications.value[index].longitude);
                              notificationController.urlPledgeRequest(senderEmail);
                              notificationController.urlPledgeResponse(senderEmail);
                              notificationController.acceptInvitation(senderEmail, recipientEmail!, 0,notificationController.notifications.value[index]);
                              helpController.giveHelp();
                              Get.back();
                            },
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                            child: const Icon(Icons.check,color: Colors.white,)),
                        const SizedBox(width: 5,),
                        ElevatedButton(
                          onPressed: () {
                            var senderEmail = notificationController.notifications.value[index].inviteEmail;
                            var recipientEmail = UserController.to.getUserEmail();
                            notificationController.rejectMatching(senderEmail, recipientEmail!);
                          },
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                          child: const Icon(Icons.close,color: Colors.white,),
                        )
                      ],
                    )

                  ],
                ),
              ),
            ),
          );
          }
      ))
    );
  }
}
