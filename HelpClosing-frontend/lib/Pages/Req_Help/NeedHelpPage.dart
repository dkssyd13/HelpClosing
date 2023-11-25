
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_routes/google_maps_routes.dart';


class NeedHelpBody extends StatefulWidget {
  const NeedHelpBody({super.key});

  @override
  State<NeedHelpBody> createState() => _NeedHelpBodyState();
}

class _NeedHelpBodyState extends State<NeedHelpBody> {
  late GoogleMapController mapController;

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

  getLocation() async {
    LocationPermission permission;
    permission = await Geolocator.requestPermission();

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    double lat = position.latitude;
    double long = position.longitude;

    LatLng location = LatLng(lat, long);

    setState(() {
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
          _isLoading ? const Center(child: CircularProgressIndicator()) :
          _currentPosition != null ? GoogleMap(
              zoomControlsEnabled: false,
              onMapCreated: _onMapCreated,
              polylines: route.routes,
              //
              markers: {
                Marker(
                markerId: const MarkerId('내위치'),
                position: _currentPosition!,
              ),
                // Marker(
                //   markerId: const MarkerId("중앙대학교 310관"),
                //   position: const LatLng(37.504815334545874, 126.95534935119163),
                //   icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen)
                // ),
              },
              initialCameraPosition: CameraPosition(
                target: _currentPosition!,
                zoom: 16.0,
              )
          ) : Container(),
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
                // onPressed: () async {
                //   await route.drawRoute(points, 'Test routes',
                //       const Color.fromRGBO(130, 78, 210, 1.0),
                //       travelMode: TravelModes.walking);
                //   setState(() {
                //     totalDistance =
                //         distanceCalculator.calculateRouteDistance(points, decimals: 1);
                //   });
                // },
                child: const Icon(Icons.note_alt_sharp),
                onPressed: (){
                  // showModalBottomSheet(context: context, builder: (context){
                  //   return SizedBox(
                  //     height: 400,
                  //     width: MediaQuery.of(context).size.width,
                  //     child: Column(
                  //       mainAxisAlignment: MainAxisAlignment.spaceAround,
                  //       children: [
                  //         ElevatedButton(
                  //             style: ElevatedButton.styleFrom(backgroundColor: Colors.green,elevation: 50,shadowColor: myColorDark),
                  //             onPressed: () {
                  //             },
                  //             child: SizedBox(
                  //                 width: MediaQuery.of(context).size.width * 0.8,
                  //                 height: 50,
                  //                 child: const Center(
                  //                   child: Text("도움 요청 됐습니다! 조금만 기다려주세요~!",style: TextStyle(fontWeight: FontWeight.w800,fontSize: 20,color: Colors.white),),
                  //                 )
                  //             )
                  //         ),
                  //         ElevatedButton(
                  //             style: ElevatedButton.styleFrom(elevation: 20,shadowColor: myColorDark),
                  //             onPressed: (){
                  //               showModalBottomSheet(context: context, builder: (context) {
                  //                 return SizedBox(
                  //                   height: 200,
                  //                   width: MediaQuery.of(context).size.width,
                  //                   child: const Center(
                  //                     child: Text("상태를 입력하세요"),
                  //                   ),
                  //                 );
                  //               });
                  //             },
                  //             child: SizedBox(
                  //                 width: MediaQuery.of(context).size.width * 0.8,
                  //                 height: 50,
                  //                 child: const Center(
                  //                   child: Text("상태 전달하기",style: TextStyle(fontWeight: FontWeight.w800,fontSize: 20),),
                  //                 )
                  //             )
                  //         ),
                  //         ElevatedButton(
                  //             style: ElevatedButton.styleFrom(elevation: 20,shadowColor: myColorDark),
                  //             onPressed: (){},
                  //             child: SizedBox(
                  //                 width: MediaQuery.of(context).size.width * 0.8,
                  //                 height: 50,
                  //                 child: const Center(
                  //                   child: Text("요청 대상 선택하기",style: TextStyle(fontWeight: FontWeight.w800,fontSize: 20),),
                  //                 )
                  //             )
                  //         ),
                  //         ElevatedButton(
                  //             style: ElevatedButton.styleFrom(elevation: 20,shadowColor: myColorDark),
                  //             onPressed: (){},
                  //             child: SizedBox(
                  //                 width: MediaQuery.of(context).size.width * 0.8,
                  //                 height: 50,
                  //                 child: const Center(
                  //                   child: Text("비상 연락망 연락",style: TextStyle(fontWeight: FontWeight.w800,fontSize: 20),),
                  //                 )
                  //             )
                  //         )
                  //       ],
                  //     ),
                  //   );
                  // });
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
                      child: Text("도움 요청 됐습니다! 조금만 기다려주세요~!",style: TextStyle(fontWeight: FontWeight.w800,fontSize: 20,color: Colors.white),),
                    )
                )
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(elevation: 20,shadowColor: myColorDark),
                onPressed: (){
                  showModalBottomSheet(context: context, builder: (context) {
                    return SizedBox(
                      height: 200,
                      width: MediaQuery.of(context).size.width,
                      child: const Center(
                        child: Text("상태를 입력하세요"),
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
    });
  }

}



