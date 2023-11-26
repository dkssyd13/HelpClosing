class ChatMessageResponse {
  String message;
  DateTime chatDate;
  int chatRoomId;
  String name;
  String nickName;
  String email;
  String image;

  ChatMessageResponse({
    required this.message,
    required this.chatDate,
    required this.chatRoomId,
    required this.name,
    required this.nickName,
    required this.email,
    required this.image,
  });



  factory ChatMessageResponse.fromJson(Map<String, dynamic> json) {
    return ChatMessageResponse(
      message: json['message'],
      chatDate: DateTime.parse(json['chatDate']),
      chatRoomId: json['chatRoomId'],
      name: json['name'],
      nickName: json['nickName'],
      email: json['email'],
      image: json['image'],
    );
  }
}