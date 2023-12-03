class ChatMessageResponse {
  String message;
  DateTime chatDate;
  String name;
  String nickName;
  String email;
  String image;

  ChatMessageResponse({
    required this.message,
    required this.chatDate,
    required this.name,
    required this.nickName,
    required this.email,
    required this.image,
  });

  factory ChatMessageResponse.fromJson(Map<String, dynamic> json) {
    var name = '';
    if (json['name']!=null){
      name=json['name'];
    }
    var chatDate = json['chatDate'];
    var chatDateString = "${chatDate[0]}-${chatDate[1].toString().padLeft(2, '0')}-${chatDate[2].toString().padLeft(2, '0')} ${chatDate[3].toString().padLeft(2, '0')}:${chatDate[4].toString().padLeft(2, '0')}:${chatDate[5].toString().padLeft(2, '0')}";

    var image = 'https://th.bing.com/th/id/R.f29406735baf0861647a78ae9c4bf5af?rik=GKTBhov2iZge9Q&riu=http%3a%2f%2fcdn.onlinewebfonts.com%2fsvg%2fimg_206976.png&ehk=gCH45Zmryw3yqyqG%2fhd8WDQ53zwYfmC8K9OIkNHP%2fNU%3d&risl=&pid=ImgRaw&r=0';
    if (json['image']!=null){
      image=json['image'];
    }
    return ChatMessageResponse(
      message: json['message'],
      chatDate: DateTime.parse(chatDateString),
      name: name,
      nickName: json['nickName'],
      email: json['email'],
      image: image,
    );
  }
}