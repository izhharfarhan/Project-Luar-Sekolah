import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/response/post_response.dart';
import '../models/response/user_response.dart';

class PostApi {
  static const String baseUrl = 'https://jsonplaceholder.typicode.com';

  static Future<List<PostResponse>> fetchPosts() async {
    final postsResponse = await http.get(Uri.parse('$baseUrl/posts'));
    final usersResponse = await http.get(Uri.parse('$baseUrl/users'));

    if (postsResponse.statusCode == 200 && usersResponse.statusCode == 200) {
      final postsJson = jsonDecode(postsResponse.body);
      final usersJson = jsonDecode(usersResponse.body);

      final users = usersJson.map<UserResponse>((u) => UserResponse.fromJson(u)).toList();

      return postsJson.map<PostResponse>((p) {
        final post = PostResponse.fromJson(p);
        final user = users.firstWhere((u) => u.id == post.userId, orElse: () => UserResponse(id: 0, name: 'Tidak diketahui'));
        post.userName = user.name;
        return post;
      }).toList();
    } else {
      throw Exception('Gagal mengambil data dari API');
    }
  }
}
