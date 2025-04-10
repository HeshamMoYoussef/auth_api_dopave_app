class ApiConstants {
  // Base URL for all API requests
  static const String baseUrl = 'https://h.rhmany.com';

  // API Endpoints
  static const String sendVerificationCode = '/api/send/verification/code';
  static const String checkVerificationCode = '/api/check/verification/code';
  static const String register = '/api/user/register';
  static const String login = '/api/user/login';
  static const String forgotPassword = '/api/user/forgot/password';
  static const String userProfile = '/api/user/me';
  static const String updateProfile = '/api/user/update/profile';
  static const String logout = '/api/user/logout';
  static const String deleteUser = '/api/user/delete';
  static const String matchesEndpoint = '/api/matches';
  static const String matchDetailsEndpoint = '/api/match/info/';
  static const String articlesEndpoint = '/api/articles';
  static const String goldPricesEndpoint = '/api/gold';
}
