import '../entities/post.dart';

class PostsResponse {
  final List<Post> items;
  final int total;
  final int skip;
  final int limit;

  PostsResponse({
    required this.items,
    required this.total,
    required this.skip,
    required this.limit,
  });
}

abstract class PostsRepository {
  Future<PostsResponse> getPosts({
    required int skip,
    required int limit,
    String? token,
  });
}
