import '../../core/utils/exceptions.dart';
import '../../domain/repositories/products_repository.dart';
import '../datasources/remote/products_remote_datasource.dart';

class ProductsRepositoryImpl implements ProductsRepository {
  final ProductsRemoteDataSource remoteDataSource;

  ProductsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<ProductsResponse> getProducts({
    required int skip,
    required int limit,
    String? token,
  }) async {
    try {
      final response = await remoteDataSource.getProducts(
        skip: skip,
        limit: limit,
        token: token,
      );

      return ProductsResponse(
        items: response.items,
        total: response.total,
        skip: response.skip,
        limit: response.limit,
      );
    } on AppException {
      rethrow;
    } catch (e) {
      throw ServerException(
        message: 'Failed to fetch products',
        originalError: e,
      );
    }
  }
}
