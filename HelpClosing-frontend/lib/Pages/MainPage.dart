import 'dart:async';
import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:help_closing_frontend/Controller/EmergencyContactsController.dart';
import 'package:help_closing_frontend/GoogleApiKey.dart';
import 'package:help_closing_frontend/Pages/Chat/ChatRoomsPage.dart';
import 'package:help_closing_frontend/Pages/Notification/NotificationPage.dart';
import 'package:help_closing_frontend/Pages/Req_Help/NeedHelpPage.dart';
import 'package:help_closing_frontend/Pages/Settings/SettingsPage.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import '../Controller/Help_Controller.dart';
import '../Fcm/fcmSettings.dart';
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
          IconButton(onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context) => NotificationPage()));},
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
      return _helpController.navigateHomePage();
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

  HelpController helpController = Get.put(HelpController());

  int _currentSec = 5; //"잘못 눌렀어요..." 옆에 타이머가 줄어드는거 추가하기 위해 필요한 state
  String _currentSituation = "잘못 눌렀어요...";
  bool _cancelHelpFlag = false;
  final HelpController _helpController = Get.put(HelpController());
  TextEditingController _currentStateController = TextEditingController();
  final EmergencyContactsController ecc = Get.put(EmergencyContactsController());
  LatLng? _currentPosition;
  String myAddr = "";


  getAddr() async{
    //google api 위도 경도 -> 주소
    final url = 'https://maps.googleapis.com/maps/api/geocode/json?latlng=${_currentPosition!.latitude},${_currentPosition!.longitude}&key=${googleApiKey}&language=ko';
    var responseAddr=await http.get(Uri.parse(url));
    print("json body(위경도 -> 주소) : ${jsonDecode(responseAddr.body)}");
    myAddr = await jsonDecode(responseAddr.body)['results'][0]['formatted_address'];
  }

  getLocation() async {
    LocationPermission permission;
    permission = await Geolocator.requestPermission();

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    double lat = position.latitude;
    double long = position.longitude;

    LatLng location = LatLng(lat, long);

    _currentPosition = location;
    getAddr();
  }

  @override
  void initState() {
    super.initState();
    getLocation();
    _currentSituation = "잘못 눌렀어요 $_currentSec...";
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
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!_cancelHelpFlag && _currentSec > 0) {
        setState(() {
          _currentSec -= 1;
          _currentSituation = "잘못 눌렀어요 $_currentSec...";
        });
      }
      else {
        _timer?.cancel();
        _currentColor = Colors.green;
        print("도움 요청 완료");
        helpController.requestHelp();
        _cancelHelpFlag = false;
        setState(() {
          _currentSituation = "도움 요청 됐습니다! 조금만 기다려주세요~!";
        });
        // Get.back();
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
    // super.dispose();
  }

  void sendSms(String number) async {
    final Uri url = Uri(
      scheme: 'sms',
      path : number,
      queryParameters: <String, String>{
        'body': '도와줘! 내 위치는 $myAddr',
      },
    );

    if(await canLaunchUrl(url)){
      await launchUrl(url);
      Get.snackbar("메세지 전송 성공", "메세지를 보냈습니다!", backgroundColor: Colors.green);

    }else{
      Get.snackbar("메세지 전송 실패", "메세지를 보내는 과정에서 오류가 발생했습니다",backgroundColor: Colors.red);
    }
  }

  @override
  Widget build(BuildContext context) {
    Color myColorDark = Theme
        .of(context)
        .primaryColorDark;
    return Center(
      // child: Column(
      //   mainAxisAlignment: MainAxisAlignment.spaceAround,
      //   children: [
      //     ElevatedButton(
      //       style: ElevatedButton.styleFrom(backgroundColor: _currentColor,elevation: 50,shadowColor: myColorDark),
      //         onPressed: () {
      //           if (!helpController.helpFlag) {
      //             _cancelHelp();
      //           }
      //         },
      //         child: SizedBox(
      //             width: MediaQuery.of(context).size.width * 0.8,
      //             height: 50,
      //             child: Center(
      //                 child: Text(_currentSituation,style: const TextStyle(fontWeight: FontWeight.w800,fontSize: 20,color: Colors.white),),
      //             )
      //         )
      //     ),
      //     ElevatedButton(
      //       style: ElevatedButton.styleFrom(elevation: 20,shadowColor: myColorDark),
      //         onPressed: (){},
      //         child: SizedBox(
      //             width: MediaQuery.of(context).size.width * 0.8,
      //             height: 50,
      //             child: const Center(
      //                 child: Text("상태 전달하기",style: TextStyle(fontWeight: FontWeight.w800,fontSize: 20),),
      //             )
      //         )
      //     ),
      //     ElevatedButton(
      //       style: ElevatedButton.styleFrom(elevation: 20,shadowColor: myColorDark),
      //         onPressed: (){},
      //         child: SizedBox(
      //             width: MediaQuery.of(context).size.width * 0.8,
      //             height: 50,
      //             child: const Center(
      //                 child: Text("요청 대상 선택하기",style: TextStyle(fontWeight: FontWeight.w800,fontSize: 20),),
      //             )
      //         )
      //     ),
      //     ElevatedButton(
      //       style: ElevatedButton.styleFrom(elevation: 20,shadowColor: myColorDark),
      //         onPressed: (){},
      //         child: SizedBox(
      //             width: MediaQuery.of(context).size.width * 0.8,
      //             height: 50,
      //             child: const Center(
      //                 child: Text("비상 연락망 연락",style: TextStyle(fontWeight: FontWeight.w800,fontSize: 20),),
      //             )
      //         )
      //     )
      //   ],
      // ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: _currentColor,
                  elevation: 50,
                  shadowColor: myColorDark),
              onPressed: () {
                if (!helpController.helpFlag) {
                  _cancelHelp();
                }
              },

              child: SizedBox(
                  width: MediaQuery
                      .of(context)
                      .size
                      .width * 0.8,
                  height: 50,
                  child: Center(
                    child: Text(_currentSituation, style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 15,
                        color: Colors.white),),
                  )
              )
          ),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                  elevation: 20, shadowColor: myColorDark),
              onPressed: () {
                showModalBottomSheet(context: context,
                    isScrollControlled: true,
                    builder: (context) {
                      return Padding(
                        padding: EdgeInsets.only(bottom: MediaQuery
                            .of(context)
                            .viewInsets
                            .bottom),
                        child: SizedBox(
                          height: 400,
                          width: MediaQuery
                              .of(context)
                              .size
                              .width,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    margin: EdgeInsets.all(10),
                                    child: IconButton(
                                      onPressed: () {
                                        Get.back();
                                      },
                                      icon: const Icon(Icons.close),
                                    ),
                                  ),
                                ],
                              ),
                              const Text("현재 상태를 입력해주세요", style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: Colors.blue),),
                              const SizedBox(height: 30,),
                              Padding(
                                padding: EdgeInsets.only(left: 10, right: 10),
                                child: TextField(
                                  controller: _currentStateController,
                                  decoration: InputDecoration(
                                    suffixIcon: IconButton(
                                      onPressed: () {
                                        _helpController.requestHelpStateReq =
                                            _currentStateController.text.trim();
                                        _currentStateController.clear();
                                        Get.snackbar(
                                            "현재 상태 저장 완료", "현재 상태를 저장했습니다!",
                                            backgroundColor: Colors.green);
                                        Get.back();
                                      },
                                      icon: const Icon(Icons.send),
                                    ),
                                    hintText: "현재 상태를 입력해주세요",
                                  ),
                                  onSubmitted: (m) {
                                    _helpController.requestHelpStateReq =
                                        _currentStateController.text.trim();
                                    _currentStateController.clear();
                                    Get.snackbar(
                                        "현재 상태 저장 완료", "현재 상태를 저장했습니다!",
                                        backgroundColor: Colors.green);
                                  },
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    });
              },
              child: SizedBox(
                  width: MediaQuery
                      .of(context)
                      .size
                      .width * 0.8,
                  height: 50,
                  child: const Center(
                    child: Text("상태 전달하기", style: TextStyle(
                        fontWeight: FontWeight.w800, fontSize: 20),),
                  )
              )
          ),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                  elevation: 20, shadowColor: myColorDark),
              onPressed: () {
                showModalBottomSheet(context: context, builder: (context) {
                  return SizedBox(
                    height: 400,
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Container(
                              margin: EdgeInsets.all(10),
                              child: IconButton(
                                onPressed: (){
                                  Get.back();
                                },
                                icon: const Icon(Icons.close),
                              ),
                            ),
                            const Text("요청 대상",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.blue),),
                          ],
                        ),

                        const SizedBox(height: 30,),
                        Expanded(
                          child: Padding(
                              padding: EdgeInsets.only(left: 10,right: 10),
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: _helpController.markers.value.length,
                                  itemBuilder: (context, index){
                                    return ListTile(
                                      title: Text(_helpController.markers.value.elementAt(index).markerId.toString()),
                                      leading: const Icon(Icons.person),
                                      onTap: (){
                                        String input = _helpController.markers.value.elementAt(index).markerId.toString();
                                        String result = input.replaceAll("MarkerId(", "").replaceAll(")", "");
                                        _helpController.matchingInvite(result, index+1);},
                                    );
                                  }
                              )
                          ),
                        )
                      ],
                    ),
                  );
                });
              },
              child: SizedBox(
                  width: MediaQuery
                      .of(context)
                      .size
                      .width * 0.8,
                  height: 50,
                  child: const Center(
                    child: Text("요청 대상 선택하기", style: TextStyle(
                        fontWeight: FontWeight.w800, fontSize: 20),),
                  )
              )
          ),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                  elevation: 20, shadowColor: myColorDark),
              onPressed: () {
                showModalBottomSheet(context: context, builder: (context) {
                  return SizedBox(
                    height: 400,
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Container(
                              margin: EdgeInsets.all(10),
                              child: IconButton(
                                onPressed: (){
                                  Get.back();
                                },
                                icon: const Icon(Icons.close),
                              ),
                            ),
                            const Text("긴급 연락처",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.blue),),
                          ],
                        ),

                        const SizedBox(height: 30,),
                        Expanded(
                          child: Padding(
                              padding: EdgeInsets.only(left: 10,right: 10),
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: ecc.contactsList.length,
                                  itemBuilder: (context, index){
                                    return ListTile(
                                      title: Text(ecc.contactsList.value[index].name),
                                      leading: const Icon(Icons.person),
                                      onTap: (){
                                        print(ecc.contactsList.value[index].id);
                                        sendSms(ecc.contactsList.value[index].id);
                                      },
                                    );
                                  }
                              )
                          ),
                        )
                      ],
                    ),
                  );
                });
              },
              child: SizedBox(
                  width: MediaQuery
                      .of(context)
                      .size
                      .width * 0.8,
                  height: 50,
                  child: const Center(
                    child: Text("비상 연락망 연락", style: TextStyle(
                        fontWeight: FontWeight.w800, fontSize: 20),),
                  )
              )
          )
        ],
      ),
    );
  }

}