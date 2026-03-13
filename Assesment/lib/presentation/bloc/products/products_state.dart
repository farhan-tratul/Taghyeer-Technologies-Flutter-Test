import 'package:equatable/equatable.dart';
import '../../../domain/entities/product.dart';

abstract class ProductsState extends Equatable {
  const ProductsState();

  @override
  List<Object?> get props => [];
}

class ProductsInitial extends ProductsState {
  const ProductsInitial();
}

class ProductsLoading extends ProductsState {
  const ProductsLoading();
}

class ProductsLoaded extends ProductsState {
  final List<Product> products;
  final int total;
  final int skip;
  final int limit;
  final bool hasMoreData;

  const ProductsLoaded({
    required this.products,
    required this.total,
    required this.skip,
    required this.limit,
    required this.hasMoreData,
  });

  @override
  List<Object?> get props => [products, total, skip, limit, hasMoreData];
}

class ProductsPaginationLoading extends ProductsState {
  final List<Product> products;
  final int total;
  final int skip;
  final int limit;

  const ProductsPaginationLoading({
    required this.products,
    required this.total,
    required this.skip,
    required this.limit,
  });

  @override
  List<Object?> get props => [products, total, skip, limit];
}

class ProductsError extends ProductsState {
  final String message;
  final List<Product>? previousProducts;

  const ProductsError({
    required this.message,
    this.previousProducts,
  });

  @override
  List<Object?> get props => [message, previousProducts];
}

class ProductsEmpty extends ProductsState {
  const ProductsEmpty();
}
