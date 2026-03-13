import 'package:equatable/equatable.dart';

abstract class ProductsEvent extends Equatable {
  const ProductsEvent();

  @override
  List<Object?> get props => [];
}

class FetchProductsEvent extends ProductsEvent {
  final int skip;
  final int limit;
  final String? token;

  const FetchProductsEvent({
    required this.skip,
    required this.limit,
    this.token,
  });

  @override
  List<Object?> get props => [skip, limit, token];
}

class LoadMoreProductsEvent extends ProductsEvent {
  final int skip;
  final int limit;
  final String? token;

  const LoadMoreProductsEvent({
    required this.skip,
    required this.limit,
    this.token,
  });

  @override
  List<Object?> get props => [skip, limit, token];
}
