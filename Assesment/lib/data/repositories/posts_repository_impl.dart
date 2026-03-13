import '../../core/utils/exceptions.dart';
import '../../domain/repositories/posts_repository.dart';
import '../datasources/remote/posts_remote_datasource.dart';

class PostsRepositoryImpl implements PostsRepository {
  final PostsRemoteDataSource remoteDataSource;

  PostsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<PostsResponse> getPosts({
    required int skip,
    required int limit,
    String? token,
  }) async {
    try {
      final response = await remoteDataSource.getPosts(
        skip: skip,
        limit: limit,
        token: token,
      );

      return PostsResponse(
        items: response.items,
        total: response.total,
        skip: response.skip,
        limit: response.limit,
      );
    } on AppException {
      rethrow;
    } catch (e) {
      throw ServerException(
        message: 'Failed to fetch posts',
        originalError: e,
      );
    }
  }
}
