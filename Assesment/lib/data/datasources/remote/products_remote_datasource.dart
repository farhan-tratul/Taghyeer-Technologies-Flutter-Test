import '../../../core/constants/api_constants.dart';
import '../../../core/network/api_client.dart';
import '../../models/pagination_response_model.dart';
import '../../models/product_model.dart';

abstract class ProductsRemoteDataSource {
  Future<PaginationResponseModel<ProductModel>> getProducts({
    required int skip,
    required int limit,
    String? token,
  });
}

class ProductsRemoteDataSourceImpl implements ProductsRemoteDataSource {
  final ApiClient apiClient;

  ProductsRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<PaginationResponseModel<ProductModel>> getProducts({
    required int skip,
    required int limit,
    String? token,
  }) async {
    final response = await apiClient.get(
      endpoint: '${ApiConstants.productsEndpoint}?limit=$limit&skip=$skip',
      token: token,
    );

    final products = (response['products'] as List)
        .map((json) => ProductModel.fromJson(json as Map<String, dynamic>))
        .toList();

    return PaginationResponseModel(
      total: response['total'] as int,
      skip: response['skip'] as int,
      limit: response['limit'] as int,
      items: products,
    );
  }
}
