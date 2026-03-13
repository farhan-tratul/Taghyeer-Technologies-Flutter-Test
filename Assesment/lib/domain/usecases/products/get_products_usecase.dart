import '../../repositories/products_repository.dart';

class GetProductsUseCase {
  final ProductsRepository repository;

  GetProductsUseCase(this.repository);

  Future<ProductsResponse> call({
    required int skip,
    required int limit,
    String? token,
  }) {
    return repository.getProducts(
      skip: skip,
      limit: limit,
      token: token,
    );
  }
}
