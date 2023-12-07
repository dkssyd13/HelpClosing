
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_routes/google_maps_routes.dart';
import 'package:help_closing_frontend/Controller/Auth_Controller.dart';
import 'package:help_closing_frontend/Controller/EmergencyContactsController.dart';
import 'package:help_closing_frontend/Controller/Help_Controller.dart';
import 'package:help_closing_frontend/GoogleApiKey.dart';
import 'package:help_closing_frontend/Pages/Notification/NotificationPage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';


class NeedHelpBody extends StatefulWidget {
  const NeedHelpBody({super.key});

  @override
  State<NeedHelpBody> createState() => _NeedHelpBodyState();
}

class _NeedHelpBodyState extends State<NeedHelpBody> {
  late GoogleMapController mapController;
  final HelpController _helpController = Get.put(HelpController());
  final TextEditingController _currentStateController = TextEditingController();
  final EmergencyContactsController ecc = Get.put(EmergencyContactsController());
  String myAddr = "";

  //위치 예시
  List<LatLng> points = [
    const LatLng(37.499449, 126.971902),
  ];

  MapsRoutes route = MapsRoutes();

  //거리 계산기??암튼
  DistanceCalculator distanceCalculator = DistanceCalculator();
  String totalDistance = 'No route';

  LatLng? _currentPosition;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    getLocation();
  }

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
    // await getAddr(lat, long);

    _helpController.latitude=lat;
    _helpController.longitude=long;
    _helpController.findAround(lat,long);
    _helpController.markers.value.add(
      Marker(
        markerId: const MarkerId('내위치'),
        position: LatLng(lat,long),
      ),
    );

    LatLng location = LatLng(lat, long);

    setState((){
      _currentPosition = location;
      getAddr();
      _isLoading = false;
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void _goToCurrentPosition() {
    print("current Pos : ${_currentPosition}");
    mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: _currentPosition!,
          zoom: 16.0,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Color myColorDark=Theme.of(context).primaryColorDark;
    return SafeArea(
      child: Stack(
        children: [
          _currentPosition != null ? Obx(() => GoogleMap(
              zoomControlsEnabled: false,
              onMapCreated: _onMapCreated,
              polylines: route.routes,
              //
              markers: _helpController.markers.value,
              initialCameraPosition: CameraPosition(
                target: _currentPosition!,
                zoom: 16.0,
              )
          )) : const Center(child : CircularProgressIndicator()),
          Positioned(
            right: 10,
            bottom: 10,
            child: FloatingActionButton(
              onPressed: _goToCurrentPosition,
              child: const Icon(Icons.location_searching),
            ),
          ),
          Positioned(
            right: 10,
              bottom: 70,
              child: FloatingActionButton(
                child: const Icon(Icons.note_alt_sharp),
                onPressed: (){
                  _showMenu();
                },
              )
          ),
        ],
      ),
    );
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

  Future _showMenu(){
    Color myColorDark=Theme.of(context).primaryColorDark;
    return showModalBottomSheet(context: context, builder: (context){
      return SizedBox(
        height: 400,
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green,elevation: 50,shadowColor: myColorDark),
                onPressed: () {
                },
                child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: 50,
                    child: const Center(
                      child: Text("도움 요청 됐습니다! 조금만 기다려주세요~!",style: TextStyle(fontWeight: FontWeight.w800,fontSize: 15,color: Colors.white),),
                    )
                )
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(elevation: 20,shadowColor: myColorDark),
                onPressed: (){
                  showModalBottomSheet(context: context,isScrollControlled: true ,builder: (context) {
                    return Padding(
                      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                      child: SizedBox(
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
                              ],
                            ),
                            const Text("현재 상태를 입력해주세요",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.blue),),
                            const SizedBox(height: 30,),
                            Padding(
                              padding: EdgeInsets.only(left: 10,right: 10),
                              child: TextField(
                                controller: _currentStateController,
                                decoration: InputDecoration(
                                  suffixIcon: IconButton(
                                    onPressed: (){
                                      _helpController.requestHelpStateReq=_currentStateController.text.trim();
                                      _currentStateController.clear();
                                      Get.snackbar("현재 상태 저장 완료", "현재 상태를 저장했습니다!",backgroundColor: Colors.green);
                                    },
                                    icon: const Icon(Icons.send),
                                  ),
                                  hintText: "현재 상태를 입력해주세요",
                                ),
                                onSubmitted: (m){
                                  _helpController.requestHelpStateReq=_currentStateController.text.trim();
                                  _currentStateController.clear();
                                  Get.snackbar("현재 상태 저장 완료", "현재 상태를 저장했습니다!",backgroundColor: Colors.green);
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
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: 50,
                    child: const Center(
                      child: Text("상태 전달하기",style: TextStyle(fontWeight: FontWeight.w800,fontSize: 20),),
                    )
                )
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(elevation: 20,shadowColor: myColorDark),
                onPressed: (){
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
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: 50,
                    child: const Center(
                      child: Text("요청 대상 선택하기",style: TextStyle(fontWeight: FontWeight.w800,fontSize: 20),),
                    )
                )
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(elevation: 20,shadowColor: myColorDark),
                onPressed: (){
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
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: 50,
                    child: const Center(
                      child: Text("비상 연락망 연락",style: TextStyle(fontWeight: FontWeight.w800,fontSize: 20),),
                    )
                )
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(elevation: 20,shadowColor: myColorDark, backgroundColor: Colors.red),
                onPressed: (){
                  _helpController.cancelHelp();
                  Get.back();
                },
                child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: 50,
                    child: const Center(child: Text("나가기",style: TextStyle(fontWeight: FontWeight.w800,fontSize: 20, color: Colors.white),)))
            )
          ],
        ),
      );
    },);
  }

}



