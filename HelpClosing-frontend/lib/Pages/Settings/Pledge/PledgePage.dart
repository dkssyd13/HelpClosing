import 'package:flutter/material.dart';
import 'package:help_closing_frontend/Controller/Auth_Controller.dart';

class PledgePage extends StatefulWidget {
  const PledgePage({super.key});

  @override
  State<PledgePage> createState() => _PledgePageState();
}

class _PledgePageState extends State<PledgePage> {
  var reqPledge;
  var respPledge;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getImgs();
  }

  getImgs()async{
    reqPledge = AuthController.to.userController.getUserRequestPledge();
    respPledge = AuthController.to.userController.getUserResponsePledge();
  }

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
          Image.network(reqPledge),
          const Divider(),
          Image.network(respPledge)
        ],
      )
    );
  }
}
