import 'package:equatable/equatable.dart';
import '../../../domain/entities/post.dart';

abstract class PostsState extends Equatable {
  const PostsState();

  @override
  List<Object?> get props => [];
}

class PostsInitial extends PostsState {
  const PostsInitial();
}

class PostsLoading extends PostsState {
  const PostsLoading();
}

class PostsLoaded extends PostsState {
  final List<Post> posts;
  final int total;
  final int skip;
  final int limit;
  final bool hasMoreData;

  const PostsLoaded({
    required this.posts,
    required this.total,
    required this.skip,
    required this.limit,
    required this.hasMoreData,
  });

  @override
  List<Object?> get props => [posts, total, skip, limit, hasMoreData];
}

class PostsPaginationLoading extends PostsState {
  final List<Post> posts;
  final int total;
  final int skip;
  final int limit;

  const PostsPaginationLoading({
    required this.posts,
    required this.total,
    required this.skip,
    required this.limit,
  });

  @override
  List<Object?> get props => [posts, total, skip, limit];
}

class PostsError extends PostsState {
  final String message;
  final List<Post>? previousPosts;

  const PostsError({
    required this.message,
    this.previousPosts,
  });

  @override
  List<Object?> get props => [message, previousPosts];
}

class PostsEmpty extends PostsState {
  const PostsEmpty();
}
