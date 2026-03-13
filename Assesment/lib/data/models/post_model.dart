import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/post.dart';

part 'post_model.g.dart';

@JsonSerializable()
class PostModel extends Post {
  @JsonKey(name: 'id')
  final int postId;
  
  @JsonKey(name: 'title')
  final String postTitle;
  
  @JsonKey(name: 'body')
  final String postBody;
  
  @JsonKey(name: 'userId')
  final int postUserId;
  
  @JsonKey(name: 'tags')
  final List<String>? postTags;

  const PostModel({
    required this.postId,
    required this.postTitle,
    required this.postBody,
    required this.postUserId,
    this.postTags,
  }) : super(
    id: postId,
    title: postTitle,
    body: postBody,
    userId: postUserId,
    tags: postTags,
  );

  factory PostModel.fromJson(Map<String, dynamic> json) =>
      _$PostModelFromJson(json);

  Map<String, dynamic> toJson() => _$PostModelToJson(this);
}
