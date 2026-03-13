import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/api_constants.dart';
import '../utils/exceptions.dart';

class ApiClient {
  final http.Client httpClient;
  
  ApiClient({required this.httpClient});

  Future<Map<String, dynamic>> get({
    required String endpoint,
    Map<String, String>? headers,
    String? token,
  }) async {
    try {
      final url = Uri.parse('${ApiConstants.baseUrl}$endpoint');
      final defaultHeaders = {
        'Content-Type': 'application/json',
        ...?headers,
      };

      if (token != null) {
        defaultHeaders['Authorization'] = 'Bearer $token';
      }

      final response = await httpClient
          .get(url, headers: defaultHeaders)
          .timeout(
            const Duration(seconds: ApiConstants.requestTimeout),
            onTimeout: () => throw NetworkException(
              message: 'Request timeout',
              code: 'TIMEOUT',
            ),
          );

      return _handleResponse(response);
    } catch (e) {
      if (e is AppException) rethrow;
      throw NetworkException(
        message: 'Network error occurred',
        originalError: e,
      );
    }
  }

  Future<Map<String, dynamic>> post({
    required String endpoint,
    required Map<String, dynamic> body,
    Map<String, String>? headers,
    String? token,
  }) async {
    try {
      final url = Uri.parse('${ApiConstants.baseUrl}$endpoint');
      final defaultHeaders = {
        'Content-Type': 'application/json',
        ...?headers,
      };

      if (token != null) {
        defaultHeaders['Authorization'] = 'Bearer $token';
      }

      final response = await httpClient
          .post(
            url,
            headers: defaultHeaders,
            body: jsonEncode(body),
          )
          .timeout(
            const Duration(seconds: ApiConstants.requestTimeout),
            onTimeout: () => throw NetworkException(
              message: 'Request timeout',
              code: 'TIMEOUT',
            ),
          );

      return _handleResponse(response);
    } catch (e) {
      if (e is AppException) rethrow;
      throw NetworkException(
        message: 'Network error occurred',
        originalError: e,
      );
    }
  }

  Map<String, dynamic> _handleResponse(http.Response response) {
    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else if (response.statusCode == 401) {
      throw UnauthorizedException(
        message: 'Unauthorized access',
        code: '401',
      );
    } else if (response.statusCode >= 400 && response.statusCode < 500) {
      throw ServerException(
        message: 'Client error: ${response.statusCode}',
        code: response.statusCode.toString(),
      );
    } else if (response.statusCode >= 500) {
      throw ServerException(
        message: 'Server error: ${response.statusCode}',
        code: response.statusCode.toString(),
      );
    } else {
      throw ServerException(
        message: 'Unknown error occurred',
        code: response.statusCode.toString(),
      );
    }
  }
}
