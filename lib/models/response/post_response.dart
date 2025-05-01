class PostResponse {
  final int id;
  final int userId;
  final String title;
  final String body;
  String? userName;

  PostResponse({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
    this.userName,
  });

  factory PostResponse.fromJson(Map<String, dynamic> json) {
    return PostResponse(
      id: json['id'],
      userId: json['userId'],
      title: json['title'],
      body: json['body'],
    );
  }
}
