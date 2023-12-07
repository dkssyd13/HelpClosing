import 'package:help_closing_frontend/Controller/Auth_Controller.dart';
import 'package:help_closing_frontend/ServerUrl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Invitation {
  final int ID;
  final String inviteEmail;
  String inviteName="";
  final int closenessRank;
  final double latitude;
  final double longitude;
  final String description;

  Invitation({required this.ID, required this.inviteEmail, required this.closenessRank,required this.latitude, required this.longitude, required this.description});

  factory Invitation.fromJson(Map<String, dynamic> json) {
    return Invitation(
      ID: json['invitationId'],
      inviteEmail: json['invitePerson'],
      closenessRank: json['closenessRank'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      description: json['briefDescription'],
    );
  }
}