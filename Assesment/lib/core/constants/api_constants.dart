class ApiConstants {
  static const String baseUrl = 'https://dummyjson.com';
  
  // Auth Endpoints
  static const String loginEndpoint = '/auth/login';
  
  // Products Endpoints
  static const String productsEndpoint = '/products';
  static const int productsLimit = 10;
  
  // Posts Endpoints
  static const String postsEndpoint = '/posts';
  static const int postsLimit = 10;
  
  // Request timeout
  static const int requestTimeout = 30; // seconds
}

class StorageConstants {
  static const String userSessionKey = 'user_session';
  static const String themeKey = 'theme_mode';
  static const String tokenKey = 'auth_token';
}
