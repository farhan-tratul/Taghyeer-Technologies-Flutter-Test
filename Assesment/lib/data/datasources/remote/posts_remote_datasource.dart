import '../../../core/constants/api_constants.dart';
import '../../../core/network/api_client.dart';
import '../../models/pagination_response_model.dart';
import '../../models/post_model.dart';

abstract class PostsRemoteDataSource {
  Future<PaginationResponseModel<PostModel>> getPosts({
    required int skip,
    required int limit,
    String? token,
  });
}

class PostsRemoteDataSourceImpl implements PostsRemoteDataSource {
  final ApiClient apiClient;

  PostsRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<PaginationResponseModel<PostModel>> getPosts({
    required int skip,
    required int limit,
    String? token,
  }) async {
    final response = await apiClient.get(
      endpoint: '${ApiConstants.postsEndpoint}?limit=$limit&skip=$skip',
      token: token,
    );

    final posts = (response['posts'] as List)
        .map((json) => PostModel.fromJson(json as Map<String, dynamic>))
        .toList();

    return PaginationResponseModel(
      total: response['total'] as int,
      skip: response['skip'] as int,
      limit: response['limit'] as int,
      items: posts,
    );
  }
}
