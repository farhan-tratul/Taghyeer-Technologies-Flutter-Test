import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/utils/exceptions.dart';
import '../../../domain/usecases/posts/get_posts_usecase.dart';
import 'posts_event.dart';
import 'posts_state.dart';

class PostsBloc extends Bloc<PostsEvent, PostsState> {
  final GetPostsUseCase getPostsUseCase;

  PostsBloc({required this.getPostsUseCase})
      : super(const PostsInitial()) {
    on<FetchPostsEvent>(_onFetchPosts);
    on<LoadMorePostsEvent>(_onLoadMorePosts);
  }

  Future<void> _onFetchPosts(
    FetchPostsEvent event,
    Emitter<PostsState> emit,
  ) async {
    emit(const PostsLoading());
    try {
      final response = await getPostsUseCase(
        skip: event.skip,
        limit: event.limit,
        token: event.token,
      );

      if (response.items.isEmpty) {
        emit(const PostsEmpty());
      } else {
        final hasMoreData = (event.skip + event.limit) < response.total;
        emit(PostsLoaded(
          posts: response.items,
          total: response.total,
          skip: event.skip,
          limit: event.limit,
          hasMoreData: hasMoreData,
        ));
      }
    } on AppException catch (e) {
      emit(PostsError(message: e.message));
    } catch (e) {
      emit(PostsError(message: 'Failed to load posts'));
    }
  }

  Future<void> _onLoadMorePosts(
    LoadMorePostsEvent event,
    Emitter<PostsState> emit,
  ) async {
    if (state is PostsLoaded) {
      final currentState = state as PostsLoaded;
      
      if (!currentState.hasMoreData) {
        return;
      }

      emit(PostsPaginationLoading(
        posts: currentState.posts,
        total: currentState.total,
        skip: currentState.skip,
        limit: currentState.limit,
      ));

      try {
        final response = await getPostsUseCase(
          skip: event.skip,
          limit: event.limit,
          token: event.token,
        );

        final allPosts = [...currentState.posts, ...response.items];
        final hasMoreData = (event.skip + event.limit) < response.total;

        emit(PostsLoaded(
          posts: allPosts,
          total: response.total,
          skip: event.skip,
          limit: event.limit,
          hasMoreData: hasMoreData,
        ));
      } on AppException catch (e) {
        emit(PostsError(
          message: e.message,
          previousPosts: currentState.posts,
        ));
      } catch (e) {
        emit(PostsError(
          message: 'Failed to load more posts',
          previousPosts: currentState.posts,
        ));
      }
    }
  }
}
