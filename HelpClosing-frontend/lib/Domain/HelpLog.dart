import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:help_closing_frontend/Domain/Location.dart';
import 'package:help_closing_frontend/Domain/Pledge.dart';
import 'package:help_closing_frontend/Domain/User.dart';

class HelpLog {
  final int id;
  final String time;
  final User requester;
  final User recipient;
  final double latitude;
  final double longitude;

  HelpLog({
    required this.id,
    required this.time,
    required this.requester,
    required this.recipient,
    required this.latitude,
    required this.longitude
  });

  factory HelpLog.fromJson(Map<String, dynamic> json) {
    var dateList = json['time'];
    String dateStr = "${dateList[0]}-${dateList[1].toString().padLeft(2, '0')}-${dateList[2].toString().padLeft(2, '0')} ${dateList[3].toString().padLeft(2, '0')}:${dateList[4].toString().padLeft(2, '0')}:${dateList[5].toString().padLeft(2, '0')}";
    return HelpLog(
      id: json['id'],
      time: dateStr,
      requester: User.fromJson(json['requester']),
      recipient: User.fromJson(json['recipient']),
      latitude: json['latitude'],
      longitude: json['longitude']
    );
  }
}
