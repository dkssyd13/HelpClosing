
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_routes/google_maps_routes.dart';
import 'package:help_closing_frontend/Controller/Help_Controller.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class NeedHelpBody extends StatefulWidget {
  const NeedHelpBody({super.key});

  @override
  State<NeedHelpBody> createState() => _NeedHelpBodyState();
}

class _NeedHelpBodyState extends State<NeedHelpBody> {
  late GoogleMapController mapController;
  final HelpController _helpController = Get.put(HelpController());
  TextEditingController _currentStateController = TextEditingController();

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

  getAddr(lat,long) async{
    //google api 위도 경도 -> 주소
    final url = 'https://maps.googleapis.com/maps/api/geocode/json?latlng=${lat},${long}&key=AIzaSyAVkF1MVwblmaf6a8hfP3aXDgtrS6V7UMI';
    var responseAddr=await http.get(Uri.parse(url));
    print("json body(위경도 -> 주소) : ${jsonDecode(responseAddr.body)}");

    var addr='130-1+Cheongna-dong,+Seo-gu,+Incheon,+South+Korea';
    var responseLatLong=await  http.get(Uri.parse('https://maps.googleapis.com/maps/api/geocode/json?address=${addr}&key=AIzaSyAVkF1MVwblmaf6a8hfP3aXDgtrS6V7UMI'));
    print("json body(주소 -> 위도 경도) : ${jsonDecode(responseLatLong.body)}");
  }

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
                                  onPressed: (){},
                                  icon: const Icon(Icons.send),
                                ),
                                hintText: "현재 상태를 입력해주세요",
                              ),
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
    });
  }

}



