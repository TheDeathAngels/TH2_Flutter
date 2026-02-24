import 'dart:convert';

class Note {
  final String id;
  final String title;
  final String content;
  final DateTime modifiedAt;

  Note({String? id, required this.title, required this.content, DateTime? modifiedAt})
      : id = id ?? DateTime.now().microsecondsSinceEpoch.toString(),
        modifiedAt = modifiedAt ?? DateTime.now();

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'content': content,
        'modifiedAt': modifiedAt.toIso8601String(),
      };

  factory Note.fromJson(Map<String, dynamic> json) => Note(
        id: json['id'] as String?,
        title: json['title'] as String? ?? '',
        content: json['content'] as String? ?? '',
        modifiedAt: json['modifiedAt'] != null
            ? DateTime.parse(json['modifiedAt'] as String)
            : DateTime.now(),
      );

  static List<Note> listFromJson(String jsonStr) {
    final data = json.decode(jsonStr) as List<dynamic>;
    return data.map((e) => Note.fromJson(e as Map<String, dynamic>)).toList();
  }

  static String listToJson(List<Note> notes) => json.encode(notes.map((n) => n.toJson()).toList());
}
