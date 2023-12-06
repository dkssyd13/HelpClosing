import 'dart:convert';
import 'package:help_closing_frontend/Domain/Location.dart';

List<User> userFromJson(String str) => List<User>.from(json.decode(str).map((x) => User.fromJson(x)));

String userToJson(List<User> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class User {
  String _id;
  String _name;
  String _email;
  String _nickname;
  String? _image; //사진
  Location? _location;
  String? _address;


  String get id => _id;

  User({
    required String id,
    required String name,
    required String email,
    required String nickname,
    String? image,
    Location? location,
    String? address,
  })  : _id = id,
        _name = name,
        _email = email,
        _nickname = nickname,
        _image = image,
        _location = location,
        _address = address;


  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"].toString(),
    name: json["name"],
    email: json["email"],
    nickname: json["nickName"],
    // image: json["profile"],
    // location: Location.fromJson(json["location"]),
    // address: json["address"],
  );

  Map<String, dynamic> toJson() => {
    "id": _id,
    "name": _name,
    "email": _email,
    "nickname": _nickname,
    "image": _image,
    "location": _location?.toJson(),
    "address": _address,
  };

  String get name => _name;

  String get email => _email;

  String get nickname => _nickname;

  String? get image => _image;

  Location? get location => _location;

  String? get address => _address;
}


