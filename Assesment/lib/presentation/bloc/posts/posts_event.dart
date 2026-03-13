import 'package:equatable/equatable.dart';

abstract class PostsEvent extends Equatable {
  const PostsEvent();

  @override
  List<Object?> get props => [];
}

class FetchPostsEvent extends PostsEvent {
  final int skip;
  final int limit;
  final String? token;

  const FetchPostsEvent({
    required this.skip,
    required this.limit,
    this.token,
  });

  @override
  List<Object?> get props => [skip, limit, token];
}

class LoadMorePostsEvent extends PostsEvent {
  final int skip;
  final int limit;
  final String? token;

  const LoadMorePostsEvent({
    required this.skip,
    required this.limit,
    this.token,
  });

  @override
  List<Object?> get props => [skip, limit, token];
}
