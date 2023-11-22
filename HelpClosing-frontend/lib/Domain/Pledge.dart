class Pledge {
  final int id;
  final String name;

  Pledge({required this.id, required this.name});

  factory Pledge.fromJson(Map<String, dynamic> json) {
    return Pledge(
      id: json['id'],
      name: json['name'],
    );
  }
}