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