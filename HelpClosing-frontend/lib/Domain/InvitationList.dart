class Invitation {
  final String invitedEmail;
  final String invitedName;
  final int clossnessRank;

  Invitation({required this.invitedEmail, required this.invitedName, required this.clossnessRank});

  factory Invitation.fromJson(Map<String, dynamic> json) {
    return Invitation(
      invitedEmail: json['invitedEmail'],
      invitedName: json['invitedName'],
      clossnessRank: json['clossnessRank'],
    );
  }
}