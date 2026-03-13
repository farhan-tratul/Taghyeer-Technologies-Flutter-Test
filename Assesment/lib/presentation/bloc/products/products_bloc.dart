import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/utils/exceptions.dart';
import '../../../domain/usecases/products/get_products_usecase.dart';
import 'products_event.dart';
import 'products_state.dart';

class ProductsBloc extends Bloc<ProductsEvent, ProductsState> {
  final GetProductsUseCase getProductsUseCase;

  ProductsBloc({required this.getProductsUseCase})
      : super(const ProductsInitial()) {
    on<FetchProductsEvent>(_onFetchProducts);
    on<LoadMoreProductsEvent>(_onLoadMoreProducts);
  }

  Future<void> _onFetchProducts(
    FetchProductsEvent event,
    Emitter<ProductsState> emit,
  ) async {
    emit(const ProductsLoading());
    try {
      final response = await getProductsUseCase(
        skip: event.skip,
        limit: event.limit,
        token: event.token,
      );

      if (response.items.isEmpty) {
        emit(const ProductsEmpty());
      } else {
        final hasMoreData = (event.skip + event.limit) < response.total;
        emit(ProductsLoaded(
          products: response.items,
          total: response.total,
          skip: event.skip,
          limit: event.limit,
          hasMoreData: hasMoreData,
        ));
      }
    } on AppException catch (e) {
      emit(ProductsError(message: e.message));
    } catch (e) {
      emit(ProductsError(message: 'Failed to load products'));
    }
  }

  Future<void> _onLoadMoreProducts(
    LoadMoreProductsEvent event,
    Emitter<ProductsState> emit,
  ) async {
    if (state is ProductsLoaded) {
      final currentState = state as ProductsLoaded;
      
      if (!currentState.hasMoreData) {
        return;
      }

      emit(ProductsPaginationLoading(
        products: currentState.products,
        total: currentState.total,
        skip: currentState.skip,
        limit: currentState.limit,
      ));

      try {
        final response = await getProductsUseCase(
          skip: event.skip,
          limit: event.limit,
          token: event.token,
        );

        final allProducts = [...currentState.products, ...response.items];
        final hasMoreData = (event.skip + event.limit) < response.total;

        emit(ProductsLoaded(
          products: allProducts,
          total: response.total,
          skip: event.skip,
          limit: event.limit,
          hasMoreData: hasMoreData,
        ));
      } on AppException catch (e) {
        emit(ProductsError(
          message: e.message,
          previousProducts: currentState.products,
        ));
      } catch (e) {
        emit(ProductsError(
          message: 'Failed to load more products',
          previousProducts: currentState.products,
        ));
      }
    }
  }
}
