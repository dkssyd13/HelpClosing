class LocationResponse {
  final String userEmail;
  final double latitude;
  final double longitude;
  final int closenessRank;

  LocationResponse({
    required this.userEmail,
    required this.latitude,
    required this.longitude,
    required this.closenessRank,
  });

  factory LocationResponse.fromJson(Map<String, dynamic> json) {
    return LocationResponse(
      userEmail: json['userEmail'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      closenessRank: json['closenessRank'],
    );
  }
}
