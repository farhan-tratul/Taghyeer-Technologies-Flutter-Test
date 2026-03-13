import '../entities/product.dart';

class ProductsResponse {
  final List<Product> items;
  final int total;
  final int skip;
  final int limit;

  ProductsResponse({
    required this.items,
    required this.total,
    required this.skip,
    required this.limit,
  });
}

abstract class ProductsRepository {
  Future<ProductsResponse> getProducts({
    required int skip,
    required int limit,
    String? token,
  });
}
