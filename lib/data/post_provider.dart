import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/response/post_response.dart';

class PostProvider {
  Future<List<PostResponse>> fetchPosts() async {
    final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/posts'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List;
      return data.map((e) => PostResponse.fromJson(e)).toList();
    } else {
      throw Exception('Gagal mengambil data');
    }
  }
}
