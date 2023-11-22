import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:help_closing_frontend/Domain/HelpLog.dart';
import '../../Controller/Help_Log_Controller.dart';


class RecordPage extends StatelessWidget {
  final HelpLogController _helpLogController = Get.put(HelpLogController());

  RecordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(width: MediaQuery
              .of(context)
              .size
              .width, child: const ChoiceState()),
          Expanded(
            child: Obx(
                    () =>
                    ListView.builder(
                      itemCount: _helpLogController.recipientHelpLogs.length,
                      itemBuilder: (context, index) {
                        return Card(
                          color: Colors.white,
                          elevation: 20,
                          child: Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("시간: ${_helpLogController
                                      .recipientHelpLogs[index].time}"),
                                  Text("요청자: ${_helpLogController
                                      .recipientHelpLogs[index].requester.name}"),
                                  Text("수령자: ${_helpLogController
                                      .recipientHelpLogs[index].recipient.name}"),
                                  Text("위치: ${_helpLogController
                                      .recipientHelpLogs[index].location
                                      .description}"),
                                  Text("요청 기부: ${_helpLogController
                                      .recipientHelpLogs[index].pledgeRequest.name}"),
                                  Text("수령 기부: ${_helpLogController
                                      .recipientHelpLogs[index].pledgeRecipient
                                      .name}"),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    )
            ),
          ),
        ],
      ),
    );
  }

  // Widget? getTime(List<HelpLog> helpLogList){
  //   for(HelpLog helpLog in helpLogList) {
  //     return Text("${helpLog.location}");
  //   }
  // }
}




enum Choice {give, receive}
class ChoiceState extends StatefulWidget {
  const ChoiceState({super.key});

  @override
  State<ChoiceState> createState() => _ChoiceStateState();
}

class _ChoiceStateState extends State<ChoiceState> {
  Choice choiceView = Choice.receive;

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
            label: Text("도움 받은거"),
            icon: Icon(Icons.arrow_circle_down_outlined),
          ),
          ButtonSegment<Choice>(
            value: Choice.give,
            label: Text("도움 준거"),
            icon: Icon(Icons.arrow_circle_up_outlined),
          ),
        ],
        selected: <Choice>{choiceView},
      onSelectionChanged: (Set<Choice> newSelection){
          setState(() {
            choiceView = newSelection.first;
          });
      },
    );
  }
}
