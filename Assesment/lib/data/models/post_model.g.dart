// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostModel _$PostModelFromJson(Map<String, dynamic> json) => PostModel(
      postId: (json['id'] as num).toInt(),
      postTitle: json['title'] as String,
      postBody: json['body'] as String,
      postUserId: (json['userId'] as num).toInt(),
      postTags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList(),
    );

Map<String, dynamic> _$PostModelToJson(PostModel instance) => <String, dynamic>{
      'id': instance.postId,
      'title': instance.postTitle,
      'body': instance.postBody,
      'userId': instance.postUserId,
      'tags': instance.postTags,
    };
