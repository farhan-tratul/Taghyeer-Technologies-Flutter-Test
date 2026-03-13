import '../../../core/constants/api_constants.dart';
import '../../../core/network/api_client.dart';
import '../../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login({
    required String username,
    required String password,
  });
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient apiClient;

  AuthRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<UserModel> login({
    required String username,
    required String password,
  }) async {
    final response = await apiClient.post(
      endpoint: ApiConstants.loginEndpoint,
      body: {
        'username': username,
        'password': password,
        'expiresInMins': 30,
      },
    );
    
    return UserModel.fromJson(response);
  }
}
