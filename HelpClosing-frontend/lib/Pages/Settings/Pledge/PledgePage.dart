import 'package:flutter/material.dart';

class PledgePage extends StatelessWidget {
  const PledgePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("계약서"),
        titleTextStyle: const TextStyle(fontSize: 40,fontWeight: FontWeight.bold,color: Colors.blue),
      ),
      body: ListView(
        children: [
          Image.network("https://helpclosing-bucket.s3.ap-northeast-2.amazonaws.com/secondPledge.png"),
          const Divider(),
          Image.network("https://helpclosing-bucket.s3.ap-northeast-2.amazonaws.com/secondPledge.png")
        ],
      )
    );
  }
}
