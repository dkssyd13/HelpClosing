import 'package:help_closing_frontend/Domain/Location.dart';
import 'package:help_closing_frontend/Domain/Pledge.dart';
import 'package:help_closing_frontend/Domain/User.dart';

class HelpLog {
  final int id;
  final String time;
  final User requester;
  final User recipient;
  final Pledge pledgeRequest;
  final Pledge pledgeRecipient;
  // final String pledgeRequestImg;
  // final String pledgeRecipientImg;
  final Location location;

  HelpLog({
    required this.id,
    required this.time,
    required this.requester,
    required this.recipient,
    required this.pledgeRequest,
    required this.pledgeRecipient,
    // required this.pledgeRecipientImg,
    // required this.pledgeRequestImg,
    required this.location,
  });

  factory HelpLog.fromJson(Map<String, dynamic> json) {
    return HelpLog(
      id: json['id'],
      time: json['time'],
      requester: User.fromJson(json['requester']),
      recipient: User.fromJson(json['recipient']),
      pledgeRequest: Pledge.fromJson(json['pledgeRequest']),
      pledgeRecipient: Pledge.fromJson(json['pledgeRecipient']),
      location: Location.fromJson(json['location']),
    );
  }
}
