import 'package:equatable/equatable.dart';

class Post extends Equatable {
  final int id;
  final String title;
  final String body;
  final int userId;
  final List<String>? tags;

  const Post({
    required this.id,
    required this.title,
    required this.body,
    required this.userId,
    this.tags,
  });

  @override
  List<Object?> get props => [id, title];
}
