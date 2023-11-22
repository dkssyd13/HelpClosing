import 'dart:convert';
import 'package:help_closing_frontend/Domain/Location.dart';

List<User> userFromJson(String str) => List<User>.from(json.decode(str).map((x) => User.fromJson(x)));

String userToJson(List<User> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class User {
  String? id;
  String? name;
  String? email;
  String? nickname;
  String? image; //사진
  Location? location;
  String? address;



  User({
    required this.id,
    required this.name,
    required this.email,
    required this.nickname,
    required this.image,
    required this.location,
    required this.address,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    name: json["name"],
    email: json["email"],
    nickname: json["nickname"],
    image: json["profile"],
    location: Location.fromJson(json["location"]),
    address: json["address"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
    "nickname": nickname,
    "image": image,
    "location": location?.toJson(),
    "address": address,
  };
}


