import 'dart:convert';

class Notes {
  final int? id;
  final String title;
  final String description;
  final String time;

  Notes({this.id, required this.title, required this.description, required this.time});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'time': time
    };
  }

  factory Notes.fromMap(Map<String, dynamic> map) {
    return Notes(
      id: map['id']?.toInt() ?? 0,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      time: map['time'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Notes.fromJson(String source) => Notes.fromMap(json.decode(source));

}