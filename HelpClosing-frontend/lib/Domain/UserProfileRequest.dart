class UserProfileRequest {
  final String name;
  final String nickName;
  final String image;

  UserProfileRequest({required this.name, required this.nickName, required this.image});

  Map<String, dynamic> toJson() => {
    'name': name,
    'nickName': nickName,
    'image': image,
  };
}