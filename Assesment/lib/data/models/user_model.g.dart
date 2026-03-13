// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
      userId: (json['id'] as num).toInt(),
      userUsername: json['username'] as String,
      userEmail: json['email'] as String,
      userFirstName: json['firstName'] as String,
      userLastName: json['lastName'] as String,
      userImage: json['image'] as String?,
      userToken: json['accessToken'] as String,
    );

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'id': instance.userId,
      'username': instance.userUsername,
      'email': instance.userEmail,
      'firstName': instance.userFirstName,
      'lastName': instance.userLastName,
      'image': instance.userImage,
      'accessToken': instance.userToken,
    };
