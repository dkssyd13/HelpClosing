import 'dart:async';
import 'dart:convert';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:help_closing_frontend/GoogleApiKey.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_routes/google_maps_routes.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:url_launcher/url_launcher.dart';

import 'temp/temp.dart';

class GiveHelpBody extends StatefulWidget {
  const GiveHelpBody({super.key});

  @override
  State<GiveHelpBody> createState() => _GiveHelpBodyState();
}

class _GiveHelpBodyState extends State<GiveHelpBody> {
  bool flagPoliceSound=false;
  late GoogleMapController mapController;
  AssetsAudioPlayer _assetsAudioPlayer = AssetsAudioPlayer.newPlayer();


  _launchNaverMap(String lat, String long) async{
    var encodedData = utf8.encode("목적지");
    var decodedData = "";
    for (int i = 0; i < encodedData.length; i++) {
      decodedData += '%' + encodedData[i].toRadixString(16);
    }
    // var url = "nmap://route/walk?dlat=${lat}&dlng=${long}&dname=$decodedData&appname=com.example.help_closing_frontend";
    var url = "nmap://route/walk?dlat=${lat}&dlng=${long}&appname=com.example.help_closing_frontend";

    await canLaunchUrl(Uri.parse(url)) ? await launchUrl(Uri.parse(url)) : Get.snackbar("지도 앱 오류", "네이버 지도 앱을 여는데 실패했습니다",backgroundColor: Colors.red);
  }


  void togglePoliceSoundFlag(){
    flagPoliceSound=!flagPoliceSound;
}

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


    _assetsAudioPlayer.open(
      Audio("assets/audios/police.mp3"),
      loopMode: LoopMode.single, //반복 여부 (LoopMode.none : 없음)
      autoStart: false, //자동 시작 여부
      showNotification: false, //스마트폰 알림 창에 띄울지 여부
    );
  }

  // getAddr(lat,long) async{
  //   //google api 위도 경도 -> 주소
  //   final url = 'https://maps.googleapis.com/maps/api/geocode/json?latlng=${lat},${long}&key=AIzaSyAVkF1MVwblmaf6a8hfP3aXDgtrS6V7UMI';
  //   var responseAddr=await http.get(Uri.parse(url));
  //   print("json body(위경도 -> 주소) : ${jsonDecode(responseAddr.body)}");
  //
  //   var addr='130-1+Cheongna-dong,+Seo-gu,+Incheon,+South+Korea';
  //   var responseLatLong=await  http.get(Uri.parse('https://maps.googleapis.com/maps/api/geocode/json?address=${addr}&key=AIzaSyAVkF1MVwblmaf6a8hfP3aXDgtrS6V7UMI'));
  //   print("json body(주소 -> 위도 경도) : ${jsonDecode(responseLatLong.body)}");
  // }

  getLocation() async {
    LocationPermission permission;
    permission = await Geolocator.requestPermission();

    // Position position = await Geolocator.getCurrentPosition(
    //     desiredAccuracy: LocationAccuracy.high);
    // double lat = position.latitude;
    // double long = position.longitude;
    // await getAddr(lat, long);

    double lat =37.504904929679796;
    double long = 126.95403171766152;
    LatLng location = LatLng(lat, long);


    setState((){
      _currentPosition = location;
      _isLoading = false;
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void _goToCurrentPosition() {
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
          _currentPosition != null ? GoogleMap(
              zoomControlsEnabled: false,
              onMapCreated: _onMapCreated,
              //
              markers: {
                Marker(
                  markerId: const MarkerId('내위치'),
                  position: _currentPosition!,
                ),
                Marker(
                    markerId: const MarkerId("중앙대학교 310관"),
                    position: const LatLng(37.50385146926803, 126.95590974755156),
                    icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen)
                ),
              },
              initialCameraPosition: CameraPosition(
                target: _currentPosition!,
                zoom: 16.0,
              )
          ) : const Center(child: CircularProgressIndicator()),
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
                child: const Icon(Icons.assistant),
                onPressed: (){
                  _showMenu();
                },
              )
          ),
          Positioned(
              right: 10,
              bottom: 130,
              child: FloatingActionButton(
                onPressed: () {
                  indirectHelp();
                },
                child: const Icon(Icons.add_alert_sharp),
              )
          ),
          Positioned(
            left: 10,
            bottom: 10,
            child: FloatingActionButton(
              onPressed: (){
                _launchNaverMap(_currentPosition!.latitude.toString(),_currentPosition!.longitude.toString());
              },
              child: const Icon(Icons.map_outlined),
            ),
          )
        ],
      ),
    );
  }
  
  Future _showMenu(){
    return showModalBottomSheet(context: context, builder: (context){
      return SizedBox(
        height: 180,
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Divider(indent: 200, endIndent: 200, thickness: 5,),
            const SizedBox(height: 20,),
            const Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Text("사고 발생 위치 : ",
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                      fontSize: 15
                    ),
                  ),
                ),
                Expanded(
                    child: Text("서울 동작구 흑석로 84 중앙대학교",
                    style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
                    )

                ),
              ],
            ),
            const SizedBox(height: 20,),
            const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Text("거리 : ",
                    style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                        fontSize: 15
                    ),
                  ),
                ),
                Expanded(
                    child: Text("400m",
                      style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
                    )

                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(onPressed: (){},
                    child: const Text("계약서 확인하기",style: TextStyle(color: Colors.blue, fontSize: 16),))
              ],
            )
          ],
        ),
      );
    });
  }

  Future indirectHelp() {
    return showModalBottomSheet(context: context, builder: (context) {
      return SizedBox(
          height: 400,
          width: MediaQuery
              .of(context)
              .size
              .width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("신고 접수 위치", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold,color: Colors.blue[300]),),
              Text("서울특별시 동작구 흑석로 84", style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold,color: Colors.blue[400]),),
              const SizedBox(height: 40,),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                  child: Row(
                      children: [
                        Card(
                            elevation: 50,
                            child: Column(
                              children: [
                                IconButton(onPressed: () {
                                  _assetsAudioPlayer.playOrPause();
                                },
                                    icon: const Icon(Icons.local_police),
                                  iconSize: 150,
                                ),
                                Text("사이렌 올리기",style: TextStyle(fontSize: 20, color: Colors.blue[600]),)
                              ],
                            )),
                        const SizedBox(width: 30,),
                        Card(
                            elevation: 50,
                            child: Column(
                              children: [
                                IconButton(onPressed: () async{
                                  final policeNumber = "112";
                                  await FlutterPhoneDirectCaller.callNumber(policeNumber);
                                },
                                    icon: const Icon(Icons.call),
                                  iconSize: 150,
                                ),
                                Text("경찰(112) 신고하기",style: TextStyle(fontSize: 20, color: Colors.blue[600]),)
                              ],
                            )),
                        const SizedBox(width: 30,),
                        Card(
                            elevation: 50,
                            child: Column(
                              children: [
                                IconButton(onPressed: () {},
                                    icon: const Icon(Icons.more_horiz),
                                  iconSize: 150,
                                ),
                                Text("등 등",style: TextStyle(fontSize: 20, color: Colors.blue[600]),)
                              ],
                            )),
                      ]
                  )
              ),
            ],
          )
      );
    }
    );
  }
}


