import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:help_closing_frontend/Controller/Help_Controller.dart';


class NotificationPage extends StatelessWidget {
  NotificationPage({super.key});
  HelpController helpController = Get.put(HelpController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("알림"),
        titleTextStyle: const TextStyle(
            fontSize: 40, fontWeight: FontWeight.bold),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Card(
              elevation: 50,
              child: Container(
                width: MediaQuery
                    .of(context)
                    .size
                    .width * 0.9,
                child: Column(
                  children: [
                    const Text("김중앙이 도움을 요청했습니다.",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 30)),
                    const SizedBox(height: 5,),
                    const Text("수락하시겠습니까?",style: TextStyle(fontSize: 20),),
                    const SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                            onPressed: () {
                              helpController.giveHelp();
                              Get.back();
                            },
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                            child: const Icon(Icons.check,color: Colors.white,)),
                        const SizedBox(width: 5,),
                        ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                            child: const Icon(Icons.close,color: Colors.white,),
                        )
                      ],
                    )

                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
