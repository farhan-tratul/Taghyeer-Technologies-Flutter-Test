import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/utils/exceptions.dart';
import '../../models/user_model.dart';

abstract class AuthLocalDataSource {
  Future<void> saveUser(UserModel user);
  
  Future<UserModel?> getCachedUser();
  
  Future<void> clearUser();
  
  Future<bool> hasValidSession();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences sharedPreferences;

  AuthLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<void> saveUser(UserModel user) async {
    try {
      final jsonString = jsonEncode(user.toStorageJson());
      await sharedPreferences.setString(
        StorageConstants.userSessionKey,
        jsonString,
      );
    } catch (e) {
      throw CacheException(
        message: 'Failed to save user to local storage',
        originalError: e,
      );
    }
  }

  @override
  Future<UserModel?> getCachedUser() async {
    try {
      final jsonString = sharedPreferences.getString(
        StorageConstants.userSessionKey,
      );
      
      if (jsonString == null) {
        return null;
      }
      
      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      return UserModel.fromStorageJson(json);
    } catch (e) {
      throw CacheException(
        message: 'Failed to retrieve cached user',
        originalError: e,
      );
    }
  }

  @override
  Future<void> clearUser() async {
    try {
      await sharedPreferences.remove(StorageConstants.userSessionKey);
    } catch (e) {
      throw CacheException(
        message: 'Failed to clear user from local storage',
        originalError: e,
      );
    }
  }

  @override
  Future<bool> hasValidSession() async {
    try {
      final user = await getCachedUser();
      return user != null && user.token.isNotEmpty;
    } catch (e) {
      return false;
    }
  }
}
