import 'dart:convert';

List<User> userFromJson(String str) => List<User>.from(json.decode(str).map((x) => User.fromJson(x)));

String userToJson(List<User> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class User {
  String? id;
  String? name;
  String? email;
  String? nickname;
  String? profile; //사진
  Location? location;
  String? address;



  User({
    required this.id,
    required this.name,
    required this.email,
    required this.nickname,
    required this.profile,
    required this.location,
    required this.address,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    name: json["name"],
    email: json["email"],
    nickname: json["nickname"],
    profile: json["profile"],
    location: Location.fromJson(json["location"]),
    address: json["address"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
    "nickname": nickname,
    "profile": profile,
    "location": location?.toJson(),
    "address": address,
  };
}

class Location {
  String description;
  double latitude;
  double longitude;

  Location({
    required this.description,
    required this.latitude,
    required this.longitude,
  });

  factory Location.fromJson(Map<String, dynamic> json) => Location(
    description: json["description"],
    latitude: json["latitude"]?.toDouble(),
    longitude: json["longitude"]?.toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "description": description,
    "latitude": latitude,
    "longitude": longitude,
  };
}
