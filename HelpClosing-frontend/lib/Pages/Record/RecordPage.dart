import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:help_closing_frontend/Domain/HelpLog.dart';
import 'package:help_closing_frontend/GoogleApiKey.dart';
import '../../Controller/Help_Log_Controller.dart';
import 'package:http/http.dart' as http;


// class RecordPage extends StatelessWidget {
//   final HelpLogController _helpLogController = Get.put(HelpLogController());
//
//   RecordPage({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         children: [
//           SizedBox(width: MediaQuery
//               .of(context)
//               .size
//               .width, child: const ChoiceState()),
//           Expanded(
//             child: Obx(
//                     () =>
//                     ListView.builder(
//                       itemCount: _helpLogController.recipientHelpLogs.length,
//                       itemBuilder: (context, index) {
//                         return Card(
//                           color: Colors.white,
//                           elevation: 20,
//                           child: Row(
//                             children: [
//                               Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text("시간: ${_helpLogController
//                                       .recipientHelpLogs[index].time}"),
//                                   Text("요청자: ${_helpLogController
//                                       .recipientHelpLogs[index].requester.name}"),
//                                   Text("수령자: ${_helpLogController
//                                       .recipientHelpLogs[index].recipient.name}"),
//                                   Text("위치: ${_helpLogController
//                                       .recipientHelpLogs[index].location
//                                       .description}"),
//                                   Text("요청 기부: ${_helpLogController
//                                       .recipientHelpLogs[index].pledgeRequest.name}"),
//                                   Text("수령 기부: ${_helpLogController
//                                       .recipientHelpLogs[index].pledgeRecipient
//                                       .name}"),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         );
//                       },
//                     )
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // Widget? getTime(List<HelpLog> helpLogList){
//   //   for(HelpLog helpLog in helpLogList) {
//   //     return Text("${helpLog.location}");
//   //   }
//   // }
// }
//
//
//
//
// enum Choice {give, receive}
// class ChoiceState extends StatefulWidget {
//   const ChoiceState({super.key});
//
//   @override
//   State<ChoiceState> createState() => _ChoiceStateState();
// }
//
// class _ChoiceStateState extends State<ChoiceState> {
//   Choice choiceView = Choice.receive;
//
//   @override
//   Widget build(BuildContext context) {
//     return SegmentedButton<Choice>(
//       // style: ButtonStyle(
//       //   shape: MaterialStateProperty.all<RoundedRectangleBorder>(
//       //     const RoundedRectangleBorder(borderRadius: BorderRadius.zero)
//       //   )
//       // ),
//         segments: const <ButtonSegment<Choice>>[
//           ButtonSegment<Choice>(
//             value: Choice.receive,
//             label: Text("도움 받은거"),
//             icon: Icon(Icons.arrow_circle_down_outlined),
//           ),
//           ButtonSegment<Choice>(
//             value: Choice.give,
//             label: Text("도움 준거"),
//             icon: Icon(Icons.arrow_circle_up_outlined),
//           ),
//         ],
//         selected: <Choice>{choiceView},
//       onSelectionChanged: (Set<Choice> newSelection){
//           setState(() {
//             choiceView = newSelection.first;
//           });
//       },
//     );
//   }
// }

class RecordPage extends StatefulWidget {
  RecordPage({Key? key}) : super(key: key);

  @override
  _RecordPageState createState() => _RecordPageState();
}

class _RecordPageState extends State<RecordPage> {
  final HelpLogController _helpLogController = Get.put(HelpLogController());
  Choice choiceView = Choice.receive;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _helpLogController.getHelpLogsForRequester();
    _helpLogController.getHelpLogsForRecipient();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
              width: MediaQuery.of(context).size.width,
              child: ChoiceState(
                  choiceView: choiceView,
                  onSelectionChanged: (newChoice) {
                    setState(() {
                      choiceView = newChoice;
                    });
                  })),
          Expanded(
            child: Obx(() => ListView.builder(
                itemCount: choiceView == Choice.give ? _helpLogController.recipientHelpLogs.length : _helpLogController.requesterHelpLogs.length,
                itemBuilder: (context, index) {
                  final log = choiceView == Choice.give ? _helpLogController.recipientHelpLogs[index] : _helpLogController.requesterHelpLogs[index];
                  if (choiceView == Choice.receive) {
                    return _buildCardSos(log);
                  } else {
                    print(_helpLogController.recipientHelpLogs.length);
                    return _buildCardPeople(log);
                  }
                })),
          ),
        ],
      ),
    );
  }

  Widget _buildCardSos(HelpLog helpLog) {
    return GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => RecordDetailRecipientPage(log: helpLog),
              ));
        },
        child: Card(
            color: Colors.white,
            elevation: 5,
            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: ListTile(
              leading: Icon(Icons.sos),
              title: Text('${helpLog.recipient.name}님에게 도움 요청'),
              subtitle: Text('${helpLog.time}'),
            )));
  }

  Widget _buildCardPeople(HelpLog helpLog) {
    return GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => RecordDetailRequesterPage(log: helpLog),
              ));
        },
        child: Card(
            color: Colors.white,
            elevation: 5,
            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: ListTile(
              leading: Icon(Icons.emoji_people),
              title: Text('${helpLog.requester.name}님에게 도움 제공'),
              subtitle: Text('${helpLog.time}'),
            )));
  }
}

class RecordDetailRequesterPage extends StatefulWidget {
  final HelpLog log;

  const RecordDetailRequesterPage({super.key, required this.log});

  @override
  State<RecordDetailRequesterPage> createState() => _RecordDetailRequesterPageState();
}

class _RecordDetailRequesterPageState extends State<RecordDetailRequesterPage> {
  late String destAddress="";
  HelpLogController helpLogController = Get.put(HelpLogController());


  @override
  void initState() {
    super.initState();
    getLocation();
  }

  void getLocation()async{
    final url = 'https://maps.googleapis.com/maps/api/geocode/json?latlng=${widget.log.latitude},${widget.log.longitude}&key=${googleApiKey}&language=ko';
    var responseAddr=await http.get(Uri.parse(url));
    print("json body(위경도 -> 주소) : ${jsonDecode(responseAddr.body)}");

    setState(() {
      destAddress = jsonDecode(responseAddr.body)['results'][0]['formatted_address'];
    });

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('${widget.log.requester.name}님과의 도움 기록'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        body:ListView(
            children: [
              Text("날짜 : ${widget.log.time}", style: const TextStyle(fontSize: 15),),
              const Divider(),
              Text("장소 : $destAddress",style: const TextStyle(fontSize: 15)),
              const Divider(),
              const Center(
                child: Text("서약서",
                  style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold, color: Colors.blue),
                ),
              ),
              const Divider(),
              Image.network(widget.log.requester.urlPledgeRequest),
              const Divider(),
              Image.network(widget.log.recipient.urlPledgeResponse),
            ]
        ),
        );
  }
}

class RecordDetailRecipientPage extends StatefulWidget {
  final HelpLog log;


  const RecordDetailRecipientPage({super.key, required this.log});

  @override
  State<RecordDetailRecipientPage> createState() => _RecordDetailRecipientPageState();
}

class _RecordDetailRecipientPageState extends State<RecordDetailRecipientPage> {
  late String destAddress="";
  HelpLogController helpLogController = Get.put(HelpLogController());

  @override
  void initState() {
    super.initState();
    getLocation();
  }

  void getLocation()async{
    print("start getting location record");
    final url = 'https://maps.googleapis.com/maps/api/geocode/json?latlng=${widget.log.latitude},${widget.log.longitude}&key=${googleApiKey}&language=ko';
    var responseAddr=await http.get(Uri.parse(url));
    print("json body(위경도 -> 주소) : ${jsonDecode(responseAddr.body)}");

    setState(() {
      destAddress = jsonDecode(responseAddr.body)['results'][0]['formatted_address'];
    });

  }



    @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('${widget.log.recipient.name}님과의 도움 기록'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        body:ListView(
          children: [
            Text("날짜 : ${widget.log.time}", style: const TextStyle(fontSize: 15),),
            const Divider(),
            Text("장소 : $destAddress",style: const TextStyle(fontSize: 15)),
            const Divider(),
            const Center(
              child: Text("서약서",
              style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold, color: Colors.blue),
              ),
            ),
            const Divider(),
            Image.network(widget.log.requester.urlPledgeRequest),
            const Divider(),
            Image.network(widget.log.recipient.urlPledgeResponse),
          ]
        )
    );
  }


}

enum Choice { give, receive }

class ChoiceState extends StatefulWidget {
  final Choice choiceView;
  final ValueChanged<Choice> onSelectionChanged;

  const ChoiceState({
    Key? key,
    required this.choiceView,
    required this.onSelectionChanged,
  }) : super(key: key);

  @override
  State<ChoiceState> createState() => _ChoiceStateState();
}

class _ChoiceStateState extends State<ChoiceState> {
  @override
  Widget build(BuildContext context) {
    return SegmentedButton<Choice>(
      // style: ButtonStyle(
      //   shape: MaterialStateProperty.all<RoundedRectangleBorder>(
      //     const RoundedRectangleBorder(borderRadius: BorderRadius.zero)
      //   )
      // ),
      segments: const <ButtonSegment<Choice>>[
        ButtonSegment<Choice>(
          value: Choice.receive,
          label: Text("도움 요청"),
          icon: Icon(Icons.arrow_circle_down_outlined),
        ),
        ButtonSegment<Choice>(
          value: Choice.give,
          label: Text("도움 제공"),
          icon: Icon(Icons.arrow_circle_up_outlined),
        ),
      ],
      selected: <Choice>{widget.choiceView},
      onSelectionChanged: (Set<Choice> newSelection) {
        widget.onSelectionChanged(newSelection.first);
      },
    );
  }
}