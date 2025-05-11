import '../data/post_provider.dart';
import '../models/response/post_response.dart';

class PostRepository {
  final PostProvider provider;
  PostRepository(this.provider);

  Future<List<PostResponse>> getPosts() => provider.fetchPosts();
}
