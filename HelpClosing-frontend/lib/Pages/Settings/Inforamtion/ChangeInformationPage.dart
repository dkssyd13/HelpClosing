import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChangeInformationPage extends StatefulWidget {
  const ChangeInformationPage({super.key});

  @override
  State<ChangeInformationPage> createState() => _ChangeInformationPageState();
}

class _ChangeInformationPageState extends State<ChangeInformationPage> {
  final TextEditingController _nicknameController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(icon: const Icon(Icons.close),onPressed: (){Get.back();},),
        title: const Text("정보 변경"),
        titleTextStyle: const TextStyle(fontSize: 40,fontWeight: FontWeight.bold,color: Colors.blue),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 40, right: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              children: [
                _buildText("닉네임 변경"),
                SizedBox(width: 10,),
                Expanded(
                  child: SizedBox(
                    child: TextField(
                      controller: _nicknameController,
                      decoration: const InputDecoration(hintText: "새로운 닉네임을 입력해주세요"),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20,),
            Row(
              children: [
                _buildText("비밀번호 변경"),
                SizedBox(width: 10,),
                Expanded(
                  child: SizedBox(
                    child: TextField(
                      controller: _nicknameController,
                      decoration: const InputDecoration(hintText: "새로운 비밀번호을 입력해주세요"),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20,),
            Row(
              children: [
                _buildText("이메일 변경"),
                SizedBox(width: 10,),
                Expanded(
                  child: SizedBox(
                    child: TextField(
                      controller: _nicknameController,
                      decoration: const InputDecoration(hintText: "새로운 이메일을 입력해주세요"),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20,),
            ElevatedButton(onPressed: (){},
              style: ElevatedButton.styleFrom(elevation: 30,backgroundColor: Colors.blue[100]),
                child: const Text("저장하기",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildText(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: Colors.blue,
        fontSize: 15
      ),
    );
  }
}
