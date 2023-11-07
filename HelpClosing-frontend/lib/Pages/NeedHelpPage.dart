import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_routes/google_maps_routes.dart';

class NeedHelpBody extends StatefulWidget {
  NeedHelpBody({super.key});

  @override
  State<NeedHelpBody> createState() => _NeedHelpBodyState();
}

class _NeedHelpBodyState extends State<NeedHelpBody> {
  late GoogleMapController mapController;

  //위치 예시
  List<LatLng> points = [
    LatLng(37.499449, 126.971902),
  ];

  MapsRoutes route=new MapsRoutes();

  //거리 계산기??암튼
  DistanceCalculator distanceCalculator = new DistanceCalculator();
  String totalDistance= 'No route';

  LatLng? _currentPosition;
  bool _isLoading=true;

  @override
  void initState(){
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

  // @override
  // Widget build(BuildContext context) {
  //   return SafeArea(
  //       child: _isLoading ?
  //       Center(child: CircularProgressIndicator()) :
  //       _currentPosition != null ? GoogleMap( // _currentPosition이 null이 아닐 때만 GoogleMap을 렌더링
  //           onMapCreated: _onMapCreated,
  //           markers: {Marker(
  //             markerId: MarkerId('내위치'),
  //             position: _currentPosition!,
  //           )},
  //           initialCameraPosition: CameraPosition(
  //             target: _currentPosition!,
  //             zoom: 16.0,),
  //       ) : Container()); // _currentPosition이 null일 경우에는 빈 컨테이너 렌더링
  // }
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          _isLoading ? Center(child: CircularProgressIndicator()) :
          _currentPosition != null ? GoogleMap(
              onMapCreated: _onMapCreated,
              polylines: route.routes, //
              markers: {Marker(
                markerId: MarkerId('내위치'),
                position: _currentPosition!,
              )},
              initialCameraPosition: CameraPosition(
                target: _currentPosition!,
                zoom: 16.0,
              )
          ) : Container(),
          Positioned(
            left: 10,
            bottom: 10,
            child: FloatingActionButton(
              child: Icon(Icons.location_searching),
              onPressed: _goToCurrentPosition,
            ),
          ),
        ],
      ),
    );
  }
}



