import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/api_constants.dart';
import '../../../presentation/bloc/posts/posts_bloc.dart';
import '../../../presentation/bloc/posts/posts_event.dart';
import '../../../presentation/bloc/posts/posts_state.dart';
import '../../widgets/common/error_widget.dart';
import '../../widgets/common/empty_state_widget.dart';
import '../../widgets/common/loading_widget.dart';

class PostsScreen extends StatefulWidget {
  const PostsScreen({Key? key}) : super(key: key);

  @override
  State<PostsScreen> createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
  late ScrollController _scrollController;
  String? _userToken;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
    
    // Load initial posts
    Future.microtask(() {
      context.read<PostsBloc>().add(
        FetchPostsEvent(
          skip: 0,
          limit: ApiConstants.postsLimit,
          token: _userToken,
        ),
      );
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 500) {
      _loadMore();
    }
  }

  void _loadMore() {
    final state = context.read<PostsBloc>().state;
    if (state is PostsLoaded && state.hasMoreData) {
      context.read<PostsBloc>().add(
        LoadMorePostsEvent(
          skip: state.skip + state.limit,
          limit: state.limit,
          token: _userToken,
        ),
      );
    }
  }

  void _retry() {
    context.read<PostsBloc>().add(
      FetchPostsEvent(
        skip: 0,
        limit: ApiConstants.postsLimit,
        token: _userToken,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Posts'),
        centerTitle: true,
      ),
      body: BlocBuilder<PostsBloc, PostsState>(
        builder: (context, state) {
          if (state is PostsLoading) {
            return const LoadingWidget(message: 'Loading posts...');
          } else if (state is PostsEmpty) {
            return const EmptyStateWidget(
              title: 'No Posts',
              message: 'No posts available at the moment',
            );
          } else if (state is PostsError) {
            return ErrorWidget_Custom(
              message: state.message,
              onRetry: _retry,
            );
          } else if (state is PostsLoaded) {
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    itemCount: state.posts.length +
                        (state.hasMoreData ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == state.posts.length) {
                        return const Padding(
                          padding: EdgeInsets.all(16),
                          child: CircularProgressIndicator(),
                        );
                      }

                      final post = state.posts[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                post.title,
                                style: Theme.of(context).textTheme.titleLarge,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                post.body,
                                style: Theme.of(context).textTheme.bodySmall,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 12),
                              Wrap(
                                spacing: 8,
                                children: [
                                  if (post.tags != null)
                                    ...post.tags!
                                        .take(2)
                                        .map((tag) => Chip(
                                      label: Text(tag),
                                      visualDensity:
                                          VisualDensity.compact,
                                    ))
                                        .toList(),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          }

          return const LoadingWidget();
        },
      ),
    );
  }
}
