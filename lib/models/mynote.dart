class MyNote {
  final String id;
  final String title;
  final String content;
  final DateTime createdAt;

  MyNote({
    required this.id,
    required this.title,
    required this.content,
    required this.createdAt,
  });

  factory MyNote.fromMap(String id, Map<String, dynamic> map) {
    return MyNote(
      id: id,
      title: map['title'] ?? '',
      content: map['content'] ?? '',
      createdAt: DateTime.tryParse(map['created_at'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'content': content,
      'created_at': createdAt.toIso8601String(),
    };
  }
}