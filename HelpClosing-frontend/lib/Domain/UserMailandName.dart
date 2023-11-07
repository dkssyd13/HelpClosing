class UserMailandName {
  final String email;
  final String name;
  final String nickName;
  final String image;

  UserMailandName({required this.email, required this.name, required this.nickName, required this.image});

  factory UserMailandName.fromJson(Map<String, dynamic> json) {
    return UserMailandName(
      email: json['email'],
      name: json['name'],
      nickName: json['nickName'],
      image: json['image'],
    );
  }
}