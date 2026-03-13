import '../../core/utils/exceptions.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/local/auth_local_datasource.dart';
import '../datasources/remote/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<User> login({
    required String username,
    required String password,
  }) async {
    try {
      final userModel = await remoteDataSource.login(
        username: username,
        password: password,
      );
      
      // Save user locally
      await localDataSource.saveUser(userModel);
      
      return userModel;
    } on AppException {
      rethrow;
    } catch (e) {
      throw ServerException(
        message: 'Login failed',
        originalError: e,
      );
    }
  }

  @override
  Future<User?> getCachedUser() async {
    try {
      return await localDataSource.getCachedUser();
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> logout() async {
    try {
      await localDataSource.clearUser();
    } catch (e) {
      throw CacheException(
        message: 'Logout failed',
        originalError: e,
      );
    }
  }

  @override
  Future<bool> hasValidSession() async {
    try {
      return await localDataSource.hasValidSession();
    } catch (e) {
      return false;
    }
  }
}
