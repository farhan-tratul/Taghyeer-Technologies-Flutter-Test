import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/user.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel extends User {
  @JsonKey(name: 'id')
  final int userId;
  
  @JsonKey(name: 'username')
  final String userUsername;
  
  @JsonKey(name: 'email')
  final String userEmail;
  
  @JsonKey(name: 'firstName')
  final String userFirstName;
  
  @JsonKey(name: 'lastName')
  final String userLastName;
  
  @JsonKey(name: 'image')
  final String? userImage;
  
  @JsonKey(name: 'accessToken')
  final String userToken;

  const UserModel({
    required this.userId,
    required this.userUsername,
    required this.userEmail,
    required this.userFirstName,
    required this.userLastName,
    this.userImage,
    required this.userToken,
  }) : super(
    id: userId,
    username: userUsername,
    email: userEmail,
    firstName: userFirstName,
    lastName: userLastName,
    image: userImage,
    token: userToken,
  );

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  Map<String, dynamic> toStorageJson() => {
    'id': userId,
    'username': userUsername,
    'email': userEmail,
    'firstName': userFirstName,
    'lastName': userLastName,
    'image': userImage,
    'accessToken': userToken,
  };

  factory UserModel.fromStorageJson(Map<String, dynamic> json) => UserModel(
    userId: json['id'] as int,
    userUsername: json['username'] as String,
    userEmail: json['email'] as String,
    userFirstName: json['firstName'] as String,
    userLastName: json['lastName'] as String,
    userImage: json['image'] as String?,
    userToken: json['accessToken'] as String,
  );
}
