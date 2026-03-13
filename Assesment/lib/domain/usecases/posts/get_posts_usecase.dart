import '../../repositories/posts_repository.dart';

class GetPostsUseCase {
  final PostsRepository repository;

  GetPostsUseCase(this.repository);

  Future<PostsResponse> call({
    required int skip,
    required int limit,
    String? token,
  }) {
    return repository.getPosts(
      skip: skip,
      limit: limit,
      token: token,
    );
  }
}
