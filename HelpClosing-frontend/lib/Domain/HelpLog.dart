import 'package:help_closing_frontend/Domain/Location.dart';
import 'package:help_closing_frontend/Domain/Pledge.dart';
import 'package:help_closing_frontend/Domain/User.dart';

class HelpLog {
  final int id;
  final String time;
  final User requester;
  final User recipient;
  Location? location;

  HelpLog({
    required this.id,
    required this.time,
    required this.requester,
    required this.recipient,
    this.location,
  });

  factory HelpLog.fromJson(Map<String, dynamic> json) {


    return HelpLog(
      id: json['id'],
      time: (json['time'] as List).join('-'),
      requester: User.fromJson(json['requester']),
      recipient: User.fromJson(json['recipient']),
      location: json['location'] != null ? Location.fromJson(json['location']) : null,
    );
  }
}
