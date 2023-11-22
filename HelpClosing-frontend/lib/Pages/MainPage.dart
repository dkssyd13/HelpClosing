import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:help_closing_frontend/Pages/Chat/ChatRoomPage.dart';
import 'package:help_closing_frontend/Pages/Notification/NotificationPage.dart';
import 'package:help_closing_frontend/Pages/Req_Help/NeedHelpPage.dart';
import 'package:help_closing_frontend/Pages/SettingsPage.dart';

import '../Controller/Help_Controller.dart';
import 'Record/RecordPage.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int pageIndex=0;
  // var pagesList=[HomePage(),const Text('메세지'),const Text('기록'),const Settings()];
  var pagesList=[HomePage(), ChatRoomListPage(), RecordPage(),const SettingsPage()];
  final pagesTitle=[const Text('도움닿기'),
    const Text('메세지'),
    const Text('기록'),
    const Text('설정')];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //floatingActionButton: FloatingActionButton(onPressed: (){Navigator.push(context,MaterialPageRoute(builder: (context) => NeedHelpPage()));},child: Icon(Icons.assistant_navigation)),

      appBar: AppBar(
        centerTitle: true,
        title: pagesTitle[pageIndex],
        titleTextStyle: const TextStyle(fontSize: 40,fontWeight: FontWeight.bold,color: Colors.blue),
        actions: [
          // IconButton(onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context) => const NotificationPage()));},
          IconButton(onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context) => const NotificationPage()));},
              icon: const Icon(Icons.notifications)),
        ],
      ),


      body: pagesList[pageIndex],


      bottomNavigationBar: BottomNavigationBar(
        showUnselectedLabels: true,
        showSelectedLabels: true,
        currentIndex: pageIndex,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home),label: '홈'),
          BottomNavigationBarItem(icon: Icon(Icons.message),label: '메세지'),
          BottomNavigationBarItem(icon: Icon(Icons.history),label: '기록'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: '설정'),
        ],
        onTap: (i) {setState(() {
          pageIndex=i;
        });},
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        unselectedLabelStyle: const TextStyle(color: Colors.white),
      ),
    );
  }
}




class HomePage extends StatelessWidget {
  HomePage({super.key});

  final HelpController _helpController = Get.put(HelpController());

  @override
  Widget build(BuildContext context){
    return Obx((){
      return _helpController.helpFlag?const NeedHelpBody() : const DoesntNeedHelpBody();
    });
  }
}

class DoesntNeedHelpBody extends StatelessWidget {
  const DoesntNeedHelpBody({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
        child: SizedBox(
          width: 200,
          height: 100,
          child: ElevatedButton(
            onPressed: (){
              showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    return const SizedBox(
                      height: 400,
                      child: TimerWidget(),
                    );
                  });
            },
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100))
            ),
            child: const Text("도움 요청하기"),
          ),
        )
    );
  }
}

class TimerWidget extends StatefulWidget {
  // const NeedHelp({super.key, required this.requestHelp});
  const TimerWidget({super.key});

  @override
  State<TimerWidget> createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget> {
  Color _currentColor = Colors.red; // 잘못눌렀어요 버튼의 초기 색
  Timer? _timer;

  HelpController helpController=Get.put(HelpController());

  int _currentSec=5; //"잘못 눌렀어요..." 옆에 타이머가 줄어드는거 추가하기 위해 필요한 state
  String _currentSituation="잘못 눌렀어요...";
  bool _cancelHelpFlag = false;



  @override
  void initState() {
    super.initState();
    _currentSituation="잘못 눌렀어요 $_currentSec...";
    _startTimer();
  }

  void _startTimer() {
    // _timer = Timer(Duration(seconds: 5), () {
    //   if (!_cancelHelpFlag) {
    //     showDialog(context: context, builder: (BuildContext ctx){
    //       return const Dialog(child: Text('ㅇㅇ 도움 요청한거임'),);
    //     });
    //   }
    // });
    _timer= Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!_cancelHelpFlag && _currentSec > 0) {
        setState(() {
          _currentSec-=1;
          _currentSituation="잘못 눌렀어요 $_currentSec...";
        });
      }
      else{
        _timer?.cancel();
        _currentColor=Colors.green;
        print("도움 요청 완료");
        helpController.requestHelp();
        _cancelHelpFlag=false;
        setState(() {
          _currentSituation="도움 요청 됐습니다! 조금만 기다려주세요~!";
        });
        Get.back();
      }
    });
  }

  void _cancelHelp() {
    setState(() {
      // _currentColor = Colors.green;
      _cancelHelpFlag = true;
      helpController.cancelHelp();
      _timer?.cancel();
      Navigator.pop(context);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    Color myColorDark=Theme.of(context).primaryColorDark;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: _currentColor,elevation: 50,shadowColor: myColorDark),
              onPressed: () {
                if (!helpController.helpFlag) {
                  _cancelHelp();
                }
              },
              child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: 50,
                  child: Center(
                      child: Text(_currentSituation,style: const TextStyle(fontWeight: FontWeight.w800,fontSize: 20,color: Colors.white),),
                  )
              )
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(elevation: 20,shadowColor: myColorDark),
              onPressed: (){},
              child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: 50,
                  child: const Center(
                      child: Text("상태 전달하기",style: TextStyle(fontWeight: FontWeight.w800,fontSize: 20),),
                  )
              )
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(elevation: 20,shadowColor: myColorDark),
              onPressed: (){},
              child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: 50,
                  child: const Center(
                      child: Text("요청 대상 선택하기",style: TextStyle(fontWeight: FontWeight.w800,fontSize: 20),),
                  )
              )
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(elevation: 20,shadowColor: myColorDark),
              onPressed: (){},
              child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: 50,
                  child: const Center(
                      child: Text("비상 연락망 연락",style: TextStyle(fontWeight: FontWeight.w800,fontSize: 20),),
                  )
              )
          )
        ],
      ),
    );
  }

}